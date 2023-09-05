//
//  bpmVC.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2022/07/07.
//

import UIKit
import Foundation
import Charts
import SnapKit
import Then


let bpmChartView = LineChartView()
let twoDaysBpmChartView = LineChartView()
let threeDaysBpmChartView = LineChartView()

var bpmArrayData1: [Double] = []
var bpmTimeData1: [String] = []
var numbersOfBpm1 = 0

var bpmArrayData2: [Double] = []
var bpmTimeData2: [String] = []
var numbersOfBpm2 = 0

var bpmArrayData3: [Double] = []
var bpmTimeData3: [String] = []
var numbersOfBpm3 = 0

var bpmArrayData4: [Double] = []
var bpmTimeData4: [String] = []
var numbersOfBpm4 = 0

var bpmArrayData5: [Double] = []
var bpmTimeData5: [String] = []
var numbersOfBpm5 = 0

var bpmThreeArrayData1: [Double] = []
var bpmThreeTimeData1: [String] = []
var numbersOfThreeBpm1 = 0

var bpmThreeArrayData2: [Double] = []
var bpmThreeTimeData2: [String] = []
var numbersOfThreeBpm2 = 0

var bpmThreeArrayData3: [Double] = []
var bpmThreeTimeData3: [String] = []
var numbersOfThreeBpm3 = 0

var bpmThreeArrayData4: [Double] = []
var bpmThreeTimeData4: [String] = []
var numbersOfThreeBpm4 = 0

var bpmThreeArrayData5: [Double] = []
var bpmThreeTimeData5: [String] = []
var numbersOfThreeBpm5 = 0

var bpmThreeArrayData6: [Double] = []
var bpmThreeTimeData6: [String] = []
var numbersOfThreeBpm6 = 0

var bpmThreeArrayData7: [Double] = []
var bpmThreeTimeData7: [String] = []
var numbersOfThreeBpm7 = 0

var numbersOfThreeBpm = 0
//let breathChartView = LineChartView()
//
//var breathData: [Double] = []
//var breathTimeData: [String] = []
//var numbersOfBreath = 0
////var breathDate = ""

var bpmTodayDate = Date()
var twoDaysBpmTodayDate = Date()
var bpmThreeDays = Date()


var bpmChangeRealYear:String = ""
var bpmChangeRealMonth:String = ""
var bpmChangeRealDate:String = ""

var bpmChangeTwoDaysYear:String = ""
var bpmChangeTwoDaysMonth:String = ""
var bpmChangeTwoDaysDate:String = ""

var bpmBaseTwoDaysYear:String = ""
var bpmBaseTwoDaysMonth:String = ""
var bpmBaseTwoDaysDate:String = ""


var bpmBaseThreeDaysYear:String = ""
var bpmBaseThreeDaysMonth:String = ""
var bpmBaseThreeDaysDate:String = ""

var bpmChangeThreeDaysYear:String = ""
var bpmChangeThreeDaysMonth:String = ""
var bpmChangeThreeDaysDate:String = ""

var bpmChangeThreeDaysYear1:String = ""
var bpmChangeThreeDaysMonth1:String = ""
var bpmChangeThreeDaysDate1:String = ""

var bpmChangeThreeDaysYear2:String = ""
var bpmChangeThreeDaysMonth2:String = ""
var bpmChangeThreeDaysDate2:String = ""

var bpmChangeThreeDaysYear3:String = ""
var bpmChangeThreeDaysMonth3:String = ""
var bpmChangeThreeDaysDate3:String = ""

var lastTwoDaysBpmButtonFlag = 0
var nextTwoDaysBpmButtonFlag = 0

var previousArrowFlag = 0
var nextArrowFlag = 0
var baseArrowFlag = 0

var bpmDateCount = 0
var bpmTwodateCount = 0
var bpmThreeDateCount = 0

var numberOfBpmTimeData1 = 0.0
var numberOfBpmTimeData2 = 0.0

let HeartBeat : UIImage = UIImage(named: "heartbeat")!
let irregularHB : UIImage = UIImage(named:"ARR")!
let temperature : UIImage = UIImage(named:"temperature")!
let step : UIImage = UIImage(named:"step")!
let calorie : UIImage = UIImage(named:"calorie")!
//let leftArrow : UIImage = UIImage(named:"left arrow")!
//let rightArrow : UIImage = UIImage(named:"right arrow")!

//let leftArrow : UIImage = UIImage(named:"leftArrow")!
//let rightArrow : UIImage = UIImage(named:"rightArrow")!

let leftArrow =  UIImage(systemName: "arrow.left.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
let rightArrow =  UIImage(systemName: "arrow.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)

let buttonBackground = UIColor(named: "buttonBackgrond")
let mint = UIColor(named: "mint")
let backgroundColor = UIColor(named: "backgroundColor")
let lineGreen = UIColor(named: "lineGreen")


class bpmGraphVC : UIViewController {
    
    var fCurTextfieldBottom: CGFloat = 0.0
    
    private let safeAreaView = UIView()
    
    var saveThreeDaysDate = Date()
    var lastButtonFlag = false
    var nextButtonFlag = false
    
    let plusImage =  UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    let minusImage =  UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    let refreshImage =  UIImage(systemName: "arrow.clockwise.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    let leftArrow =  UIImage(systemName: "arrow.left.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    let rightArrow =  UIImage(systemName: "arrow.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    // MARK: - Alert
    let alertBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.layer.borderWidth = 3
        label.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        label.layer.cornerRadius = 20
        label.isHidden = true
        return label
    }()
    
    let alertLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.isHidden = true
        label.numberOfLines = 4
        label.textAlignment = .center
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(enlargementButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(enlargementButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(refreshImage, for: .normal)
        button.addTarget(self, action: #selector(enlargementButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func enlargementButtonTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            for _ in 0..<30{
                bpmChartView.zoomOut()
                twoDaysBpmChartView.zoomOut()
                ThreeDaysBpmChartView.zoomOut()
            }
        }
        else if sender.tag == 2 {
            bpmChartView.zoomOut()
            twoDaysBpmChartView.zoomOut()
            ThreeDaysBpmChartView.zoomOut()
        }
        else if sender.tag == 3 {
            bpmChartView.zoomIn()
            twoDaysBpmChartView.zoomIn()
            ThreeDaysBpmChartView.zoomIn()
        }
    }
    
    // MARK: -
    
    private func setupView1() {
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
    }
    
    
    lazy var bpmChartView: LineChartView =  {
        let bpmChartView = LineChartView()
        bpmChartView.noDataText = ""
        return bpmChartView
        
    }()
    
    
    lazy var twoDaysBpmChartView: LineChartView =  {
        let twoDaysBpmChartView = LineChartView()
        twoDaysBpmChartView.noDataText = ""
        return twoDaysBpmChartView
        
    }()
    
    
    lazy var ThreeDaysBpmChartView: LineChartView =  {
        let ThreeDaysBpmChartView = LineChartView()
        ThreeDaysBpmChartView.noDataText = ""
        return ThreeDaysBpmChartView
        
    }()
    
    
    //    lazy var breathChartView: LineChartView =  {
    //        let breathChartView = LineChartView()
    //        return breathChartView
    //
    //    }()
    
    
    lazy var oneDayButton = UIButton().then {
        $0.setTitle ("Today", for: .normal )
        
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                         
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(selectOneDayClick(sender:)), for: .touchUpInside)
        
    }
    
    
    lazy var twoDaysButton = UIButton().then {
        $0.setTitle ("2 Days", for: .normal )
            
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                             
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(selectTwoDaysClick(sender:)), for: .touchUpInside)
    }
    
    
    lazy var ThreeDaysButton = UIButton().then {
        $0.setTitle ("3 Days", for: .normal )
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                         
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        
        $0.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(selectThreeDaysClick(sender:)), for: .touchUpInside)
    }
    
    lazy var todayDispalay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)-\(realDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var twoDaysDispalay = UILabel().then {
        $0.text = "\(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate) ~ \(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var ThreeDaysDispalay = UILabel().then {
        $0.text = "\(bpmChangeThreeDaysMonth).\(bpmChangeThreeDaysDate) ~ \(bpmChangeThreeDaysMonth).\(bpmChangeThreeDaysDate) "
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
//    lazy var bpmButton = UIButton().then {
//        $0.setImage(HeartBeat, for: UIControl.State.normal)
//        $0.backgroundColor = .cyan
//        //        $0.addTarget(self, action: #selector(bpmBpmClick(sender:)), for: .touchUpInside)
//
//    }
//
//    lazy var arrButton = UIButton().then {
//        $0.setImage(irregularHB, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(bpmArrClick(sender:)), for: .touchUpInside)
//    }
//
//
//    lazy var calorieButton = UIButton().then {
//        $0.setImage(calorie, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(bpmCalorieClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var stepButton = UIButton().then {
//        $0.setImage(step, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(bpmStepClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var temperatureButton = UIButton().then {
//        $0.setImage(temperature, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(bpmTemperatureClick(sender:)), for: .touchUpInside)
//    }
    
    
    //    lazy var breathButton = UIButton().then {
    //        $0.setTitle (" 호흡 ", for: .normal )
    //        $0.setTitleColor(.yellow, for: .normal)
    //        $0.setTitle (" 호흡 ", for: .highlighted )
    //        $0.setTitleColor(.green, for: .highlighted)
    //        $0.backgroundColor = .red
    //        $0.layer.masksToBounds = true
    //        $0.layer.cornerRadius = 5
    //        $0.addTarget(self, action: #selector(selectBreathClick(sender:)), for: .touchUpInside)
    //        $0.addTarget(self, action: #selector(breathChartViewGraph(_:)), for: .touchUpInside)
    //
    //        // Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(bpmChartViewGraph(_:)), userInfo: nil, repeats: true)
    //
    //    }
    
    
    
    //    -----------------------------day button-------------------
    
    
    lazy var yesterdayBpmButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(yesterdaySelectBpmButton(sender:)), for: .touchUpInside)
    }
    
    lazy var tomorrowBpmButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(tomorrowSelectBpmButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------day button-------------------
    
    
    //    -----------------------------2days button-------------------
    lazy var lastTwoDaysBpmButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastTwoDaysSelectBpmButton(sender:)), for: .touchUpInside)
    }
    
    
    
    lazy var nextTwoDaysBpmButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextTwoDaysSelectBpmButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------2days button-------------------
    
    
    
    //    -----------------------------7days button-------------------
    lazy var lastThreeDaysBpmButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastThreeDaysSelectBpmButton(sender:)), for: .touchUpInside)
    }
    
    
    
    lazy var nextThreeDaysBpmButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextThreeDaysSelectBpmButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------v button-------------------
    
    
    
    lazy var HeartBeatLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "심박수"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var HeartBeatValue = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var currentTime = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    lazy var minHeartBeat = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    lazy var aveHeartBeat = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    lazy var maxHeartBeat = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    
    
    
    func bpmviews(){
        
//        let buttonStackView1: UIStackView = {
//            let buttonStackView1 = UIStackView(arrangedSubviews: [bpmButton, arrButton, calorieButton, stepButton, temperatureButton])
//            buttonStackView1.axis = .horizontal
//            buttonStackView1.distribution = .fillEqually // default
//            buttonStackView1.alignment = .fill // default
//            buttonStackView1.backgroundColor = .white
//            buttonStackView1.spacing = 10.0
//
//            view.addSubview(buttonStackView1)
//
//
//            self.bpmButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//            }
//            self.arrButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//            }
//
//            self.calorieButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//            }
//
//            self.stepButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//            }
//
//            self.temperatureButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//                $0.trailing.equalTo(buttonStackView1)
//
//            }
//
//            return buttonStackView1
//        }()
//
//
//        buttonStackView1.snp.makeConstraints { (make) in
//
//            make.leading.equalTo(self.safeAreaView.snp.leading)
//            make.trailing.equalTo(self.safeAreaView.snp.trailing)
//            make.top.equalTo(self.safeAreaView.snp.top)
//            make.height.equalTo(50)
//        }
        
        //        view.addSubview(breathButton)
        //        breathButton.snp.makeConstraints {(make) in
        //            make.leading.equalTo(bpmButton.snp.trailing).offset(10)
        //            make.top.equalTo(self.safeAreaView.snp.top).offset(10)
        //            make.height.equalTo(30)
        //
        //        }
        
        
        view.addSubview(bpmChartView)
        bpmChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
        }
        
        view.addSubview(twoDaysBpmChartView)
        twoDaysBpmChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(bpmChartView.snp.bottom)
        }
        
        
        view.addSubview(ThreeDaysBpmChartView)
        ThreeDaysBpmChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(bpmChartView.snp.bottom)
        }
        
        
        
        //        view.addSubview(breathChartView)
        //        breathChartView.snp.makeConstraints {(make) in
        //            make.top.equalTo(resetButton.snp.bottom).offset(20)
        //            make.width.equalTo(self.safeAreaView.snp.width)
        //            make.leading.equalTo(self.safeAreaView.snp.leading).offset(10)
        //            make.height.equalTo(250)
        //        }
        //
        
        
        let buttonStackView2: UIStackView = {
            let buttonStackView2 = UIStackView(arrangedSubviews: [oneDayButton, twoDaysButton, ThreeDaysButton])
            buttonStackView2.axis = .horizontal
            buttonStackView2.distribution = .fillEqually // default
            buttonStackView2.spacing = 50.0
            buttonStackView2.alignment = .fill // default
            //            buttonStackView2.backgroundColor = .gray
            
            view.addSubview(buttonStackView2)
            
            
            self.oneDayButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
                $0.leading.equalTo(buttonStackView2)
                
            }
            self.twoDaysButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            
            self.ThreeDaysButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
                $0.trailing.equalTo(buttonStackView2)
            }
            
            return buttonStackView2
        }()
        
        
        buttonStackView2.snp.makeConstraints { (make) in
            
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.top.equalTo(self.bpmChartView.snp.bottom)
            make.height.equalTo(50)
        }
        
        //        -----------------------day button position--------------------
        
        view.addSubview(yesterdayBpmButton)
        yesterdayBpmButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(todayDispalay)
        todayDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(yesterdayBpmButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tomorrowBpmButton)
        tomorrowBpmButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(todayDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------day button position--------------------
        
        
        //        -----------------------2 days button position--------------------
        view.addSubview(lastTwoDaysBpmButton)
        lastTwoDaysBpmButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(twoDaysDispalay)
        twoDaysDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastTwoDaysBpmButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(nextTwoDaysBpmButton)
        nextTwoDaysBpmButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(twoDaysDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------2 days button position--------------------
        
        
        //        -----------------------7 days button position--------------------
        view.addSubview(lastThreeDaysBpmButton)
        lastThreeDaysBpmButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(ThreeDaysDispalay)
        ThreeDaysDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastThreeDaysBpmButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(nextThreeDaysBpmButton)
        nextThreeDaysBpmButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(ThreeDaysDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------7 days button position--------------------
        
        
        
        let bpmVCStackView1: UIStackView = {
            let bpmVCStackView1 = UIStackView(arrangedSubviews: [HeartBeatLabel, HeartBeatValue,currentTime])
            bpmVCStackView1.axis = .horizontal
            bpmVCStackView1.distribution = .fillEqually // default
            bpmVCStackView1.alignment = .fill // default
            bpmVCStackView1.backgroundColor = .white
            
            view.addSubview(bpmVCStackView1)
            
            
            self.HeartBeatLabel.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView1)
                $0.trailing.equalTo(HeartBeatValue.snp.leading)
            }
            self.HeartBeatValue.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView1)
                $0.trailing.equalTo(currentTime.snp.leading)
            }
            
            self.currentTime.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView1)
                $0.trailing.equalTo(bpmVCStackView1)
                
            }
            
            return bpmVCStackView1
        }()
        
        
        let bpmVCStackView2: UIStackView = {
            let bpmVCStackView2 = UIStackView(arrangedSubviews: [minHeartBeat, aveHeartBeat, maxHeartBeat])
            bpmVCStackView2.axis = .horizontal // default
            bpmVCStackView2.distribution = .fillEqually // default
            bpmVCStackView2.alignment = .fill // default
            bpmVCStackView2.backgroundColor = .white
            
            view.addSubview(bpmVCStackView2)
            
            self.minHeartBeat.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView2)
                $0.trailing.equalTo(self.aveHeartBeat.snp.leading)
            }
            self.aveHeartBeat.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView2)
                $0.trailing.equalTo(self.maxHeartBeat.snp.leading)
            }
            
            self.maxHeartBeat.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView2)
                $0.trailing.equalTo(bpmVCStackView2)
                
            }
            
            return bpmVCStackView2
        }()
        
        
        let _: UIStackView = {
            let bpmVCStackView3 = UIStackView(arrangedSubviews: [bpmVCStackView1, bpmVCStackView2])
            bpmVCStackView3.axis = .vertical // default
            bpmVCStackView3.distribution = .fillEqually // default
            bpmVCStackView3.alignment = .fill // default
            bpmVCStackView3.backgroundColor = .white
            bpmVCStackView3.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
            bpmVCStackView3.layer.cornerRadius = 10
            bpmVCStackView3.layer.borderWidth = 3
            
            view.addSubview(bpmVCStackView3)
            
            bpmVCStackView3.snp.makeConstraints { (make) in
                make.leading.equalTo(self.safeAreaView.snp.leading)
                make.trailing.equalTo(self.safeAreaView.snp.trailing)
                make.top.equalTo(self.yesterdayBpmButton.snp.bottom).offset(20)
                make.bottom.equalTo(self.safeAreaView.snp.bottom)
                make.height.equalTo(100)
            }
            
            
            bpmVCStackView1.snp.makeConstraints { (make) in
                
                make.leading.trailing.top.equalTo(bpmVCStackView3)
                make.height.equalTo(50)
                
            }
            
            
            bpmVCStackView2.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(bpmVCStackView1)
                make.top.equalTo(bpmVCStackView1.snp.bottom)
                make.height.equalTo(50)
            }
            
            return bpmVCStackView3
        }()
        
        //
        // alertLabel
        view.addSubview(alertBackground)
        view.addSubview(alertLabel)
        
        refreshButton.tag = 1
        minusButton.tag = 2
        plusButton.tag = 3
        
        view.addSubview(refreshButton)
        view.addSubview(minusButton)
        view.addSubview(plusButton)
        
        alertBackground.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertBackground.leadingAnchor.constraint(equalTo: twoDaysBpmChartView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            alertBackground.centerXAnchor.constraint(equalTo: twoDaysBpmChartView.centerXAnchor),
            alertBackground.centerYAnchor.constraint(equalTo: twoDaysBpmChartView.centerYAnchor),
            
            alertBackground.heightAnchor.constraint(equalToConstant: 120),
            
            
            alertLabel.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
            
            refreshButton.topAnchor.constraint(equalTo: twoDaysBpmChartView.topAnchor, constant: 10),
            refreshButton.trailingAnchor.constraint(equalTo: twoDaysBpmChartView.trailingAnchor, constant: -5),
            
            minusButton.topAnchor.constraint(equalTo: refreshButton.topAnchor),
            minusButton.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: -5),
            
            plusButton.topAnchor.constraint(equalTo: refreshButton.topAnchor),
            plusButton.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -5),
            
        ])
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
    
        setupView1()
        bpmviews()
        bpmTimer()
        
        bpmChartViewGraph()
        
        oneDayButton.isSelected = true
        twoDaysButton.isSelected  = false
        ThreeDaysButton.isSelected = false
        
        
        todayDispalay.isHidden = false
        twoDaysDispalay.isHidden = true
        ThreeDaysDispalay.isHidden = true
        
        yesterdayBpmButton.isHidden = false
        tomorrowBpmButton.isHidden = false
        lastTwoDaysBpmButton.isHidden = true
        nextTwoDaysBpmButton.isHidden = true
        lastThreeDaysBpmButton.isHidden = true
        nextThreeDaysBpmButton.isHidden = true
        
        yesterdayBpmButton.isEnabled = true
        tomorrowBpmButton.isEnabled = true
        lastTwoDaysBpmButton.isEnabled = false
        nextTwoDaysBpmButton.isEnabled = false
        lastThreeDaysBpmButton.isEnabled = false
        nextThreeDaysBpmButton.isEnabled = false
        
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(bpmTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func bpmTimer(){
        
        let date = Date()
        let df = DateFormatter()
        let ds = DateFormatter()
        let dh = DateFormatter()
        let dm = DateFormatter()
        let dyear = DateFormatter()
        let dmonth = DateFormatter()
        let ddate = DateFormatter()
        let dday = DateFormatter()
        
        
        df.dateFormat = "HH:mm:ss"
        dyear.dateFormat = "yyyy"
        dmonth.dateFormat = "MM"
        ddate.dateFormat = "dd"
        dday.dateFormat = "EEE"
        dh.dateFormat = "HH"
        dm.dateFormat = "mm"
        ds.dateFormat = "ss"
        
        
        realTime = df.string(from: date)
        
        realYear = dyear.string(from: date)
        realMonth = dmonth.string(from: date)
        realDate = ddate.string(from: date)
        realDay = dday.string(from: date)
        realHour = dh.string(from: date)
        realMinute = dm.string(from: date)
        realSecond = ds.string(from: date)
        
        currentTime.text = df.string(from: date)
        HeartBeatValue.text = String(real_bpm)
        minHeartBeat.text = "최소: " + String(tenMinutelVMin)
        maxHeartBeat.text = "최대: " + String(tenMinutelVMax)
        aveHeartBeat.text = "평균: " + String(tenMinutelVAvg)
        
    }
    
    // MARK: - today Graph
    func bpmChartViewGraph(){
        
        bpmChartView.clear()
        twoDaysBpmChartView.clear()
        ThreeDaysBpmChartView.clear()
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        plusButton.isHidden = false
        minusButton.isHidden = false
        refreshButton.isHidden = false
        
        bpmChangeRealYear = defaults.string(forKey: "bpmChangeRealYear") ?? "\(realYear)"
        bpmChangeRealMonth = defaults.string(forKey: "bpmChangeRealMonth") ?? "\(realMonth)"
        bpmChangeRealDate = defaults.string(forKey: "bpmChangeRealDate") ?? "\(realDate)"
        
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("\(bpmChangeRealYear)/\(bpmChangeRealMonth)/\(bpmChangeRealDate)")
        
        let fileURL = directoryURL.appendingPathComponent("/BpmData.csv")
        
        let filePath = fileURL.path
        
        if fileManager.fileExists(atPath: filePath){
            
            do {
                let data1 = try String(contentsOf: fileURL)
                let bpmData1 = data1.components(separatedBy: .newlines)
                
                numbersOfBpm1 = bpmData1.count
                
                for i in 0..<numbersOfBpm1 - 1{
                    let row = bpmData1[i]
                    let columns1 = row.components(separatedBy: ",")
                    let bpmDataRow1 = Double(columns1[2])
                    
                    let bpmTimeCheck = columns1[0].components(separatedBy: ":")
                    let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1]
                    
                    bpmTimeData1.append(MybpmTimeRow)
                    bpmArrayData1.append(bpmDataRow1 ?? 0.0)
                    
                    //   print(bpmTimeData)
                    //  print(bpmData)
                }
            } catch  {
                print("Error reading CSV file")
            }
            
            var bpmDataEntries1 = [ChartDataEntry]()
            
            for i in 0 ..< numbersOfBpm1 - 1 {
                let bpmDataEntry = ChartDataEntry(x: Double(i), y: bpmArrayData1[i])
                bpmDataEntries1.append(bpmDataEntry)
            }
            
            
            let bpmChartDataSet = LineChartDataSet(entries: bpmDataEntries1, label: "BPM")
            bpmChartDataSet.drawCirclesEnabled = false
            bpmChartDataSet.setColor(NSUIColor.blue)
            bpmChartDataSet.mode = .linear
            bpmChartDataSet.lineWidth = 0.5
            bpmChartDataSet.drawValuesEnabled = true
            
            
            // 2
            let bpmChartData = LineChartData(dataSet: bpmChartDataSet)
            bpmChartView.data = bpmChartData
            bpmChartView.noDataText = ""
            bpmChartView.xAxis.enabled = true
            bpmChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            bpmChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: bpmTimeData1)
//            twoDaysBpmChartView.xAxis.axisMinimum = 0
            bpmChartView.setVisibleXRangeMaximum(500)   // 처음 보여지는 x축 범위
            bpmChartView.xAxis.granularity = 1
            bpmChartView.xAxis.labelPosition = .bottom
            bpmChartView.xAxis.drawGridLinesEnabled = false
            
            bpmChartView.leftAxis.axisMaximum = 200
            bpmChartView.leftAxis.axisMinimum = 40
            bpmChartView.rightAxis.enabled = false
            bpmChartView.drawMarkers = false
            bpmChartView.dragEnabled = true
            bpmChartView.pinchZoomEnabled = false
            bpmChartView.doubleTapToZoomEnabled = false
            bpmChartView.highlightPerTapEnabled = false
//            bpmChartView.legend.enabled = false
            
            bpmChartView.data?.notifyDataChanged()
            bpmChartView.notifyDataSetChanged()
            bpmChartView.moveViewToX(0)
            
            bpmTimeData1 = []
            bpmArrayData1 = []
            
            twoDaysBpmChartView.isUserInteractionEnabled = false
            bpmChartView.isUserInteractionEnabled = true
            ThreeDaysBpmChartView.isUserInteractionEnabled = false
            
            // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
            for _ in 0..<20 {
                bpmChartView.zoomOut()
            }
        }
        else{
            alertFlag = true
            alertString += "\(bpmChangeRealYear)/\(bpmChangeRealMonth)/\(bpmChangeRealDate)\n"
        }
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            plusButton.isHidden = true
            minusButton.isHidden = true
            refreshButton.isHidden = true
            alertLabel.text = alertString + "데이터가 없습니다."
        }
        
    }
    
    
    // MARK: - 2Days Graph
    func twoDaysBpmChartViewGraph(){
        
        bpmChartView.clear()
        twoDaysBpmChartView.clear()
        ThreeDaysBpmChartView.clear()
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        plusButton.isHidden = false
        minusButton.isHidden = false
        refreshButton.isHidden = false
        
        bpmBaseTwoDaysYear = defaults.string(forKey:"bpmBaseTwoDaysYear") ?? "\(realYear)"
        bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmBaseTwoDaysMonth") ?? "\(realMonth)"
        bpmBaseTwoDaysDate = defaults.string(forKey:"bpmBaseTwoDaysDate") ?? "\(realDate)"

        bpmChangeTwoDaysYear = defaults.string(forKey:"bpmChangeTwoDaysYear") ?? "\(realYear)"
        bpmChangeTwoDaysMonth = defaults.string(forKey:"bpmChangeTwoDaysMonth") ?? "\(realMonth)"
        bpmChangeTwoDaysDate = defaults.string(forKey:"bpmChangeTwoDaysDate") ?? "\(realDate)"
        
        // 버튼을 여러번 클릭하였을때 값이 섞이는 것을 방지
        bpmTimeData2 = []
        bpmArrayData2 = []
        
        bpmTimeData3 = []
        bpmArrayData3 = []
        
        bpmTimeData4 = []
        bpmArrayData4 = []
        
        bpmTimeData5 = []
        bpmArrayData5 = []
        
        // test
//        bpmBaseTwoDaysYear = "2023"
//        bpmBaseTwoDaysMonth = "06"
//        bpmBaseTwoDaysDate = "09"
//
//        bpmChangeTwoDaysYear = "2023"
//        bpmChangeTwoDaysMonth = "06"
//        bpmChangeTwoDaysDate = "08"

        if ((previousArrowFlag == 1) || (baseArrowFlag == 1)){
            
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL = documentsURL.appendingPathComponent("\(bpmChangeTwoDaysYear)/\(bpmChangeTwoDaysMonth)/\(bpmChangeTwoDaysDate)")
            
            let fileURL = directoryURL.appendingPathComponent("/BpmData.csv")
            
            let filePath = fileURL.path

            
            // time table : 그래프에 보여줄 시간 저장 배열
            var timeTable: [String] = []
            
            // 바꿀 날짜
            if fileManager.fileExists(atPath: filePath){

                do {
                    let data2 = try String(contentsOf: fileURL)
                    let bpmData2 = data2.components(separatedBy: .newlines)

                    numbersOfBpm2 = bpmData2.count

                    for i in 0..<numbersOfBpm2 - 1{
                        let row = bpmData2[i]
                        let columns = row.components(separatedBy: ",")

                        let bpmTimeCheck = columns[0].components(separatedBy: ":")
                        let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")

                        bpmTimeData2.append(MybpmTimeRow)
                        bpmArrayData2.append(Double(columns[2]) ?? 0.0)
                    }
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(bpmChangeTwoDaysYear)/\(bpmChangeTwoDaysMonth)/\(bpmChangeTwoDaysDate),\n"
            }
            
            let fileManager1 = FileManager.default
            let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL1 = documentsURL1.appendingPathComponent("\(bpmBaseTwoDaysYear)/\(bpmBaseTwoDaysMonth)/\(bpmBaseTwoDaysDate)")

            let fileURL1 = directoryURL1.appendingPathComponent("/BpmData.csv")

            let filePath1 = fileURL1.path

            // 기준이 되는 날짜
            if fileManager1.fileExists(atPath: filePath1){

                do {
                    let data3 = try String(contentsOf: fileURL1)
                    let bpmData3 = data3.components(separatedBy: .newlines)

                    numbersOfBpm3 = bpmData3.count

                    for i in 0..<numbersOfBpm3 - 1{
                        let row = bpmData3[i]
                        let columns3 = row.components(separatedBy: ",")


                        let bpmTimeCheck = columns3[0].components(separatedBy: ":")
                        let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")

                        bpmTimeData3.append(MybpmTimeRow)
                        bpmArrayData3.append(Double(columns3[2]) ?? 0.0)
                    }
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(bpmBaseTwoDaysYear)/\(bpmBaseTwoDaysMonth)/\(bpmBaseTwoDaysDate),\n"
            }
 
            // file이 없는 경우
            if alertFlag == true {
                alertLabel.isHidden = false
                alertBackground.isHidden = false
                plusButton.isHidden = true
                minusButton.isHidden = true
                refreshButton.isHidden = true
                
                // 마지막 전 문자(,) 제거
                let index = alertString.index(alertString.endIndex, offsetBy: -2)
                alertString.remove(at: index)
                
                alertLabel.text = alertString + "데이터가 없습니다."
            }
            
            // 두 개의 그래프가 있는 경우(fileExists) 두 개의 그래프 표시
            if (fileManager.fileExists(atPath: filePath) && fileManager1.fileExists(atPath: filePath1)){
                
                lastTwoDaysBpmButton.isEnabled = true
                nextTwoDaysBpmButton.isEnabled = true
                
                /*
                 X 축 타임 테이블을 위해 시작 시간과 종료 시간을 구함
                 */
                let startOfYesterday = bpmTimeData2.first!.components(separatedBy: ":") // 어제의 시작
                let endOfYesterday =  bpmTimeData2.last!.components(separatedBy: ":") // 어제의 마지막
                
                let startOfToday = bpmTimeData3.first!.components(separatedBy: ":") // 오늘의 시작
                let endOfToday = bpmTimeData3.last!.components(separatedBy: ":") // 오늘의 마지막
                
                var startTime = [String]()
                var endTime = [String]()
                
                var copyEndHour = ""
                var copyStartHour = 0
//                var copyStartMinute = 0
                
                var minuteDifference = 0 // 분 차이
                var hourDifference = 0 // 시간 차이
                
//                var yesterdayXValue = 0 // 어제 x value
//                var todayXValue = 0 // 오늘 x value
                var totalXValue = 0 // 전체 x value
//                var startXValue = 0 // 그래프가 그려지는 X 밸류
                
                // 전체 시작 시간 비교(total)
                if ( Int(startOfYesterday[0])! > Int(startOfToday[0])! ||
                     ((Int(startOfYesterday[0])! == Int(startOfToday[0])!) &&
                      (Int(startOfYesterday[1])! > Int(startOfToday[1])!))){
                    startTime = bpmTimeData3.first!.components(separatedBy: ":")
                }
                else{
                    startTime = bpmTimeData2.first!.components(separatedBy: ":")
                }
                
                // 전체 종료 시간 비교(total)
                if ( Int(endOfYesterday[0])! > Int(endOfToday[0])! ||
                     ((Int(endOfYesterday[0])! == Int(endOfToday[0])!) &&
                      (Int(endOfYesterday[1])! > Int(endOfToday[1])!))){
                    endTime = bpmTimeData2.last!.components(separatedBy: ":")
                }
                else{
                    endTime = bpmTimeData3.last!.components(separatedBy: ":")
                }
                
                copyEndHour = endTime[0] // hour 계산을 위한 시간값 복사
                
                
                // 오늘 x축의 개수를 위한 시간 차이 구하기(today)
                copyStartHour = Int(endOfToday[0])!
                
                // 분 차이
                if Int(endOfToday[1])! < Int(startOfToday[1])! && Int(endOfToday[0])! > Int(startOfToday[1])! {
                    copyStartHour = Int(endOfToday[0])! - 1
                    minuteDifference = (Int(endOfToday[1])! + 60) - Int(startOfToday[1])!
                }
                else {
                    minuteDifference = Int(endOfToday[1])! - Int(startOfToday[1])! + 1
                }
                
                // 시 차이
                if copyStartHour > Int(startOfToday[0])!{
                    hourDifference = copyStartHour - Int(startOfToday[0])!
                }
                
//                todayXValue = (hourDifference * 360) + (minuteDifference * 6)

                // 어제 x축의 개수를 위한 시간 차이 구하기(yesterday)
                copyStartHour = Int(endOfYesterday[0])!
                
                // 분 차이
                if Int(endOfYesterday[1])! < Int(startOfYesterday[1])! && Int(endOfYesterday[0])! > Int(startOfYesterday[1])! {
                    copyStartHour = Int(endOfYesterday[0])! - 1
                    minuteDifference = (Int(endOfYesterday[1])! + 60) - Int(startOfYesterday[1])!
                }
                else {
                    minuteDifference = Int(endOfYesterday[1])! - Int(startOfYesterday[1])!
                }
                // 시 차이
                if copyStartHour > Int(startOfYesterday[0])!{
                    hourDifference = copyStartHour - Int(startOfYesterday[0])!
                }
                
//                yesterdayXValue = (hourDifference * 360) + (minuteDifference * 6)
                
                // 전체 x축의 개수를 위한 시간 차이 구하기(total)
                copyStartHour = Int(startTime[0])! // 시작 시간
//                copyStartMinute = Int(startTime[1])! // 시작 분
                
                // 분 차이
                if Int(endTime[1])! < Int(startTime[1])!{
                    
                    copyEndHour = String(Int(endTime[0])! - 1)
                    minuteDifference = (Int(endTime[1])! + 60) - Int(startTime[1])!
                }
                else {
                    minuteDifference = Int(endTime[1])! - Int(startTime[1])!
                }
                // 시 차이
                if Int(copyEndHour)! > Int(startTime[0])!{
                    hourDifference = Int(copyEndHour)! - Int(startTime[0])!
                }
                
                totalXValue = (hourDifference * 360) + (minuteDifference * 6)
                                                
                if (numbersOfBpm2 > numbersOfBpm3){
                    numberOfBpmTimeData1 = Double(numbersOfBpm2)
                }else{
                    numberOfBpmTimeData1 = Double(numbersOfBpm3)
                }
                
                var bpmDataEntries2 = [ChartDataEntry]()
                var bpmDataEntries3 = [ChartDataEntry]()
                
                var StringStartHour = startTime[0] // 시작 시간
                var StringStartMinute = startTime[1] // 시작 분
                var secondCount = 0

                // x축 timeTable
                for _ in 0 ..< totalXValue + 1 {
                    
                    let time = "\(StringStartHour):\(StringStartMinute):\(secondCount)"

                    timeTable.append(time)
                    secondCount += 1
                    
                    // 초 -> 분
                    if secondCount == 6 {
                        if Int(StringStartMinute)! < 9 {
                            StringStartMinute = "0"+String(Int(StringStartMinute)! + 1)
                        }
                        else{
                            StringStartMinute = String(Int(StringStartMinute)! + 1)
                        }
                        secondCount = 0
                    }
                    
                    // 분 -> 시
                    if StringStartMinute == "60" {
                        if Int(StringStartHour)! < 9 {
                            StringStartHour = "0"+String(Int(StringStartHour)! + 1)
                        }
                        else{
                            StringStartHour = String(Int(StringStartHour)! + 1)
                        }
                        StringStartMinute = "00"
                    }
                }
                             
                var bpmTimeCount = 0
                var timeTableCount = 0
                     
                copyStartHour = Int(startOfToday[0])!
                
                // 시작지점이 같음
                if startTime[0] == startOfToday[0] && startTime[1] == startOfToday[1]{
                    timeTableCount = 0
                }
                // 시작지점이 다름
                else{
                    // minute
                    if Int(startOfToday[1])! < Int(startTime[1])! {
                        copyStartHour -= 1
                        minuteDifference = (Int(startOfToday[1])! + 60) - Int(startTime[1])!
                    }
                    else{
                        minuteDifference = Int(startOfToday[1])! - Int(startTime[1])!
                    }
                    // hour
                    if copyStartHour > Int(startTime[0])! {
                        hourDifference = copyStartHour - Int(startTime[0])!
                    }
                    else{
                        hourDifference = 0
                    }
                    timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
                }
                
                // today
                for _ in 0 ..< totalXValue {
                    var bpmTime = bpmTimeData3[bpmTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                    
//                    print("------------------------------------------")
//                    print("timeTable : \(timeTable[timeTableCount])")
//                    print("bpmTime : \(bpmTime)")
//                    print("bpmSecond : \(String(bpmTime[2]))")
//                    print("bpmTimeFirst : \(String(bpmTime[2].first!))")
//                    print("checkTimeTable : \(checkTimeTable[2])")
                    
                    // 값이 있는 경우
                    if bpmTime[0] == checkTimeTable[0] { // hour
                        if bpmTime[1] == checkTimeTable[1] { // minute
                            if String(bpmTime[2].first!) == checkTimeTable[2]{ // second
//                                print("----> \(bpmTimeData3[bpmTimeCount]) CheckCount : \(bpmTimeCount)")
                                let bpmDataEntry3 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData3[bpmTimeCount])
                                bpmDataEntries3.append(bpmDataEntry3)
                                
                                bpmTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let bpmDataEntry3 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData3[bpmTimeCount-1])
                            bpmDataEntries3.append(bpmDataEntry3)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let bpmDataEntry3 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData3[bpmTimeCount-1])
                        bpmDataEntries3.append(bpmDataEntry3)
                    }
                    
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && bpmTimeCount < bpmTimeData3.count {
                        bpmTime = bpmTimeData3[bpmTimeCount].components(separatedBy: ":")
                        
                        while String(bpmTime[2].first!) == checkTimeTable[2] {
                            let bpmDataEntry3 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData3[bpmTimeCount])
                            bpmDataEntries3.append(bpmDataEntry3)
                            bpmTimeCount += 1
                            bpmTime = bpmTimeData3[bpmTimeCount].components(separatedBy: ":")
                        }
                    }

                    timeTableCount += 1
                    
                    // 마지막 값
                    if bpmTime[0] == endOfToday[0] && bpmTime[1] == endOfToday[1] && bpmTime[2] == endOfToday[2] || totalXValue == timeTableCount || bpmTimeData3.count == bpmTimeCount {
                        break
                    }
                }
                
                bpmTimeCount = 0
                copyStartHour = Int(startOfYesterday[0])!
                
                // 시작지점이 같음
                if startTime[0] == startOfYesterday[0] && startTime[1] == startOfYesterday[1]{
                    timeTableCount = 0
                }
                // 시작지점이 다름
                else{
                    // minute
                    if Int(startOfYesterday[1])! < Int(startTime[1])! {
                        copyStartHour -= 1
                        minuteDifference = (Int(startOfYesterday[1])! + 60) - Int(startTime[1])!
                    }
                    else{
                        minuteDifference = Int(startOfYesterday[1])! - Int(startTime[1])!
                    }
                    // hour
                    if copyStartHour > Int(startTime[0])! {
                        hourDifference = copyStartHour - Int(startTime[0])!
                    }
                    else{
                        hourDifference = 0
                    }
                    timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
                }
                
                // yesterday
                for _ in 0 ..< totalXValue {
                    var bpmTime = bpmTimeData2[bpmTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                
                    // 값이 있는 경우
                    if bpmTime[0] == checkTimeTable[0] { // hour
                        if bpmTime[1] == checkTimeTable[1] { // minute
                            if String(bpmTime[2].first!) == checkTimeTable[2]{ // second

                                let bpmDataEntry2 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData2[bpmTimeCount])
                                bpmDataEntries2.append(bpmDataEntry2)
                                
                                bpmTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let bpmDataEntry2 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData2[bpmTimeCount-1])
                            bpmDataEntries2.append(bpmDataEntry2)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let bpmDataEntry2 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData2[bpmTimeCount-1])
                        bpmDataEntries2.append(bpmDataEntry2)
                    }
                    
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && bpmTimeCount < bpmTimeData2.count{
                        bpmTime = bpmTimeData2[bpmTimeCount].components(separatedBy: ":")
                        
                        while String(bpmTime[2].first!) == checkTimeTable[2] {
                            let bpmDataEntry2 = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData2[bpmTimeCount])
                            bpmDataEntries2.append(bpmDataEntry2)
                            bpmTimeCount += 1
                            bpmTime = bpmTimeData2[bpmTimeCount].components(separatedBy: ":")
                        }
                    }
                    
                    timeTableCount += 1
                    
                    // 마지막 값
                    if bpmTime[0] == endOfYesterday[0] && bpmTime[1] == endOfYesterday[1] && bpmTime[2] == endOfYesterday[2] || totalXValue == timeTableCount || bpmTimeData2.count == bpmTimeCount {
                        break
                    }
                }
                
                StringStartHour = startTime[0] // 시작 시간
                StringStartMinute = startTime[1] // 시작 분
                
                timeTable = []
                
                // remove second
                for _ in 0 ..< totalXValue + 1 {
                    
                    let time = "\(StringStartHour):\(StringStartMinute)"
                    
                    timeTable.append(time)
                    secondCount += 1
                    
                    // 초 -> 분
                    if secondCount == 6 {
                        if Int(StringStartMinute)! < 9 {
                            StringStartMinute = "0"+String(Int(StringStartMinute)! + 1)
                        }
                        else{
                            StringStartMinute = String(Int(StringStartMinute)! + 1)
                        }
                        secondCount = 0
                    }
                    // 분 -> 시
                    if StringStartMinute == "60" {
                        if Int(StringStartHour)! < 9 {
                            StringStartHour = "0"+String(Int(StringStartHour)! + 1)
                        }
                        else{
                            StringStartHour = String(Int(StringStartHour)! + 1)
                        }
                        StringStartMinute = "00"
                    }
                }

                
                let bpmChartDataSet1 = LineChartDataSet(entries: bpmDataEntries2, label: "\(bpmChangeTwoDaysMonth)-\(bpmChangeTwoDaysDate)")
                bpmChartDataSet1.drawCirclesEnabled = false
                bpmChartDataSet1.setColor(NSUIColor.red)
                bpmChartDataSet1.mode = .linear
                bpmChartDataSet1.lineWidth = 0.5
                bpmChartDataSet1.drawValuesEnabled = true // value값 보이게
                
                
                let bpmChartDataSet2 = LineChartDataSet(entries: bpmDataEntries3, label: "\(bpmBaseTwoDaysMonth)-\(bpmBaseTwoDaysDate)")
                bpmChartDataSet2.drawCirclesEnabled = false
                bpmChartDataSet2.setColor(NSUIColor.blue)
                bpmChartDataSet2.mode = .linear
                bpmChartDataSet2.lineWidth = 0.5
                bpmChartDataSet2.drawValuesEnabled = true  // value값 보이게
                
                let twoDaysBpmChartdataSets: [LineChartDataSet] = [bpmChartDataSet1, bpmChartDataSet2]
                let twoDaysBpmChartData = LineChartData(dataSets: twoDaysBpmChartdataSets)
                

                twoDaysBpmChartView.data = twoDaysBpmChartData
                twoDaysBpmChartView.noDataText = ""
                twoDaysBpmChartView.xAxis.enabled = true
                twoDaysBpmChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
                // x축 시간값 출력
                twoDaysBpmChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeTable)
                twoDaysBpmChartView.xAxis.axisMinimum = 0
                twoDaysBpmChartView.xAxis.axisMaximum = Double(totalXValue) // x축 범위
                twoDaysBpmChartView.setVisibleXRangeMaximum(1000)   // 처음 보여지는 x축 범위
                twoDaysBpmChartView.xAxis.granularity = 1
                twoDaysBpmChartView.xAxis.labelPosition = .bottom
                twoDaysBpmChartView.xAxis.drawGridLinesEnabled = false
                
                twoDaysBpmChartView.leftAxis.axisMaximum = 200
                twoDaysBpmChartView.leftAxis.axisMinimum = 40
                twoDaysBpmChartView.rightAxis.enabled = false
                twoDaysBpmChartView.drawMarkers = false
                twoDaysBpmChartView.dragEnabled = true // 좌우 드래그
                twoDaysBpmChartView.pinchZoomEnabled = false
                twoDaysBpmChartView.doubleTapToZoomEnabled = true // 더블 줌
                twoDaysBpmChartView.highlightPerTapEnabled = false
                
                twoDaysBpmChartView.data?.notifyDataChanged()
                twoDaysBpmChartView.notifyDataSetChanged()
                twoDaysBpmChartView.moveViewToX(0)
                
                bpmTimeData2 = []
                bpmArrayData2 = []
                
                bpmTimeData3 = []
                bpmArrayData3 = []
                
                bpmTimeData4 = []
                bpmArrayData4 = []
                
                bpmTimeData5 = []
                bpmArrayData5 = []
                

//                twoDaysBpmChartView.moveViewToX(Double(timeTable.count))
                twoDaysBpmChartView.isUserInteractionEnabled = true
                bpmChartView.isUserInteractionEnabled = false
                ThreeDaysBpmChartView.isUserInteractionEnabled = false
                
                // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
                for _ in 0..<20 {
                    twoDaysBpmChartView.zoomOut()
                }
                
            }
        }
        // Next Button Event
        else if (nextArrowFlag  == 1) {
    
            let fileManager4 = FileManager.default
            let documentsURL4 = fileManager4.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL4 = documentsURL4.appendingPathComponent("\(bpmBaseTwoDaysYear)/\(bpmBaseTwoDaysMonth)/\(bpmBaseTwoDaysDate)")
            
            let fileURL4 = directoryURL4.appendingPathComponent("/BpmData.csv")
            
            let filePath4 = fileURL4.path
            
            // time table : 그래프에 보여줄 시간 저장 배열
            var timeTable: [String] = []
            
            // 버튼을 여러번 클릭하였을때 값이 섞이는 것을 방지
            bpmTimeData2 = []
            bpmArrayData2 = []
            
            bpmTimeData3 = []
            bpmArrayData3 = []
            
            bpmTimeData4 = []
            bpmArrayData4 = []
            
            bpmTimeData5 = []
            bpmArrayData5 = []
            
            if fileManager4.fileExists(atPath: filePath4){
                
                do {
                    let data4 = try String(contentsOf: fileURL4)
                    let bpmData4 = data4.components(separatedBy: .newlines)
                    
                    numbersOfBpm4 = bpmData4.count
                    
                    for i in 0..<numbersOfBpm4 - 1{
                        let row = bpmData4[i]
                        let columns4 = row.components(separatedBy: ",")
                        
                        let bpmTimeCheck = columns4[0].components(separatedBy: ":")
                        let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")
                        
                        bpmTimeData4.append(MybpmTimeRow)
                        bpmArrayData4.append(Double(columns4[2]) ?? 0.0)
                    }
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(bpmBaseTwoDaysYear)/\(bpmBaseTwoDaysMonth)/\(bpmBaseTwoDaysDate),\n"
            }
            
            let fileManager5 = FileManager.default
            let documentsURL5 = fileManager5.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL5 = documentsURL5.appendingPathComponent("\(bpmChangeTwoDaysYear)/\(bpmChangeTwoDaysMonth)/\(bpmChangeTwoDaysDate)")
            
            let fileURL5 = directoryURL5.appendingPathComponent("/BpmData.csv")
            
            let filePath5 = fileURL5.path
            
            if fileManager5.fileExists(atPath: filePath5){
                
                do {
                    let data5 = try String(contentsOf: fileURL5)
                    let bpmData5 = data5.components(separatedBy: .newlines)
                    
                    numbersOfBpm5 = bpmData5.count
                    
                    for i in 0..<numbersOfBpm5 - 1{
                        let row = bpmData5[i]
                        let columns5 = row.components(separatedBy: ",")
                        
                        let bpmTimeCheck = columns5[0].components(separatedBy: ":")
                        let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")
                        
                        bpmTimeData5.append(MybpmTimeRow)
                        bpmArrayData5.append(Double(columns5[2]) ?? 0.0)
                    }
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(bpmChangeTwoDaysYear)/\(bpmChangeTwoDaysMonth)/\(bpmChangeTwoDaysDate),\n"
            }
            
            // file이 없는 경우
            if alertFlag == true {
                alertLabel.isHidden = false
                alertBackground.isHidden = false
                plusButton.isHidden = true
                minusButton.isHidden = true
                refreshButton.isHidden = true
                
                // 마지막 전 문자(,) 제거
                let index = alertString.index(alertString.endIndex, offsetBy: -2)
                alertString.remove(at: index)
                
                alertLabel.text = alertString + "데이터가 없습니다."
            }
            
            // 두 개의 그래프 표시
            if (fileManager4.fileExists(atPath: filePath4) && fileManager5.fileExists(atPath: filePath5)){
                
                lastTwoDaysBpmButton.isEnabled = true
                nextTwoDaysBpmButton.isEnabled = true
                             
                /*
                 X 축 타임 테이블을 위해 시작 시간과 종료 시간을 구함
                 */
                let startOfYesterday = bpmTimeData4.first!.components(separatedBy: ":") // 어제의 시작
                let endOfYesterday =  bpmTimeData4.last!.components(separatedBy: ":") // 어제의 마지막
                
                let startOfToday = bpmTimeData5.first!.components(separatedBy: ":") // 오늘의 시작
                let endOfToday = bpmTimeData5.last!.components(separatedBy: ":") // 오늘의 마지막
                
                var startTime = [String]()
                var endTime = [String]()
                
                var copyEndHour = ""
                var copyStartHour = 0
                
                var minuteDifference = 0 // 분 차이
                var hourDifference = 0 // 시간 차이
                
//                var yesterdayXValue = 0 // 어제 x value
//                var todayXValue = 0 // 오늘 x value
                var totalXValue = 0 // 전체 x value
                
                // 전체 시작 시간 비교(total)
                if ( Int(startOfYesterday[0])! > Int(startOfToday[0])! ||
                     ((Int(startOfYesterday[0])! == Int(startOfToday[0])!) &&
                      (Int(startOfYesterday[1])! > Int(startOfToday[1])!))){
                    startTime = bpmTimeData5.first!.components(separatedBy: ":")
                }
                else{
                    startTime = bpmTimeData4.first!.components(separatedBy: ":")
                }
                
                // 전체 종료 시간 비교(total)
                if ( Int(endOfYesterday[0])! > Int(endOfToday[0])! ||
                     ((Int(endOfYesterday[0])! == Int(endOfToday[0])!) &&
                      (Int(endOfYesterday[1])! > Int(endOfToday[1])!))){
                    endTime = bpmTimeData4.last!.components(separatedBy: ":")
                }
                else{
                    endTime = bpmTimeData5.last!.components(separatedBy: ":")
                }
                
                copyEndHour = endTime[0] // hour 계산을 위한 시간값 복사
                
                // 오늘 x축의 개수를 위한 시간 차이 구하기(today)
                copyStartHour = Int(endOfToday[0])!
                
                // 분 차이
                if Int(endOfToday[1])! < Int(startOfToday[1])! && Int(endOfToday[0])! > Int(startOfToday[1])! {
                    copyStartHour = Int(endOfToday[0])! - 1
                    minuteDifference = (Int(endOfToday[1])! + 60) - Int(startOfToday[1])!
                }
                else {
                    minuteDifference = Int(endOfToday[1])! - Int(startOfToday[1])!
                }
                
                // 시 차이
                if copyStartHour > Int(startOfToday[0])!{
                    hourDifference = copyStartHour - Int(startOfToday[0])!
                }
                
//                todayXValue = (hourDifference * 360) + (minuteDifference * 6)
                
                // 어제 x축의 개수를 위한 시간 차이 구하기(yesterday)
                copyStartHour = Int(endOfYesterday[0])!
                
                // 분 차이
                if Int(endOfYesterday[1])! < Int(startOfYesterday[1])! && Int(endOfYesterday[0])! > Int(startOfYesterday[1])! {
                    copyStartHour = Int(endOfYesterday[0])! - 1
                    minuteDifference = (Int(endOfYesterday[1])! + 60) - Int(startOfYesterday[1])!
                }
                else {
                    minuteDifference = Int(endOfYesterday[1])! - Int(startOfYesterday[1])!
                }
                // 시 차이
                if copyStartHour > Int(startOfYesterday[0])!{
                    hourDifference = copyStartHour - Int(startOfYesterday[0])!
                }
                
//                yesterdayXValue = (hourDifference * 360) + (minuteDifference * 6)
                
                // 전체 x축의 개수를 위한 시간 차이 구하기(total)
                copyStartHour = Int(startTime[0])! // 시작 시간
                
                // 분 차이
                if Int(endTime[1])! < Int(startTime[1])!{
                    
                    copyEndHour = String(Int(endTime[0])! - 1)
                    minuteDifference = (Int(endTime[1])! + 60) - Int(startTime[1])!
                }
                else {
                    minuteDifference = Int(endTime[1])! - Int(startTime[1])!
                }
                // 시 차이
                if Int(copyEndHour)! > Int(startTime[0])!{
                    hourDifference = Int(copyEndHour)! - Int(startTime[0])!
                }
                
                totalXValue = (hourDifference * 360) + (minuteDifference * 6)
                
                if (numbersOfBpm4 > numbersOfBpm5){
                    numberOfBpmTimeData2 = Double(numbersOfBpm4)
                }else{
                    numberOfBpmTimeData2 = Double(numbersOfBpm5)
                }
                
                var bpmDataEntries4 = [ChartDataEntry]()
                var bpmDataEntries5 = [ChartDataEntry]()
                
                var StringStartHour = startTime[0] // 시작 시간
                var StringStartMinute = startTime[1] // 시작 분
                var secondCount = 0
            
                // x축 timeTable
                for _ in 0 ..< totalXValue + 1 {
                    
                    let time = "\(StringStartHour):\(StringStartMinute):\(secondCount)"
                    
                    timeTable.append(time)
                    secondCount += 1
                    
                    // 초 -> 분
                    if secondCount == 6 {
                        if Int(StringStartMinute)! < 9 {
                            StringStartMinute = "0"+String(Int(StringStartMinute)! + 1)
                        }
                        else{
                            StringStartMinute = String(Int(StringStartMinute)! + 1)
                        }
                        secondCount = 0
                    }
                    // 분 -> 시
                    if StringStartMinute == "60" {
                        if Int(StringStartHour)! < 9 {
                            StringStartHour = "0"+String(Int(StringStartHour)! + 1)
                        }
                        else{
                            StringStartHour = String(Int(StringStartHour)! + 1)
                        }
                        StringStartMinute = "00"
                    }
                }
                
                var bpmTimeCount = 0
                var timeTableCount = 0
                
                copyStartHour = Int(startOfToday[0])!
                
                // 시작지점이 같음
                if startTime[0] == startOfToday[0] && startTime[1] == startOfToday[1]{
                    timeTableCount = 0
                }
                // 시작지점이 다름
                else{
                    // minute
                    if Int(startOfToday[1])! < Int(startTime[1])! {
                        copyStartHour -= 1
                        minuteDifference = (Int(startOfToday[1])! + 60) - Int(startTime[1])!
                    }
                    else{
                        minuteDifference = Int(startOfToday[1])! - Int(startTime[1])!
                    }
                    // hour
                    if copyStartHour > Int(startTime[0])! {
                        hourDifference = copyStartHour - Int(startTime[0])!
                    }
                    else{
                        hourDifference = 0
                    }
                    timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
                }
                
                // today
                for _ in 0 ..< totalXValue {
                    var bpmTime = bpmTimeData5[bpmTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                    
                    // 값이 있는 경우
                    if bpmTime[0] == checkTimeTable[0] { // hour
                        if bpmTime[1] == checkTimeTable[1] { // minute
                            if String(bpmTime[2].first!) == checkTimeTable[2]{ // second
                                
                                let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData5[bpmTimeCount])
                                bpmDataEntries5.append(bpmDataEntry)
                                
                                bpmTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData5[bpmTimeCount-1])
                            bpmDataEntries5.append(bpmDataEntry)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData5[bpmTimeCount-1])
                        bpmDataEntries5.append(bpmDataEntry)
                    }
                    
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && bpmTimeCount < bpmTimeData5.count {
                        bpmTime = bpmTimeData5[bpmTimeCount].components(separatedBy: ":")
                        
                        while String(bpmTime[2].first!) == checkTimeTable[2] {
                            let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData5[bpmTimeCount])
                            bpmDataEntries5.append(bpmDataEntry)
                            bpmTimeCount += 1
                            bpmTime = bpmTimeData5[bpmTimeCount].components(separatedBy: ":")
                        }
                    }
                    
                    timeTableCount += 1
                    
                    // 마지막 값
                    if bpmTime[0] == endOfToday[0] && bpmTime[1] == endOfToday[1] && bpmTime[2] == endOfToday[2] || totalXValue == timeTableCount || bpmTimeData5.count == bpmTimeCount {
                        break
                    }
                }
                
                bpmTimeCount = 0
                copyStartHour = Int(startOfYesterday[0])!
                
                // 시작지점이 같음
                if startTime[0] == startOfYesterday[0] && startTime[1] == startOfYesterday[1]{
                    timeTableCount = 0
                }
                // 시작지점이 다름
                else{
                    // minute
                    if Int(startOfYesterday[1])! < Int(startTime[1])! {
                        copyStartHour -= 1
                        minuteDifference = (Int(startOfYesterday[1])! + 60) - Int(startTime[1])!
                    }
                    else{
                        minuteDifference = Int(startOfYesterday[1])! - Int(startTime[1])!
                    }
                    // hour
                    if copyStartHour > Int(startTime[0])! {
                        hourDifference = copyStartHour - Int(startTime[0])!
                    }
                    else{
                        hourDifference = 0
                    }
                    timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
                }
                
                // yesterday
                for _ in 0 ..< totalXValue {
                    var bpmTime = bpmTimeData4[bpmTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                    
                    // 값이 있는 경우
                    if bpmTime[0] == checkTimeTable[0] { // hour
                        if bpmTime[1] == checkTimeTable[1] { // minute
                            if String(bpmTime[2].first!) == checkTimeTable[2]{ // second
                                
                                let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData4[bpmTimeCount])
                                bpmDataEntries4.append(bpmDataEntry)
                                
                                bpmTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData4[bpmTimeCount-1])
                            bpmDataEntries4.append(bpmDataEntry)
                        }
                    }
                    // 값이 없는 경우
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData4[bpmTimeCount-1])
                        bpmDataEntries4.append(bpmDataEntry)
                    }
                    
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && bpmTimeCount < bpmTimeData4.count{
                        bpmTime = bpmTimeData4[bpmTimeCount].components(separatedBy: ":")
                        
                        while String(bpmTime[2].first!) == checkTimeTable[2] {
                            let bpmDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmArrayData4[bpmTimeCount])
                            bpmDataEntries4.append(bpmDataEntry)
                            bpmTimeCount += 1
                            bpmTime = bpmTimeData4[bpmTimeCount].components(separatedBy: ":")
                        }
                    }
                    
                    timeTableCount += 1
                    
                    // 마지막 값
                    if bpmTime[0] == endOfYesterday[0] && bpmTime[1] == endOfYesterday[1] && bpmTime[2] == endOfYesterday[2] || totalXValue == timeTableCount || bpmTimeData4.count == bpmTimeCount{
                        break
                    }
                }
                    
                StringStartHour = startTime[0] // 시작 시간
                StringStartMinute = startTime[1] // 시작 분
                
                timeTable = [] // 기존 배열 초기화
                
                // remove second
                for _ in 0 ..< totalXValue + 1 {
                    
                    let time = "\(StringStartHour):\(StringStartMinute)"
            
                    timeTable.append(time)
                    secondCount += 1
                    
                    // 초 -> 분
                    if secondCount == 6 {
                        if Int(StringStartMinute)! < 9 {
                            StringStartMinute = "0"+String(Int(StringStartMinute)! + 1)
                        }
                        else{
                            StringStartMinute = String(Int(StringStartMinute)! + 1)
                        }
                        secondCount = 0
                    }
                    // 분 -> 시
                    if StringStartMinute == "60" {
                        if Int(StringStartHour)! < 9 {
                            StringStartHour = "0"+String(Int(StringStartHour)! + 1)
                        }
                        else{
                            StringStartHour = String(Int(StringStartHour)! + 1)
                        }
                        StringStartMinute = "00"
                    }
                }
                
                let bpmChartDataSet4 = LineChartDataSet(entries: bpmDataEntries4, label: "\(bpmBaseTwoDaysMonth)-\(bpmBaseTwoDaysDate)")
                bpmChartDataSet4.drawCirclesEnabled = false
                bpmChartDataSet4.setColor(NSUIColor.red)
                bpmChartDataSet4.mode = .linear
                bpmChartDataSet4.lineWidth = 0.5
                bpmChartDataSet4.drawValuesEnabled = true  // value값 보이게
                
                
                let bpmChartDataSet5 = LineChartDataSet(entries: bpmDataEntries5, label: "\(bpmChangeTwoDaysMonth)-\(bpmChangeTwoDaysDate)")
                bpmChartDataSet5.drawCirclesEnabled = false
                bpmChartDataSet5.setColor(NSUIColor.blue)
                bpmChartDataSet5.mode = .linear
                bpmChartDataSet5.lineWidth = 0.5
                bpmChartDataSet5.drawValuesEnabled = true  // value값 보이게
                
                let twoDaysBpmChartdataSets2: [LineChartDataSet] = [bpmChartDataSet4, bpmChartDataSet5]
                let twoDaysBpmChartData2 = LineChartData(dataSets: twoDaysBpmChartdataSets2)
                
                twoDaysBpmChartView.data = twoDaysBpmChartData2
                twoDaysBpmChartView.noDataText = ""
                twoDaysBpmChartView.xAxis.enabled = true
                twoDaysBpmChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
                twoDaysBpmChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeTable)
                twoDaysBpmChartView.xAxis.axisMinimum = 0
                twoDaysBpmChartView.xAxis.axisMaximum = Double(totalXValue) // x축 범위
                twoDaysBpmChartView.setVisibleXRangeMaximum(1000)   // 처음 보여지는 x축 범위
                twoDaysBpmChartView.xAxis.granularity = 1
                twoDaysBpmChartView.xAxis.labelPosition = .bottom
                twoDaysBpmChartView.xAxis.drawGridLinesEnabled = false
                
                twoDaysBpmChartView.leftAxis.axisMaximum = 200
                twoDaysBpmChartView.leftAxis.axisMinimum = 40
                twoDaysBpmChartView.rightAxis.enabled = false
                twoDaysBpmChartView.drawMarkers = false
                twoDaysBpmChartView.dragEnabled = true // 좌우 드래그
                twoDaysBpmChartView.pinchZoomEnabled = false
                twoDaysBpmChartView.doubleTapToZoomEnabled = true // 더블 줌
                twoDaysBpmChartView.highlightPerTapEnabled = false
                
                twoDaysBpmChartView.data?.notifyDataChanged()
                twoDaysBpmChartView.notifyDataSetChanged()
                twoDaysBpmChartView.moveViewToX(0)
                
                
                bpmTimeData2 = []
                bpmArrayData2 = []
                
                bpmTimeData3 = []
                bpmArrayData3 = []
                
                bpmTimeData4 = []
                bpmArrayData4 = []
                
                bpmTimeData5 = []
                bpmArrayData5 = []
                
                twoDaysBpmChartView.isUserInteractionEnabled = true
                bpmChartView.isUserInteractionEnabled = false
                ThreeDaysBpmChartView.isUserInteractionEnabled = false
            }
        }
        else {
            let alert = UIAlertController(title: "more data need", message: "", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
            })
            alert.addAction(ok)
            present(alert,animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - 3Days Graph
    func threeDaysBpmChartViewGraph(){
        
        bpmChartView.clear()
        twoDaysBpmChartView.clear()
        ThreeDaysBpmChartView.clear()
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        plusButton.isHidden = false
        minusButton.isHidden = false
        refreshButton.isHidden = false
        
        bpmThreeArrayData1 = []
        bpmThreeTimeData1 = []
        
        bpmThreeArrayData2 = []
        bpmThreeTimeData2 = []
        
        bpmThreeArrayData3 = []
        bpmThreeTimeData3 = []
        
        bpmChangeThreeDaysYear1 = defaults.string(forKey:"bpmChangeThreeDaysYear1") ?? "\(realYear)"
        bpmChangeThreeDaysMonth1 = defaults.string(forKey:"bpmChangeThreeDaysMonth1") ?? "\(realMonth)"
        bpmChangeThreeDaysDate1 = defaults.string(forKey:"bpmChangeThreeDaysDate1") ?? "\(realDate)"

        bpmChangeThreeDaysYear2 = defaults.string(forKey:"bpmChangeThreeDaysYear2") ?? "\(realYear)"
        bpmChangeThreeDaysMonth2 = defaults.string(forKey:"bpmChangeThreeDaysMonth2") ?? "\(realMonth)"
        bpmChangeThreeDaysDate2 = defaults.string(forKey:"bpmChangeThreeDaysDate2") ?? "\(realDate)"

        bpmChangeThreeDaysYear3 = defaults.string(forKey:"bpmChangeThreeDaysYear3") ?? "\(realYear)"
        bpmChangeThreeDaysMonth3 = defaults.string(forKey:"bpmChangeThreeDaysMonth3") ?? "\(realMonth)"
        bpmChangeThreeDaysDate3 = defaults.string(forKey:"bpmChangeThreeDaysDate3") ?? "\(realDate)"

        // test
//        bpmChangeThreeDaysYear1 = "2023"
//        bpmChangeThreeDaysMonth1 = "06"
//        bpmChangeThreeDaysDate1 = "09"
//
//        bpmChangeThreeDaysYear2 = "2023"
//        bpmChangeThreeDaysMonth2 = "06"
//        bpmChangeThreeDaysDate2 = "08"
//
//        bpmChangeThreeDaysYear3 = "2023"
//        bpmChangeThreeDaysMonth3 = "06"
//        bpmChangeThreeDaysDate3 = "07"
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL.appendingPathComponent("\(bpmChangeThreeDaysYear1)/\(bpmChangeThreeDaysMonth1)/\(bpmChangeThreeDaysDate1)")
        
        let fileURL1 = directoryURL1.appendingPathComponent("/BpmData.csv")
        
        let filePath1 = fileURL1.path
        
        // time table : 그래프에 보여줄 시간 배열
        var timeTable: [String] = []
        
        // 기준일
        if fileManager.fileExists(atPath: filePath1){
            
            do {
                let data1 = try String(contentsOf: fileURL1)
                let bpmData1 = data1.components(separatedBy: .newlines)
                
                numbersOfThreeBpm1 = bpmData1.count
                
                for i in 0..<numbersOfThreeBpm1 - 1{
                    let row = bpmData1[i]
                    let columns = row.components(separatedBy: ",")
                    
                    let bpmTimeCheck = columns[0].components(separatedBy: ":")
                    let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")
                    
                    bpmThreeTimeData1.append(MybpmTimeRow)
                    bpmThreeArrayData1.append(Double(columns[2]) ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertFlag = true
            alertString = "\(bpmChangeThreeDaysYear1)/\(bpmChangeThreeDaysMonth1)/\(bpmChangeThreeDaysDate1),\n"
        }

        let directoryURL2 = documentsURL.appendingPathComponent("\(bpmChangeThreeDaysYear2)/\(bpmChangeThreeDaysMonth2)/\(bpmChangeThreeDaysDate2)")
        
        let fileURL2 = directoryURL2.appendingPathComponent("/BpmData.csv")
        
        let filePath2 = fileURL2.path
        
        // 기준일(-1)
        if fileManager.fileExists(atPath: filePath2){
            
            do {
                let data2 = try String(contentsOf: fileURL2)
                let bpmData2 = data2.components(separatedBy: .newlines)
                
                numbersOfThreeBpm2 = bpmData2.count
                
                for i in 0..<numbersOfThreeBpm2 - 1{
                    let row = bpmData2[i]
                    let columns = row.components(separatedBy: ",")
                    
                    let bpmTimeCheck = columns[0].components(separatedBy: ":")
                    let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")
                    
                    bpmThreeTimeData2.append(MybpmTimeRow)
                    bpmThreeArrayData2.append(Double(columns[2]) ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
        }
        else {
            alertFlag = true
            alertString += "\(bpmChangeThreeDaysYear2)/\(bpmChangeThreeDaysMonth2)/\(bpmChangeThreeDaysDate2),\n"
        }
        
        let directoryURL3 = documentsURL.appendingPathComponent("\(bpmChangeThreeDaysYear3)/\(bpmChangeThreeDaysMonth3)/\(bpmChangeThreeDaysDate3)")
        
        let fileURL3 = directoryURL3.appendingPathComponent("/BpmData.csv")
        
        let filePath3 = fileURL3.path
        
        // 기준일(-2)
        if fileManager.fileExists(atPath: filePath3){
            
            do {
                let data3 = try String(contentsOf: fileURL3)
                let bpmData3 = data3.components(separatedBy: .newlines)
                
                numbersOfThreeBpm3 = bpmData3.count
                
                for i in 0..<numbersOfThreeBpm3 - 1{
                    let row = bpmData3[i]
                    let columns = row.components(separatedBy: ",")
                    
                    let bpmTimeCheck = columns[0].components(separatedBy: ":")
                    let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1] + ":" + (bpmTimeCheck[safe: 2] ?? "00")
                    
                    bpmThreeTimeData3.append(MybpmTimeRow)
                    bpmThreeArrayData3.append(Double(columns[2]) ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
        }
        else {
            alertFlag = true
            alertString += "\(bpmChangeThreeDaysYear3)/\(bpmChangeThreeDaysMonth3)/\(bpmChangeThreeDaysDate3),\n"
        }
        
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            plusButton.isHidden = true
            minusButton.isHidden = true
            refreshButton.isHidden = true
            
            // 마지막 전 문자(,) 제거
            let index = alertString.index(alertString.endIndex, offsetBy: -2)
            alertString.remove(at: index)
            
            alertLabel.text = alertString + "데이터가 없습니다."
        }
        
        // 그래프 표시
        if (fileManager.fileExists(atPath: filePath1) && fileManager.fileExists(atPath: filePath2) && fileManager.fileExists(atPath: filePath3)){
                        
            /*
             X 축 타임 테이블을 위해 시작 시간과 종료 시간을 구함
             */
            let firstTwoDaysAgoTime = bpmThreeTimeData3.first!.components(separatedBy: ":") // 이틀전 시작
            let lastTwoDaysAgoTime =  bpmThreeTimeData3.last!.components(separatedBy: ":") // 이틀전 마지막
            
            let firstYesterdayTime = bpmThreeTimeData2.first!.components(separatedBy: ":") // 어제 시작
            let lastYesterdayTime =  bpmThreeTimeData2.last!.components(separatedBy: ":") // 어제 마지막
            
            let firstSelectTime = bpmThreeTimeData1.first!.components(separatedBy: ":") // 오늘 시작
            let lastSelectTime = bpmThreeTimeData1.last!.components(separatedBy: ":") // 오늘 마지막
            
            
            var startTime = [String]()
            var endTime = [String]()
            
            // 시간값 계산을 위한 변수
            var copyEndHour = ""
            var copyStartHour = 0
            
            var minuteDifference = 0 // 분 차이
            var hourDifference = 0 // 시간 차이
            
            var totalXValue = 0 // 전체 x value
            
            // 전체 시작 시간 비교
            // 오늘과 어제 비교
            if ( Int(firstYesterdayTime[0])! > Int(firstSelectTime[0])! ||
                 ((Int(firstYesterdayTime[0])! == Int(firstSelectTime[0])!) &&
                  (Int(firstYesterdayTime[1])! > Int(firstSelectTime[1])!))){
                // 오늘이 빠름
                startTime = bpmThreeTimeData1.first!.components(separatedBy: ":")
            }
            else{
                // 어제가 빠름
                startTime = bpmThreeTimeData2.first!.components(separatedBy: ":")
            }
            // 빠른 날과 이틀전 비교
            if ( Int(firstTwoDaysAgoTime[0])! > Int(startTime[0])! ||
                 ((Int(firstTwoDaysAgoTime[0])! == Int(startTime[0])!) &&
                  (Int(firstTwoDaysAgoTime[1])! > Int(startTime[1])!))){
                // 기존에 빠른 날이 제일 빠름
            }
            else{
                // 이틀전이 제일 빠름
                startTime = bpmThreeTimeData3.first!.components(separatedBy: ":")
            }
            
            
            
            // 전체 종료 시간 비교
            // 오늘과 어제 비교
            if ( Int(lastYesterdayTime[0])! > Int(lastSelectTime[0])! ||
                 ((Int(lastYesterdayTime[0])! == Int(lastSelectTime[0])!) &&
                  (Int(lastYesterdayTime[1])! > Int(lastSelectTime[1])!))){
                // 어제가 느림
                endTime = bpmThreeTimeData2.last!.components(separatedBy: ":")
            }
            else{
                // 오늘이 느림
                endTime = bpmThreeTimeData1.last!.components(separatedBy: ":")
            }
            // 느린 날과 이틀전 비교
            if ( Int(lastTwoDaysAgoTime[0])! > Int(endTime[0])! ||
                 ((Int(lastTwoDaysAgoTime[0])! == Int(endTime[0])!) &&
                  (Int(lastTwoDaysAgoTime[1])! > Int(endTime[1])!))){
                // 이틀전이 제일 느림
                endTime = bpmThreeTimeData3.last!.components(separatedBy: ":")
            }
            else{
                // 기존에 느린날이 제일 느림
            }
               
            // 전체 x축의 개수를 위한 시간 차이 구하기(total)
            copyStartHour = Int(startTime[0])! // 시작 시간
            copyEndHour = endTime[0] // hour 계산을 위한 시간값 복사
            
            // 분 차이
            if Int(endTime[1])! < Int(startTime[1])!{
                
                copyEndHour = String(Int(endTime[0])! - 1)
                minuteDifference = (Int(endTime[1])! + 60) - Int(startTime[1])!
            }
            else {
                minuteDifference = Int(endTime[1])! - Int(startTime[1])!
            }
            // 시 차이
            if Int(copyEndHour)! > Int(startTime[0])!{
                hourDifference = Int(copyEndHour)! - Int(startTime[0])!
            }
            
            totalXValue = (hourDifference * 360) + (minuteDifference * 6)
            
            var bpmThreeDataEntries1 = [ChartDataEntry]()
            var bpmThreeDataEntries2 = [ChartDataEntry]()
            var bpmThreeDataEntries3 = [ChartDataEntry]()

            var StringStartHour = startTime[0] // 시작 시간
            var StringStartMinute = startTime[1] // 시작 분
            var secondCount = 0

            // TimeTable(x축)
            for _ in 0 ..< totalXValue + 1 {
                
                let time = "\(StringStartHour):\(StringStartMinute):\(secondCount)"
                
                timeTable.append(time)
                secondCount += 1
                
                // 초 -> 분
                if secondCount == 6 {
                    if Int(StringStartMinute)! < 9 {
                        StringStartMinute = "0"+String(Int(StringStartMinute)! + 1)
                    }
                    else{
                        StringStartMinute = String(Int(StringStartMinute)! + 1)
                    }
                    secondCount = 0
                }
                // 분 -> 시
                if StringStartMinute == "60" {
                    if Int(StringStartHour)! < 9 {
                        StringStartHour = "0"+String(Int(StringStartHour)! + 1)
                    }
                    else{
                        StringStartHour = String(Int(StringStartHour)! + 1)
                    }
                    StringStartMinute = "00"
                }
            }
            
            // bpmTime 배열, timeTable 배열 카운트 변수
            var bpmTimeCount = 0
            var timeTableCount = 0
            
            // 시작지점 비교를 위함
            copyStartHour = Int(firstSelectTime[0])!
            
            
            // 시작지점 비교
            if startTime[0] == firstSelectTime[0] && startTime[1] == firstSelectTime[1]{
                timeTableCount = 0 // 시작지점이 제일 빠르므로 0부터 시작
            }
            // 시작지점이 다름
            else{
                // minute
                if Int(firstSelectTime[1])! < Int(startTime[1])! {
                    copyStartHour -= 1
                    minuteDifference = (Int(firstSelectTime[1])! + 60) - Int(startTime[1])!
                }
                else{
                    minuteDifference = Int(firstSelectTime[1])! - Int(startTime[1])!
                }
                // hour
                if copyStartHour > Int(startTime[0])! {
                    hourDifference = copyStartHour - Int(startTime[0])!
                }
                else{
                    hourDifference = 0
                }
                // 그래프 그리는 시작 지점
                timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
            }
            
            // today 값 저장
            for _ in 0 ..< totalXValue {
                var bpmTime = bpmThreeTimeData1[bpmTimeCount].components(separatedBy: ":")
                let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                var checkFlag = false
                
                // 값이 있는 경우
                if bpmTime[0] == checkTimeTable[0] { // hour
                    if bpmTime[1] == checkTimeTable[1] { // minute
                        if String(bpmTime[2].first!) == checkTimeTable[2]{ // second
                            
                            let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData1[bpmTimeCount])
                            bpmThreeDataEntries1.append(bpmThreeDataEntry)
                            
                            bpmTimeCount += 1 // 값이 있으니까 +1
                            checkFlag = true
                        }
                    }
                    else{
                        // 분 값이 없는 경우 이전 값을 씀
                        let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData1[bpmTimeCount-1])
                        bpmThreeDataEntries1.append(bpmThreeDataEntry)
                    }
                }
                else{
                    // 시간 값이 없는 경우
                    let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData1[bpmTimeCount-1])
                    bpmThreeDataEntries1.append(bpmThreeDataEntry)
                }
                
                // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                if checkFlag == true && bpmTimeCount < bpmThreeTimeData1.count{
                    bpmTime = bpmThreeTimeData1[bpmTimeCount].components(separatedBy: ":")
                    
                    while String(bpmTime[2].first!) == checkTimeTable[2] {
                        let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData1[bpmTimeCount])
                        bpmThreeDataEntries1.append(bpmThreeDataEntry)
                        bpmTimeCount += 1
                        bpmTime = bpmThreeTimeData1[bpmTimeCount].components(separatedBy: ":")
                    }
                    
                }
                
                timeTableCount += 1
                
                // 마지막 값
                if bpmTime[0] == lastSelectTime[0] && bpmTime[1] == lastSelectTime[1] && bpmTime[2] == lastSelectTime[2] || totalXValue == timeTableCount || bpmThreeTimeData1.count == bpmTimeCount {
                    break
                }
            }
            
            bpmTimeCount = 0
            copyStartHour = Int(firstYesterdayTime[0])!
            
            // 시작지점 비교
            if startTime[0] == firstYesterdayTime[0] && startTime[1] == firstYesterdayTime[1]{
                timeTableCount = 0 // 시작지점이 제일 빠르므로 0부터 시작
            }
            // 시작지점이 다름
            else{
                // minute
                if Int(firstYesterdayTime[1])! < Int(startTime[1])! {
                    copyStartHour -= 1
                    minuteDifference = (Int(firstYesterdayTime[1])! + 60) - Int(startTime[1])!
                }
                else{
                    minuteDifference = Int(firstYesterdayTime[1])! - Int(startTime[1])!
                }
                // hour
                if copyStartHour > Int(startTime[0])! {
                    hourDifference = copyStartHour - Int(startTime[0])!
                }
                else{
                    hourDifference = 0
                }
                // 그래프 그리는 시작 지점
                timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
            }
            
            // yesterday 값 저장
            for _ in 0 ..< totalXValue {
                var bpmTime = bpmThreeTimeData2[bpmTimeCount].components(separatedBy: ":")
                let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                var checkFlag = false
                
                // 값이 있는 경우
                if bpmTime[0] == checkTimeTable[0] { // hour
                    if bpmTime[1] == checkTimeTable[1] { // minute
                        if String(bpmTime[2].first!) == checkTimeTable[2]{ // second
                            
                            let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData2[bpmTimeCount])
                            bpmThreeDataEntries2.append(bpmThreeDataEntry)
                            
                            bpmTimeCount += 1 // 값이 있으니까 +1
                            checkFlag = true
                        }
                    }
                    else{
                        // 분 값이 없는 경우 이전 값을 씀
                        let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData2[bpmTimeCount-1])
                        bpmThreeDataEntries2.append(bpmThreeDataEntry)
                    }
                }
                else{
                    // 시간 값이 없는 경우 이전 값을 씀
                    let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData2[bpmTimeCount-1])
                    bpmThreeDataEntries2.append(bpmThreeDataEntry)
                }
                
                // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                if checkFlag == true && bpmTimeCount < bpmThreeTimeData2.count{
                    bpmTime = bpmThreeTimeData2[bpmTimeCount].components(separatedBy: ":")
                    
                    while String(bpmTime[2].first!) == checkTimeTable[2] {
                        let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData2[bpmTimeCount])
                        bpmThreeDataEntries2.append(bpmThreeDataEntry)
                        bpmTimeCount += 1
                        bpmTime = bpmThreeTimeData2[bpmTimeCount].components(separatedBy: ":")
                    }
                }
                
                timeTableCount += 1
                
                // 마지막 값
                if bpmTime[0] == lastYesterdayTime[0] && bpmTime[1] == lastYesterdayTime[1] && bpmTime[2] == lastYesterdayTime[2] || totalXValue == timeTableCount || bpmThreeTimeData2.count == bpmTimeCount {
                    break
                }
            }
            
            bpmTimeCount = 0
            copyStartHour = Int(firstTwoDaysAgoTime[0])!
            
            // 시작지점 비교
            if startTime[0] == firstTwoDaysAgoTime[0] && startTime[1] == firstTwoDaysAgoTime[1]{
                timeTableCount = 0 // 시작지점이 제일 빠르므로 0부터 시작
            }
            // 시작지점이 다름
            else{
                // minute
                if Int(firstTwoDaysAgoTime[1])! < Int(startTime[1])! {
                    copyStartHour -= 1
                    minuteDifference = (Int(firstTwoDaysAgoTime[1])! + 60) - Int(startTime[1])!
                }
                else{
                    minuteDifference = Int(firstTwoDaysAgoTime[1])! - Int(startTime[1])!
                }
                // hour
                if copyStartHour > Int(startTime[0])! {
                    hourDifference = copyStartHour - Int(startTime[0])!
                }
                else{
                    hourDifference = 0
                }
                // 그래프 그리는 시작 지점
                timeTableCount = (hourDifference * 360) + (minuteDifference * 6)
            }
            
            // twodays Ago 값 저장
            for _ in 0 ..< totalXValue {
                var bpmTime = bpmThreeTimeData3[bpmTimeCount].components(separatedBy: ":")
                let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                var checkFlag = false
                
                // 값이 있는 경우
                if bpmTime[0] == checkTimeTable[0] { // hour
                    if bpmTime[1] == checkTimeTable[1] { // minute
                        if String(bpmTime[2].first!) == checkTimeTable[2]{ // second
                            
                            let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData3[bpmTimeCount])
                            bpmThreeDataEntries3.append(bpmThreeDataEntry)
                            
                            bpmTimeCount += 1 // 값이 있으니까 +1
                            checkFlag = true
                        }
                    }
                    else{
                        // 분 값이 없는 경우 이전 값을 씀
                        let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData3[bpmTimeCount-1])
                        bpmThreeDataEntries3.append(bpmThreeDataEntry)
                    }
                }
                else{
                    // 시간 값이 없는 경우 이전 값을 씀
                    let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData3[bpmTimeCount-1])
                    bpmThreeDataEntries3.append(bpmThreeDataEntry)
                }
                
                // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                if checkFlag == true && bpmTimeCount < bpmThreeTimeData3.count {
                    bpmTime = bpmThreeTimeData3[bpmTimeCount].components(separatedBy: ":")
                    
                    while String(bpmTime[2].first!) == checkTimeTable[2] {
                        let bpmThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: bpmThreeArrayData3[bpmTimeCount])
                        bpmThreeDataEntries3.append(bpmThreeDataEntry)
                        bpmTimeCount += 1
                        bpmTime = bpmThreeTimeData3[bpmTimeCount].components(separatedBy: ":")
                    }
                }
                
                timeTableCount += 1
                
                // 마지막 값
                if bpmTime[0] == lastTwoDaysAgoTime[0] && bpmTime[1] == lastTwoDaysAgoTime[1] && bpmTime[2] == lastTwoDaysAgoTime[2] || totalXValue == timeTableCount || bpmTimeCount == bpmThreeTimeData3.count {
                    break
                }
            }
            
            StringStartHour = startTime[0] // 시작 시간
            StringStartMinute = startTime[1] // 시작 분
            
            timeTable = []
            
            // remove second
            for _ in 0 ..< totalXValue + 1 {
                
                let time = "\(StringStartHour):\(StringStartMinute)"
                
                timeTable.append(time)
                secondCount += 1
                
                // 초 -> 분
                if secondCount == 6 {
                    if Int(StringStartMinute)! < 9 {
                        StringStartMinute = "0"+String(Int(StringStartMinute)! + 1)
                    }
                    else{
                        StringStartMinute = String(Int(StringStartMinute)! + 1)
                    }
                    secondCount = 0
                }
                // 분 -> 시
                if StringStartMinute == "60" {
                    if Int(StringStartHour)! < 9 {
                        StringStartHour = "0"+String(Int(StringStartHour)! + 1)
                    }
                    else{
                        StringStartHour = String(Int(StringStartHour)! + 1)
                    }
                    StringStartMinute = "00"
                }
            }
            
            let bpmThreeChartDataSet1 = LineChartDataSet(entries: bpmThreeDataEntries1, label: "\(bpmChangeThreeDaysMonth1)-\(bpmChangeThreeDaysDate1)")
            bpmThreeChartDataSet1.drawCirclesEnabled = false
            bpmThreeChartDataSet1.setColor(NSUIColor.lineGreen!)
            bpmThreeChartDataSet1.mode = .linear
            bpmThreeChartDataSet1.lineWidth = 0.5
            bpmThreeChartDataSet1.drawValuesEnabled = true
            
            
            let bpmThreeChartDataSet2 = LineChartDataSet(entries: bpmThreeDataEntries2, label: "\(bpmChangeThreeDaysMonth2)-\(bpmChangeThreeDaysDate2)")
            bpmThreeChartDataSet2.drawCirclesEnabled = false
            bpmThreeChartDataSet2.setColor(NSUIColor.blue)
            bpmThreeChartDataSet2.mode = .linear
            bpmThreeChartDataSet2.lineWidth = 0.5
            bpmThreeChartDataSet2.drawValuesEnabled = true
            
            
            let bpmThreeChartDataSet3 = LineChartDataSet(entries: bpmThreeDataEntries3, label: "\(bpmChangeThreeDaysMonth3)-\(bpmChangeThreeDaysDate3)")
            bpmThreeChartDataSet3.drawCirclesEnabled = false
            bpmThreeChartDataSet3.setColor(NSUIColor.red)
            bpmThreeChartDataSet3.mode = .linear
            bpmThreeChartDataSet3.lineWidth = 0.5
            bpmThreeChartDataSet3.drawValuesEnabled = true
            
         
            let  bpmThreeChartdataSets: [LineChartDataSet] = [bpmThreeChartDataSet3, bpmThreeChartDataSet2, bpmThreeChartDataSet1]
            
            let bpmThreeChartchartData = LineChartData(dataSets: bpmThreeChartdataSets)
            
            ThreeDaysBpmChartView.data = bpmThreeChartchartData
            ThreeDaysBpmChartView.noDataText = ""
            ThreeDaysBpmChartView.xAxis.enabled = true
            ThreeDaysBpmChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            ThreeDaysBpmChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeTable)
            ThreeDaysBpmChartView.xAxis.axisMinimum = 0
            ThreeDaysBpmChartView.xAxis.axisMaximum = Double(totalXValue) // x축 범위
            ThreeDaysBpmChartView.setVisibleXRangeMaximum(1000)
            ThreeDaysBpmChartView.xAxis.granularity = 1
            ThreeDaysBpmChartView.xAxis.labelPosition = .bottom
            ThreeDaysBpmChartView.xAxis.drawGridLinesEnabled = false
            
            ThreeDaysBpmChartView.leftAxis.axisMaximum = 200
            ThreeDaysBpmChartView.leftAxis.axisMinimum = 40
            ThreeDaysBpmChartView.rightAxis.enabled = false
            ThreeDaysBpmChartView.drawMarkers = false
            ThreeDaysBpmChartView.dragEnabled = true // 좌우 드래그
            ThreeDaysBpmChartView.pinchZoomEnabled = false
            ThreeDaysBpmChartView.doubleTapToZoomEnabled = true // 더블 줌
            ThreeDaysBpmChartView.highlightPerTapEnabled = false
            
            ThreeDaysBpmChartView.data?.notifyDataChanged()
            ThreeDaysBpmChartView.notifyDataSetChanged()
            ThreeDaysBpmChartView.moveViewToX(0)
            
            bpmThreeArrayData1 = []
            bpmThreeTimeData1 = []
            
            bpmThreeArrayData2 = []
            bpmThreeTimeData2 = []
            
            bpmThreeArrayData3 = []
            bpmThreeTimeData3 = []
            
            twoDaysBpmChartView.isUserInteractionEnabled = false
            bpmChartView.isUserInteractionEnabled = false
            ThreeDaysBpmChartView.isUserInteractionEnabled = true
            
            // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
            for _ in 0..<20 {
                ThreeDaysBpmChartView.zoomOut()
            }
        }
    }
    
    
    
    //    @objc func breathChartViewGraph(_ sender: UIButton!)
    //
    //    {
    //        let fileManager1 = FileManager.default
    //        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //        let directoryURL1 = documentsURL1.appendingPathComponent("\(Syear)/\(Smonth)/\(Sday)")
    
    //        let fileURL1 = directoryURL1.appendingPathComponent("/BreathData.csv")
    
    //
    //        do {
    //            let data1 = try String(contentsOf: fileURL1)
    //
    //
    //            let breathData1 = data1.components(separatedBy: .newlines)
    //
    //            numbersOfBreath = breathData1.count
    //
    //            for i in 0..<numbersOfBreath - 1{
    //                let row1 = breathData1[i]
    //                let columns1 = row1.components(separatedBy: ",")
    //                let breathTimeRow = columns1[0]
    //                let breathDataRow = Double(columns1[1])
    //
    //
    //                breathTimeData.append(breathTimeRow)
    //                breathData.append(breathDataRow ?? 0.0)
    //
    //                //   print(bpmTimeData)
    //                //  print(bpmData)
    //            }
    //        } catch  {
    //            print("Error reading CSV file")
    //
    //        }
    //
    //        var breathDataEntries = [ChartDataEntry]()
    //
    //        for i in 0..<numbersOfBreath - 1 {
    //            let breathDataEntry = ChartDataEntry(x: Double(i), y: breathData[i])
    //            breathDataEntries.append(breathDataEntry)
    //        }
    //
    //
    //        let breathChartDataSet = LineChartDataSet(entries: breathDataEntries, label: "호흡수")
    //        breathChartDataSet.drawCirclesEnabled = false
    //        breathChartDataSet.setColor(NSUIColor.red)
    //        breathChartDataSet.mode = .linear
    //        breathChartDataSet.drawValuesEnabled = false
    //
    //
    //        // 2
    //        let breathChartData = LineChartData(dataSet: breathChartDataSet)
    //        breathChartView.data = breathChartData
    //        breathChartView.xAxis.enabled = true
    //        breathChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: breathTimeData)
    //        breathChartView.xAxis.granularity = 1
    //        breathChartView.xAxis.labelPosition = .bottom
    //
    //
    //        //  bpmChartView.leftAxis.axisMaximum = 250
    //        // bpmChartView.leftAxis.axisMinimum = 0
    //        breathChartView.rightAxis.enabled = false
    //        breathChartView.drawMarkers = false
    //        breathChartView.dragEnabled = false
    //        breathChartView.pinchZoomEnabled = false
    //        breathChartView.doubleTapToZoomEnabled = false
    //        breathChartView.highlightPerTapEnabled = false
    //
    //        breathChartView.notifyDataSetChanged()
    //        breathChartView.moveViewToX(0)
    //        breathTimeData = []
    //        breathData = []
    //    }
    
    // MARK: - today Button
    @objc func selectOneDayClick(sender: AnyObject) {
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -bpmDateCount, to: bpmTodayDate)!
        
        bpmTodayDate = yesterday
        
        let tyear = DateFormatter()
        let tmonth = DateFormatter()
        let tdate = DateFormatter()
        
        
        tyear.dateFormat = "yyyy"
        tmonth.dateFormat = "MM"
        tdate.dateFormat = "dd"
        
        bpmChangeRealYear = tyear.string(from: bpmTodayDate)
        bpmChangeRealMonth = tmonth.string(from: bpmTodayDate)
        bpmChangeRealDate = tdate.string(from: bpmTodayDate)
        
        
        
        defaults.set(bpmChangeRealYear, forKey: "bpmChangeRealYear")
        defaults.set(bpmChangeRealMonth , forKey: "bpmChangeRealMonth")
        defaults.set(bpmChangeRealDate, forKey: "bpmChangeRealDate")
        
        
        todayDispalay.text = String("\(bpmChangeRealYear)-\(bpmChangeRealMonth)-\(bpmChangeRealDate)")
        
        
        oneDayButton.isSelected = true
        twoDaysButton.isSelected  = false
        ThreeDaysButton.isSelected = false
        
        oneDayButton.isUserInteractionEnabled = false
        twoDaysButton.isUserInteractionEnabled  = true
        ThreeDaysButton.isUserInteractionEnabled = true
        
        todayDispalay.isHidden = false
        twoDaysDispalay.isHidden = true
        ThreeDaysDispalay.isHidden = true
        
        yesterdayBpmButton.isHidden = false
        tomorrowBpmButton.isHidden = false
        lastTwoDaysBpmButton.isHidden = true
        nextTwoDaysBpmButton.isHidden = true
        lastThreeDaysBpmButton.isHidden = true
        nextThreeDaysBpmButton.isHidden = true
        
        
        yesterdayBpmButton.isEnabled = true
        tomorrowBpmButton.isEnabled = true
        lastTwoDaysBpmButton.isEnabled = false
        nextTwoDaysBpmButton.isEnabled = false
        lastThreeDaysBpmButton.isEnabled = false
        nextThreeDaysBpmButton.isEnabled = false
        
        bpmDateCount = 0
        
        bpmChartViewGraph()
    }
    
    func yesterdayButton(){
        
        bpmDateCount = bpmDateCount - 1
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: bpmTodayDate)!
        
        bpmTodayDate = yesterday
        
        let tyear = DateFormatter()
        let tmonth = DateFormatter()
        let tdate = DateFormatter()
        
        
        tyear.dateFormat = "yyyy"
        tmonth.dateFormat = "MM"
        tdate.dateFormat = "dd"
        
        bpmChangeRealYear = tyear.string(from: bpmTodayDate)
        bpmChangeRealMonth = tmonth.string(from: bpmTodayDate)
        bpmChangeRealDate = tdate.string(from: bpmTodayDate)
        
        todayDispalay.text = String("\(bpmChangeRealYear)-\(bpmChangeRealMonth)-\(bpmChangeRealDate)")
        
        defaults.set(bpmChangeRealYear, forKey:"bpmChangeRealYear")
        defaults.set(bpmChangeRealMonth, forKey:"bpmChangeRealMonth")
        defaults.set(bpmChangeRealDate, forKey:"bpmChangeRealDate")
        
    }
    
    
    func tomorrowButton(){
        
        bpmDateCount = bpmDateCount + 1
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: bpmTodayDate)!
        bpmTodayDate = tomorrow
        
        
        let tyear = DateFormatter()
        let tmonth = DateFormatter()
        let tdate = DateFormatter()
        
        
        tyear.dateFormat = "yyyy"
        tmonth.dateFormat = "MM"
        tdate.dateFormat = "dd"
        
        
        
        bpmChangeRealYear = tyear.string(from: bpmTodayDate)
        bpmChangeRealMonth = tmonth.string(from: bpmTodayDate)
        bpmChangeRealDate = tdate.string(from: bpmTodayDate)
        
        
        todayDispalay.text = String("\(bpmChangeRealYear)-\(bpmChangeRealMonth)-\(bpmChangeRealDate)")
        
        
        defaults.set(bpmChangeRealYear, forKey:"bpmChangeRealYear")
        defaults.set(bpmChangeRealMonth, forKey:"bpmChangeRealMonth")
        defaults.set(bpmChangeRealDate, forKey:"bpmChangeRealDate")
        
    }
    
    
    
    //     ------------------------어제 내일 버튼들 시작 ----------------------
    
    @objc func yesterdaySelectBpmButton(sender: AnyObject){
        yesterdayButton()
        bpmChartViewGraph()
//        bpmChartView.zoomOut()
    }
    
    
    @objc func tomorrowSelectBpmButton(sender: AnyObject){
        tomorrowButton()
        bpmChartViewGraph()
//        bpmChartView.zoomOut()
    }
    
    //     ------------------------어제 내일 버튼들  끝 ----------------------
    
    
    
    //     ------------------------2 Days 버튼들 시작 ----------------------
    // MARK: - 2 Days Button
    
    @objc func selectTwoDaysClick(sender: AnyObject) {
        
        let TwoDays0 = Calendar.current.date(byAdding: .day, value: -bpmTwodateCount, to: twoDaysBpmTodayDate)!
        twoDaysBpmTodayDate = TwoDays0
        
        let ryear = DateFormatter()
        let rmonth = DateFormatter()
        let rdate = DateFormatter()
        
        
        ryear.dateFormat = "yyyy"
        rmonth.dateFormat = "MM"
        rdate.dateFormat = "dd"
                
        
        bpmBaseTwoDaysYear = ryear.string(from: twoDaysBpmTodayDate)
        bpmBaseTwoDaysMonth = rmonth.string(from: twoDaysBpmTodayDate)
        bpmBaseTwoDaysDate = rdate.string(from: twoDaysBpmTodayDate)
        
        defaults.set(bpmBaseTwoDaysYear, forKey: "bpmBaseTwoDaysYear")
        defaults.set(bpmBaseTwoDaysMonth, forKey: "bpmBaseTwoDaysMonth")
        defaults.set(bpmBaseTwoDaysDate, forKey: "bpmBaseTwoDaysDate")
        
        let twoDaysYesterday = Calendar.current.date(byAdding: .day, value: -1, to: twoDaysBpmTodayDate)!
        
        twoDaysBpmTodayDate = twoDaysYesterday
        
        let yyear = DateFormatter()
        let ymonth = DateFormatter()
        let ydate = DateFormatter()
        
        
        yyear.dateFormat = "yyyy"
        ymonth.dateFormat = "MM"
        ydate.dateFormat = "dd"
        
        bpmChangeTwoDaysYear = yyear.string(from: twoDaysBpmTodayDate)
        bpmChangeTwoDaysMonth = ymonth.string(from: twoDaysBpmTodayDate)
        bpmChangeTwoDaysDate = ydate.string(from: twoDaysBpmTodayDate)
        
        defaults.set(bpmChangeTwoDaysYear, forKey: "bpmChangeTwoDaysYear")
        defaults.set(bpmChangeTwoDaysMonth, forKey: "bpmChangeTwoDaysMonth")
        defaults.set(bpmChangeTwoDaysDate, forKey: "bpmChangeTwoDaysDate")
        
        
        twoDaysDispalay.text = String("\(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate) ~ \(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate)")
        
        let twoDaysTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: twoDaysBpmTodayDate)!
        
        twoDaysBpmTodayDate = twoDaysTomorrow
                        
        oneDayButton.isSelected = false
        twoDaysButton.isSelected  = true
        ThreeDaysButton.isSelected = false
        
        oneDayButton.isUserInteractionEnabled = true
        twoDaysButton.isUserInteractionEnabled  = false
        ThreeDaysButton.isUserInteractionEnabled = true
        
        todayDispalay.isHidden = true
        twoDaysDispalay.isHidden = false
        ThreeDaysDispalay.isHidden = true
        
        yesterdayBpmButton.isHidden = true
        tomorrowBpmButton.isHidden = true
        lastTwoDaysBpmButton.isHidden = false
        nextTwoDaysBpmButton.isHidden = false
        lastThreeDaysBpmButton.isHidden = true
        nextThreeDaysBpmButton.isHidden = true
        
        
        yesterdayBpmButton.isEnabled = false
        tomorrowBpmButton.isEnabled = false
        lastTwoDaysBpmButton.isEnabled = true
        nextTwoDaysBpmButton.isEnabled = true
        lastThreeDaysBpmButton.isEnabled = false
        nextThreeDaysBpmButton.isEnabled = false
        
        baseArrowFlag = 1
        previousArrowFlag = 0
        nextArrowFlag = 0
        
        bpmTwodateCount = 0
        twoDaysBpmChartViewGraph()
    }
    
    
    func lastTwoDaysButton(){
        
        //        print("Days1: \(changeTwoDaysMonth),\(changeTwoDaysDate), \(baseTwoDaysMonth ),\(baseTwoDaysDate )")
        
        if ((baseArrowFlag == 1) && (previousArrowFlag == 1) && (nextArrowFlag == 0)){
            
            bpmBaseTwoDaysYear = defaults.string(forKey:"bpmChangeTwoDaysYear") ?? "\(realYear)"
            bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmChangeTwoDaysMonth") ?? "\(realMonth)"
            bpmBaseTwoDaysDate = defaults.string(forKey:"bpmChangeTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays1 = Calendar.current.date(byAdding: .day, value: -1, to: twoDaysBpmTodayDate)!
            
            twoDaysBpmTodayDate = TwoDays1
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            bpmChangeTwoDaysYear = tyear.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysMonth = tmonth.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysDate = tdate.string(from: twoDaysBpmTodayDate)
            
            
            
            defaults.set(bpmChangeTwoDaysYear, forKey:"bpmChangeTwoDaysYear")
            defaults.set(bpmChangeTwoDaysMonth, forKey:"bpmChangeTwoDaysMonth")
            defaults.set(bpmChangeTwoDaysDate, forKey:"bpmChangeTwoDaysDate")
            
            defaults.set(bpmBaseTwoDaysYear, forKey:"bpmBaseTwoDaysYear")
            defaults.set(bpmBaseTwoDaysMonth, forKey:"bpmBaseTwoDaysMonth")
            defaults.set(bpmBaseTwoDaysDate, forKey:"bpmBaseTwoDaysDate")
            
            
            twoDaysDispalay.text = String("\(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate) ~ \(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate)")
            
            
            
            bpmTwodateCount = bpmTwodateCount - 1
            
            baseArrowFlag = 0
            previousArrowFlag = 1
            nextArrowFlag = 0
            
            twoDaysBpmChartViewGraph()
        }
        
        
        if ((baseArrowFlag == 0) && (previousArrowFlag == 1) && (nextArrowFlag == 0)){
            
            bpmBaseTwoDaysYear = defaults.string(forKey:"bpmChangeTwoDaysYear") ?? "\(realYear)"
            bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmChangeTwoDaysMonth") ?? "\(realMonth)"
            bpmBaseTwoDaysDate = defaults.string(forKey:"bpmChangeTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays2 = Calendar.current.date(byAdding: .day, value: -1, to: twoDaysBpmTodayDate)!
            
            twoDaysBpmTodayDate = TwoDays2
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            bpmChangeTwoDaysYear = tyear.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysMonth = tmonth.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysDate = tdate.string(from: twoDaysBpmTodayDate)
            
            defaults.set(bpmChangeTwoDaysYear, forKey:"bpmChangeTwoDaysYear")
            defaults.set(bpmChangeTwoDaysMonth, forKey:"bpmChangeTwoDaysMonth")
            defaults.set(bpmChangeTwoDaysDate, forKey:"bpmChangeTwoDaysDate")
            
            defaults.set(bpmBaseTwoDaysYear, forKey:"bpmBaseTwoDaysYear")
            defaults.set(bpmBaseTwoDaysMonth, forKey:"bpmBaseTwoDaysMonth")
            defaults.set(bpmBaseTwoDaysDate, forKey:"bpmBaseTwoDaysDate")
            
            twoDaysDispalay.text = String("\(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate) ~ \(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate)")
            
            
            bpmTwodateCount = bpmTwodateCount - 1
            nextArrowFlag = 0
            baseArrowFlag = 0
            previousArrowFlag = 1
            
            twoDaysBpmChartViewGraph()
            
        }
        
        if ((baseArrowFlag == 0) && (previousArrowFlag == 1) && (nextArrowFlag == 1)){
            
            bpmBaseTwoDaysYear = defaults.string(forKey:"bpmBaseTwoDaysYear") ?? "\(realYear)"
            bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmBaseTwoDaysMonth") ?? "\(realMonth)"
            bpmBaseTwoDaysDate = defaults.string(forKey:"bpmBaseTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays3 = Calendar.current.date(byAdding: .day, value: -2, to: twoDaysBpmTodayDate)!
            
            twoDaysBpmTodayDate = TwoDays3
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            bpmChangeTwoDaysYear = tyear.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysMonth = tmonth.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysDate = tdate.string(from: twoDaysBpmTodayDate)
            
            defaults.set(bpmChangeTwoDaysYear, forKey:"bpmChangeTwoDaysYear")
            defaults.set(bpmChangeTwoDaysMonth, forKey:"bpmChangeTwoDaysMonth")
            defaults.set(bpmChangeTwoDaysDate, forKey:"bpmChangeTwoDaysDate")
            
            defaults.set(bpmBaseTwoDaysYear, forKey:"bpmBaseTwoDaysYear")
            defaults.set(bpmBaseTwoDaysMonth, forKey:"bpmBaseTwoDaysMonth")
            defaults.set(bpmBaseTwoDaysDate, forKey:"bpmBaseTwoDaysDate")
            
            twoDaysDispalay.text = String("\(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate) ~ \(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate)")
            
            
            bpmTwodateCount = bpmTwodateCount - 2
            
            nextArrowFlag = 0
            baseArrowFlag = 0
            previousArrowFlag = 1
            
            twoDaysBpmChartViewGraph()
        }
        
        
    }
    
    
    func nextTwoDaysButton(){
        
        if ((baseArrowFlag == 1) && (previousArrowFlag == 0) && (nextArrowFlag == 1)){
            
            bpmBaseTwoDaysYear = defaults.string(forKey:"bpmBaseTwoDaysYear") ?? "\(realYear)"
            bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmBaseTwoDaysMonth") ?? "\(realMonth)"
            bpmBaseTwoDaysDate = defaults.string(forKey:"bpmBaseTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays4 = Calendar.current.date(byAdding: .day, value: 1, to: twoDaysBpmTodayDate)!
            
            twoDaysBpmTodayDate = TwoDays4
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            bpmChangeTwoDaysYear = tyear.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysMonth = tmonth.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysDate = tdate.string(from: twoDaysBpmTodayDate)
            
            defaults.set(bpmChangeTwoDaysYear, forKey:"bpmChangeTwoDaysYear")
            defaults.set(bpmChangeTwoDaysMonth, forKey:"bpmChangeTwoDaysMonth")
            defaults.set(bpmChangeTwoDaysDate, forKey:"bpmChangeTwoDaysDate")
            
            defaults.set(bpmBaseTwoDaysYear, forKey:"bpmBaseTwoDaysYear")
            defaults.set(bpmBaseTwoDaysMonth, forKey:"bpmBaseTwoDaysMonth")
            defaults.set(bpmBaseTwoDaysDate, forKey:"bpmBaseTwoDaysDate")
            
            
            twoDaysDispalay.text = String("\(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate) ~ \(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate)")
            
            bpmTwodateCount = bpmTwodateCount + 1
            nextArrowFlag = 1
            baseArrowFlag = 0
            previousArrowFlag = 0
            
            twoDaysBpmChartViewGraph()
        }
        
        
        if ((baseArrowFlag == 0) && (previousArrowFlag == 0) && (nextArrowFlag == 1)){
            
            bpmBaseTwoDaysYear = defaults.string(forKey:"bpmChangeTwoDaysYear") ?? "\(realYear)"
            bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmChangeTwoDaysMonth") ?? "\(realMonth)"
            bpmBaseTwoDaysDate = defaults.string(forKey:"bpmChangeTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays5 = Calendar.current.date(byAdding: .day, value: 1, to: twoDaysBpmTodayDate)!
            
            twoDaysBpmTodayDate = TwoDays5
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            bpmChangeTwoDaysYear = tyear.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysMonth = tmonth.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysDate = tdate.string(from: twoDaysBpmTodayDate)
            
            defaults.set(bpmChangeTwoDaysYear, forKey:"bpmChangeTwoDaysYear")
            defaults.set(bpmChangeTwoDaysMonth, forKey:"bpmChangeTwoDaysMonth")
            defaults.set(bpmChangeTwoDaysDate, forKey:"bpmChangeTwoDaysDate")
            
            defaults.set(bpmBaseTwoDaysYear, forKey:"bpmBaseTwoDaysYear")
            defaults.set(bpmBaseTwoDaysMonth, forKey:"bpmBaseTwoDaysMonth")
            defaults.set(bpmBaseTwoDaysDate, forKey:"bpmBaseTwoDaysDate")
            
            
            twoDaysDispalay.text = String("\(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate) ~ \(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate)")
            
            
            bpmTwodateCount = bpmTwodateCount + 1
            nextArrowFlag = 1
            baseArrowFlag = 0
            previousArrowFlag = 0
            twoDaysBpmChartViewGraph()
        }
        
        
        if ((baseArrowFlag == 0) && (previousArrowFlag == 1) && (nextArrowFlag == 1)){
            
            bpmBaseTwoDaysYear = defaults.string(forKey:"bpmBaseTwoDaysYear") ?? "\(realYear)"
            bpmBaseTwoDaysMonth = defaults.string(forKey:"bpmBaseTwoDaysMonth") ?? "\(realMonth)"
            bpmBaseTwoDaysDate = defaults.string(forKey:"bpmBaseTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays6 = Calendar.current.date(byAdding: .day, value: 2, to: twoDaysBpmTodayDate)!
            
            twoDaysBpmTodayDate = TwoDays6
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            bpmChangeTwoDaysYear = tyear.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysMonth = tmonth.string(from: twoDaysBpmTodayDate)
            bpmChangeTwoDaysDate = tdate.string(from: twoDaysBpmTodayDate)
            
            defaults.set(bpmChangeTwoDaysYear, forKey:"bpmChangeTwoDaysYear")
            defaults.set(bpmChangeTwoDaysMonth, forKey:"bpmChangeTwoDaysMonth")
            defaults.set(bpmChangeTwoDaysDate, forKey:"bpmChangeTwoDaysDate")
            
            defaults.set(bpmBaseTwoDaysYear, forKey:"bpmBaseTwoDaysYear")
            defaults.set(bpmBaseTwoDaysMonth, forKey:"bpmBaseTwoDaysMonth")
            defaults.set(bpmBaseTwoDaysDate, forKey:"bpmBaseTwoDaysDate")
            
            
            twoDaysDispalay.text = String("\(bpmBaseTwoDaysMonth).\(bpmBaseTwoDaysDate) ~ \(bpmChangeTwoDaysMonth).\(bpmChangeTwoDaysDate)")
            
            
            bpmTwodateCount = bpmTwodateCount + 2
            nextArrowFlag = 1
            baseArrowFlag = 0
            previousArrowFlag = 0
            twoDaysBpmChartViewGraph()
        }
    }
    
    
    @objc func lastTwoDaysSelectBpmButton(sender: AnyObject){
        
        previousArrowFlag = 1
        lastTwoDaysButton()
    }
    
    
    @objc func nextTwoDaysSelectBpmButton(sender: AnyObject){
        
        nextArrowFlag = 1
        nextTwoDaysButton()
    }
    
    //     ------------------------2 Days  버튼들 끝  ----------------------
    
    
    // MARK: - 3 Days Button
    @objc func selectThreeDaysClick(sender: AnyObject) {
        
        oneDayButton.isSelected = false
        twoDaysButton.isSelected  = false
        ThreeDaysButton.isSelected = true
        
        oneDayButton.isUserInteractionEnabled = true
        twoDaysButton.isUserInteractionEnabled  = true
        ThreeDaysButton.isUserInteractionEnabled = false
        
        todayDispalay.isHidden = true
        twoDaysDispalay.isHidden = true
        ThreeDaysDispalay.isHidden = false
        
        
        yesterdayBpmButton.isHidden = true
        tomorrowBpmButton.isHidden = true
        lastTwoDaysBpmButton.isHidden = true
        nextTwoDaysBpmButton.isHidden = true
        lastThreeDaysBpmButton.isHidden = false
        nextThreeDaysBpmButton.isHidden = false
        
        yesterdayBpmButton.isEnabled = false
        tomorrowBpmButton.isEnabled = false
        lastTwoDaysBpmButton.isEnabled = false
        nextTwoDaysBpmButton.isEnabled = false
        lastThreeDaysBpmButton.isEnabled = true
        nextThreeDaysBpmButton.isEnabled = true
        
        // 초기화
        bpmThreeDateCount = 0
        saveThreeDaysDate = Date()
        let currentDate = Date()
                
        // 현재 날짜 값
        let toDays = Calendar.current.date(byAdding: .day, value: 0, to: currentDate)!
        
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        bpmBaseThreeDaysYear = syear.string(from: toDays)
        bpmBaseThreeDaysMonth = smonth.string(from: toDays)
        bpmBaseThreeDaysDate = sdate.string(from: toDays)
        
        defaults.set(bpmBaseThreeDaysYear, forKey:"bpmChangeThreeDaysYear1")
        defaults.set(bpmBaseThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth1")
        defaults.set(bpmBaseThreeDaysDate, forKey:"bpmChangeThreeDaysDate1")
        
        
        let oneDays = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        
        bpmChangeThreeDaysYear = syear.string(from: oneDays)
        bpmChangeThreeDaysMonth = smonth.string(from: oneDays)
        bpmChangeThreeDaysDate = sdate.string(from: oneDays)
        
        defaults.set(bpmChangeThreeDaysYear, forKey:"bpmChangeThreeDaysYear2")
        defaults.set(bpmChangeThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth2")
        defaults.set(bpmChangeThreeDaysDate, forKey:"bpmChangeThreeDaysDate2")
        
        let twoDays = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
        
        bpmChangeThreeDaysYear = syear.string(from: twoDays)
        bpmChangeThreeDaysMonth = smonth.string(from: twoDays)
        bpmChangeThreeDaysDate = sdate.string(from: twoDays)
        
        defaults.set(bpmChangeThreeDaysYear, forKey:"bpmChangeThreeDaysYear3")
        defaults.set(bpmChangeThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth3")
        defaults.set(bpmChangeThreeDaysDate, forKey:"bpmChangeThreeDaysDate3")
        
        ThreeDaysDispalay.text = String("\(bpmChangeThreeDaysMonth).\(bpmChangeThreeDaysDate) ~ \(bpmBaseThreeDaysMonth).\(bpmBaseThreeDaysDate)")
        
        threeDaysBpmChartViewGraph()
    }
    
    
    
    func lastThreeDaysButton(){

        var toDay:Date
        
        let dateFormatter = DateFormatter()
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        bpmThreeDateCount = -1
        lastButtonFlag = true
        
        toDay = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount, to: saveThreeDaysDate)!
        
        // 다음 버튼이 눌린 상태
        if nextButtonFlag == true {
            
            bpmThreeDateCount = 1
            nextButtonFlag = false
            
            toDay = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount, to: saveThreeDaysDate)!
            
        }
                
        bpmBaseThreeDaysYear = syear.string(from: toDay)
        bpmBaseThreeDaysMonth = smonth.string(from: toDay)
        bpmBaseThreeDaysDate = sdate.string(from: toDay)
        
        defaults.set(bpmBaseThreeDaysYear, forKey:"bpmChangeThreeDaysYear1")
        defaults.set(bpmBaseThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth1")
        defaults.set(bpmBaseThreeDaysDate, forKey:"bpmChangeThreeDaysDate1")
        
        
        let oneDays = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount-1, to: saveThreeDaysDate)!
        
        bpmChangeThreeDaysYear = syear.string(from: oneDays)
        bpmChangeThreeDaysMonth = smonth.string(from: oneDays)
        bpmChangeThreeDaysDate = sdate.string(from: oneDays)
        
        defaults.set(bpmChangeThreeDaysYear, forKey:"bpmChangeThreeDaysYear2")
        defaults.set(bpmChangeThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth2")
        defaults.set(bpmChangeThreeDaysDate, forKey:"bpmChangeThreeDaysDate2")
        
        
        let twoDays = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount-2, to: saveThreeDaysDate)!
        
        bpmChangeThreeDaysYear = syear.string(from: twoDays)
        bpmChangeThreeDaysMonth = smonth.string(from: twoDays)
        bpmChangeThreeDaysDate = sdate.string(from: twoDays)
        
        defaults.set(bpmChangeThreeDaysYear, forKey:"bpmChangeThreeDaysYear3")
        defaults.set(bpmChangeThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth3")
        defaults.set(bpmChangeThreeDaysDate, forKey:"bpmChangeThreeDaysDate3")
        
        // 라벨 텍스트
        ThreeDaysDispalay.text = String("\(bpmChangeThreeDaysMonth).\(bpmChangeThreeDaysDate) ~ \(bpmBaseThreeDaysMonth).\(bpmBaseThreeDaysDate)")
        
        // 기준 값 저장
        saveThreeDaysDate = dateFormatter.date(from: "\(bpmBaseThreeDaysYear)- \(bpmBaseThreeDaysMonth)-\(bpmBaseThreeDaysDate)")!
        
        threeDaysBpmChartViewGraph()
    }
    
    
    func nextThreeDaysButton(){
                
        var toDay:Date
        
        let dateFormatter = DateFormatter()
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        bpmThreeDateCount = 1
        nextButtonFlag = true
                
        toDay = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount, to: saveThreeDaysDate)!
        
        // 이전 버튼이 눌린 상태
        if lastButtonFlag == true {
            
            bpmThreeDateCount = -1
            lastButtonFlag = false
            
            toDay = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount, to: saveThreeDaysDate)!
            
        }
        
        bpmBaseThreeDaysYear = syear.string(from: toDay)
        bpmBaseThreeDaysMonth = smonth.string(from: toDay)
        bpmBaseThreeDaysDate = sdate.string(from: toDay)
        
        defaults.set(bpmBaseThreeDaysYear, forKey:"bpmChangeThreeDaysYear3")
        defaults.set(bpmBaseThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth3")
        defaults.set(bpmBaseThreeDaysDate, forKey:"bpmChangeThreeDaysDate3")
        
        
        let oneDays = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount+1, to: saveThreeDaysDate)!
        
        bpmChangeThreeDaysYear = syear.string(from: oneDays)
        bpmChangeThreeDaysMonth = smonth.string(from: oneDays)
        bpmChangeThreeDaysDate = sdate.string(from: oneDays)
        
        defaults.set(bpmChangeThreeDaysYear, forKey:"bpmChangeThreeDaysYear2")
        defaults.set(bpmChangeThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth2")
        defaults.set(bpmChangeThreeDaysDate, forKey:"bpmChangeThreeDaysDate2")
        
        
        let twoDays = Calendar.current.date(byAdding: .day, value: bpmThreeDateCount+2, to: saveThreeDaysDate)!
        
        bpmChangeThreeDaysYear = syear.string(from: twoDays)
        bpmChangeThreeDaysMonth = smonth.string(from: twoDays)
        bpmChangeThreeDaysDate = sdate.string(from: twoDays)
        
        defaults.set(bpmChangeThreeDaysYear, forKey:"bpmChangeThreeDaysYear1")
        defaults.set(bpmChangeThreeDaysMonth, forKey:"bpmChangeThreeDaysMonth1")
        defaults.set(bpmChangeThreeDaysDate, forKey:"bpmChangeThreeDaysDate1")
        
        // 라벨 텍스트
        ThreeDaysDispalay.text = String("\(bpmBaseThreeDaysMonth).\(bpmBaseThreeDaysDate) ~ \(bpmChangeThreeDaysMonth).\(bpmChangeThreeDaysDate)")
        
        // 기준 값 저장
        saveThreeDaysDate = dateFormatter.date(from: "\(bpmBaseThreeDaysYear)- \(bpmBaseThreeDaysMonth)-\(bpmBaseThreeDaysDate)")!
        
        threeDaysBpmChartViewGraph()
        
    }
    
    
    //     ------------------------7 Days 버튼들 시작 ----------------------
    @objc func lastThreeDaysSelectBpmButton(sender: AnyObject){
        lastThreeDaysButton()
       
    }
    
    
    @objc func nextThreeDaysSelectBpmButton(sender: AnyObject){
        nextThreeDaysButton()
//        ThreeDaysBpmChartViewGraph()
        
    }
    //     ------------------------7 Days 버튼들 끝  ----------------------
    
    
    // MARK: - bpm,arr,calorie,step,temperature
//    @objc func bpmBpmClick(sender: AnyObject) {
//        bpmButton.isSelected = true
//        //       bpmChartViewGraph()
//    }
//    @objc func bpmArrClick(sender: AnyObject) {
//        bpmButton.isSelected = true
//        let arrVC = arrGraphVC()
//        arrVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(arrVC, animated: true)
//        //        arrVC.hourlyArrChartViewGraph()
//    }
//
//    @objc func bpmCalorieClick(sender: AnyObject) {
//        bpmButton.isSelected = true
//        let calorieVC = calorieGraphVC()
//        calorieVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(calorieVC, animated: true)
//        //        calorieVC.calorieDayGraph()
//    }
//
//    @objc func bpmStepClick(sender: AnyObject) {
//        bpmButton.isSelected = true
//        let stepVC = stepAndDistanceGraphVC()
//        stepVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(stepVC, animated: true)
//        //        stepVC.hourlyStepChartViewGraph()
//    }
//
//    @objc func bpmTemperatureClick(sender: AnyObject) {
//        bpmButton.isSelected = true
//        let tempVC = temperatureGraphVC()
//        tempVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(tempVC, animated: true)
//        //        tempVC.temperatureDayGraph()
//    }    
    //    @objc func selectBreathClick(sender: AnyObject) {
    //        breathDate = yearTextField.text ?? "\(year)\(month)\(day)"
    //
    //    }
    
}


extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}

extension UIColor {
    /// Primary ColorSet
    ///
    /// Primary color - (100, 149, 237, 100%)
    class var buttonBackground: UIColor? { return UIColor(named: "buttonBackground") }
    /// Secondary color - (0, 0, 205, 100%)
    class var lableBackground: UIColor? { return UIColor(named: "lableBackground") }
    /// Tertiary color - (0, 0, 139, 100%)
    class var mint: UIColor? { return UIColor(named: "mint") }
    
    class var lineGreen: UIColor? { return UIColor(named: "lineGreen") }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
