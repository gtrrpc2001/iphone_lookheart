//  Created by Yeun-Ho Joung on 2021/09/04.

import Foundation
import AVFoundation
import UIKit
import Then
import SnapKit
import CoreBluetooth
import CoreLocation
import LookheartPackage
import UserNotifications
import DGCharts

let defaults = UserDefaults.standard

var connectionFlag = false // BLE Connection Flag
var conversionFlag = true // true : PEAK FLAG, false : ECG

class MainViewController: BaseViewController, BluetoothManagerDelegate {
    
    private let MaxBpmDiff = 1, MinBpmDiff = 2, AvgBpmDiff = 3, HRV = 4
    private let MaxBpm = 1, MinBpm = 2, AvgBpm = 3
    private let ExTime = 1, ExCal = 2, ExStep = 3, ExDistance = 4
    
    private var bluetoothManager: BluetoothManager?
    private var dataEntries = [ChartDataEntry](repeating: ChartDataEntry(x: 0.0, y: 512.0), count: 500)
    private var ecgPeakFlag = 0 // 파형 변환 변수
    
    private var exerciseFlag = false
    private var exerciseTimer: Timer?
    private var exerciseCount = 0
    
    // MARK: -
    private var chartView: LineChartView?
    
    private var arrCntLabel: UILabel?
    
    private var heartValue: UILabel?, bpmViewLabel: UILabel?, exerciseViewLabel: UILabel?, tagLabel: UILabel?
    
    private var middleStackView: UIStackView?, rightStackView: UIStackView?, exStackView: UIStackView?
    
    private var restButton: UIButton?, activityButton: UIButton?, sleepButton: UIButton?

    private var calValue: UILabel?, stepValue: UILabel?, temperatureValue: UILabel?, distanceValue: UILabel?
    
    // MARK: - Button Event
    @objc func bodyStateEvent(_ sender: UIButton) {
        let buttons = [restButton!, activityButton!, sleepButton!]
        
        for button in buttons {
            if button == sender {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor.MY_BODY_STATE
                button.tintColor = .white
            } else {
                button.setTitleColor(.lightGray, for: .normal)
                button.backgroundColor = UIColor.MY_LIGHT_GRAY_BORDER
                button.tintColor = .lightGray
            }
        }
    }
    
    @objc func exerciseTapped() {
        if !exerciseFlag { showExerciseAlert(message: "notiStartExercise".localized()) }
        else { showExerciseAlert(message: "notiEndExercise".localized()) }
    }
    
    @objc func buttonPEAK(_ sender: Any) {
        
//        ecgPeakFlag += 1
//        if ecgPeakFlag == 2 {
//            if conversionFlag {
//                conversionFlag = false
//            } else{
//                conversionFlag = true
//            }
//            propProfil.conversionFlag = conversionFlag
//            ecgPeakFlag = 0
//            ToastHelper.shared.showToast(view, "Change MODE", withDuration: 1.0, delay: 1.0, bottomPosition: true)
//        }
    }
        
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        
        getUserProfile()

        LocationManager.shared.requestLocationAuthorization()   // 위치 권한 요청
        
    }
            
    private func presentModalAlert(_ alert: UIViewController) {
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        if let topController = getTopViewController() {
            topController.present(alert, animated: true)
        }
    }
    
    // MARK: - UI
    func didUpdateGraphData(_ ecgData: [Double]) {
        
        // 그래프 데이터 업데이트 로직
        func updateChartData() {
            if let chartDataSet = chartView!.data?.dataSets.first as? LineChartDataSet {
                chartDataSet.replaceEntries(dataEntries)
                chartView!.data?.notifyDataChanged()
            } else {
                let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Peak")
                chartDataSet.drawCirclesEnabled = false
                chartDataSet.setColor(NSUIColor.blue)
                chartDataSet.mode = .linear
                chartDataSet.drawValuesEnabled = false

                let chartData = LineChartData(dataSet: chartDataSet)
                chartView!.data = chartData
            }

            chartView!.notifyDataSetChanged()
            chartView!.moveViewToX(0)
        }
        
        let newGraphDataCount = ecgData.count
        let startIndex = ECG_MAX_ARRAY - newGraphDataCount

        // 기존 데이터 이동
        for i in stride(from: startIndex - 1, through: 0, by: -1) {
            dataEntries[i + newGraphDataCount] = dataEntries[i]
        }

        // 새 데이터 추가
        for i in 0..<newGraphDataCount {
            let dataEntry = ChartDataEntry(x: Double(startIndex + i), y: ecgData[i])
            dataEntries[startIndex + i] = dataEntry
        }
            
        updateChartData()
                
    }
    
    func didUpdateUI() {
        
        // Bpm Diff
        func bpmDifference(from bpm: Int, comparedTo otherBpm: Int) -> String {
            let difference = bpm - otherBpm
            return difference > 0 ? "+\(difference)" : "\(difference)"
        }
        
        // Body State
        func updateBodyState(state: String) {
            switch (state) {
            case "E":
                bodyStateEvent(activityButton!)
            case "S":
                bodyStateEvent(sleepButton!)
            default:
                bodyStateEvent(restButton!)
            }
        }
        
        let healthDataManager = HealthDataManager.shared        
        let distanceM = healthDataManager.distance / 100 / 1000
        let resultDistanceM = floor(distanceM * 1000) / 1000 // 소수점 세 자리 제거
        
        if exerciseFlag {
            updateExerciseUI()
        }
        
        // bpm
        heartValue!.text = String(healthDataManager.bpm)
        updateValue(stackView: rightStackView!, text: String(healthDataManager.maxBpm), tag: MaxBpm)
        updateValue(stackView: rightStackView!, text: String(healthDataManager.minBpm), tag: MinBpm)
        updateValue(stackView: rightStackView!, text: String(healthDataManager.avgBpm), tag: AvgBpm)

        // diff
        let maxBpm = bpmDifference(from: healthDataManager.bpm, comparedTo: healthDataManager.maxBpm)
        let minBpm = bpmDifference(from: healthDataManager.bpm, comparedTo: healthDataManager.minBpm)
        let avgBpm = bpmDifference(from: healthDataManager.bpm, comparedTo: healthDataManager.avgBpm)
        
        updateValue(stackView: middleStackView!, text: maxBpm, tag: MaxBpmDiff)
        updateValue(stackView: middleStackView!, text: minBpm, tag: MinBpmDiff)
        updateValue(stackView: middleStackView!, text: avgBpm, tag: AvgBpmDiff)
        updateValue(stackView: middleStackView!, text: String(healthDataManager.hrv), tag: HRV) // HRV
        
        // other
        arrCntLabel!.text = String(healthDataManager.arrCnt)
        stepValue!.text = "\(String(healthDataManager.step)) \("stepValue2".localized())"
        calValue!.text = "\(String(Int(healthDataManager.activityCalorie))) \("eCalValue2".localized())"
        distanceValue!.text = "\(resultDistanceM) \("distanceValue2".localized())"
        temperatureValue!.text = "\(String(healthDataManager.temp)) \("temperatureValue2".localized())"

        updateBodyState(state: healthDataManager.bodyState)
    }
    
    // MARK: - Exercise
    private func updateExerciseUI() {
        let exerciseData = HealthDataManager.shared.getExerciseData()
        if let exStackView = exStackView {
            updateValue(stackView: exStackView, text: String(Int(exerciseData.0)), tag: ExCal)
            updateValue(stackView: exStackView, text: String(exerciseData.1), tag: ExStep)
            updateValue(stackView: exStackView, text: String(format: "%.3f", exerciseData.2 / 100 / 1000.0), tag: ExDistance)
        }
    }
    
    private func updateValue(stackView: UIStackView, text: String, tag: Int) {
        if let label = stackView.arrangedSubviews.first(where: { $0.tag == tag }) as? UILabel {
            label.text = text
        }
    }
    
    private func setExerciseColor(_ flag: Bool) {
        tagLabel!.text = flag ? "E" : "B"
        tagLabel!.backgroundColor = flag ? UIColor.MY_BLUE : UIColor.MY_RED
        tagLabel!.layer.borderColor = flag ? UIColor.MY_BLUE.cgColor : UIColor.MY_RED.cgColor
    }
    
    private func showExerciseAlert(message: String?) {
        let alert = UIAlertController(title: "noti".localized(), message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok".localized(), style: .destructive, handler: { [self] Action in
            if !exerciseFlag {
                startExercise()
                
                ToastHelper.shared.showToast(view, "startExercise".localized())
                
            } else {
                stopExercise()

                ToastHelper.shared.showToast(view, "endExercise".localized())
            }
        })
        
        let cancel = UIAlertAction(title: "reject".localized(), style: UIAlertAction.Style.cancel, handler: { Action in
        })
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: false)
    }
        
    private func startExercise() {
        exerciseFlag = true
        bpmViewLabel!.isHidden = exerciseFlag
        exerciseViewLabel!.isHidden = !exerciseFlag
        
        HealthDataManager.shared.startExercise()
        setExerciseColor(exerciseFlag)
        
        exerciseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(exerciseTimeCount), userInfo: nil, repeats: true)
    }
    
    private func stopExercise() {
        exerciseFlag = false
        bpmViewLabel!.isHidden = exerciseFlag
        exerciseViewLabel!.isHidden = !exerciseFlag
        
        exerciseTimer?.invalidate()
        exerciseTimer = nil
        
        exerciseCount = 0
        
        HealthDataManager.shared.resetExercise()
        setExerciseColor(exerciseFlag)
    }
    
    @objc func exerciseTimeCount() {
        exerciseCount += 1
        if let exStackView = exStackView {
            updateValue(stackView: exStackView, text: setTime(exerciseCount), tag: ExTime)
        }
    }
    
    private func setTime(_ cnt: Int) -> String {
        let sec = cnt % 60
        let min = (cnt / 60) % 60 // 60으로 나눈 후 다시 60으로 나누어 나머지를 구함
        let hour = cnt / 3600

        let secString = sec < 10 ? "0\(sec)" : "\(sec)"
        let minString = min < 10 ? "0\(min)" : "\(min)"
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"

        if hour > 0 {
            return "\(hourString):\(minString):\(secString)"
        } else {
            return "\(minString):\(secString)"
        }
    }
    
    //MARK: - LoadUserData
    func getUserProfile() {
    
        let identification = Keychain.shared.getString(forKey: userEmailKey) ?? "test"
        
        Task {
            
            let getProfile = await ProfileService.shared.getProfile(id: identification)
            let profile = getProfile.0
            let response = getProfile.1
            
            switch response {
            case .success:
                // set Profile
                propProfil.profile = profile!
                propProfil.isLogin = true
                
                // PEAK : 0, ECG : 1
                conversionFlag = propProfil.conversionFlag
                
                // guardian Alert
                NotificationManager.shared.showAlert(type: .guardian)
                
                // set Gender Flag
                HealthDataManager.shared.setGender(propProfil.gender == "남자")
                HealthDataManager.shared.setHeight(Double(propProfil.height) ?? 170.0)
                
                // BLE
                bluetoothManager = BluetoothManager.shared
                bluetoothManager?.delegate = self
                if ((bluetoothManager?.isUserInitiatedDisconnect) != nil) {
                    bluetoothManager?.startScanning()
                }
                
                // Init Singleton
                TenSecondDataManager.shared.resetTenSecondData()
                HourlyDataManager.shared.initHourlyDataManager()
                HealthDataManager.shared.initHealthDataManager()
                bluetoothManager?.initBluetoothManager()
                
                // Log
                Task {
                    let isLogged = defaults.bool(forKey: "autoLoginFlag")
                    await LogService.shared.sendLog(userType: .User, action: isLogged ? .AutoLogin : .Login)
                }
                
                ToastHelper.shared.showToast(view, "userDataComplete".localized())
            default:
                ToastHelper.shared.showToast(view, "serverErr".localized())
            }
            
        }
    }
    
    //MARK: - addView
    private func addView() {
        
        func createLabel(_ text: String, _ color: UIColor, _ baseline: UIBaselineAdjustment, _ alignment: TextAlignment, _ size: CGFloat, _ weight: UIFont.Weight, _ tag: Int?) -> UILabel {
            let label = UILabel().then {
                $0.text = text
                $0.textColor = color
                $0.textAlignment = alignment
                $0.baselineAdjustment = baseline
                $0.font = UIFont.systemFont(ofSize: size, weight: weight)
                $0.tag = tag ?? 0
            }
            return label
        }
                
        
        /*------------------------- HeartRate Start ------------------------*/
        // Create
        let heartBackground = UILabel().then {
            $0.layer.borderColor = UIColor.MY_BLUE.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
        }
        
        let heartImg = UIImageView().then {
            let image =  UIImage(named: "summary_bpm")!
            let coloredImage = image.withRenderingMode(.alwaysTemplate)
            $0.image = coloredImage
            $0.tintColor = UIColor.MY_BLUE
            $0.backgroundColor = .white
            $0.contentMode = .scaleAspectFit
        }
        
        heartValue = createLabel("0", UIColor.MY_BLUE, .alignCenters, .center, 30, .bold, nil)
        
        // AddSubview
        view.addSubview(heartBackground)
        view.addSubview(heartImg)
        
        // Constraints
        heartBackground.snp.makeConstraints { make in
            make.top.equalTo(safeAreaView.snp.top).offset(10)
            make.left.equalTo(safeAreaView).offset(10)
            make.right.equalTo(safeAreaView.snp.centerX).offset(-20)
            make.height.equalTo(80)
        }
        
        heartImg.snp.makeConstraints { make in
            make.top.equalTo(heartBackground).offset(-8)
            make.centerX.equalTo(heartBackground)
            make.width.equalTo(30)
        }
        
        if let heartValue = heartValue {
            view.addSubview(heartValue)
            heartValue.snp.makeConstraints { make in
                make.centerX.centerY.equalTo(heartBackground)
            }
        }
        
        /*------------------------- HeartRate End ------------------------*/
        
        
        /*------------------------- Bpm & Exercise View Start ------------------------*/
        // Create
        let topViewLabel = UILabel().then {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exerciseTapped))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
        
        bpmViewLabel = UILabel().then {
            $0.layer.borderColor = UIColor.MY_RED.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            $0.clipsToBounds = true
        }
        
        exerciseViewLabel = UILabel().then {
            $0.layer.borderColor = UIColor.MY_BLUE.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            $0.clipsToBounds = true
            $0.isHidden = true
        }
        
        tagLabel = UILabel().then {
            $0.text = "B"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            $0.backgroundColor = UIColor.MY_RED
            $0.layer.borderColor = UIColor.MY_RED.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]   // 왼쪽 상하단 설정
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
        
        // Left Label Create
        let maxBpmLabel = createLabel("home_maxBpm".localized(), .lightGray, .alignCenters, .left, 14, .bold, nil)
        let minBpmLabel = createLabel("home_minBpm".localized(), .lightGray, .alignCenters, .left, 14, .bold, nil)
        let avgBpmLabel = createLabel( "home_avgBpm".localized(), .black, .alignCenters, .left, 16, .bold, nil)
        let hrvLabel = createLabel("home_hrv".localized(), .black, .alignCenters, .left, 16, .bold, nil)
        let leftStackView = UIStackView(arrangedSubviews: [maxBpmLabel, avgBpmLabel, minBpmLabel, hrvLabel]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        // Middle Label Create
        let maxBpmDiff = createLabel("0", .MY_RED, .alignCenters, .center, 14, .bold, MaxBpmDiff)
        let minBpmDiff = createLabel("0", .MY_BLUE, .alignCenters, .center, 14, .bold, MinBpmDiff)
        let avgBpmDiff = createLabel("0", .black, .alignCenters, .center, 14, .bold, AvgBpmDiff)
        let hrv = createLabel("0", .black, .alignCenters, .center, 16, .bold, HRV)
        middleStackView = UIStackView(arrangedSubviews: [maxBpmDiff, avgBpmDiff, minBpmDiff, hrv]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        // Right Label Create
        let maxBpm = createLabel("0", .lightGray, .alignCenters, .right, 14, .medium, MaxBpm)
        let minBpm = createLabel("0", .lightGray, .alignCenters, .right, 14, .medium, MinBpm)
        let avgBpm = createLabel("0", .lightGray, .alignCenters, .right, 14, .medium, AvgBpm)
        let hrvUnit = createLabel("home_hrv_unit".localized(), .lightGray, .alignCenters, .right, 14, .bold, nil)
        rightStackView = UIStackView(arrangedSubviews: [maxBpm, avgBpm, minBpm, hrvUnit]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        
        
        
        // Exercise Left Label Create
        let exTimeLabel = createLabel("exerciseTime".localized(), .darkGray, .alignCenters, .left, 14, .bold, nil)
        let exCalLabel = createLabel("summaryCal".localized(), .darkGray, .alignCenters, .left, 14, .bold, nil)
        let exStepLabel = createLabel("summaryStep".localized(), .darkGray, .alignCenters, .left, 14, .bold, nil)
        let exDistanceLabel = createLabel("exerciseDistance".localized(), .darkGray, .alignCenters, .left, 14, .bold, nil)
        let exLeftStackView = UIStackView(arrangedSubviews: [exTimeLabel, exCalLabel, exStepLabel, exDistanceLabel]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        // Exercise Right Label Create
        let space = createLabel("sec", .lightGray, .alignCenters, .center, 12, .bold, nil)
        let calUnit = createLabel("kcal", .lightGray, .alignCenters, .center, 12, .bold, nil)
        let stepUnit = createLabel("step", .lightGray, .alignCenters, .center, 12, .bold, nil)
        let distanceUnit = createLabel("km", .lightGray, .alignCenters, .center, 12, .bold, nil)
        let exRightStackView = UIStackView(arrangedSubviews: [space, calUnit, stepUnit, distanceUnit]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
                
        // Exercise Middle Label Create
        let exerciseTime = createLabel("00:00", .MY_BLUE, .alignCenters, .left, 14, .bold, ExTime)
        let exCalorie = createLabel("0", .MY_BLUE, .alignCenters, .center, 14, .bold, ExCal)
        let exStep = createLabel("0", .MY_BLUE, .alignCenters, .center, 14, .bold, ExStep)
        let exDistance = createLabel("0.000", .MY_BLUE, .alignCenters, .center, 14, .bold, ExDistance)
        exStackView = UIStackView(arrangedSubviews: [exerciseTime, exCalorie, exStep, exDistance]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        // AddSubview & Constraints
        if let tagLabel = tagLabel,let bpmViewLabel = bpmViewLabel, let rightStackView = rightStackView, let middleStackView = middleStackView, let exerciseViewLabel = exerciseViewLabel, let exStackView = exStackView {
            
            view.addSubview(topViewLabel)
            view.addSubview(tagLabel)
            
            // BPM
            topViewLabel.addSubview(bpmViewLabel)
            bpmViewLabel.addSubview(leftStackView)
            bpmViewLabel.addSubview(rightStackView)
            bpmViewLabel.addSubview(middleStackView)
            
            // Exercise
            topViewLabel.addSubview(exerciseViewLabel)
            exerciseViewLabel.addSubview(exLeftStackView)
            exerciseViewLabel.addSubview(exRightStackView)
            exerciseViewLabel.addSubview(exStackView)
            
            
            topViewLabel.snp.makeConstraints { make in
                make.top.equalTo(heartBackground)
                make.left.equalTo(safeAreaView.snp.centerX).offset(5)
                make.right.equalTo(safeAreaView).offset(-10)
                make.height.equalTo(80)
            }
                    
            tagLabel.snp.makeConstraints { make in
                make.top.equalTo(topViewLabel)
                make.bottom.equalTo(topViewLabel.snp.centerY)
                make.right.equalTo(topViewLabel.snp.left)
                make.width.equalTo(15)
            }
            
            
            // BPM
            bpmViewLabel.snp.makeConstraints { make in
                make.top.bottom.left.right.equalTo(topViewLabel)
            }
            
            leftStackView.snp.makeConstraints { make in
                make.top.equalTo(bpmViewLabel).offset(5)
                make.left.equalTo(bpmViewLabel).offset(10)
                make.right.equalTo(bpmViewLabel.snp.centerX).offset(5)
                make.bottom.equalTo(bpmViewLabel).offset(-5)
            }

            rightStackView.snp.makeConstraints { make in
                make.top.equalTo(bpmViewLabel).offset(5)
                make.left.equalTo(bpmViewLabel.snp.centerX).offset(20)
                make.right.equalTo(bpmViewLabel).offset(-10)
                make.bottom.equalTo(bpmViewLabel).offset(-5)
            }
            
            middleStackView.snp.makeConstraints { make in
                make.top.equalTo(bpmViewLabel).offset(5)
                make.bottom.equalTo(bpmViewLabel).offset(-5)
                make.centerX.equalTo(bpmViewLabel)
            }
            

            // Exercise
            exerciseViewLabel.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(topViewLabel)
            }
                    
            exLeftStackView.snp.makeConstraints { make in
                make.top.bottom.left.right.equalTo(leftStackView)
            }
                    
            exRightStackView.snp.makeConstraints { make in
                make.top.bottom.right.equalTo(rightStackView)
            }
                                
            exStackView.snp.makeConstraints { make in
                make.top.bottom.left.right.equalTo(middleStackView)
            }
        }
        
        /*------------------------- Bpm & Exercise View End ------------------------*/
        
        
        /*------------------------- Arr Button Start ------------------------*/
        // Create
        let arrButton = UIButton().then {
            $0.setTitle("summaryArr".localized(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.contentHorizontalAlignment = .left
            $0.backgroundColor = UIColor.MY_RED
            $0.layer.borderWidth = 0
            $0.layer.cornerRadius = 10
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            $0.addTarget(self, action: #selector(buttonPEAK(_:)), for: .touchUpInside)
        }
        
        let arrUnit = UILabel().then {
            $0.text = "profile3_time".localized()
            $0.textColor = .white
            $0.baselineAdjustment = .alignCenters
            $0.font = .boldSystemFont(ofSize: 14)
        }
        
        arrCntLabel = UILabel().then {
            $0.text = "0"
            $0.textColor = .white
            $0.baselineAdjustment = .alignCenters
            $0.font = .boldSystemFont(ofSize: 16)
        }
        
        // AddSubview
        view.addSubview(arrButton)
        view.addSubview(arrUnit)
        
        // Constraints
        arrButton.snp.makeConstraints { make in
            make.top.equalTo(topViewLabel.snp.bottom).offset(10)
            make.left.right.equalTo(topViewLabel)
            make.height.equalTo(30)
        }

        arrUnit.snp.makeConstraints { make in
            make.centerY.equalTo(arrButton)
            make.right.equalTo(arrButton).offset(-20)
        }

        if let arrCntLabel = arrCntLabel {
            view.addSubview(arrCntLabel)
            arrCntLabel.snp.makeConstraints { make in
                make.centerX.equalTo(arrButton).offset(10)
                make.centerY.equalTo(arrButton)
            }
        }
        /*------------------------- Arr Button End ------------------------*/
        
        
        
        /*------------------------- Body State Start ------------------------*/
        let viewWidth = self.view.frame.size.width / 2
        let buttonWidth = (viewWidth - 30) / 3
        
        // Create
        let bodyStateBackground = UILabel().then {
            $0.backgroundColor = UIColor.MY_LIGHT_GRAY_BORDER
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        restButton = UIButton().then {
            $0.setTitle("rest".localized(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setImage(UIImage(named: "state_rest"), for: .normal)
            $0.tintColor = .white
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
            $0.titleLabel?.contentMode = .center
            $0.backgroundColor = UIColor.MY_BODY_STATE
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 0
            $0.layer.cornerRadius = 5
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            $0.addTarget(self, action: #selector(bodyStateEvent(_:)), for: .touchUpInside)
        }
        
        activityButton = UIButton().then {
            $0.setTitle("exercise".localized(), for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.setImage(UIImage(named: "state_activity"), for: .normal)
            $0.tintColor = .lightGray
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
            $0.titleLabel?.contentMode = .center
            $0.backgroundColor = UIColor.MY_LIGHT_GRAY_BORDER
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 0
            $0.layer.cornerRadius = 5
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            $0.addTarget(self, action: #selector(bodyStateEvent(_:)), for: .touchUpInside)
        }
        
        sleepButton = UIButton().then {
            $0.setTitle("sleep".localized(), for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.setImage(UIImage(named: "state_sleep"), for: .normal)
            $0.tintColor = .lightGray
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
            $0.titleLabel?.contentMode = .center
            $0.backgroundColor = UIColor.MY_LIGHT_GRAY_BORDER
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 0
            $0.layer.cornerRadius = 5
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            $0.addTarget(self, action: #selector(bodyStateEvent(_:)), for: .touchUpInside)
        }
        
        // AddSubView & Constraints
        view.addSubview(bodyStateBackground)
        bodyStateBackground.snp.makeConstraints { make in
            make.centerY.equalTo(arrButton)
            make.left.equalTo(safeAreaView).offset(10)
            make.right.equalTo(arrButton.snp.left).offset(-20)
            make.height.equalTo(30)
        }
        
        if let restButton = restButton, let activityButton = activityButton, let sleepButton = sleepButton {

            view.addSubview(restButton)
            restButton.snp.makeConstraints { make in
                make.centerY.equalTo(arrButton)
                make.left.equalTo(safeAreaView).offset(10)
                make.height.equalTo(bodyStateBackground)
                make.width.equalTo(buttonWidth)
            }


            view.addSubview(activityButton)
            activityButton.snp.makeConstraints { make in
                make.centerY.height.width.equalTo(restButton)
                make.left.equalTo(restButton.snp.right)
            }
            
            
            view.addSubview(sleepButton)
            sleepButton.snp.makeConstraints { make in
                make.centerY.height.width.equalTo(restButton)
                make.left.equalTo(activityButton.snp.right)
            }
        }
        
        /*------------------------- Body State End ------------------------*/
        
        
        /*------------------------- ChartView Start ------------------------*/
        // Create
        chartView = LineChartView().then {
            $0.xAxis.enabled = false
            $0.leftAxis.axisMaximum = 1024
            $0.leftAxis.axisMinimum = 0
            $0.rightAxis.enabled = false
            $0.drawMarkers = false
            $0.dragEnabled = false
            $0.pinchZoomEnabled = false
            $0.doubleTapToZoomEnabled = false
            $0.highlightPerTapEnabled = false
            $0.legend.enabled = false // 범례 숨기기
        }
        
        // AddSubView & Constraints
        if let chartView = chartView {
            view.addSubview(chartView)
            chartView.snp.makeConstraints { make in
                make.top.equalTo(arrButton.snp.bottom).offset(10)
                make.width.equalTo(self.safeAreaView.snp.width)
            }
        }
        /*------------------------- ChartView End ------------------------*/
        
                
        /*------------------------- Bottom Contents Start ------------------------*/
        // Create
        let calLabel = UILabel().then {
            $0.text = "homeECal".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
            $0.textColor = .darkGray
        }
        
        calValue = UILabel().then {
            $0.text = "eCalValue".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.numberOfLines = 2
            $0.textColor = .darkGray
            $0.textAlignment = .right
        }
        
        let stepLabel = UILabel().then {
            $0.text = "step".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.textColor = .darkGray
        }
        
        stepValue = UILabel().then {
            $0.text = "stepValue".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.numberOfLines = 2
            $0.textColor = .darkGray
            $0.textAlignment = .right
        }
        
        let temperatureLabel = UILabel().then {
            $0.text = "temperature".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.textColor = .darkGray
        }

        temperatureValue = UILabel().then {
            $0.text = "temperatureValue".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.numberOfLines = 2
            $0.textColor = .darkGray
            $0.textAlignment = .right
        }
        
        let distanceLabel = UILabel().then {
            $0.text = "distance".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.textColor = .darkGray
        }

        distanceValue = UILabel().then {
            $0.text = "distanceValue".localized()
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.numberOfLines = 2
            $0.textColor = .darkGray
            $0.textAlignment = .right
        }
        
        let calButton = UIButton().then {
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
        }
        
        let stepButton = UIButton().then {
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
        }
        
        let calAndStepStackView = UIStackView(arrangedSubviews: [calButton, stepButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually // default
            $0.alignment = .fill // default
            $0.spacing = 10
        }
        
        let temperatureButton = UIButton().then {
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
        }
        
        let distanceButton = UIButton().then {
            $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
        }
        
        let temperatureAndDistanceStackView = UIStackView(arrangedSubviews: [temperatureButton, distanceButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually // default
            $0.alignment = .fill // default
            $0.spacing = 10
        }

        let bottomStackView = UIStackView(arrangedSubviews: [calAndStepStackView, temperatureAndDistanceStackView]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually // default
            $0.alignment = .fill // default
            $0.spacing = 10
        }
        
        // AddSubview & Constraint
        if let calValue = calValue, let stepValue = stepValue, let temperatureValue = temperatureValue, let distanceValue = distanceValue, let chartView = chartView {
            
            view.addSubview(bottomStackView)
            view.addSubview(calLabel)
            view.addSubview(calValue)
            
            view.addSubview(stepLabel)
            view.addSubview(stepValue)
            
            view.addSubview(temperatureLabel)
            view.addSubview(temperatureValue)
            
            view.addSubview(distanceLabel)
            view.addSubview(distanceValue)
            
            
            bottomStackView.snp.makeConstraints { make in
                make.top.equalTo(chartView.snp.bottom).offset(20)
                make.left.equalTo(safeAreaView).offset(10)
                make.right.equalTo(safeAreaView).offset(-10)
                make.bottom.equalTo(safeAreaView)
                make.height.equalTo(130)
            }
            
            calLabel.snp.makeConstraints { make in
                make.top.left.equalTo(calButton).offset(10)
            }
            
            calValue.snp.makeConstraints { make in
                make.bottom.right.equalTo(calButton).offset(-10)
            }
            
            stepLabel.snp.makeConstraints { make in
                make.top.left.equalTo(stepButton).offset(10)
            }
            
            stepValue.snp.makeConstraints { make in
                make.bottom.right.equalTo(stepButton).offset(-10)
            }
            
            temperatureLabel.snp.makeConstraints { make in
                make.top.left.equalTo(temperatureButton).offset(10)
            }
            
            temperatureValue.snp.makeConstraints { make in
                make.bottom.right.equalTo(temperatureButton).offset(-10)
            }
            
            distanceLabel.snp.makeConstraints { make in
                make.top.left.equalTo(distanceButton).offset(10)
            }
            
            distanceValue.snp.makeConstraints { make in
                make.bottom.right.equalTo(distanceButton).offset(-10)
            }
            
        }
        /*------------------------- Bottom Contents End ------------------------*/
    }
}
