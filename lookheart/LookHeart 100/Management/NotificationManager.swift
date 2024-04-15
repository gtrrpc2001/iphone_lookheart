import Foundation
import LookheartPackage
import UIKit
import UserNotifications

class NotificationManager {
    
    public enum NotiType: String {
        case emergency
        case myo
        case noncontact
        case arr
        case fast
        case slow
        case irregular
        case total
        case hourly
        case guardian
        case null
    }
    
    static let shared = NotificationManager()
        
    private let content = UNMutableNotificationContent()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notiSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "basicsound.mp3"))
    private let arrSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "arrSound.mp3"))

    private let arrNoti = true, basicNoti = false
    private let totalNoti = true, hourlyNoti = false
    private let notification = true, alert = false
    
    private let totalArrThresholds: [Int] = [50, 100, 200, 300]
    private let hourlyArrThresholds: [Int] = [10, 20, 30, 50]
    
    private var basicAlert: BasicAlert?
    private var emergencyAlert: EmergencyAlert?
    
    // MARK: - Notification
    private func showNotification(_ title: String, _ message: String, _ soundFlag: Bool) {
        content.title = title
        content.body = message
        content.sound = soundFlag ? arrSound : notiSound
        
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
    
    public func showNotification(noti: NotiType) {
        let notiTitleAndSound = getNotiTitle(noti)
        let title = notiTitleAndSound.0
        let message = getTimeMessage()
        let soundFlag = notiTitleAndSound.1
        
        if getNotificationEnabled(type: noti) {
            showNotification(title, message, soundFlag)
        }
    }
    
    // MARK: - Alert
    private func presentModalAlert(_ alert: UIViewController) {
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        if let topController = getTopViewController() {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    public func showAlert(type: NotiType, arrCnt: Int? = nil ) {
        if !getNotificationEnabled(type: type) {return}
                            
        switch type {
        case .emergency:
            showEmergencyAlert()
        case .guardian:
            showGuardianAlert()
        case .total, .hourly:
            let flag = type == .total ? totalNoti : hourlyNoti
            showArrAlert(arrCnt!, flag)
        default:
            break
        }
    }
    
    
    private func showEmergencyAlert() {
        // 응급상황
        if !(getTopViewController() is EmergencyAlert) {
            // Notification
            showNotification(noti: .emergency)
            // Alert
            emergencyAlert = EmergencyAlert()
            presentModalAlert(emergencyAlert!)
        } 
    }
    
    
    private func showGuardianAlert() {
        // 보호자 설정
        let guardianAlert = GuardianAlert()
        presentModalAlert(guardianAlert)
    }
    
    
    private func showArrAlert(_ cnt: Int, _ flag: Bool) {
        // Total: 50, 100, 200, 300
        // Hourly: 10, 20, 30, 50
        let thresholds = flag ? totalArrThresholds : hourlyArrThresholds
        let arrType = flag ? "totalArr" : "hourlyArr"
        var alertNumber = 0
        
        for threshold in thresholds {
            if cnt >= threshold {
                alertNumber += 1
            } else {
                break
            }
        }
        
        if alertNumber == 0 || getArrNotiEnabled(type: "\(arrType)\(alertNumber)") {
            return
        }
        
        // Notification
        let notiText = getArrText(cnt, flag, notification)  // true : Noti
        let notiTitle = notiText.0
        let notiBody = notiText.1
        
        showNotification(notiTitle, notiBody, arrNoti)
                
        // Alert
        let alertText = getArrText(cnt, flag, alert) // false : Alert
        let alertTitle = alertText.0
        let alertBody = alertText.1
        
        if !(getTopViewController() is BasicAlert) {
            basicAlert = BasicAlert(title: alertTitle, message: alertBody)
            presentModalAlert(basicAlert!)
        } else {
            basicAlert?.updateText(title: alertTitle, message: alertBody)
        }
                
        // Set Enabled
        setArrNotiEnabled(type: "\(arrType)\(alertNumber)", flag: true)
    }
    
    
    
    // MARK: - Title & Message
    private func getNotiTitle(_ type: NotiType) -> (String, Bool) {
        // Title, Notification Sound Flag
        switch type {
        case .emergency:
            return (getTitle("emergencyNotiText"), basicNoti)
        case .noncontact:
            return (getTitle("notiTypeNonContact"), basicNoti)
        case .myo:
            return (getTitle("notiTypeMyo"), basicNoti)
        case .arr:
            return (getTitle("notiTypeArr"), arrNoti)
        case .fast:
            return (getTitle("notiTypeFastArr"), arrNoti)
        case .slow:
            return (getTitle("notiTypeSlowArr"), arrNoti)
        case .irregular:
            return (getTitle("notiTypeHeavyArr"), arrNoti)
        default:
            return ("isEmpty", basicNoti)
        }
    }
    
    private func getArrText(_ arrCnt: Int, _ arrType: Bool, _ notiAlertFlag: Bool) -> (String, String) {
        let flag = notiAlertFlag ? "noti_" : "alert_"
        let type = arrType ? "\(flag)totalArrTitle" : "\(flag)hourlyArrTitle"
        let randomText = Int.random(in:  1...8)
        
        let arrCntBody = "\(type.localized(with: arrCnt, comment: "cnt"))"
        let arrHelpBody = "\(flag)arrBody\(randomText)".localized()
        
        let title = notiAlertFlag ? arrCntBody : "noti".localized()
        let body = notiAlertFlag ? arrHelpBody : "\(arrCntBody)\(arrHelpBody)"
        
        return (title, body)
    }
    
    private func getTitle(_ localizable: String) -> String {
        return localizable.localized()
    }
    
    private func getTimeMessage() -> String {
        return "\("notiTime".localized()) \(MyDateTime.shared.getCurrentDateTime(.TIME))"
    }
    
    
    
    
    // MARK: - Get & Set
    public func getNotificationEnabled(type: NotiType) -> Bool {
        return defaults.bool(forKey: "\(propEmail)\(type.rawValue)")
    }
    
    public func setNotificationEnabled(type: NotiType, flag: Bool) {
        defaults.set(flag, forKey: "\(propEmail)\(type.rawValue)")
    }
    
    
    // Arr
    public func getArrNotiEnabled(type: String) -> Bool {
        return defaults.bool(forKey: "\(propEmail)\(type)")
    }
    
    public func setArrNotiEnabled(type: String, flag: Bool) {
        defaults.set(flag, forKey: "\(propEmail)\(type)")
    }
    
    public func resetArrAlert(type: NotiType) {
        let arrType = type == .total ? "totalArr" : "hourlyArr"
        
        // 1...4
        for i in 1...totalArrThresholds.count {
            setArrNotiEnabled(type: "\(arrType)\(i)", flag: false)
        }
    }
}
