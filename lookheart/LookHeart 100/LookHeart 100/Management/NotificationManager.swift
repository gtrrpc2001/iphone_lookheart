import Foundation
import LookheartPackage
import UIKit
import UserNotifications

enum NotiType {
    case emergency
    case arr
    case fast
    case slow
    case heavy
    case myo
    case noncontact
    case hourly
    case total
    case null
}

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private let content = UNMutableNotificationContent()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notiSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "basicsound.wav"))
    private let arrSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "arrSound.wav"))
            
    private let totalArrThresholds: [Int] = [50, 100, 200, 300]
    private var totalArrAlertCheck: [Bool] = [false, false, false, false]
    
    private let hourlyArrThresholds: [Int] = [10, 20, 30, 50]
    private var horulyArrAlertCheck: [Bool] = [false, false, false, false]
    
    // NOTI
    private var emergencyNotiFlag = false
    private var myoNotiFlag = false
    private var nonContactNotiFlag = false
    private var arrNotiFlag = false
    private var fastArrNotiFlag = false
    private var slowArrNotiFlag = false
    private var heavyArrNotiFlag = false
    
    private var totalArrAlertFlag:Bool = false
    private var hourlyArrAlertFlag:Bool = false
    
    private var notiTrigger = true              // 1분 마다 전극 알림 확인
    private var exerciseNotiTrigger = false     // 운동 상태 확인
    
    init() {
        emergencyNotiFlag = defaults.bool(forKey: "HeartAttackFlag")
        myoNotiFlag = defaults.bool(forKey: "MyoFlag")
        nonContactNotiFlag = defaults.bool(forKey: "NoncontactFlag")
        arrNotiFlag = defaults.bool(forKey: "ArrFlag")
        fastArrNotiFlag = defaults.bool(forKey: "TarchycardiaFlag")
        slowArrNotiFlag = defaults.bool(forKey: "BradycardiaFlag")
        heavyArrNotiFlag = defaults.bool(forKey: "AtrialFibrillaionFlag")
        totalArrAlertFlag = defaults.bool(forKey: "totalArrAlert")
        hourlyArrAlertFlag = defaults.bool(forKey: "hourlyArrAlert")
    }
    
    private func presentModalAlert(_ alert: UIViewController) {
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        if let topController = getTopViewController() {
            topController.present(alert, animated: true)
        }
    }
    
    func emergencyAlert() {
        // 현재 뷰에 띄워진 Emergency 알림이 없고 알림 허용 시
        if !(getTopViewController() is EmergencyAlert) && emergencyNotiFlag {
            let emergencyAlert = EmergencyAlert(emergencyCheck: true)
            presentModalAlert(emergencyAlert)
        }
    }
    
    func guardianAlert() {
        if !(getTopViewController() is EmergencyAlert) && UserProfileManager.shared.guardianPhoneNumber.isEmpty {
            let guardianAlert = GuardianAlert()
            presentModalAlert(guardianAlert)
        }
    }
    
    func authAlert() {
        if !(getTopViewController() is AuthAlert) {
            let authAlert = AuthAlert()
            presentModalAlert(authAlert)
        }
    }
    
    func sendNotification(title: String, message: String, arrFlag: Bool) {
        content.title = title
        content.body = message
        content.sound = arrFlag ? arrSound : notiSound
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("알림 등록 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
    func totalArrCntAlert(_ cnt: Int) {
        if !totalArrAlertFlag { return } // Alert & nofi Off
        
        var arrFlag = -1
        
        for threshold in totalArrThresholds {
            if cnt >= threshold {
                arrFlag += 1
            } else {
                break   // 현재 임계값 보다 arrCnt 값이 작으면 반복문 탈출
            }
        }
        
        if returnCheck(arrFlag: arrFlag, flagList: &totalArrAlertCheck) {    return  }
        
        if let result = getTitleAndMessage(forArrFlag: arrFlag) {
            // Alert
            setAlert(title: result.title,
                     message: result.message)
            // Notification
            sendNotification(title: result.title,
                             message: result.message,
                             arrFlag: true)
            totalArrAlertCheck[arrFlag] = true
        }
    }
    
    func hourlyArrCntAlert(_ cnt: Int) {
        if !hourlyArrAlertFlag { return } // Alert & nofi Off
        
        var arrFlag = -1
        
        for threshold in hourlyArrThresholds {
            if cnt >= threshold {
                arrFlag += 1
            } else {
                break   // 현재 임계값 보다 arrCnt 값이 작으면 반복문 탈출
            }
        }
        
        if returnCheck(arrFlag: arrFlag, flagList: &horulyArrAlertCheck) {    return  } // 중복 알림 방지
        if let result = getTitleAndMessage(forArrFlag: 4 + arrFlag) {
            // Alert
            setAlert(title: result.title,
                     message: result.message)
            // Notification
            sendNotification(title: result.title,
                             message: result.message,
                             arrFlag: true)
            horulyArrAlertCheck[arrFlag] = true
        }
    }
    
    func getTitleAndMessage(forArrFlag arrFlag: Int) -> (title: String, message: String)? {
        switch arrFlag {
        case 0:
            return ("arrCnt50".localized(), "arrCnt50Text".localized())
        case 1:
            return ("arrCnt100".localized(), "arrCnt100Text".localized())
        case 2:
            return ("arrCnt200".localized(), "arrCnt200Text".localized())
        case 3:
            return ("arrCnt200".localized(), "arrCnt200Text".localized())
        case 4:
            return ("notiHourlyArr10".localized(), "notiHourlyArr10Text".localized())
        case 5:
            return ("notiHourlyArr20".localized(), "notiHourlyArr20Text".localized())
        case 6:
            return ("notiHourlyArr30".localized(), "notiHourlyArr30Text".localized())
        case 7:
            return ("notiHourlyArr50".localized(), "notiHourlyArr50Text".localized())
        default:
            return nil
        }
    }
    
    func setAlert(title: String, message: String) {
        guard let topViewController = getTopViewController() else {
            return
        }
        
        if let emergencyAlert = topViewController.presentedViewController as? EmergencyAlert {
            emergencyAlert.updateArrAlert(arrTitle: title, arrMessage: message)
        } else {
            let emergencyAlert = EmergencyAlert(emergencyCheck: false)
            emergencyAlert.titleLabel.text = title
            emergencyAlert.messageLabel.text = message
            presentAlert(emergencyAlert)
        }
    }
    
    func presentAlert(_ emergencyAlert: EmergencyAlert) {
        emergencyAlert.modalPresentationStyle = .overCurrentContext
        emergencyAlert.modalTransitionStyle = .crossDissolve
        if let topController = getTopViewController() { // 최상위 뷰를 찾아 알림 띄움 : 모든 뷰에서 알림
            topController.present(emergencyAlert, animated: true)
        }
    }
    
    func returnCheck(arrFlag: Int, flagList: inout [Bool]) -> Bool {
        if arrFlag == -1 { return true }    // 조건 해당 없음
        else if flagList[arrFlag] { return true }    // 알림 중복
        return false
    }
    
    // MARK: -
    func sendNonContactNoti(){
        // 전극 떨어짐 알림
        if !nonContactNotiFlag {return}
        else if !notiTrigger {return}   // 1분 마다 변경되는 FLAG
        sendNotification(title: getTitle("notiTypeNonContact"), message: getTimeMessage(), arrFlag: false)
        notiTrigger = false
    }
    
    func sendMyoNoti(){
        // 근전도 알림
        if !myoNotiFlag {return}
        sendNotification(title: getTitle("notiTypeMyo"), message: getTimeMessage(), arrFlag: false)
    }
    
    func sendArrNoti(for type: Int) {
        // 비정상 맥박
        switch(type) {
        case ARR_TAG:
            if !arrNotiFlag {return}
            sendNotification(title: getTitle("notiTypeArr"), message: getTimeMessage(), arrFlag: true)
        case FAST_ARR_TAG:
            if !fastArrNotiFlag {return}
            sendNotification(title: getTitle("notiTypeFastArr"), message: getTimeMessage(), arrFlag: true)
        case SLOW_ARR_TAG:
            if !slowArrNotiFlag {return}
            sendNotification(title: getTitle("notiTypeSlowArr"), message: getTimeMessage(), arrFlag: true)
        case HEAVY_ARR_TAG:
            if !heavyArrNotiFlag {return}
            sendNotification(title: getTitle("notiTypeHeavyArr"), message: getTimeMessage(), arrFlag: true)
        default:
            return
        }
    }
    
    private func getTitle(_ localizable: String) -> String {
        return localizable.localized()
    }
    
    private func getTimeMessage() -> String {
        return "\("notiTime".localized()) \(MyDateTime.shared.getCurrentDateTime(.TIME))"
    }
    
    func setNotiTrigger() {
        notiTrigger = true
    }
    
    func setExerciseTrigger() {
        exerciseNotiTrigger = !exerciseNotiTrigger
    }
    // MARK: -
    // setter
    func setFlag(_ type: NotiType, _ flag: Bool) {
        switch type {
        case .emergency:
            emergencyNotiFlag = flag
        case .arr:
            arrNotiFlag = flag
        case .fast:
            fastArrNotiFlag = flag
        case .slow:
            slowArrNotiFlag = flag
        case .heavy:
            heavyArrNotiFlag = flag
        case .myo:
            myoNotiFlag = flag
        case .noncontact:
            nonContactNotiFlag = flag
        case .hourly:
            hourlyArrAlertFlag = flag
        case .total:
            totalArrAlertFlag = flag
        case .null:
            break
        }
    }
    
    // getter
    func getFlag(_ type: NotiType) -> Bool {
        switch type {
        case .emergency:
            return emergencyNotiFlag
        case .arr:
            return arrNotiFlag
        case .fast:
            return fastArrNotiFlag
        case .slow:
            return slowArrNotiFlag
        case .heavy:
            return heavyArrNotiFlag
        case .myo:
            return myoNotiFlag
        case .noncontact:
            return nonContactNotiFlag
        case .hourly:
            return hourlyArrAlertFlag
        case .total:
            return totalArrAlertFlag
        case .null:
            break
        }
        return false
    }
    
    func setNotiUserDefault() {
        defaults.set(emergencyNotiFlag, forKey: "HeartAttackFlag")
        defaults.set(myoNotiFlag, forKey: "MyoFlag")
        defaults.set(nonContactNotiFlag, forKey: "NoncontactFlag")
        defaults.set(arrNotiFlag, forKey: "ArrFlag")
        defaults.set(fastArrNotiFlag, forKey: "TarchycardiaFlag")
        defaults.set(slowArrNotiFlag, forKey: "BradycardiaFlag")
        defaults.set(heavyArrNotiFlag, forKey: "AtrialFibrillaionFlag")
        defaults.set(hourlyArrAlertFlag, forKey: "hourlyArrAlert")
        defaults.set(totalArrAlertFlag, forKey: "totalArrAlert")
    }
    
    func resetToalArray(){
        totalArrAlertCheck = [false, false, false, false]
    }
    
    func resetHourlyArray(){
        horulyArrAlertCheck = [false, false, false, false]
    }
}
