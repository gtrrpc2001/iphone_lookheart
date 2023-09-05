//
//  ViewController.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/04.
//

import UIKit
import SnapKit
import CoreBluetooth
import Charts
import Then
import Foundation
import AVFoundation
import CoreLocation
import UserNotifications
import AVFoundation

//let ServiceCBUUID = CBUUID(string: "0000fff0-0000-1000-8000-00805f9b34fb")   //for old ble
//let ReceiveCBUUID = CBUUID(string: "0000fff2-0000-1000-8000-00805f9b34fb")   //for old ble
//let SendCBUUID = CBUUID(string: "0000fff1-0000-1000-8000-00805f9b34fb")      //for old ble

let ServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
let ReceiveCBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
let SendCBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")

var connectionFlag = 0

let chartView = LineChartView()
let defaults = UserDefaults.standard

var battery = 0
var bat = 0
var bpm = 90
var pre_bpm = 0
//var pre_breathtingTime = 0
var real_bpm = 70
var c_bpm = 0
//var saveflag = 0
var saveflagBreath = 0

var temp = 0
//var breathtingTime = 0
var dtemp = 0.0
var arr = 0
var arrLast = 0
var stepCal = 0
var iCalTimeCount = 0

var dCalMinU = 0.0
var arrCnt = 0
var wnowstep = 0
var nowstep = 0
var wallstep = 0
var allstep = 0
var wdistanceKM = 0.0
var distanceKM = 0.0
var avgsize = 0.0
var wdistance = 0.0
var distance = 0.0
var pHrv = 0
var distanceM = 0.0

var idistanceM = 0
var idCal = 0
var idExeCal = 0

var HeartAttack = 0
var HeartAttackFlag = 0
var nonContact = 0
var noncontactFlag = 0
var Myo = 0
var MyoFlag = 0
var arrFlag = 0

var Tarchycardia = 0
var TarchycardiaFlag = 0
var Bradycardia = 0
var BradycardiaFlag = 0
var FastTarchycardia = 0
var FastTarchycardiaFlag = 0
var AtrialFibrillaion = 0
var AtrialFibrillaionFlag = 0

var userDefaultsHeartAttack:Bool = false
var userDefaultsArr:Bool = false
var userDefaultsMyo:Bool = false
var userDefaultsNoncontact:Bool = false
var userDefaultsTarchycardia:Bool = false
var userDefaultsBradycardia:Bool = false
var userDefaultsAtrialFibrillaion:Bool = false

var dCal = 0.0
var wdCal = 0.0
var dExeCal = 0.0
var wdExeCal = 0.0

var pre_dCal = 0
var i_dCal = 0
var daily_dCal = 0

var pre_dExeCal = 0
var i_dExeCal = 0
var daily_dExeCal = 0

var pre_distanceKM = 0
var i_distanceKM = 0
var daily_distanceKM = 0

var pre_allstep = 0
var i_allstep = 0
var daily_allstep = 0

var pre_arrCnt = 0
var i_arrCnt = 0
var daily_arrCnt = 0


var s_daily_dCal = ""
var s_daily_dExeCal = ""
var s_daily_distanceKM = ""
var s_daily_allstep  = ""
var s_daily_arrCnt = ""

var s_idCal = ""
var s_idExeCal = ""
var s_idistanceM = ""
var s_allstep = ""
var s_arrCnt = ""

var s_M_dCal = ""
var s_M_dExeCal = ""
var s_M_distanceKM = ""
var s_M_allstep = ""
var s_M_arrCnt = ""

var M_dCal = 0
var preM_dCal = 0
var M_dExeCal = 0
var preM_dExeCal = 0
var M_distanceKM = 0
var preM_distanceKM = 0
var M_allstep = 0
var preM_allstep = 0
var M_arrCnt = 0
var preM_arrCnt = 0

var name = "Name"
var identification = "LookHeart"
var iGender = 1
var iAge = 54
var dWeight = 92
var disheight = 182
var eCalBPM = 90
var iAge_parameter =  0.0
var dWeight_parameter = 0.0
var heartrate_parameter = 0.0
var guardianTel = 01012345678
var guardianTel2 = 01012345678


//var ecgPacket = [Double](repeating: 0.0, count: 13)
var ecgPacket = [Double](repeating: 0.0, count: 14)

var ecgData = [Double](repeating: 0.0, count: 500)

var ecg = 0
var ecgP = 0
var dEcg = 0.0

var dataEntries = [ChartDataEntry]()
var iRecvCnt = 0
var eRecvCnt = 0
var arriRecvCnt = 0

var lVSum = 0
var lVMin = 0
var lVMax = 0
var lVAvg = 0
var lVCnt = 0

var tenSecondlVSum = 0
var tenSecondlVMin = 0
var tenSecondlVMax = 0
var tenSecondlVAvg = 0
var tenSecondlVCnt = 0


var tenMinutelVSum = 0
var tenMinutelVMin = 0
var tenMinutelVMax = 0
var tenMinutelVAvg = 0
var tenMinutelVCnt = 0

var tenSecondTemplVSum = 0.0
var tenSecondTemplVMin = 0.0
var tenSecondTemplVMax = 0.0
var tenSecondTemplVAvg = 0.0
var tenSecondTemplVCnt = 0

var tenSecondHRVSum = 0
var tenSecondHRVAvg = 0

var preDay = ""
var preDate = ""
var preMonth = ""
var preYear = ""

var dataCnt = 0

private var txCharacteristic: CBCharacteristic!
private var rxCharacteristic: CBCharacteristic!

var gpsDate = Date()
var gpsLat = 0.0
var gpsLong = 0.0

let date = Date()
let calendar = Calendar.autoupdatingCurrent

var pre_hour = ""
var currentHour = ""
var currentDate = ""

var timerCnt = 0
var timer10Seconds = 0
var timerMinutes = 0
var timerTenMinutes = 0
var timerHours  = 0
var countTimer = 0

var realTime:String = ""
var actualTime:String = ""
var bpmTime:String = ""

var realYear:String = ""
var realMonth:String = ""
var realDate:String = ""
var realDay:String = ""
var realHour:String = ""
var realMinute:String = ""
var realSecond :String = ""

var packetCnt = 0
var packetList: String = ""

var pre_minute = ""

var monthlyOffset: UInt64 = 0
var monthlyCurrentOffset: UInt64 = 0
var monthlyNewOffset: UInt64 = 0

var monthlyOffset1: UInt64 = 0
var monthlyCurrentOffset1: UInt64 = 0
var monthlyNewOffset1: UInt64 = 0

var monthlyOffset2: UInt64 = 0
var monthlyCurrentOffset2: UInt64 = 0
var monthlyNewOffset2: UInt64 = 0

var monthlyOffset3: UInt64 = 0
var monthlyCurrentOffset3: UInt64 = 0
var monthlyNewOffset3: UInt64 = 0

var dailyOffset: UInt64 = 0
var dailyCurrentOffset: UInt64 = 0
var dailyNewOffset: UInt64 = 0

var dailyOffset1: UInt64 = 0
var dailyCurrentOffset1: UInt64 = 0
var dailyNewOffset1: UInt64 = 0

var dailyOffset2: UInt64 = 0
var dailyCurrentOffset2: UInt64 = 0
var dailyNewOffset2: UInt64 = 0

var dailyOffset3: UInt64 = 0
var dailyCurrentOffset3: UInt64 = 0
var dailyNewOffset3: UInt64 = 0

var hourlyOffset: UInt64 = 0
var hourlyCurrentOffset: UInt64 = 0
var hourlyNewOffset: UInt64 = 0

var hourlyOffset1: UInt64 = 0
var hourlyCurrentOffset1: UInt64 = 0
var hourlyNewOffset1: UInt64 = 0

var compareRealYear:String = ""
var compareRealMonth:String = ""
var compareRealDate:String = ""
var compareRealDay:String = ""

var compareYear:String = ""
var compareMonth:String = ""

var dateDifference = 0
var monthDifference = 0

var thisMonth = Date()
var compareTodayDate = Date()

var differenceHour = 0

var d_pre_hour = 0
var d_realHour = 0

var dateChangeFlag = 0
var monthChangeFlag = 0

var noncontactCount = 0

var audioPlayer: AVAudioPlayer?
var soundTimeTrigger = true
var soundRealTime = Timer()

var exerciseTarchycardiaFlag: Bool = false
var centralManager: CBCentralManager!

var utcOffsetAndCountry = ""
var bodyStatus = ""
var arrStatus = ""

class MainViewController: UIViewController, CLLocationManagerDelegate{
    
    //    let userNotiCenter = UNUserNotificationCenter.current()
    
    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral!
//    var locationManger = CLLocationManager()
    var locationManager: CLLocationManager!
    
    private let safeAreaView = UIView()
    
    var tensecondStep = 0 // 10초 동안 걸음 수 체크
    var isSleep:Bool = false // 수면 시간 체크
    
    let ecgAndPeakImage =  UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    var ecgPeakCheck:Bool = false // false : Peak
    
    // Navigation title Label
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "LOOKHEART"
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy) // 크기, 굵음 정도 설정
        label.textColor = .black
        
        return label
    }()
    
    var batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "%"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
        return label
    }()
    
    // Navigation battery prograss
    lazy var batProgress: UIProgressView = {
        let battery = UIProgressView()
        
        let batteryLevel: Float = 0.5 // 프로그래스 바 값 설정
        battery.setProgress(batteryLevel, animated: false)
        battery.progressViewStyle = .default
        battery.progressTintColor = UIColor.red
        battery.trackTintColor = UIColor.lightGray
        battery.layer.cornerRadius = 8
        battery.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
        battery.clipsToBounds = true
        // height 높이 설정
        battery.transform = battery.transform.scaledBy(x: 1, y: 3)
        
        return battery
        
    }()
    
    let customView: UIView = {
        let customView = UIView()
        //        customView.backgroundColor = .green
        customView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        return customView
    }()
    
    
    // view 설정
    private func setupView() {
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.backgroundColor = .white
        view.addSubview(safeAreaView)
        
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            safeAreaView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                safeAreaView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: safeAreaView.bottomAnchor, multiplier: 1.0)
            ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                safeAreaView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: standardSpacing)
            ])
        }
        
        let guide = view.safeAreaLayoutGuide
        let dsafeAreaHeight = guide.layoutFrame.size.height
        let dsafeAreaWidth = guide.layoutFrame.size.width
        
        let dhalfSafeAreaHeight = dsafeAreaHeight/2
        let dhalfSafeAreaWidth = dsafeAreaWidth/2
        
        let dTwoOfThreeSafeAreaHeight = (2.0 * dsafeAreaHeight)/3
        let dTwoOfThreeSafeAreaWidth = (2.0 * dsafeAreaWidth)/3
        
        halfSafeAreaHeight = Int(dhalfSafeAreaHeight)
        halfSafeAreaWidth = Int(dhalfSafeAreaWidth)
        safeAreaHeight = Int(dsafeAreaHeight)
        safeAreaWidth = Int(dsafeAreaWidth)
        
        TwoOfThreeSafeAreaHeight = Int(dTwoOfThreeSafeAreaHeight)
        TwoOfThreeSafeAreaWidth = Int(dTwoOfThreeSafeAreaWidth)
        safeAreaWidth = Int(dsafeAreaWidth)
    }
    
    // MARK: - ecgButton
    lazy var ecgAndPeakImageButton: UIButton = {
       let button = UIButton()

        button.setImage(ecgAndPeakImage, for: .normal)
        button.isEnabled = true

        button.addTarget(self, action: #selector(buttonPEAK(_:)), for: .touchUpInside)
       return button
   }()

    lazy var ecgAndPeakButton: UIButton = {
       let button = UIButton()

        button.setTitle("Peak", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.clear.cgColor
        button.isEnabled = true

        button.addTarget(self, action: #selector(buttonPEAK(_:)), for: .touchUpInside)
       return button
   }()
    
    // chart
    lazy var chartView: LineChartView =  {
        let chartView = LineChartView()
        return chartView
        
    }()
        
    lazy var heartBackground: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
//        label.layer.borderColor = UIColor(red: 239/255, green: 80/255, blue: 123/255, alpha: 1.0).cgColor
        label.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 10
        
        return label
    }()
    
    lazy var heart: UIImageView = {
        var imageView = UIImageView()
        // record.circle
        let image =  UIImage(named: "myHeartbeat")!
        
        let coloredImage = image.withRenderingMode(.alwaysTemplate)
        
        imageView.image = coloredImage
//        imageView.tintColor = UIColor(red: 239/255, green: 80/255, blue: 123/255, alpha: 1.0)
        imageView.tintColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit // 또는 .scaleAspectFill
        
        return imageView
    }()
    lazy var heartValue = UILabel().then {
        $0.text = "0"
//        $0.textColor = UIColor(red: 239/255, green: 80/255, blue: 123/255, alpha: 1.0)
        $0.textColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0)
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 30)
    }
    
    lazy var topViewLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .gray
        return label
    }()
    
    lazy var HeartBeat = UILabel().then {
        //        $0.text = "맥박"
//        $0.text = "Heart rate"
        $0.text = "Avg"
        $0.textColor = .black
//        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var HeartBeatValue = UILabel().then {
        $0.text = "0"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    lazy var minHeartBeat = UILabel().then {
        $0.text = "Min"
        $0.textColor = .lightGray
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var minHeartBeatValue = UILabel().then {
        $0.text = "0"
        $0.textColor = .lightGray
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var diffMinHeartBeatValue = UILabel().then {
        $0.text = "0"
        $0.textColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0)
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var aveHeartBeat = UILabel().then {
        $0.text = "0"
        $0.textColor = .lightGray
//        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var maxHeartBeat = UILabel().then {
        $0.text = "Max"
        $0.textColor = .lightGray
//        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var maxHeartBeatValue = UILabel().then {
        $0.text = "0"
        $0.textColor = .lightGray
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var diffMaxHeartBeatValue = UILabel().then {
        $0.text = "0"
        $0.textColor = UIColor(red: 239/255, green: 80/255, blue: 123/255, alpha: 1.0)
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var HRV = UILabel().then {
        $0.text = "HRV"
        $0.textColor = .black
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var HRVValue = UILabel().then {
        $0.text = "0"
        $0.textColor = .black
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var HRVUnit = UILabel().then {
        $0.text = "ms"
        $0.textColor = .lightGray
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxHeartBeat, HeartBeat, minHeartBeat, HRV])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually // default
        stackView.alignment = .fill // default
//        stackView.backgroundColor = .white
        return stackView
    }()
    
    lazy var arrButton: UIButton = {
        
        let button = UIButton()
       
        button.setTitle("비정상맥박", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor(red: 239/255, green: 80/255, blue: 123/255, alpha: 1.0)
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 10
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        
        button.addTarget(self, action: #selector(viewButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var arrValue = UILabel().then {
        $0.text = "0"
        $0.textColor = .white
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var arrValue2 = UILabel().then {
        $0.text = "회"
        $0.textColor = .white
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    lazy var restButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("휴식", for: .normal)
       button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "mug"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0)
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
       button.isEnabled = false
       button.isUserInteractionEnabled = true
        
        button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
       return button
   }()
    
    lazy var activityButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("활동", for: .normal)
       button.setTitleColor(.lightGray, for: .normal)
        button.setImage(UIImage(named: "dumbbell"), for: .normal)
        button.tintColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
       button.isEnabled = false
       button.isUserInteractionEnabled = true
        
        button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
       return button
   }()
    
    lazy var sleepButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("수면", for: .normal)
       button.setTitleColor(.lightGray, for: .normal)
        button.setImage(UIImage(named: "sleep"), for: .normal)
        button.tintColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
       button.isEnabled = false
       button.isUserInteractionEnabled = true
        
        button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
       return button
   }()
    
    lazy var buttonBackground: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        
        return label
   }()
    
    @objc func ButtonEvent(_ sender: UIButton) {
        let buttons = [restButton, activityButton, sleepButton]
        
        for button in buttons {
            if button == sender {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0)
                button.tintColor = .white
                
            } else {
                button.setTitleColor(.lightGray, for: .normal)
                button.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
                button.tintColor = .lightGray
            }
        }
    }
    
    //MARK: - 상단 위치 설정
    func battery() {
        
        //MARK: - ECG/PEAK
        view.addSubview(ecgAndPeakImageButton)
        view.addSubview(ecgAndPeakButton)
        
        let viewWidth = self.view.frame.size.width / 2
        let buttonWidth = (viewWidth - 30) / 3
        
        view.addSubview(heartBackground)
        view.addSubview(heart)
        view.addSubview(heartValue)
        view.addSubview(topViewLabel)
        view.addSubview(topStackView)
        view.addSubview(maxHeartBeatValue)
        view.addSubview(diffMaxHeartBeatValue)
        view.addSubview(minHeartBeatValue)
        view.addSubview(diffMinHeartBeatValue)
        view.addSubview(HRVValue)
        view.addSubview(HRVUnit)
        view.addSubview(HeartBeatValue)
        view.addSubview(aveHeartBeat)
        view.addSubview(arrButton)
        view.addSubview(arrValue)
        view.addSubview(arrValue2)
        view.addSubview(buttonBackground)
        view.addSubview(restButton)
        view.addSubview(activityButton)
        view.addSubview(sleepButton)
        
        ecgAndPeakImageButton.translatesAutoresizingMaskIntoConstraints = false
        ecgAndPeakButton.translatesAutoresizingMaskIntoConstraints = false
        
        heartBackground.translatesAutoresizingMaskIntoConstraints = false
        heart.translatesAutoresizingMaskIntoConstraints = false
        heartValue.translatesAutoresizingMaskIntoConstraints = false
        topViewLabel.translatesAutoresizingMaskIntoConstraints = false
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        maxHeartBeatValue.translatesAutoresizingMaskIntoConstraints = false
        diffMaxHeartBeatValue.translatesAutoresizingMaskIntoConstraints = false
        minHeartBeatValue.translatesAutoresizingMaskIntoConstraints = false
        diffMinHeartBeatValue.translatesAutoresizingMaskIntoConstraints = false
        HRVValue.translatesAutoresizingMaskIntoConstraints = false
        HeartBeatValue.translatesAutoresizingMaskIntoConstraints = false
        HRVUnit.translatesAutoresizingMaskIntoConstraints = false
        aveHeartBeat.translatesAutoresizingMaskIntoConstraints = false
        arrButton.translatesAutoresizingMaskIntoConstraints = false
        arrValue.translatesAutoresizingMaskIntoConstraints = false
        arrValue2.translatesAutoresizingMaskIntoConstraints = false
        restButton.translatesAutoresizingMaskIntoConstraints = false
        activityButton.translatesAutoresizingMaskIntoConstraints = false
        sleepButton.translatesAutoresizingMaskIntoConstraints = false
        buttonBackground.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            ecgAndPeakImageButton.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            ecgAndPeakImageButton.leadingAnchor.constraint(equalTo: topViewLabel.leadingAnchor),
            ecgAndPeakImageButton.trailingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            ecgAndPeakImageButton.heightAnchor.constraint(equalToConstant: 30),

            ecgAndPeakButton.topAnchor.constraint(equalTo: ecgAndPeakImageButton.topAnchor),
            ecgAndPeakButton.leadingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            ecgAndPeakButton.trailingAnchor.constraint(equalTo: topViewLabel.trailingAnchor),
            ecgAndPeakButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            
            heartBackground.topAnchor.constraint(equalTo: ecgAndPeakImageButton.bottomAnchor, constant: 5),
//            heartBackground.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 5),
            heartBackground.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 0),
            heartBackground.trailingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: -20),
            heartBackground.heightAnchor.constraint(equalToConstant: 80),
            
            heart.centerXAnchor.constraint(equalTo: heartBackground.centerXAnchor),
            heart.topAnchor.constraint(equalTo: heartBackground.topAnchor, constant: -8),
            heart.widthAnchor.constraint(equalToConstant: 30),
            
            heartValue.centerXAnchor.constraint(equalTo: heartBackground.centerXAnchor),
            heartValue.centerYAnchor.constraint(equalTo: heartBackground.centerYAnchor),
            
            
            
            topViewLabel.topAnchor.constraint(equalTo: ecgAndPeakImageButton.bottomAnchor, constant: 5),
//            topViewLabel.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 5),
            topViewLabel.leadingAnchor.constraint(equalTo: safeAreaView.centerXAnchor),
            topViewLabel.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            topViewLabel.heightAnchor.constraint(equalToConstant: 80),
            
            topStackView.topAnchor.constraint(equalTo: topViewLabel.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: topViewLabel.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            topStackView.bottomAnchor.constraint(equalTo: topViewLabel.bottomAnchor),
            
            maxHeartBeatValue.centerYAnchor.constraint(equalTo: maxHeartBeat.centerYAnchor),
            maxHeartBeatValue.trailingAnchor.constraint(equalTo: topViewLabel.trailingAnchor, constant: -20),
            
            diffMaxHeartBeatValue.centerYAnchor.constraint(equalTo: maxHeartBeat.centerYAnchor),
            diffMaxHeartBeatValue.leadingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            
            minHeartBeatValue.centerYAnchor.constraint(equalTo: minHeartBeat.centerYAnchor),
            minHeartBeatValue.trailingAnchor.constraint(equalTo: topViewLabel.trailingAnchor, constant: -20),
            
            diffMinHeartBeatValue.centerYAnchor.constraint(equalTo: minHeartBeat.centerYAnchor),
            diffMinHeartBeatValue.leadingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            
            HeartBeatValue.centerYAnchor.constraint(equalTo: HeartBeat.centerYAnchor),
            HeartBeatValue.leadingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            
            aveHeartBeat.centerYAnchor.constraint(equalTo: HeartBeat.centerYAnchor),
            aveHeartBeat.trailingAnchor.constraint(equalTo: topViewLabel.trailingAnchor, constant: -20),
            
            HRVValue.centerYAnchor.constraint(equalTo: HRV.centerYAnchor),
            HRVValue.leadingAnchor.constraint(equalTo: topViewLabel.centerXAnchor),
            
            HRVUnit.centerYAnchor.constraint(equalTo: HRV.centerYAnchor),
            HRVUnit.trailingAnchor.constraint(equalTo: topViewLabel.trailingAnchor, constant: -20),
            
            arrButton.topAnchor.constraint(equalTo: topViewLabel.bottomAnchor, constant: 20),
            arrButton.leadingAnchor.constraint(equalTo: topViewLabel.leadingAnchor, constant: 0),
            arrButton.trailingAnchor.constraint(equalTo: topViewLabel.trailingAnchor),
            arrButton.heightAnchor.constraint(equalToConstant: 30),
            
            arrValue.centerXAnchor.constraint(equalTo: arrButton.centerXAnchor, constant: 10),
            arrValue.centerYAnchor.constraint(equalTo: arrButton.centerYAnchor),
            
            arrValue2.centerYAnchor.constraint(equalTo: arrButton.centerYAnchor),
            arrValue2.trailingAnchor.constraint(equalTo: arrButton.trailingAnchor, constant: -20),
            
            buttonBackground.centerYAnchor.constraint(equalTo: arrButton.centerYAnchor),
            buttonBackground.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            buttonBackground.trailingAnchor.constraint(equalTo: arrButton.leadingAnchor, constant: -20),
            buttonBackground.heightAnchor.constraint(equalToConstant: 30),
            
            restButton.centerYAnchor.constraint(equalTo: arrButton.centerYAnchor),
            restButton.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 0),
            restButton.heightAnchor.constraint(equalToConstant: 30),
            restButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            activityButton.centerYAnchor.constraint(equalTo: arrButton.centerYAnchor),
            activityButton.leadingAnchor.constraint(equalTo: restButton.trailingAnchor, constant: 0),
            activityButton.heightAnchor.constraint(equalToConstant: 30),
            activityButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            sleepButton.centerYAnchor.constraint(equalTo: arrButton.centerYAnchor),
            sleepButton.leadingAnchor.constraint(equalTo: activityButton.trailingAnchor, constant: 0),
            sleepButton.heightAnchor.constraint(equalToConstant: 30),
            sleepButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        view.addSubview(chartView)
        chartView.snp.makeConstraints {(make) in
//            make.top.equalTo(self.peakButton.snp.bottom).offset(10) // ecg, peak 모드 사용 시 설정
//            make.top.equalTo(self.safeAreaView.snp.top).offset(10)
            make.top.equalTo(arrButton.snp.bottom).offset(10)
            make.width.equalTo(self.safeAreaView.snp.width)
        }
    }
    
    // 하단 위치 설정
    let calLabel: UILabel = {
        let label = UILabel()
        
        label.text = "활동 칼로리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
        label.textColor = .darkGray
        
        return label
    }()
    let calValue: UILabel = {
        let label = UILabel()
        
        label.text = "0\nKcal"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.textAlignment = .right
        
        return label
    }()
    let stepLabel: UILabel = {
        let label = UILabel()
        
        label.text = "걸음수"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .darkGray
        
        return label
    }()
    let stepValue: UILabel = {
        let label = UILabel()
        
        label.text = "0\n걸음"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.textAlignment = .right
        
        return label
    }()
    let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.text = "전극온도"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .darkGray
        
        return label
    }()
    let temperatureValue: UILabel = {
        let label = UILabel()
        
        label.text = "-\n°C"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.textAlignment = .right
        
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "걸음거리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .darkGray
        
        return label
    }()
    let distanceValue: UILabel = {
        let label = UILabel()
        
        label.text = "0.000\nkm"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var calButton: UIButton = {
        let button = UIButton()
//        button.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(viewButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    lazy var stepButton: UIButton = {
        let button = UIButton()
//        button.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(viewButtonEvent(_:)), for: .touchUpInside)
        return button
    }()
    lazy var calAndStepStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calButton, stepButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // default
        stackView.alignment = .fill // default
        stackView.spacing = 10
//        stackView.backgroundColor = .white
//        stackView.backgroundColor = .blue
        return stackView
    }()
    
    lazy var temperatureButton: UIButton = {
        let button = UIButton()
//        button.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(viewButtonEvent(_:)), for: .touchUpInside)
        return button
    }()
    lazy var DistanceButton: UIButton = {
        let button = UIButton()
//        button.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(viewButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    @objc func viewButtonEvent(_ sender: UIButton) {
        
        if sender.tag == 1 {
            // arr
            self.tabBarController?.selectedIndex = 2
        }
        else if sender.tag == 2 {
            // calorie
            self.tabBarController?.selectedIndex = 1
            defaults.set(1, forKey: "ChildView")
        }
        else if sender.tag == 3 {
            // step
            self.tabBarController?.selectedIndex = 1
            defaults.set(2, forKey: "ChildView")
        }
        else if sender.tag == 4 {
            // temperature
            self.tabBarController?.selectedIndex = 1
            defaults.set(3, forKey: "ChildView")
        }
        else if sender.tag == 5 {
            // distance
            self.tabBarController?.selectedIndex = 1
            defaults.set(4, forKey: "ChildView")
        }
        defaults.set(true, forKey: "SummaryButtonCheck")
    }
    
    lazy var temperatureAndDistanceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureButton, DistanceButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // default
        stackView.alignment = .fill // default
        stackView.spacing = 10
//        stackView.backgroundColor = .white
//        stackView.backgroundColor = .red
        return stackView
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calAndStepStackView, temperatureAndDistanceStackView])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually // default
        stackView.alignment = .fill // default
        stackView.spacing = 10
//        stackView.backgroundColor = .white
//        stackView.backgroundColor = .green
        return stackView
    }()
    
    // MARK: - 하단 위치 설정
    func setupConstraint(){
        
        arrButton.tag = 1
        calButton.tag = 2
        stepButton.tag = 3
        temperatureButton.tag = 4
        DistanceButton.tag = 5
        
        view.addSubview(bottomStackView)
        view.addSubview(calLabel)
        view.addSubview(calValue)
        
        view.addSubview(stepLabel)
        view.addSubview(stepValue)
        
        view.addSubview(temperatureLabel)
        view.addSubview(temperatureValue)
        
        view.addSubview(distanceLabel)
        view.addSubview(distanceValue)
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        calLabel.translatesAutoresizingMaskIntoConstraints = false
        calValue.translatesAutoresizingMaskIntoConstraints = false
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepValue.translatesAutoresizingMaskIntoConstraints = false
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureValue.translatesAutoresizingMaskIntoConstraints = false
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceValue.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 130),
            
            calLabel.topAnchor.constraint(equalTo: calButton.topAnchor, constant: 10),
            calLabel.leadingAnchor.constraint(equalTo: calButton.leadingAnchor, constant: 10),
            
            calValue.trailingAnchor.constraint(equalTo: calButton.trailingAnchor, constant: -10),
            calValue.bottomAnchor.constraint(equalTo: calButton.bottomAnchor, constant: -10),
            
            
            stepLabel.topAnchor.constraint(equalTo: stepButton.topAnchor, constant: 10),
            stepLabel.leadingAnchor.constraint(equalTo: stepButton.leadingAnchor, constant: 10),
            
            stepValue.trailingAnchor.constraint(equalTo: stepButton.trailingAnchor, constant: -10),
            stepValue.bottomAnchor.constraint(equalTo: stepButton.bottomAnchor, constant: -10),
            
            temperatureLabel.topAnchor.constraint(equalTo: temperatureButton.topAnchor, constant: 10),
            temperatureLabel.leadingAnchor.constraint(equalTo: temperatureButton.leadingAnchor, constant: 10),
            
            temperatureValue.trailingAnchor.constraint(equalTo: temperatureButton.trailingAnchor, constant: -10),
            temperatureValue.bottomAnchor.constraint(equalTo: temperatureButton.bottomAnchor, constant: -10),
            
            distanceLabel.topAnchor.constraint(equalTo: DistanceButton.topAnchor, constant: 10),
            distanceLabel.leadingAnchor.constraint(equalTo: DistanceButton.leadingAnchor, constant: 10),
            
            distanceValue.trailingAnchor.constraint(equalTo: DistanceButton.trailingAnchor, constant: -10),
            distanceValue.bottomAnchor.constraint(equalTo: DistanceButton.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 초기화
//        UserDefaults.standard.set("0", forKey: "guardianAlert")
        
        name = defaults.string(forKey: "name") ?? "null"
        identification = defaults.string(forKey: "Id")  ?? ""
        iGender = defaults.integer(forKey: "Sex")
        iAge = defaults.integer(forKey: "Age")
        disheight = defaults.integer(forKey: "Height")
        dWeight = defaults.integer(forKey: "Weight")
        eCalBPM = defaults.integer(forKey: "eCalBpm")
        
        tStep = defaults.integer(forKey: "TargetStep")
        tDistance = defaults.integer(forKey: "TargetDistance")
        teCal = defaults.integer(forKey: "TargeteCal")
        ttcal = defaults.integer(forKey: "TargettCal")
        guardianTel = defaults.integer(forKey: "guardianTel1")
        guardianTel2 = defaults.integer(forKey: "guardianTel2")
        
        defaults.set(false, forKey: "exerciseTarchycardiaFlag") // 운동 상태 값 false
        
        // 일주일이 지난 운동 기록 삭제
        let exerciseVC = RecentRecordVC()
        exerciseVC.deleteExerciseData()
        
        let date = Date()
        let df = DateFormatter()
        let ds = DateFormatter()
        let dh = DateFormatter()
        let dm = DateFormatter()
        let dyear = DateFormatter()
        let dmonth = DateFormatter()
        let ddate = DateFormatter()
        let dday = DateFormatter()
        let dhm = DateFormatter()
        
        
        df.dateFormat = "HH:mm:ss"
        dyear.dateFormat = "yyyy"
        dmonth.dateFormat = "MM"
        ddate.dateFormat = "dd"
        dday.dateFormat = "EEE"
        dh.dateFormat = "HH"
        dm.dateFormat = "mm"
        ds.dateFormat = "ss"
        dhm.dateFormat = "HH:mm"
        
        
        realTime = df.string(from: date)
        actualTime = dhm.string(from: date)
        realYear = dyear.string(from: date)
        realMonth = dmonth.string(from: date)
        realDate = ddate.string(from: date)
        realDay = dday.string(from: date)
        realHour = dh.string(from: date)
        realMinute = dm.string(from: date)
        realSecond = ds.string(from: date)
        
        pre_hour = defaults.string(forKey: "pre_hour") ?? "00"
        pre_minute = defaults.string(forKey: "pre_minute") ?? ""
        preDay = defaults.string(forKey: "Day") ?? ""
        preDate = defaults.string(forKey: "Date") ?? "01"
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        timeZone()
        
        // navi, view, constraints 설정
        setNavigation()
        
        defaultFunction()
        
        createDirectory()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        setupView()
        battery()
        setupConstraint()
        
        // alert sound 설정
        do {
            // 무음일 때 소리 안남
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            // 무음일 때 소리 남
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션을 설정하는 데 문제가 발생했습니다.")
        }
        // noncontact sound 1분마다 하게끔
        checkTimeTrigger()
        
        // MARK: - location
        // 위치 관리자 초기화
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
//        // 위치 사용 권한 요청
        locationManager.requestWhenInUseAuthorization()
                
//        locationManger.delegate = self
//        // 거리 정확도 설정
//        locationManger.desiredAccuracy = kCLLocationAccuracyBest
//        // 사용자에게 허용 받기 alert 띄우기
//        locationManger.requestWhenInUseAuthorization()

        // 비동기로 실행
//        DispatchQueue.global().async { [self] in
//            if CLLocationManager.locationServicesEnabled() {
//                    switch CLLocationManager.authorizationStatus() {
//                    case .authorizedAlways, .authorizedWhenInUse:
//                        print("위치 서비스 On 상태")
////                        locationManager.startUpdatingLocation() //위치 정보 받아오기 시작
////                        locationManager.startMonitoringSignificantLocationChanges()
////                        print(locationManager.location?.coordinate as Any)
//                    case .denied:
//                        print("Location services denied")
//                        // 위치 서비스가 거부된 상태입니다. 사용자가 위치 서비스를 비활성화한 것으로 처리할 수 있습니다.
//                    case .restricted:
//                        print("Location services restricted")
//                        // 위치 서비스가 제한된 상태입니다. 일부 제한된 조건에서만 위치 서비스를 사용할 수 있습니다.
//                    case .notDetermined:
//                        print("Location services not determined")
//                        // 위치 서비스 권한 요청이 아직 이루어지지 않은 상태입니다.
//                    @unknown default:
//                        break
//                    }
//                } else {
//                    print("Location services disabled")
//                    // 위치 서비스가 비활성화된 상태입니다. 사용자가 위치 서비스를 사용하지 않도록 설정한 것으로 처리할 수 있습니다.
//                }
//        }

        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tenSecondtimerTicks), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(calAndDistance), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(didUpdatedChartView), userInfo: nil, repeats: true)
        
    }
    
    // timeInterval 값(초) 마다 soundTimeTrigger 값을 true로 만듬
    func checkTimeTrigger() {
        soundRealTime = Timer.scheduledTimer(timeInterval: 30, target: self,
            selector: #selector(updateCounter), userInfo: nil, repeats: true)
        soundTimeTrigger = true
    }
    
    @objc func updateCounter(){
        soundTimeTrigger = true
    }
    
    func defaultFunction(){
        pre_hour = defaults.string(forKey: "pre_hour") ?? "00"
        pre_minute = defaults.string(forKey: "pre_minute") ?? ""
        preDay = defaults.string(forKey: "Day") ?? ""
        preDate = defaults.string(forKey: "Date") ?? "01"
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        
        // 웗별 데이터 확인 필요
        if  (preMonth != realMonth){
            
            preM_dCal = 0
            preM_dExeCal = 0
            preM_distanceKM = 0
            preM_allstep = 0
            preM_arrCnt = 0
            
            defaults.set(preM_dCal, forKey: "preM_dCal")
            defaults.set(preM_dExeCal, forKey: "preM_dExeCal")
            defaults.set(preM_distanceKM, forKey: "preM_distanceKM")
            defaults.set(preM_allstep, forKey: "preM_allstep")
            defaults.set(preM_arrCnt, forKey: "preM_arrCnt")
            
            
            monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
            monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
            
            
            arrCnt = 0
            allstep = 0
            distance = 0.0
            dCal = 0.0
            dExeCal = 0.0
            
            hourlyOffset = 0
            hourlyCurrentOffset = 0
            pre_hour = "00"
             
            pre_dCal = 0
            pre_dExeCal = 0
            pre_distanceKM = 0
            pre_allstep = 0
            pre_arrCnt = 0
               
            let inter_dCal = 0
            let inter_dExeCal = 0
            let inter_distanceKM = 0
            let inter_allstep = 0
            let inter_arrCnt = 0
            
            defaults.set(inter_dCal, forKey: "inter_dCal")
            defaults.set(inter_dExeCal, forKey: "inter_dExeCal")
            defaults.set(inter_distanceKM, forKey: "inter_distanceKM")
            defaults.set(inter_allstep, forKey: "inter_allstep")
            defaults.set(inter_arrCnt, forKey: "inter_arrCnt")
            
            
            dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
            dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
            
            
            defaults.set(hourlyOffset, forKey: "hourlyOffset")
            defaults.set(hourlyCurrentOffset, forKey: "hourlyCurrentOffset")
            
            defaults.set(pre_hour, forKey: "pre_hour")
            
            defaults.set(arrCnt, forKey: "arrCnt")
            defaults.set(allstep, forKey: "allstep")
            defaults.set(distance, forKey: "distance")
            defaults.set(dCal, forKey: "dCal")
            defaults.set(dExeCal, forKey: "dExeCal")
            
            defaults.set(pre_dCal, forKey: "pre_dCal")
            defaults.set(pre_dExeCal, forKey: "pre_dExeCal")
            defaults.set(pre_distanceKM, forKey: "pre_distanceKM")
            defaults.set(pre_allstep, forKey: "pre_allstep")
            defaults.set(pre_arrCnt, forKey: "pre_arrCnt")
            
        } else if(preDate != realDate){
            
            arrCnt = 0
            allstep = 0
            distance = 0.0
            dCal = 0.0
            dExeCal = 0.0
            
            hourlyOffset = 0
            hourlyCurrentOffset = 0
            pre_hour = "00"
            
            pre_dCal = 0
            pre_dExeCal = 0
            pre_distanceKM = 0
            pre_allstep = 0
            pre_arrCnt = 0
            
            let inter_dCal = 0
            let inter_dExeCal = 0
            let inter_distanceKM = 0
            let inter_allstep = 0
            let inter_arrCnt = 0
            
            defaults.set(inter_dCal, forKey: "inter_dCal")
            defaults.set(inter_dExeCal, forKey: "inter_dExeCal")
            defaults.set(inter_distanceKM, forKey: "inter_distanceKM")
            defaults.set(inter_allstep, forKey: "inter_allstep")
            defaults.set(inter_arrCnt, forKey: "inter_arrCnt")
            
            dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
            dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
            
            preM_dCal = defaults.integer(forKey: "preM_dCal")
            preM_dExeCal = defaults.integer(forKey: "preM_dExeCal")
            preM_distanceKM = defaults.integer(forKey: "preM_distanceKM")
            preM_allstep = defaults.integer(forKey: "preM_allstep")
            preM_arrCnt = defaults.integer(forKey: "preM_arrCnt")
            
            defaults.set(hourlyOffset, forKey: "hourlyOffset")
            defaults.set(hourlyCurrentOffset, forKey: "hourlyCurrentOffset")
            
            defaults.set(pre_hour, forKey: "pre_hour")
            
            defaults.set(arrCnt, forKey: "arrCnt")
            defaults.set(allstep, forKey: "allstep")
            defaults.set(distance, forKey: "distance")
            defaults.set(dCal, forKey: "dCal")
            defaults.set(dExeCal, forKey: "dExeCal")
            
            defaults.set(pre_dCal, forKey: "pre_dCal")
            defaults.set(pre_dExeCal, forKey: "pre_dExeCal")
            defaults.set(pre_distanceKM, forKey: "pre_distanceKM")
            defaults.set(pre_allstep, forKey: "pre_allstep")
            defaults.set(pre_arrCnt, forKey: "pre_arrCnt")
            
        } else {
            arrCnt = defaults.integer(forKey: "arrCnt")
            allstep = defaults.integer(forKey: "allstep")
            distance = defaults.double(forKey: "distance")
            dCal = defaults.double(forKey: "dCal")
            dExeCal = defaults.double(forKey: "dExeCal")
            
            pre_dCal = defaults.integer(forKey: "pre_dCal")
            pre_dExeCal = defaults.integer(forKey: "pre_dExeCal")
            pre_distanceKM = defaults.integer(forKey: "pre_distanceKM")
            pre_allstep = defaults.integer(forKey: "pre_allstep")
            pre_arrCnt = defaults.integer(forKey: "pre_arrCnt")
            
            
            preM_dCal = defaults.integer(forKey: "preM_dCal")
            preM_dExeCal = defaults.integer(forKey: "preM_dExeCal")
            preM_distanceKM = defaults.integer(forKey: "preM_distanceKM")
            preM_allstep = defaults.integer(forKey: "preM_allstep")
            preM_arrCnt = defaults.integer(forKey: "preM_arrCnt")
            
            
            idCal = defaults.integer(forKey: "idCal")
            idExeCal = defaults.integer(forKey: "idExeCal")
            idistanceM = defaults.integer(forKey: "idistanceM")
            allstep = defaults.integer(forKey: "allstep")
            arrCnt = defaults.integer(forKey: "arrCnt")
            
            preM_dCal = preM_dCal - idCal
            preM_dExeCal = preM_dExeCal - idExeCal
            preM_distanceKM = preM_distanceKM - idistanceM
            preM_allstep = preM_allstep - allstep
            preM_arrCnt = preM_arrCnt - arrCnt
            
            
            compareYearMonthDate()
            hourlyCalandDistanceDataSave()
            dailyCalandDistanceDataSave()
            monthlyCalandDistanceDataSave()
        }
        
    }
    
    
    //MARK: - timeChangeFunction
    func timeChangeFunction(){
        
        name = defaults.string(forKey: "name") ?? ""
        identification = defaults.string(forKey: "Id")  ?? ""
        iGender = defaults.integer(forKey: "Sex")
        iAge = defaults.integer(forKey: "Age")
        disheight = defaults.integer(forKey: "Height")
        dWeight = defaults.integer(forKey: "Weight")
        eCalBPM = defaults.integer(forKey: "eCalBpm")
        
        tStep = defaults.integer(forKey: "TargetStep")
        tDistance = defaults.integer(forKey: "TargetDistance")
        teCal = defaults.integer(forKey: "TargeteCal")
        ttcal = defaults.integer(forKey: "TargettCal")
        guardianTel = defaults.integer(forKey: "guardian")
        
        userDefaultsHeartAttack = defaults.bool(forKey: "HeartAttackFlag")
        userDefaultsArr = defaults.bool(forKey: "ArrFlag")
        userDefaultsMyo = defaults.bool(forKey: "MyoFlag")
        userDefaultsNoncontact = defaults.bool(forKey: "NoncontactFlag")
        userDefaultsTarchycardia = defaults.bool(forKey: "TarchycardiaFlag")
        userDefaultsBradycardia = defaults.bool(forKey: "BradycardiaFlag")
        userDefaultsAtrialFibrillaion = defaults.bool(forKey: "AtrialFibrillaionFlag")
        exerciseTarchycardiaFlag = defaults.bool(forKey: "exerciseTarchycardiaFlag")
        
        
        let date = Date()
        let df = DateFormatter()
        let ds = DateFormatter()
        let dh = DateFormatter()
        let dm = DateFormatter()
        let dyear = DateFormatter()
        let dmonth = DateFormatter()
        let ddate = DateFormatter()
        let dday = DateFormatter()
        let dhm = DateFormatter()
        
        
        df.dateFormat = "HH:mm:ss"
        dyear.dateFormat = "yyyy"
        dmonth.dateFormat = "MM"
        ddate.dateFormat = "dd"
        dday.dateFormat = "EEE"
        dh.dateFormat = "HH"
        dm.dateFormat = "mm"
        ds.dateFormat = "ss"
        dhm.dateFormat = "HH:mm"
        
        
        realTime = df.string(from: date)
        actualTime = dhm.string(from: date)
        realYear = dyear.string(from: date)
        realMonth = dmonth.string(from: date)
        realDate = ddate.string(from: date)
        realDay = dday.string(from: date)
        realHour = dh.string(from: date)
        realMinute = dm.string(from: date)
        realSecond = ds.string(from: date)
//        currentTime.text = df.string(from: date)
        
        
        pre_hour = defaults.string(forKey: "pre_hour") ?? "00"
        pre_minute = defaults.string(forKey: "pre_minute") ?? ""
        preDay = defaults.string(forKey: "Day") ?? ""
        preDate = defaults.string(forKey: "Date") ?? "01"
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        
        
        // 웗별 데이터 확인 필요
        if  (preMonth != realMonth){
            
            preM_dCal = 0
            preM_dExeCal = 0
            preM_distanceKM = 0
            preM_allstep = 0
            preM_arrCnt = 0
            
            defaults.set(preM_dCal, forKey: "preM_dCal")
            defaults.set(preM_dExeCal, forKey: "preM_dExeCal")
            defaults.set(preM_distanceKM, forKey: "preM_distanceKM")
            defaults.set(preM_allstep, forKey: "preM_allstep")
            defaults.set(preM_arrCnt, forKey: "preM_arrCnt")
            
            monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
            monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
            
        }
        
        // 일별 데이터
        if(preDate != realDate){
            
            arrCnt = 0
            allstep = 0
            distance = 0.0
            dCal = 0.0
            dExeCal = 0.0
            
            hourlyOffset = 0
            hourlyCurrentOffset = 0
            pre_hour = "00"
            
            
            pre_dCal = 0
            pre_dExeCal = 0
            pre_distanceKM = 0
            pre_allstep = 0
            pre_arrCnt = 0
            
            let inter_dCal = 0
            let inter_dExeCal = 0
            let inter_distanceKM = 0
            let inter_allstep = 0
            let inter_arrCnt = 0
            
            defaults.set(inter_dCal, forKey: "inter_dCal")
            defaults.set(inter_dExeCal, forKey: "inter_dExeCal")
            defaults.set(inter_distanceKM, forKey: "inter_distanceKM")
            defaults.set(inter_allstep, forKey: "inter_allstep")
            defaults.set(inter_arrCnt, forKey: "inter_arrCnt")
            
            dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
            dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
            
            preM_dCal = defaults.integer(forKey: "preM_dCal")
            preM_dExeCal = defaults.integer(forKey: "preM_dExeCal")
            preM_distanceKM = defaults.integer(forKey: "preM_distanceKM")
            preM_allstep = defaults.integer(forKey: "preM_allstep")
            preM_arrCnt = defaults.integer(forKey: "preM_arrCnt")
            
            defaults.set(hourlyOffset, forKey: "hourlyOffset")
            defaults.set(hourlyCurrentOffset, forKey: "hourlyCurrentOffset")
            
            defaults.set(pre_hour, forKey: "pre_hour")
            
            defaults.set(arrCnt, forKey: "arrCnt")
            defaults.set(allstep, forKey: "allstep")
            defaults.set(distance, forKey: "distance")
            defaults.set(dCal, forKey: "dCal")
            defaults.set(dExeCal, forKey: "dExeCal")
        }
        
        
        arrCnt = defaults.integer(forKey: "arrCnt")
        allstep = defaults.integer(forKey: "allstep")
        distance = defaults.double(forKey: "distance")
        dCal = defaults.double(forKey: "dCal")
        dExeCal = defaults.double(forKey: "dExeCal")
        
        pre_dCal = defaults.integer(forKey: "pre_dCal")
        pre_dExeCal = defaults.integer(forKey: "pre_dExeCal")
        pre_distanceKM = defaults.integer(forKey: "pre_distanceKM")
        pre_allstep = defaults.integer(forKey: "pre_allstep")
        pre_arrCnt = defaults.integer(forKey: "pre_arrCnt")
        
        compareYearMonthDate()
        hourlyCalandDistanceDataSave()
        dailyCalandDistanceDataSave()
        monthlyCalandDistanceDataSave()
        
    }
    // timer
    @objc func tenSecondtimerTicks(){
        
        if (connectionFlag == 1){
            
            timerCnt += 1
            countTimer += 1
            
            timeChangeFunction()
            
            tenSecondlVCnt += 1
            
            tenSecondHRVSum += pHrv
            tenSecondlVSum += real_bpm
            
            tenSecondlVAvg = tenSecondlVSum / tenSecondlVCnt
            tenSecondHRVAvg = tenSecondHRVSum / tenSecondlVCnt
            
            tenSecondTemplVSum +=  dtemp
            tenSecondTemplVAvg = tenSecondTemplVSum / Double(tenSecondlVCnt)

            if (timerCnt == 10){
                tensecondStep = 0 // 10초 동안 걸음 개수
                
                timeZone()
                
                bpmDataSave()
                
                // test
//                sendDailyData()
//                sendMonthlyData()
                
                tenSecondlVSum = 0
                tenSecondlVAvg = 0
                tenSecondlVCnt = 0
                tenSecondHRVSum = 0
                tenSecondHRVAvg = 0
                
                tenSecondTemplVSum = 0
                
                tenSecondTemplVAvg = 0
                tenSecondTemplVCnt = 0
                
                timerCnt = 0
                timer10Seconds += 1
            }
            
            oneMinutesTickers()
        }
    }
    
    
    func oneMinutesTickers(){
        
        // 시간값 확인(1분 마다)
        let stateDateFormatter:DateFormatter = DateFormatter()
        stateDateFormatter.dateFormat = "HH"
        stateDateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let currentDateTime = Date()
        let koreanTimeString = stateDateFormatter.string(from: currentDateTime)
        // 설정 수면 시간이랑 현재 한국 시간이랑 비교해서 수면 값 true
        if Int(koreanTimeString) == Int(defaults.string(forKey: "SleepTime")!){
            isSleep = true
        }
        
        if ( timer10Seconds == 6){
            timerMinutes += 1
            timer10Seconds = 0
        }
        
        tenMinutesTickers()
    }
    
    func tenMinutesTickers(){
        
        tenMinutelVCnt += 1
        
        if (tenMinutelVCnt == 1){
            tenMinutelVMin = real_bpm
            tenMinutelVMax = real_bpm
            
            templVMin = dtemp
            templVMax = dtemp
        }
        
        
        tenMinutelVSum += real_bpm
        tenMinutelVAvg = tenMinutelVSum / tenMinutelVCnt
        
        templVSum += dtemp
        templVAvg = templVSum / Double(tenMinutelVCnt)
        
        
        if (real_bpm > tenMinutelVMax) {
            tenMinutelVMax = real_bpm
        }
        else if (real_bpm < tenMinutelVMin){
            tenMinutelVMin = real_bpm
        }
        
        if (dtemp > templVMax) {
            templVMax = dtemp
        }
        else if (dtemp < templVMin){
            templVMin = dtemp
        }
        
        minHeartBeatValue.text = String(tenMinutelVMin)
        maxHeartBeatValue.text = String(tenMinutelVMax)
        aveHeartBeat.text = String(tenMinutelVAvg)
        
        if ( timerMinutes == 10){
            
            tenMinutelVSum = 0
            tenMinutelVMin = 0
            tenMinutelVMax = 0
            tenMinutelVAvg = 0
            tenMinutelVCnt = 0
            
            templVSum = 0.0
            templVMin = 0.0
            templVMax = 0.0
            templVAvg = 0.0
            
            timerTenMinutes += 1
            timerMinutes = 0
        }
        
        sendDailyData()
        sendMonthlyData()
        HoursTickers()
    }
    
    func HoursTickers(){
        
        
        if (timerTenMinutes == 6){
            timerHours += 1
            timerTenMinutes = 0
        }
    }
    
    func sendDailyData(){
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        do {
            let inString = try String(contentsOf: fileURL, encoding: .utf8)
            ecgFileDataSend("dailyCalandDistanceData", fileURL.path, inString)
        } catch {
            assertionFailure("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    func sendMonthlyData(){
        monthChangeFlag = defaults.integer(forKey: "monthChangeFlag")
        monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
        monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
        
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        do {
            let inString = try String(contentsOf: fileURL, encoding: .utf8)
            ecgFileDataSend("monthlyCalandDistanceData", fileURL.path, inString)
        } catch {
            assertionFailure("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        
    }
    // MARK: - Received
    func onHeartRateReceived(_ heartRate: Int) {

        if (heartRate > 3){
            pre_bpm = bpm
            
            bpm = heartRate
            
            
            if (pre_bpm != bpm){
                real_bpm = bpm
            }
        }
        
        if real_bpm - tenMinutelVAvg > 0 { HeartBeatValue.text = "+\(String(real_bpm - tenMinutelVAvg))" }
        else{ HeartBeatValue.text = String(real_bpm - tenMinutelVAvg) }
        
        if  real_bpm - tenMinutelVMax > 0 { diffMaxHeartBeatValue.text = "+\(String(real_bpm - tenMinutelVMax))" }
        else { diffMaxHeartBeatValue.text = String( real_bpm - tenMinutelVMax) }
        
        if  real_bpm - tenMinutelVMin > 0 { diffMinHeartBeatValue.text = "+\(String(real_bpm - tenMinutelVMin))"}
        else { diffMinHeartBeatValue.text = String(real_bpm - tenMinutelVMin)}
        
//        diffMinHeartBeatValue.text = String(real_bpm - tenMinutelVMin)
        
        //        HeartBeatValue.text = String(tenMinutelVAvg - real_bpm)
        heartValue.text = String(real_bpm)
    }
    
    func batReceived(_  battery: Int) {
        bat = battery
        
        batteryLabel.text = String(battery)+"%"
        // print("BAT: \(bat)")
    }
    
    
    func hrvReceived(_  hrv: Int) {
        pHrv = hrv * 10
//        HRVvalue.text = String(hrv * 10)
        HRVValue.text = String(hrv * 10)
        // print("HRV: \(hrv)")
    }
    
    
    func tempReceived(_  temperature: Int) {
        
        temp = temperature
        dtemp = Double (temp + 186) / 10.0
        dtemp = dtemp + 0.5
        
//        skinTemperature.text = String(dtemp)
        temperatureValue.text = "\(String(dtemp))\n°C"
        // print("temp: \(dtemp)")
    }
    
    // 알림 전송
    // MARK: - Noti
    func noncontactRequestSendNoti() {
        let content = UNMutableNotificationContent()
//        content.title = "Electrodes are disconnected"
        content.title = "전극떨어짐 발생!"
//        content.body = "Disconnection time: \(realTime)"
        content.body = "시간: \(realTime)"
        content.sound = .default
        //        content.badge = 2
        
        let request = UNNotificationRequest(
            identifier: "local noti",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }
    
    
    func myoRequestSendNoti() {
        let content = UNMutableNotificationContent()
//        content.title = "EMG"
//        content.body = "EMG time: \(realTime)"
        content.title = "근전도 발생!"
        content.body = "시간: \(realTime)"
        content.sound = .default
        //        content.badge = 2
        
        let request = UNNotificationRequest(
            identifier: "local noti",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }
    
    
    
    func arrRequestSendNoti() {
        let content = UNMutableNotificationContent()
//        content.title = "Irregular Heart Rhythm"
//        content.body = "Time: \(realTime)"
        content.title = "비정상맥박 발생!"
        content.body = "시간: \(realTime)"
        content.sound = .default
        //        content.badge = 2
        
        let request = UNNotificationRequest(
            identifier: "local noti",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }
    
    
    
    func bradycardiaRequestSendNoti() {
        let content = UNMutableNotificationContent()
//        content.title = "Bradycardia"
//        content.body = " Bradycardia Time: \(realTime)"
        content.title = "느린 맥박!"
        content.body = "시간: \(realTime)"
        content.sound = .default
        //        content.badge = 2
        
        let request = UNNotificationRequest(
            identifier: "local noti",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }
    
    
    func tarchycardiaRequestSendNoti() {
        let content = UNMutableNotificationContent()
//        content.title = "Tarchycardia"
//        content.body = "Tarchycardia Time: \(realTime)"
        content.title = "빠른 맥박!"
        content.body = "시간: \(realTime)"
        content.sound = .default
        //        content.badge = 2
        
        let request = UNNotificationRequest(
            identifier: "local noti",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }
    
    
    func atrialFibrillaionRequestSendNoti() {
        let content = UNMutableNotificationContent()
//        content.title = "AtrialFibrillaion"
//        content.body = "AtrialFibrillaion Time: \(realTime)"
        content.title = "연속적인 비정상맥박!"
        content.body = "시간: \(realTime)"
        content.sound = .default
        //        content.badge = 2
        
        let request = UNNotificationRequest(
            identifier: "local noti",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }
    
//    func fastTarchycardiaRequestSendNoti() {
//        let content = UNMutableNotificationContent()
//        content.title = "FastTarchycardia"
//        content.body = "FastTarchycardia Time: \(realTime)"
//        content.sound = .default
//        //        content.badge = 2
//
//        let request = UNNotificationRequest(
//            identifier: "local noti",
//            content: content,
//            trigger: UNTimeIntervalNotificationTrigger(
//                timeInterval: 1,
//                repeats: false
//            )
//        )
//
//        UNUserNotificationCenter.current()
//            .add(request) { error in
//                guard let error = error else { return }
//                print(error.localizedDescription)
//            }
//    }
    
    
    func stepReceived(_  step: Int) {
        
        stepCal = step
        
        if (connectionFlag == 1){
            
            if (stepCal >= 14) {
                stepCal -= 14 }
            
            if (stepCal >= 10) {
                
                if ((stepCal / 10) == 1){
                    arr = 1
                    arrFlag = 1
                    arrLast = arrLast + 1
                    arrStatus = "arr"
                }
                
                if ((stepCal / 10) == 2){
                    HeartAttack = 1
                    HeartAttackFlag = 1
                }
                
                if ((stepCal / 10) == 3){
                    nonContact = 1
                    noncontactFlag = 1
                }
                
                if ((stepCal / 10) == 4){
                    Myo = 1
                    MyoFlag = 1
                }
                
                if ((stepCal / 10) == 5){
                    
                    if !defaults.bool(forKey: "exerciseTarchycardiaFlag") {
                        arr = 1
                        Tarchycardia = 1
                    }
                    TarchycardiaFlag = 1
                    arrLast = arrLast + 1
                    arrStatus = "fast"
                }
                
                if ((stepCal / 10) == 6){
                    arr = 1
                    Bradycardia = 1
                    BradycardiaFlag = 1
                    arrLast = arrLast + 1
                    arrStatus = "slow"
                }
                
//                if ((stepCal / 10) == 7){
//                    FastTarchycardia = 1
//                    FastTarchycardiaFlag = 1
//                }
                
                if ((stepCal / 10) == 7){
                    
                    arr  = 1
                    AtrialFibrillaion = 1
                    AtrialFibrillaionFlag = 1
                    arrLast = arrLast + 1
                    arrStatus = "irregular"
                }
                
            } else {
                arr = 0
                arrFlag = 0
                HeartAttack =  0
                HeartAttackFlag = 0
                nonContact = 0
                noncontactFlag = 0
                Myo = 0
                MyoFlag = 0
                Tarchycardia = 0
                TarchycardiaFlag = 0
                Bradycardia = 0
                BradycardiaFlag = 0
                FastTarchycardia = 0
                FastTarchycardiaFlag = 0
                AtrialFibrillaion = 0
                AtrialFibrillaionFlag = 0
            }
            
            //MARK: - HeartAttackFlag
            if (HeartAttackFlag == 1 && userDefaultsHeartAttack){

                let dtTime = DateFormatter()
                dtTime.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                // 위치 정보 업데이트
                if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                    locationManager.startUpdatingLocation()
                }
                
                let sTime = dtTime.string(from: gpsDate)
                let sLat = String(format: "%.6f", gpsLat)
                let sLong = String(format: "%.6f", gpsLong)

                // 보호자 알림 승인 시 패킷 전송
                if UserDefaults.standard.bool(forKey: "guardianAlertFlag") {
                    let sPacket = "cmd:HeartAttackFlag;gpstime:" + sTime + ";gpslat:" + sLat + ";gpslong:" + sLong + ";username:" + name + ";guardiantel:" + String(guardianTel) + ";guardiantel2:" + String(guardianTel2)
                    ecgDataSend(sPacket, 2);
                }
                
                AudioServicesPlaySystemSound(1005)
                playSound("heartAttackSound")
                
                //            let alert = UIAlertController(title: "심장박동 없음", message: "10초 안에 확인 확인 버튼을 누르지 않으면 긴급 전화 연결됩니다", preferredStyle: UIAlertController.Style.alert)
                let alert = UIAlertController(title: "응급상황", message: "10초 안에 확인 확인 버튼을 누르지 않으면 보호자에게 메시지가 전송됩니다", preferredStyle: UIAlertController.Style.alert)
                //            let ok = UIAlertAction(title: "발생 시간: \(realTime)", style: .destructive, handler: { Action in
                let ok = UIAlertAction(title: "Time: \(realTime)", style: .destructive, handler: { Action in
//                    self.calButton.addTarget(self, action: #selector(self.buttonPOT(_:)), for: .touchUpInside)
                    playSound("heartAttackSoundStop")
                    AudioServicesDisposeSystemSoundID(1005)
                    self.writeOutgoingValue(data: "c\n")
                    
                    HeartAttackFlag = 0
                })

                alert.addAction(ok)
                present(alert,animated: true, completion: nil)
            }



            if (arrFlag == 1 && userDefaultsArr){
                arrRequestSendNoti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    playSound("arrSound")
                }
            }


            if (noncontactFlag == 1 && userDefaultsNoncontact){
                if soundTimeTrigger == true {
                    noncontactRequestSendNoti()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        playSound("noncontactSound")
                    }
                }
                soundTimeTrigger = false
            }

            if (MyoFlag == 1 && userDefaultsMyo){
                myoRequestSendNoti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    playSound("myoSound")
                }
            }


            if (TarchycardiaFlag == 1 && userDefaultsTarchycardia){
                // 운동 중이 아닐 때에만 알람
                if exerciseTarchycardiaFlag == false {
                    tarchycardiaRequestSendNoti()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        playSound("TarchycardiaSound")
                    }
                }
            }


            if (BradycardiaFlag == 1 && userDefaultsBradycardia){
                bradycardiaRequestSendNoti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    playSound("BradycardiaSound")
                }
            }

            if (AtrialFibrillaionFlag == 1 && userDefaultsAtrialFibrillaion){
                atrialFibrillaionRequestSendNoti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    playSound("AtrialFibrillaionSound")
                }
            }
    
            // 빈맥 130
            stepCal = stepCal % 10;
            arrCnt += arr
            
            if arr == 1 {
                arrDataSave("\(realTime)f,\(ecgData)")
            }
            
            nowstep += stepCal;
            allstep += stepCal;
            tensecondStep += stepCal;
            
//            ARRvalue.text = String(arrCnt)
            arrValue.text = String(arrCnt)
            stepValue.text = "\(String(allstep))\n걸음"
            defaults.set(arrCnt, forKey: "arrCnt" )
            defaults.set(allstep, forKey: "allstep" )
        }
        
    }
    
    // MARK: - location
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        if let location = locations.first {
//            gpsDate = Date()
//            gpsLat = location.coordinate.latitude
//            gpsLong = location.coordinate.longitude
//
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
//        }
//    }

    // 위치 정보 업데이트 시 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
                         [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        gpsDate = Date()
        gpsLat = location.coordinate.latitude
        gpsLong = location.coordinate.longitude

        print("현재 위치 - 위도: \(gpsLat), 경도: \(gpsLong)")

        // 위치 정보 업데이트 후 종료
        locationManager.stopUpdatingLocation()
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    @objc func calAndDistance( ) {
        
        if (connectionFlag == 1){
            
            if (real_bpm > 50) {
                
                iCalTimeCount += 1
          
                dCalMinU = Double(iCalTimeCount) / (60.0)

                if (iGender == 1) {
                    iAge_parameter = Double(iAge) * 0.2017
                    dWeight_parameter = Double(dWeight) * 0.1988
                    heartrate_parameter = Double(real_bpm) * 0.6309
                    
                    dCal = dCal + (iAge_parameter + dWeight_parameter + heartrate_parameter - 55.0969) * dCalMinU /  4.184
                    if (real_bpm > eCalBPM) {
                        dExeCal = dExeCal + (iAge_parameter + dWeight_parameter + heartrate_parameter - 55.0969) * dCalMinU / 4.184
                    }
                }
                
                
                if (iGender == 2) {
                    iAge_parameter = Double(iAge) * 0.074
                    dWeight_parameter = Double(dWeight) * 0.1263
                    heartrate_parameter = Double(real_bpm) * 0.4472
                    
                    dCal = dCal + (iAge_parameter - dWeight_parameter + heartrate_parameter - 20.4022) * dCalMinU /  4.184
                    if (real_bpm > eCalBPM) {
                        dExeCal = dExeCal + (iAge_parameter - dWeight_parameter + heartrate_parameter - 20.4022) * dCalMinU / 4.184
                    }
                }
                
                //  Male: ((-55.0969 + (0.6309 x HR) + (0.1988 x W) + (0.2017 x A))/4.184) x 60 x T
                
                //  Female: ((-20.4022 + (0.4472 x HR) - (0.1263 x W) + (0.074 x A))/4.184) x 60 x T
                
                
                dCal = ((dCal * 1000).rounded() / 1000); // Math.round(dCal * 10) / 10.0;
                dExeCal = ((dExeCal * 1000).rounded() / 1000)
                
                iCalTimeCount = 0
                
            }
            
            
            let dh = Double(disheight)
            
            avgsize = ((dh * 0.37) + (dh - 100)) / 2.0 //  dh 사용자의 키
            if (avgsize < 0) {
                avgsize = 10
            }
            
            if (real_bpm < eCalBPM) //BPMchk는 맥박
            {
                distance = distance + (avgsize * Double(nowstep)); // nowstep는 걸음수  계산 값의 단위는 cm
            } else if ((real_bpm >= eCalBPM) && (real_bpm < eCalBPM + 20)) {
                distance = distance + ((avgsize + 1) * Double(nowstep))
            } else if ((real_bpm >= eCalBPM + 20) && (real_bpm < eCalBPM + 40)) {
                distance = distance + ((avgsize + 2) * Double(nowstep))
            } else if ((real_bpm >= eCalBPM + 40) && (real_bpm < 250)) {
                distance = distance + ((avgsize + 3) * Double(nowstep))
            }
            
            distance = ((distance * 1000).rounded()) / 1000.0
            nowstep = 0
            
            distanceKM = distance / 100 / 1000.0
            
            distanceM = distanceKM * 1000
            
            
            idCal = Int(dCal)
            idExeCal = Int(dExeCal)
            idistanceM = Int(distanceM)
            
            
            defaults.set(idCal, forKey: "idCal" )
            defaults.set(idExeCal, forKey: "idExeCal" )
            defaults.set(idistanceM, forKey: "idistanceM" )
            defaults.set(distanceKM, forKey: "distanceKM" )
            
            calValue.text = "\(String(idExeCal))\nKcal"
            distanceValue.text = "\(String(format: "%.3f", distanceKM ))\nKm"
//            tCalValue.text = String(idCal)
//            eCalValue.text = String(idExeCal)
//            distanceValue.text = String(format: "%.3f", distanceKM )
            
            defaults.set(distance, forKey: "distance" )
            defaults.set(dCal, forKey: "dCal" )
            defaults.set(dExeCal, forKey: "dExeCal" )
        }
    }
    
    
    func batStatus(_ battery: Int) {
        let i = battery
        let max = 100
        
        if (i <= max) {
            let ratio = Float(i) / Float(max)
            batProgress.progress = Float(ratio)
            
            ecgDataSave("\(realTime),\(ecgPacket)")
//            ecgDataSend("\(ecgPacket)", arrLast)
            
        
            
            bodyStatusCheck()
            
            packetList = packetList + "\(ecgPacket)" + ";"
            
            packetCnt = packetCnt + 1
            
        
            if (packetCnt >= 10) // 약 1초마다 서버 전송 = 9400바이트
            {
//                let currentDate = Date()
//
//                // Create a date formatter
//                let dateFormatter = DateFormatter()
//
//                // Set the format you want to display
//                dateFormatter.dateFormat = "HH:mm:ss"
//
//                // Get the string representation of the date
//                let currentDateString = dateFormatter.string(from: currentDate)
//                
//                print("Current date and time: \(currentDateString)")
//                print(packetList)
                
                ecgDataSend(packetList, arrLast)
                
                arrLast = 0
                packetCnt = 0
                packetList = ""
            }
        }
    }
    
    
    @objc func didUpdatedChartView(){
        
        if (iRecvCnt > 0)
        {
            dataEntries = [ChartDataEntry]()
            
            for i in 0 ... iRecvCnt - 1 {
                let dataEntry = ChartDataEntry(x: Double(i), y: ecgData[i])
                dataEntries.append(dataEntry)
            }
            
//            let chartDataSet = LineChartDataSet(entries: dataEntries, label: "ECG")
            let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Peak")
            
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.setColor(NSUIColor.blue)
            chartDataSet.mode = .linear
            chartDataSet.drawValuesEnabled = false
            
            // 2
            let chartData = LineChartData(dataSet: chartDataSet)
            chartView.data = chartData
            // chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.enabled = false
            chartView.leftAxis.axisMaximum = 1024
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.enabled = false
            chartView.drawMarkers = false
            chartView.dragEnabled = false
            chartView.pinchZoomEnabled = false
            chartView.doubleTapToZoomEnabled = false
            chartView.highlightPerTapEnabled = false
            chartView.legend.enabled = false // 범례 숨기기

            
            chartView.notifyDataSetChanged()
            chartView.data?.notifyDataChanged()
            chartView.moveViewToX(0)
        }
    }
    
    
    func createDirectory(){
        
        let fileManager = FileManager.default
        
        let yearDocumentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let yearDirectoryURL = yearDocumentsURL.appendingPathComponent("\(realYear)")
        
        if !fileManager.fileExists(atPath: yearDirectoryURL.path){
            do {
                try fileManager.createDirectory(at: yearDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        
        let monthDirectoryURL = yearDirectoryURL.appendingPathComponent("\(realMonth)")
        
        if !fileManager.fileExists(atPath: monthDirectoryURL.path){
            do {
                try fileManager.createDirectory(at: monthDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        
        let dailyDirectoryURL = monthDirectoryURL.appendingPathComponent("\(realDate)")
        
        if !fileManager.fileExists(atPath: dailyDirectoryURL.path){
            do {
                try fileManager.createDirectory(at: dailyDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        
        let DailyDocumentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dailyDataDirectoryURL = DailyDocumentsURL.appendingPathComponent("dailyData")
        
        if !fileManager.fileExists(atPath: dailyDataDirectoryURL.path){
            do {
                try fileManager.createDirectory(at: dailyDataDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        let MonthlyDocumentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let monthlyDataDirectoryURL = MonthlyDocumentsURL.appendingPathComponent("monthlyData")
        
        if !fileManager.fileExists(atPath: monthlyDataDirectoryURL.path){
            do {
                try fileManager.createDirectory(at: monthlyDataDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        let exerciseDataDocumentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let myExerciseDataDirectoryURL = exerciseDataDocumentsURL.appendingPathComponent("exerciseData")

        if !fileManager.fileExists(atPath: myExerciseDataDirectoryURL.path){
            do {
                try fileManager.createDirectory(at: myExerciseDataDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
    
    
    func arrDataSave(_ string: String) {
        
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL.appendingPathComponent("\(realYear)/\(realMonth)/\(realDate)")
        let directoryURL = directoryURL1.appendingPathComponent("arrEcgData_\(realYear)\(realMonth)\(realDate)")
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch let e {
            print(e.localizedDescription)
        }
        // 부정맥 데이터 저장
        let fileURL = directoryURL.appendingPathComponent("/arrEcgData_\(arrCnt).csv")
        let arrstringArray = ecgData.map { String($0) }
        let arrDataString = arrstringArray.joined(separator: ",")
        let text = NSString(string: "\(realTime),\(utcOffsetAndCountry),\(bodyStatus),\(arrStatus),\(arrDataString)")
        
        do {
            try text.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
        } catch let e {
            print(e.localizedDescription)
        }
        
        var inString = ""
        do {
            inString = try String(contentsOf: fileURL, encoding: .utf8)
            ecgFileDataSend("arrEcgData", fileURL.path, inString)
        } catch {
            assertionFailure("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    // 서버 전송 파일
    func ecgDataSend(_ packet: String, _ isArr: Int)
    {
    
        /*
         아무 파일 경로를 보내기 위함 실시간 ecg 데이터랑 상관 없음 start
         */
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("\(realYear)/\(realMonth)/\(realDate)")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: false, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL = directoryURL1.appendingPathComponent("/EcgData.csv")
        // 아무 파일 경로를 보내기 위함 실시간 ecg 데이터랑 상관 없음 end
        
        let url = URL(string: "http://db.medsyslab.co.kr:40080/lunar/msl/api_execmdfile.php")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let param = "kind=ecgPacket&filename=\(fileURL.path)&username=\(name)&data=\(packet)&userid=\(identification)&eq=\(identification)"
        
        let paramData = param.data(using: .utf8)
        
        let parameters: [String: Any] = [
            "data": packet
        ]
        
        _ = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody = paramData //jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                //                print("statusCode should be 2xx, but is \(response.statusCode)")
                //                print("response = \(response)")
                return
            }
            
            _ = String(data: data, encoding: .utf8)
            //            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
    }
    
    //MARK: - 서버 전송 csv
    // 서버 전송 csv
    func ecgFileDataSend(_ kind: String, _ filename: String, _ packet: String)
    {
        //  print(packetCnt)
        //let url = URL(string: "http://dair.co.kr/dair/hb/api_execmdfile.php")!
//        let url = URL(string: "http://db.medsyslab.co.kr/lunar/msl/api_execmdfile.php")!
//        let url = URL(string: "http://db.medsyslab.co.kr:40080/lunar/msl/api_execmdfile.php")!
    
        let url = URL(string: "http://db.medsyslab.co.kr:40080/lunar/msl/api_execmdfile.php")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
//        let param = "kind=\(kind)&filename=\(filename)&username=\(name)&data=\(packet)&userid=\(identification)&eq=\(identification)"
//        let paramData = param.data(using: .utf8)
        
        let param = "kind=\(kind)&filename=\(filename)&username=\(name)&data=\(packet)&userid=\(identification)&eq=\(identification)"
        let encodedParam = param.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let parameters: [String: Any] = [
            "data": packet
        ]
        
        _ = try? JSONSerialization.data(withJSONObject: parameters)
        
//        request.httpBody = paramData //jsonData
        request.httpBody = encodedParam.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                //                print("statusCode should be 2xx, but is \(response.statusCode)")
                //                print("response = \(response)")
                return
            }
            
            _ = String(data: data, encoding: .utf8)
            //            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
    }
    
    // ecg data 저장
    func ecgDataSave(_ string: String) {
        
        //        print("\(realYear),\(realMonth),\(realDate)")
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("\(realYear)/\(realMonth)/\(realDate)")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: false, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL = directoryURL1.appendingPathComponent("/EcgData.csv")
        let stringArray1 = ecgPacket.map { String($0) }
        let ecgDataString1 = stringArray1.joined(separator: ",")
        
        
        guard let data = ("\(realTime),\(utcOffsetAndCountry),\(bpm),\(ecgDataString1)\n").data(using: String.Encoding.utf8) else { return }
        
        
        if FileManager.default.fileExists(atPath: fileURL.path){
            if let fileHandle = try? FileHandle(forWritingTo: fileURL){
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            
            let text = NSString(string: "\(realTime),\(utcOffsetAndCountry),\(bpm),\(ecgDataString1)\n")
            
            do {
                try text.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8.rawValue)
                
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
    
    // MARK: - bpmDataSave
    // 맥박, 체온 데이터 저장
    func bpmDataSave() {
        
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("\(realYear)/\(realMonth)/\(realDate)")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        
        let fileURL = directoryURL1.appendingPathComponent("/BpmData.csv")
        
        guard let data = ("\(realTime),\(utcOffsetAndCountry),\(tenSecondlVAvg),\(tenSecondTemplVAvg),\(tenSecondHRVAvg)\n").data(using: String.Encoding.utf8) else { return }
        
        if fileManager1.fileExists(atPath: fileURL.path){
            if let fileHandle = try? FileHandle(forWritingTo: fileURL){
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            
            let text = NSString(string: "\(actualTime),\(utcOffsetAndCountry),\(tenSecondlVAvg),\(tenSecondTemplVAvg),\(tenSecondHRVAvg)\n")
            
            do {
                try text.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8.rawValue)
                
            } catch let e {
                print(e.localizedDescription)
            }
            
        }
        
        do {
            let inString = try String(contentsOf: fileURL, encoding: .utf8)
            ecgFileDataSend("BpmData", fileURL.path, inString)
        } catch {
            assertionFailure("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    // 시간 별 데이터 저장( 걸음수, 걸음거리, 활동 칼로리, 전체 칼로리, 부정맥 횟수)
    func hourlyCalandDistanceDataSave() {
        
        pre_hour = defaults.string(forKey: "pre_hour") ?? ""
        
        pre_dCal = defaults.integer(forKey: "pre_dCal")
        pre_dExeCal = defaults.integer(forKey: "pre_dExeCal")
        pre_distanceKM = defaults.integer(forKey: "pre_distanceKM")
        pre_allstep = defaults.integer(forKey: "pre_allstep")
        pre_arrCnt = defaults.integer(forKey: "pre_arrCnt")
        
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("\(realYear)/\(realMonth)/\(realDate)")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
    
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL = directoryURL1.appendingPathComponent("/calandDistanceData.csv")
        
        d_pre_hour = Int(pre_hour)!
        d_realHour = Int(realHour)!
        
        
        differenceHour = d_realHour - d_pre_hour
        
        if fileManager1.fileExists(atPath: fileURL.path){
            if let fileHandle = try? FileHandle(forWritingTo: fileURL){
                
                if (differenceHour > 1){
                    for i in 1 ..< differenceHour + 1 {
                        
                        hourlyOffset = UInt64(defaults.integer(forKey: "hourlyOffset"))
                        hourlyCurrentOffset = UInt64(defaults.integer(forKey: "hourlyCurrentOffset"))
                        
                        let s_d_prehour = String("\(d_pre_hour + i)")
                        
                        let s_zero = String(format: "%06d", 0)
                        
                        guard let data0 = ("\(s_d_prehour),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                        
                        fileHandle.seek(toFileOffset: hourlyCurrentOffset)
                        
                        hourlyOffset1 = fileHandle.offsetInFile
                        fileHandle.write(data0)
                        hourlyCurrentOffset1 = fileHandle.offsetInFile
                        
                        defaults.set(hourlyOffset1, forKey: "hourlyOffset")
                        defaults.set(hourlyCurrentOffset1, forKey: "hourlyCurrentOffset")
                        defaults.set(realHour, forKey: "pre_hour")
                        
                        pre_dCal = defaults.integer(forKey: "inter_dCal")
                        pre_dExeCal = defaults.integer(forKey: "inter_dExeCal")
                        pre_distanceKM = defaults.integer(forKey: "inter_distanceKM")
                        pre_allstep = defaults.integer(forKey: "inter_allstep")
                        pre_arrCnt = defaults.integer(forKey: "inter_arrCnt")
                        
                        
                        defaults.set(pre_dCal, forKey: "pre_dCal")
                        defaults.set(pre_dExeCal, forKey: "pre_dExeCal")
                        defaults.set(pre_distanceKM, forKey: "pre_distanceKM")
                        defaults.set(pre_allstep, forKey: "pre_allstep")
                        defaults.set(pre_arrCnt, forKey: "pre_arrCnt")
                        
                        differenceHour = 0
                    }
                    
                } else if (pre_hour != realHour){
                    
                    hourlyOffset = UInt64(defaults.integer(forKey: "hourlyOffset"))
                    hourlyCurrentOffset = UInt64(defaults.integer(forKey: "hourlyCurrentOffset"))
                    // currentOffset은 다음칸으로 옴김
                    //offset은 같은 칸에서 쓰기
                    
                    let s_zero = String(format: "%06d", 0)
                    guard let data1 = ("\(realHour),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                    
                    fileHandle.seek(toFileOffset: hourlyCurrentOffset)
                    
                    hourlyOffset1 = fileHandle.offsetInFile
                    fileHandle.write(data1)
                    hourlyCurrentOffset1 = fileHandle.offsetInFile
                    
                    fileHandle.closeFile()
                    
                    pre_dCal = defaults.integer(forKey: "inter_dCal")
                    pre_dExeCal = defaults.integer(forKey: "inter_dExeCal")
                    pre_distanceKM = defaults.integer(forKey: "inter_distanceKM")
                    pre_allstep = defaults.integer(forKey: "inter_allstep")
                    pre_arrCnt = defaults.integer(forKey: "inter_arrCnt")
                    
                    
                    defaults.set(hourlyOffset1, forKey: "hourlyOffset")
                    defaults.set(hourlyCurrentOffset1, forKey: "hourlyCurrentOffset")
                    
                    defaults.set(pre_dCal, forKey: "pre_dCal")
                    defaults.set(pre_dExeCal, forKey: "pre_dExeCal")
                    defaults.set(pre_distanceKM, forKey: "pre_distanceKM")
                    defaults.set(pre_allstep, forKey: "pre_allstep")
                    defaults.set(pre_arrCnt, forKey: "pre_arrCnt")
                    
                    
                    defaults.set(realHour, forKey: "pre_hour")
      
                } else if (pre_hour == realHour){

                    hourlyOffset = UInt64(defaults.integer(forKey: "hourlyOffset"))
                    
                    i_dCal = idCal
                    i_dCal = idCal
                    i_dExeCal = idExeCal
                    i_distanceKM = idistanceM
                    i_allstep = allstep
                    i_arrCnt = arrCnt
                    
                    daily_dCal = idCal - pre_dCal
                    daily_dExeCal = idExeCal - pre_dExeCal
                    daily_distanceKM = idistanceM - pre_distanceKM
                    daily_allstep = allstep - pre_allstep
                    daily_arrCnt = arrCnt - pre_arrCnt
                    
                    if ((daily_dCal < 0) || (daily_dExeCal < 0) || (daily_allstep < 0) || (daily_distanceKM < 0)  || (daily_arrCnt < 0) ){
                        
                        daily_dCal = 0
                        daily_dExeCal = 0
                        daily_distanceKM = 0
                        daily_allstep = 0
                        daily_arrCnt = 0
                    }
                    
                    
                    s_daily_dCal = String(format: "%06d", daily_dCal)
                    s_daily_dExeCal = String(format: "%06d", daily_dExeCal)
                    s_daily_distanceKM = String(format: "%06d", daily_distanceKM)
                    s_daily_allstep = String(format: "%06d", daily_allstep)
                    s_daily_arrCnt = String(format: "%06d", daily_arrCnt)
//                    print(String(format: "%06d", nowstep))
//                    print(s_daily_allstep)
                    
                    guard let data = ("\(realHour),\(utcOffsetAndCountry),\(s_daily_allstep),\(s_daily_distanceKM),\(s_daily_dCal),\(s_daily_dExeCal),\(s_daily_arrCnt)\n").data(using: String.Encoding.utf8) else { return }
                    
                    fileHandle.seek(toFileOffset: hourlyOffset)
                    hourlyOffset = fileHandle.offsetInFile
                    
                    fileHandle.write(data)
                    
                    hourlyCurrentOffset = fileHandle.offsetInFile
                    fileHandle.closeFile()
                    defaults.set(hourlyOffset, forKey: "hourlyOffset")
                    defaults.set(hourlyCurrentOffset, forKey: "hourlyCurrentOffset")
                    
                    defaults.set(realHour, forKey: "pre_hour")
                    
                    defaults.set(i_dCal, forKey: "inter_dCal")
                    defaults.set(i_dExeCal, forKey: "inter_dExeCal")
                    defaults.set(i_distanceKM, forKey: "inter_distanceKM")
                    defaults.set(i_allstep, forKey: "inter_allstep")
                    defaults.set(i_arrCnt, forKey: "inter_arrCnt")
                    
                }
            }
        }else {
            let text = NSString(string: "\(""),\(""),\(""),\(""),\(""),\("")\n")
            
            do {
                try text.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8.rawValue)
        
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        var inString = ""
        do {
            inString = try String(contentsOf: fileURL, encoding: .utf8)
            ecgFileDataSend("calandDistanceData", fileURL.path, inString)
        } catch {
            assertionFailure("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    
    func compareYearMonthDate(){

        preDay = defaults.string(forKey: "Day") ?? ""
        preDate = defaults.string(forKey: "Date") ?? "01"
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        
        if ((preYear != realYear) || (preMonth != realMonth) || (preDate != realDate)){
            
            for _ in 1...10000{
                
                if ((preYear == compareRealYear) && (preMonth == compareRealMonth) && (preDate == compareRealDate)){
                    
                    break
                }
                
                let yesterday = calendar.date(byAdding: .day, value: -1, to: compareTodayDate)!
                
                compareTodayDate = yesterday
                
                let tyear = DateFormatter()
                let tmonth = DateFormatter()
                let tdate = DateFormatter()
                let tday = DateFormatter()
                
                tyear.dateFormat = "yyyy"
                tmonth.dateFormat = "MM"
                tdate.dateFormat = "dd"
                tday.dateFormat = "EEE"
                
                
                compareRealYear = tyear.string(from: compareTodayDate)
                compareRealMonth = tmonth.string(from: compareTodayDate)
                compareRealDate = tdate.string(from: compareTodayDate)
                compareRealDay = tday.string(from: compareTodayDate)
                
                defaults.set(compareRealYear, forKey: "compareRealYear")
                defaults.set(compareRealMonth, forKey: "compareRealMonth")
                defaults.set(compareRealDate, forKey: "compareRealDate")
                defaults.set(compareRealDay, forKey: "compareRealDay")
                
                dateDifference += 1
            }
            
            dailyCalandDistanceDataSave()
        }
        
        
        if ((preYear != realYear) || (preMonth != realMonth)){
            for _ in 1...1000{
                
                if ((preYear == compareYear) && (preMonth == compareMonth)){
                    break
                }
                
                let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: thisMonth)!
                
                thisMonth = lastMonth
                
                let tyear = DateFormatter()
                let tmonth = DateFormatter()
                
                tyear.dateFormat = "yyyy"
                tmonth.dateFormat = "MM"
                
                compareYear = tyear.string(from: thisMonth )
                compareMonth = tmonth.string(from: thisMonth )
                
                defaults.set(compareYear, forKey: "compareYear")
                defaults.set(compareMonth, forKey: "compareMonth")
                
                monthDifference += 1
            }
            monthlyCalandDistanceDataSave()
        }
    }
    
    
    // 일별 데이터 저장( 걸음수, 걸음거리, 활동 칼로리, 전체 칼로리, 부정맥 횟수)
    func dailyCalandDistanceDataSave() {
        
        dateChangeFlag = defaults.integer(forKey: "dateChangeFlag")
        dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
        dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
        
        preDay = defaults.string(forKey: "Day") ?? ""
        preDate = defaults.string(forKey: "Date") ?? "01"
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        
        if fileManager1.fileExists(atPath: fileURL1.path){
            if let fileHandle = try? FileHandle(forWritingTo: fileURL1){
                
                if ((dateDifference > 1) && ( dateChangeFlag == 0)) {
                    for i in 0 ..< dateDifference + 1{
                        
                        compareRealYear = defaults.string(forKey: "compareRealYear") ?? ""
                        compareRealMonth = defaults.string(forKey: "compareRealMonth") ?? ""
                        compareRealDate = defaults.string(forKey: "compareRealDate") ?? ""
                        compareRealDay = defaults.string(forKey: "compareRealDay") ?? ""
                        
                        dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
                        dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
                        
                        let s_zero = String(format: "%07d", 0)
                        
                        guard let data0 = ("\(compareRealYear),\(compareRealMonth),\(compareRealDate),\(compareRealDay),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                        
                        fileHandle.seek(toFileOffset: dailyCurrentOffset)
                        
                        dailyOffset2 = fileHandle.offsetInFile
                        fileHandle.write(data0)
                        dailyCurrentOffset2 = fileHandle.offsetInFile
                        
                        defaults.set(dailyOffset2 , forKey: "dailyOffset")
                        defaults.set(dailyCurrentOffset2, forKey: "dailyCurrentOffset")
                        
                        dateDifference = 0
                        dateChangeFlag = 1
                        
                        defaults.set(dateChangeFlag, forKey: "dateChangeFlag")
                        
                        if ((realYear == compareRealYear) && (realMonth == compareRealMonth) && (realDate == compareRealDate)){
                            
                            break
                        }
                        
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: compareTodayDate)!
                        compareTodayDate = tomorrow
                        
                        let tyear = DateFormatter()
                        let tmonth = DateFormatter()
                        let tdate = DateFormatter()
                        let tday = DateFormatter()
                        
                        
                        tyear.dateFormat = "yyyy"
                        tmonth.dateFormat = "MM"
                        tdate.dateFormat = "dd"
                        tday.dateFormat = "EEE"
                        
                        compareRealYear = tyear.string(from: compareTodayDate)
                        compareRealMonth = tmonth.string(from: compareTodayDate)
                        compareRealDate = tdate.string(from: compareTodayDate)
                        compareRealDay = tday.string(from: compareTodayDate)
                        
                        print("\(i)")
                        
                        defaults.set(compareRealYear, forKey: "compareRealYear")
                        defaults.set(compareRealMonth, forKey: "compareRealMonth")
                        defaults.set(compareRealDate, forKey: "compareRealDate")
                        defaults.set(compareRealDay, forKey: "compareRealDay")
                        
                        defaults.set(realDate, forKey: "Date")
                        defaults.set(realDay, forKey: "Day")
                    }
                } else if ((dateDifference > 1) && (dateChangeFlag == 1)) {
                    for i in 0 ..< dateDifference {
                        
                        compareRealYear = defaults.string(forKey: "compareRealYear") ?? ""
                        compareRealMonth = defaults.string(forKey: "compareRealMonth") ?? ""
                        compareRealDate = defaults.string(forKey: "compareRealDate") ?? ""
                        compareRealDay = defaults.string(forKey: "compareRealDay") ?? ""
                        
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: compareTodayDate)!
                        compareTodayDate = tomorrow
                        
                        let tyear = DateFormatter()
                        let tmonth = DateFormatter()
                        let tdate = DateFormatter()
                        let tday = DateFormatter()
                        
                        
                        tyear.dateFormat = "yyyy"
                        tmonth.dateFormat = "MM"
                        tdate.dateFormat = "dd"
                        tday.dateFormat = "EEE"
                        
                        compareRealYear = tyear.string(from: compareTodayDate)
                        compareRealMonth = tmonth.string(from: compareTodayDate)
                        compareRealDate = tdate.string(from: compareTodayDate)
                        compareRealDay = tday.string(from: compareTodayDate)
                        
                        print("\(i)")
                        
                        defaults.set(compareRealYear, forKey: "compareRealYear")
                        defaults.set(compareRealMonth, forKey: "compareRealMonth")
                        defaults.set(compareRealDate, forKey: "compareRealDate")
                        defaults.set(compareRealDay, forKey: "compareRealDay")
                        
                        dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
                        dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
                        
                        let s_zero = String(format: "%07d", 0)
                        
                        guard let data0 = ("\(compareRealYear),\(compareRealMonth),\(compareRealDate),\(compareRealDay),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                        
                        fileHandle.seek(toFileOffset: dailyCurrentOffset)
                        
                        dailyOffset2 = fileHandle.offsetInFile
                        fileHandle.write(data0)
                        dailyCurrentOffset2 = fileHandle.offsetInFile
                        
                        defaults.set(dailyOffset2 , forKey: "dailyOffset")
                        defaults.set(dailyCurrentOffset2, forKey: "dailyCurrentOffset")
                        
                        dateChangeFlag = 1
                        dateDifference = 0
                        if ((realYear == compareRealYear) && (realMonth == compareRealMonth) && (realDate == compareRealDate)){
                            
                            break
                        }
                        
                        defaults.set(realDate, forKey: "Date")
                        defaults.set(realDay, forKey: "Day")
                    }
                    
                    
                }
                else if (realDate != preDate){
                    
                    dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
                    dailyCurrentOffset = UInt64(defaults.integer(forKey: "dailyCurrentOffset"))
                    
                    
                    let s_zero = String(format: "%07d", 0)
                    
                    guard let data1 = ("\(realYear),\(realMonth),\(realDate),\(realDay),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                    
                    fileHandle.seek(toFileOffset: dailyCurrentOffset)
                    
                    dailyOffset1 = fileHandle.offsetInFile
                    
                    fileHandle.write(data1)
                    
                    dailyCurrentOffset1 = fileHandle.offsetInFile
                    fileHandle.closeFile()
                    
                    defaults.set(dailyOffset1 , forKey:"dailyOffset")
                    defaults.set(dailyCurrentOffset1, forKey:"dailyCurrentOffset")
                    
                    defaults.set(realDate, forKey: "Date")
                    
                } else if(realDate == preDate){
                    
                    dailyOffset = UInt64(defaults.integer(forKey: "dailyOffset"))
                    
                    
                    s_idCal = String(format: "%07d", idCal)
                    s_idExeCal = String(format: "%07d", idExeCal)
                    s_idistanceM = String(format: "%07d", idistanceM)
                    s_allstep = String(format: "%07d", allstep)
                    s_arrCnt = String(format: "%07d", arrCnt)
                    
                    guard let data = ("\(realYear),\(realMonth),\(realDate),\(realDay),\(utcOffsetAndCountry),\(s_allstep),\(s_idistanceM),\(s_idCal),\(s_idExeCal),\(s_arrCnt)\n").data(using: String.Encoding.utf8) else { return }
                    
                    fileHandle.seek(toFileOffset: dailyOffset)
                    
                    dailyOffset = fileHandle.offsetInFile
                    
                    fileHandle.write(data)
                    
                    dailyCurrentOffset = fileHandle.offsetInFile
                    
                    fileHandle.closeFile()
                    
                    defaults.set(dailyOffset, forKey: "dailyOffset")
                    defaults.set(dailyCurrentOffset, forKey: "dailyCurrentOffset")
                    
                    
                    defaults.set(realDate, forKey: "Date")

                }
            }
        }
        
        else{
            
            let text = NSString(string: "\(""),\(""),\(""),\(""),\(""),\(""),\(""),\(""),\("")\n")
            
            do {
                try text.write(to: fileURL1, atomically: false, encoding: String.Encoding.utf8.rawValue)
                
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
    
    
    // 월별 데이터 저장( 걸음수, 걸음거리, 활동 칼로리, 전체 칼로리, 부정맥 횟수)
    func monthlyCalandDistanceDataSave() {
        
        monthChangeFlag = defaults.integer(forKey: "monthChangeFlag")
        monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
        monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
        
        preMonth = defaults.string(forKey: "Month") ?? "01"
        preYear = defaults.string(forKey: "Year") ?? "2023"
        
        let fileManager1 = FileManager.default
        
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        
        if !fileManager1.fileExists(atPath: directoryURL1.path){
            
            do {
                try fileManager1.createDirectory(at: directoryURL1, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("fail to create directory")
            }
        }
        
        let fileURL2 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        if fileManager1.fileExists(atPath: fileURL2.path){
            if let fileHandle = try? FileHandle(forWritingTo: fileURL2){
                
                if ((monthDifference > 1) && (monthChangeFlag == 0)){
                    for i in 0 ..< monthDifference + 1 {
                        
                        compareYear = defaults.string(forKey: "compareYear") ?? ""
                        compareMonth = defaults.string(forKey: "compareMonth") ?? ""
                        
                        monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
                        monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
                        
                        
                        let s_zero = String(format: "%08d", 0)
                        
                        guard let data0 = ("\(compareYear),\(compareMonth),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                        
                        fileHandle.seek(toFileOffset: monthlyCurrentOffset)
                        
                        monthlyOffset2 = fileHandle.offsetInFile
                        fileHandle.write(data0)
                        monthlyCurrentOffset2 = fileHandle.offsetInFile
                        
                        
                        defaults.set(monthlyOffset2, forKey: "monthlyOffset")
                        defaults.set(monthlyCurrentOffset2, forKey: "monthlyCurrentOffset")
                        
                        monthDifference = 0
                        monthChangeFlag = 1
                        
                        defaults.set(monthChangeFlag, forKey: "monthChangeFlag")
                        
                        if ((realYear == compareYear) && (realMonth == compareMonth)){
                            defaults.set(realYear, forKey: "Year")
                            defaults.set(realMonth, forKey: "Month")
                            
                            break
                        }
                        
                        
                        let nextMonth  = Calendar.current.date(byAdding: .month, value: 1, to: thisMonth)!
                        thisMonth = nextMonth
                        
                        let tyear = DateFormatter()
                        let tmonth = DateFormatter()
                        
                        tyear.dateFormat = "yyyy"
                        tmonth.dateFormat = "MM"
                        
                        compareYear = tyear.string(from: thisMonth)
                        compareMonth = tmonth.string(from: thisMonth)
                        
                        print("\(i)")
                        
                        defaults.set(compareYear, forKey: "compareYear")
                        defaults.set(compareMonth, forKey: "compareMonth")
                        
                        
                        defaults.set(realMonth, forKey: "Month")
                        defaults.set(realYear, forKey: "Year")
                    }
                } else if ((monthDifference > 1) && (monthChangeFlag == 1)){
                    for i in 0 ..< monthDifference {
                        
                        compareYear = defaults.string(forKey: "compareYear") ?? ""
                        compareMonth = defaults.string(forKey: "compareMonth") ?? ""
                        
                        
                        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: thisMonth)!
                        thisMonth = nextMonth
                        
                        let tyear = DateFormatter()
                        let tmonth = DateFormatter()
                        
                        tyear.dateFormat = "yyyy"
                        tmonth.dateFormat = "MM"
                        
                        compareYear = tyear.string(from: thisMonth)
                        compareMonth = tmonth.string(from: thisMonth)
                        
                        print("\(i)")
                        
                        defaults.set(compareYear, forKey: "compareYear")
                        defaults.set(compareMonth, forKey: "compareMonth")
                        
                        
                        monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
                        monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
                        
                        
                        let s_zero = String(format: "%08d", 0)
                        
                        guard let data0 = ("\(compareYear),\(compareMonth),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                        
                        fileHandle.seek(toFileOffset: monthlyCurrentOffset)
                        
                        monthlyOffset2 = fileHandle.offsetInFile
                        fileHandle.write(data0)
                        monthlyCurrentOffset2 = fileHandle.offsetInFile
                        
                        
                        defaults.set(monthlyOffset2, forKey: "monthlyOffset")
                        defaults.set(monthlyCurrentOffset2, forKey: "monthlyCurrentOffset")
                        
                        monthDifference = 0
                        monthChangeFlag = 1
                        
                        if ((realYear == compareYear) && (realMonth == compareMonth)){
                            defaults.set(realYear, forKey: "Year")
                            defaults.set(realMonth, forKey: "Month")
                            
                            break
                        }
                        
                        defaults.set(realMonth, forKey: "Month")
                        defaults.set(realYear, forKey: "Year")
                    }
                    
                    
                } else if (realMonth != preMonth){
                    
                    monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
                    monthlyCurrentOffset = UInt64(defaults.integer(forKey: "monthlyCurrentOffset"))
                    
                    let s_zero = String(format: "%08d", 0)
                    
                    guard let data0 = ("\(realYear),\(realMonth),\(utcOffsetAndCountry),\(s_zero),\(s_zero),\(s_zero),\(s_zero),\(s_zero)\n").data(using: String.Encoding.utf8) else { return }
                    
                    fileHandle.seek(toFileOffset: monthlyCurrentOffset)
                    
                    monthlyOffset1 = fileHandle.offsetInFile
                    
                    fileHandle.write(data0)
                    
                    monthlyCurrentOffset1 = fileHandle.offsetInFile
                    
                    fileHandle.closeFile()
                    
                    defaults.set(monthlyOffset1, forKey: "monthlyOffset")
                    defaults.set(monthlyCurrentOffset1, forKey: "monthlyCurrentOffset")
                    
                    
                    defaults.set(realMonth, forKey: "Month")
                    defaults.set(realYear, forKey: "Year")
                    
                } else if(realMonth == preMonth){
                    
                    monthlyOffset = UInt64(defaults.integer(forKey: "monthlyOffset"))
                    
                    M_dCal = preM_dCal + idCal
                    M_dExeCal = preM_dExeCal + idExeCal
                    M_distanceKM = preM_distanceKM + idistanceM
                    M_allstep = preM_allstep + allstep
                    M_arrCnt = preM_arrCnt + arrCnt
                    
                    s_M_dCal = String(format: "%08d", M_dCal)
                    s_M_dExeCal = String(format: "%08d", M_dExeCal)
                    s_M_distanceKM = String(format: "%08d", M_distanceKM)
                    s_M_allstep = String(format: "%08d", M_allstep)
                    s_M_arrCnt = String(format: "%08d", M_arrCnt)
                    
                    guard let data = ("\(realYear),\(realMonth),\(utcOffsetAndCountry),\(s_M_allstep),\(s_M_distanceKM),\(s_M_dCal),\(s_M_dExeCal),\(s_M_arrCnt)\n").data(using: String.Encoding.utf8) else { return }
                    
                    
                    fileHandle.seek(toFileOffset: monthlyOffset)
                    
                    monthlyOffset = fileHandle.offsetInFile
                    fileHandle.write(data)
                    
                    monthlyCurrentOffset = fileHandle.offsetInFile
                    fileHandle.closeFile()
                    
                    defaults.set(monthlyOffset, forKey: "monthlyOffset")
                    defaults.set(monthlyCurrentOffset, forKey: "monthlyCurrentOffset")
                    
                    defaults.set(M_dCal, forKey: "preM_dCal")
                    defaults.set(M_dExeCal, forKey: "preM_dExeCal")
                    defaults.set(M_distanceKM, forKey: "preM_distanceKM")
                    defaults.set(M_allstep, forKey: "preM_allstep")
                    defaults.set(M_arrCnt, forKey: "preM_arrCnt")
                    
                    
                    defaults.set(realMonth, forKey: "Month")
                    defaults.set(realYear, forKey: "Year")
                }
            }
            
        }else{
            
            let text = NSString(string: "\(""),\(""),\(""),\(""),\(""),\(""),\("")\n")
            
            do {
                try text.write(to: fileURL2, atomically: false, encoding: String.Encoding.utf8.rawValue)
                
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
}


// BLE central
extension MainViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            
            centralManager.scanForPeripherals(withServices: [ServiceCBUUID])
        @unknown default:
            fatalError()
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        heartRatePeripheral = peripheral
        heartRatePeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(heartRatePeripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        connectionFlag = 1
        // 키에 따른 민감도 설정을 위한 구문
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.heightSend(defaults.string(forKey: "Height") ?? "170")
        }
        heartRatePeripheral.discoverServices([ServiceCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        heartRatePeripheral = peripheral
        heartRatePeripheral.delegate = self
        centralManager.retrieveConnectedPeripherals(withServices: [ServiceCBUUID])
        centralManager.connect(heartRatePeripheral)
        print("Disconnected!")
        connectionFlag = 0
    }
    
    
    private func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject])
    {
        print("Restored")
    }
    
}
// BLE 장치
extension MainViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.uuid.isEqual(ReceiveCBUUID)  {
                
                rxCharacteristic = characteristic
                
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                
                print("RX Characteristic: \(rxCharacteristic.uuid)")
            }
            
            if characteristic.uuid.isEqual(SendCBUUID){
                
                txCharacteristic = characteristic
                
                print("TX Characteristic: \(txCharacteristic.uuid)")
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        switch characteristic.uuid {
        case ReceiveCBUUID:
            let bat = battery(from: characteristic)
            NotificationCenter.default.post(name: NSNotification.Name("Battery"), object: String(bat)+"%")
            batReceived(bat)
            
            //case ReceiveCBUUID:
            let bpm = heartRate(from: characteristic)
            onHeartRateReceived(bpm)
            batStatus(bat)
            
            let tempe = temperature(from: characteristic)
            tempReceived(tempe)
            
            let stepArray = step(from: characteristic)
            stepReceived(stepArray)
            
            let bpmvari = hrv(from: characteristic)
            hrvReceived(bpmvari)
            
            let ecgA = ecgArray(from: characteristic)
            ecgData = ecgA
            
            let ecgPac = ecgPacketArray(from: characteristic)
            ecgPacket = ecgPac
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
        
    @objc  func buttonECG(_ sender: Any) {
        writeOutgoingValue(data: "e\n")
    }
    
    // MARK: - ecg buttonPeak
    @objc func buttonPEAK(_ sender: Any) {
        if ecgPeakCheck == false {
            writeOutgoingValue(data: "e\n")
            ecgPeakCheck = true
            ecgAndPeakButton.setTitle("ECG", for: .normal)
        }
        else{
            writeOutgoingValue(data: "p\n")
            ecgPeakCheck = false
            ecgAndPeakButton.setTitle("Peak", for: .normal)
        }
    }
    
    func writeOutgoingValue(data: String){
        
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        
        if let heartRatePeripheral = heartRatePeripheral {
            if let txCharacteristic = txCharacteristic {
                
                heartRatePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    
    private func battery(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return 0 }
        let byteArray = [UInt8](characteristicData)
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            return Int(byteArray[1])
            
        } else {
            return 0
        }
        
    }
    
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return 0 }
        let byteArray = [UInt8](characteristicData)
        
        
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            
            return Int(byteArray[2])
        } else {
            return 0
        }
    }
    
    
    private func temperature(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return 0 }
        let byteArray = [UInt8](characteristicData)
        
        
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            
            return Int(byteArray[3])
        } else {
            return 0
        }
    }
    
    private func step(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return 0 }
        
        let byteArray = [UInt8](characteristicData)
        
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            
            return Int(byteArray[4])
        } else {
            return 0
        }
    }
    
    
    private func hrv(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return 0 }
        let byteArray = [UInt8](characteristicData)
        
        
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            
            
            return Int(byteArray[5])
        } else {
            
            return 0
        }
    }
    
    
    private func ecgArray(from characteristic: CBCharacteristic) -> Array<Double> {
        guard let characteristicData = characteristic.value else { return []}
        let byteArray = [UInt8](characteristicData)
        
        
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            
            
            for i in 6...19  {
                ecg = Int(byteArray[i])
                ecg = ecg * 4
                
                let xmax = 500
                
                if (iRecvCnt == xmax){
                    for j in 1...xmax-1 {
                        ecgData[j - 1] = ecgData[j]
                    }
                    iRecvCnt = xmax-1
                }
                
                ecgData[iRecvCnt] = (Double(ecg))
                iRecvCnt += 1
                
            }
            
            return ecgData
        } else  {
            return ecgData
        }
    }
    
    
    
    private func ecgPacketArray(from characteristic: CBCharacteristic) -> Array<Double> {
        guard let characteristicData = characteristic.value else { return []}
        let byteArray = [UInt8](characteristicData)
        
        
        let firstBitValue = byteArray[0] & 0xFF
        if ((byteArray.count >= 19) && (firstBitValue == 1)) {
            
            
            for i in 6...19  {
                ecgP = Int(byteArray[i])
                ecgP = ecgP * 4
                
                let exmax = 14
                
                if (eRecvCnt == exmax){
                    for j in 1...exmax-1 {
                        ecgPacket[j - 1] = ecgPacket[j]
                    }
                    eRecvCnt = exmax-1
                }
                
                ecgPacket[eRecvCnt] = (Double(ecgP))
                eRecvCnt += 1
                
            }
            
            return ecgPacket
        } else  {
            return ecgPacket
        }
    }
    
    // 민감도 설정을 위한 키 값 전송
    func heightSend(_ height: String){
        let myHeight = Int(height) ?? 170
        
        if myHeight <= 165 {
            writeOutgoingValue(data: "q\n")
        }
        else if  myHeight <= 170{
            writeOutgoingValue(data: "r\n")
        }
        else if myHeight <= 175{
            writeOutgoingValue(data: "s\n")
        }
        else if myHeight <= 180{
            writeOutgoingValue(data: "t\n")
        }
        else if myHeight > 180{
            writeOutgoingValue(data: "u\n")
        }
        else{
            print("not found height")
        }
    }
    
    // MARK: -
    // navigation 설정
    func setNavigation() {
        // Navigationbar Title 왼쪽 정렬
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        customView.addSubview(batProgress)
        customView.addSubview(batteryLabel)
        let barItem = UIBarButtonItem(customView: customView)
        navigationItem.rightBarButtonItem = barItem
        
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            batProgress.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            batProgress.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: 0),
            
            batteryLabel.centerYAnchor.constraint(equalTo: batProgress.centerYAnchor),
            batteryLabel.trailingAnchor.constraint(equalTo: batProgress.leadingAnchor, constant: -10),
        ])
    }
    
    func bodyStatusCheck(){
        // 수면
        if tensecondStep < 6 && isSleep{
            ButtonEvent(sleepButton)
            bodyStatus = "S"
        }
        // 활동
        else if real_bpm > Int(defaults.string(forKey: "eCalBpm")!)! || tensecondStep > 6 {
            ButtonEvent(activityButton)
            bodyStatus = "E"
        }
        // 휴식
        else {
            ButtonEvent(restButton)
            bodyStatus = "R"
        }

    }
}

func playSound(_ sound: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
        if HeartAttackFlag == 1 {
            do {
                // 오디오 파일 URL로 AVAudioPlayer 인스턴스 생성
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = 1005
                // prepare to play and play
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("오디오 파일을 재생하는 데 문제가 발생했습니다.")
            }
        }
        else{
            do {
                // 오디오 파일 URL로 AVAudioPlayer 인스턴스 생성
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                
                // prepare to play and play
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("오디오 파일을 재생하는 데 문제가 발생했습니다.")
            }
        }
    }
}

func timeZone(){
    let currentTimeZone = TimeZone.current
    let utcOffsetInSeconds = currentTimeZone.secondsFromGMT()

    let hours = abs(utcOffsetInSeconds) / 3600
    let minutes = (abs(utcOffsetInSeconds) % 3600) / 60

    let offsetString = String(format: "%@%02d:%02d", utcOffsetInSeconds >= 0 ? "+" : "-", hours, minutes)
    
    let currentCountryCode = Locale.current.regionCode ?? "Unknown"  // "US", "KR" 등
    
    utcOffsetAndCountry = "\(offsetString)/\(currentCountryCode)"
    print(utcOffsetAndCountry)
}
