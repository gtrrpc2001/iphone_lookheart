//
//  stepAndDistanceGraph.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2023/05/10.
//

import UIKit
import Foundation
import Charts
import SnapKit
import Then

let hourlyStepChartView = BarChartView()
let weeklyStepChartView = BarChartView()
let monthlyStepChartView = BarChartView()
let yearlyAStepChartView = BarChartView()

var tStep = 10000
var tDistance = 10


var hourlyStepData: [Double] = []
var hourlyDistanceData: [Double] = []
var hourlyStepTimeData: [String] = []

var weeklyStepData: [Double] = []
var weeklyDistanceData: [Double] = []
var weeklyStepTimeData: [String] = []


var monthlyStepData: [Double] = []
var monthlyDistanceData: [Double] = []
var monthlyStepTimeData: [String] = []

var yearlyStepData: [Double] = []
var yearlyDistanceData: [Double] = []
var yearlyStepTimeData: [String] = []

var numbersOfHourlyStepData = 0
var numbersOfWeeklyStepData = 0
var numbersOfMonthlyStepData = 0
var numbersOfYearlyStepData = 0

var newNumbersOfWeeklyStepData = 0
var newNumbersOfMonthlyStepData = 0

var numbersOfStepDaysForMonth = 0
var numbersOfStepMonthsForYear = 0
var numbersOfStepDaysForYear = 0

var sumOfHourlyStep = 0
var sumOfWeeklyStep = 0
var sumOfMonthlyStep = 0
var sumOfYearlyStep = 0

var sumOfHourlyDistance = 0
var sumOfWeeklyDistance = 0
var sumOfMonthlyDistance = 0
var sumOfYearlyDistance = 0

var sumOfMonthlyStepDays = 0
var sumOfYearlyStepDays = 0


var weeklyStepButtonFlag = 0
var monthlyStepButtonFlag = 0
var yearlyStepButtonFlag = 0

var baseStepDayOfMonth = 0
var baseStepMonthOfYear = 0

var stepChangeRealYear:String = ""
var stepChangeRealMonth:String = ""
var stepChangeRealDate:String = ""

var stepTodayDate = Date()
var intStepYear = 0
var baseStepYear = 0
var currentStepYear = 0

var stepDateCount = 0



class stepAndDistanceGraphVC : UIViewController, UITextFieldDelegate {
    
    var fCurTextfieldBottom: CGFloat = 0.0
    
    private let safeAreaView = UIView()
    
    var alertString = ""
    var alertFlag = false
    
    var nextWeekDataCheck:Bool = false
    var lastWeekDataCheck:Bool = false
    
    var nextMonthDataCheck:Bool = false
    var lastMonthDataCheck:Bool = false
    
    private func setupViewStep() {
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
    
    
//    lazy var bpmButton = UIButton().then {
//        $0.setImage(HeartBeat, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(stepBpmClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var arrButton = UIButton().then {
//        $0.setImage(irregularHB, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(stepArrClick(sender:)), for: .touchUpInside)
//    }
//
//
//    lazy var calorieButton = UIButton().then {
//        $0.setImage(calorie, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(stepCalorieClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var stepButton = UIButton().then {
//        $0.setImage(step, for: UIControl.State.normal)
//        $0.backgroundColor = .cyan
//        //        $0.addTarget(self, action: #selector(stepStepClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var temperatureButton = UIButton().then {
//        $0.setImage(temperature, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(stepTemperatureClick(sender:)), for: .touchUpInside)
//    }
    
    
    lazy var hourlyStepChartView: BarChartView =  {
        let hourlyStepChartView = BarChartView()
        hourlyStepChartView.noDataText = ""
        return hourlyStepChartView
        
    }()
    
    lazy var weeklyStepChartView: BarChartView =  {
        let weeklyStepChartView = BarChartView()
        weeklyStepChartView.noDataText = ""
        return weeklyStepChartView
    }()
    
    
    lazy var monthlyStepChartView: BarChartView =  {
        let monthlyStepChartView = BarChartView()
        monthlyStepChartView.noDataText = ""
        return monthlyStepChartView
    }()
    
    
    lazy var yearlyStepChartView: BarChartView =  {
        let yearlyStepChartView = BarChartView()
        yearlyStepChartView.noDataText = ""
        return yearlyStepChartView
    }()
    
    
    lazy var dayStepButton = UIButton().then {
        $0.setTitle ("Day", for: .normal )
        
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                         
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(selectDayClick(sender:)), for: .touchUpInside)
    }
    
    
    lazy var weekStepButton = UIButton().then {
        $0.setTitle ("Week", for: .normal )
        
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                         
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(selectWeekClick(sender:)), for: .touchUpInside)
    }
    
    
    lazy var monthStepButton = UIButton().then {
        $0.setTitle ("Month", for: .normal )
        
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                         
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(selectMonthClick(sender:)), for: .touchUpInside)
    }
    
    lazy var yearStepButton = UIButton().then {
        $0.setTitle ("Year", for: .normal )
        
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.lightGray, for: .disabled)
                         
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .normal)
        $0.setBackgroundColor(UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0), for: .selected)
        $0.setBackgroundColor(UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0), for: .disabled)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(selectYearClick(sender:)), for: .touchUpInside)
    }
    
    
    lazy var dateStepDisplay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)-\(realDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var weekStepDisplay = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var monthStepDisplay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var yearStepDisplay = UILabel().then {
        $0.text = "\(realYear)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    //    -----------------------------day button-------------------
    
    lazy var yesterdayHourlyStepButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(yesterdaySelectStepButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var tomorrowHourlyStepButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(tomorrowSelectStepButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------day button-------------------
    
    
    //    -----------------------------weeek button-------------------
    
    lazy var lastWeekStepButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastWeekSelectStepButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextWeekStepButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextWeekSelectStepButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------weeek button-------------------
    
    
    
    //    -----------------------------month button-------------------
    
    lazy var lastMonthStepButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastMonthSelectStepButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextMonthStepButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextMonthSelectStepButton(sender:)), for: .touchUpInside)
    }
    //    -----------------------------month button-------------------
    
    
    //    -----------------------------yearkbutton------------------
    
    lazy var lastYearStepButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastYearSelectStepButton(sender:)), for: .touchUpInside)
    }
    
    lazy var nextYearStepButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextYearSelectStepButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------yearkbutton------------------
    
    
    lazy var stepDayLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "걸음 (steps)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
        
    }
    
    lazy var stepDayValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var stepWeekLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "걸음 (steps)"
        $0.textColor = .darkGray
        $0.baselineAdjustment = .alignCenters
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var stepWeekValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var stepMonthLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "걸음 (steps)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var stepMonthValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var stepYearLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "걸음 (steps)"
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var stepYearValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var distanceDayLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "거리 (Km)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var distanceDayValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var distanceWeekLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "거리 (Km)"
        
        $0.textColor = .darkGray
        
        $0.baselineAdjustment = .alignCenters
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var distanceWeekValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var distanceMonthLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "거리 (Km)"
        $0.textColor = .darkGray
        
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var distanceMonthValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var distanceYearLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "거리 (Km)"
        $0.textColor = .darkGray
        
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var distanceYearValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var dailyTargetStepProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .red
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var dailyTargetStepProgressTextField = UILabel().then {
        $0.text = "0%"
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
    }
    
    
    lazy var weeklyTargetStepProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .red
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var weeklyTargetStepProgressTextField = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
    }
    
    
    lazy var monthlyTargetStepProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .red
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var monthlyTargetStepProgressTextField = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
    }
    
    
    lazy var yearlyTargetStepProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .red
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var yearlyTargetStepProgressTextField = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
    }
    

    
    lazy var dailyTargetDistanceProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .blue
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var dailyTargetDistanceProgressTextField = UILabel().then {
        $0.text = "0%"
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
    }
    

    
    lazy var weeklyTargetDistanceProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .blue
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var weeklyTargetDistanceProgressTextField = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
    }

    
    lazy var monthlyTargetDistanceProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .blue
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var monthlyTargetDistanceProgressTextField = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
    }
    
    
    
    lazy var yearlyTargetDistanceProgress = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.backgroundColor = .lightGray
        $0.progressTintColor = .blue
        $0.progress = 0.5
        $0.transform = $0.transform.scaledBy(x: 1, y: 2)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 8
        $0.subviews[1].clipsToBounds = true
    }
    
    
    lazy var yearlyTargetDistanceProgressTextField = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        //   $0.borderStyle = .roundedRect
        $0.font = .boldSystemFont(ofSize: 20)
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
    }
    
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
    // MARK: - constraints
    func stepviews(){
        
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
//
//            }
//            self.arrButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//
//            }
//
//            self.calorieButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//
//            }
//
//            self.stepButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//
//            }
//
//            self.temperatureButton.snp.makeConstraints {
//                $0.top.bottom.equalTo(buttonStackView1)
//                $0.trailing.equalTo(buttonStackView1)
//            }
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
        
        view.addSubview(hourlyStepChartView)
        hourlyStepChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
        }
        
        view.addSubview(weeklyStepChartView)
        weeklyStepChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyStepChartView.snp.bottom)
        }
        
        view.addSubview(monthlyStepChartView)
        monthlyStepChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyStepChartView.snp.bottom)
        }
        
        view.addSubview(yearlyStepChartView)
        yearlyStepChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyStepChartView.snp.bottom)
        }
        
        let buttonStackView2: UIStackView = {
            let buttonStackView2 = UIStackView(arrangedSubviews: [dayStepButton, weekStepButton, monthStepButton, yearStepButton])
            buttonStackView2.axis = .horizontal
            buttonStackView2.distribution = .fillEqually // default
            buttonStackView2.alignment = .fill // default
            buttonStackView2.spacing = 20.0
    
            
            view.addSubview(buttonStackView2)
            
            
            self.dayStepButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)

            }
            self.weekStepButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)

            }
            
            self.monthStepButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)

            }
            
            self.yearStepButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
                $0.trailing.equalTo(buttonStackView2)
                
            }
            
            return buttonStackView2
        }()
        
        
        buttonStackView2.snp.makeConstraints { (make) in
            
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.top.equalTo(self.hourlyStepChartView.snp.bottom)
            make.height.equalTo(50)
        }
        
        
        //        -----------------------day button position--------------------
        
        view.addSubview(yesterdayHourlyStepButton)
        yesterdayHourlyStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(dateStepDisplay)
        dateStepDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(yesterdayHourlyStepButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tomorrowHourlyStepButton)
        tomorrowHourlyStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(dateStepDisplay.snp.trailing).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------day button position--------------------
        
        
        //        -----------------------week button position--------------------
        
        view.addSubview(lastWeekStepButton)
        lastWeekStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(weekStepDisplay)
        weekStepDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(lastWeekStepButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(nextWeekStepButton)
        nextWeekStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(weekStepDisplay.snp.trailing).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------week button position--------------------
        
        
        //        -----------------------month button position--------------------
        
        
        view.addSubview(lastMonthStepButton)
        lastMonthStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(monthStepDisplay)
        monthStepDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(lastMonthStepButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextMonthStepButton)
        nextMonthStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(monthStepDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------month button position--------------------
        
        
        
        //        -----------------------year button position--------------------
        
        
        view.addSubview(lastYearStepButton)
        lastYearStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(yearStepDisplay)
        yearStepDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(lastYearStepButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextYearStepButton)
        nextYearStepButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(yearStepDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        
        //        -----------------------year button position--------------------
        
        view.addSubview(stepDayLabel)
        stepDayLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(stepDayValue)
        stepDayValue.snp.makeConstraints {(make) in
            make.leading.equalTo(stepDayLabel.snp.trailing)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(stepWeekLabel)
        stepWeekLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(stepWeekValue)
        stepWeekValue.snp.makeConstraints {(make) in
            make.leading.equalTo(stepWeekLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(stepMonthLabel)
        stepMonthLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(stepMonthValue)
        stepMonthValue.snp.makeConstraints {(make) in
            make.leading.equalTo(stepMonthLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(stepYearLabel)
        stepYearLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(stepYearValue)
        stepYearValue.snp.makeConstraints {(make) in
            make.leading.equalTo(stepYearLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyStepButton.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        //  ---------------------------- step ------------------------------

        
        view.addSubview(dailyTargetStepProgress)
        dailyTargetStepProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(stepDayValue.snp.bottom).offset(15)
            //            make.bottom.equalTo(dailyTargetStep.snp.bottom)
            make.height.equalTo(12)
        }
        
        view.addSubview(dailyTargetStepProgressTextField)
        dailyTargetStepProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(dailyTargetStepProgress.snp.trailing).offset(10)
            make.top.equalTo(stepDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            //            make.bottom.equalTo(dailyTargetStep.snp.bottom)
            make.width.equalTo(80)
            //            make.height.equalTo(20)
        }
        

        
        view.addSubview(weeklyTargetStepProgress)
        weeklyTargetStepProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(stepDayValue.snp.bottom).offset(15)
            //            make.bottom.equalTo(weeklyTargetStep.snp.bottom)
            make.height.equalTo(12)
        }
        
        view.addSubview(weeklyTargetStepProgressTextField)
        weeklyTargetStepProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(weeklyTargetStepProgress.snp.trailing).offset(10)
            make.top.equalTo(stepDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            //            make.bottom.equalTo(weeklyTargetStep.snp.bottom)
            make.width.equalTo(80)
            //            make.height.equalTo(20)
        }
        

//
        view.addSubview(monthlyTargetStepProgress)
        monthlyTargetStepProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(stepDayValue.snp.bottom).offset(15)
            //            make.bottom.equalTo(monthlyTargetStep.snp.bottom)
            make.height.equalTo(12)
        }
        
        view.addSubview(monthlyTargetStepProgressTextField)
        monthlyTargetStepProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(monthlyTargetStepProgress.snp.trailing).offset(10)
            make.top.equalTo(stepDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            //            make.bottom.equalTo(monthlyTargetStep.snp.bottom)
            make.width.equalTo(80)
            //            make.height.equalTo(20)
        }

        
        view.addSubview(yearlyTargetStepProgress)
        yearlyTargetStepProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(stepDayValue.snp.bottom).offset(15)
            //            make.bottom.equalTo(yearlyTargetStep.snp.bottom)
            make.height.equalTo(12)
        }
        
        view.addSubview(yearlyTargetStepProgressTextField)
        yearlyTargetStepProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(yearlyTargetStepProgress.snp.trailing).offset(10)
            make.top.equalTo(stepDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            //            make.bottom.equalTo(yearlyTargetStep.snp.bottom)
            make.width.equalTo(80)
            //            make.height.equalTo(20)
        }
        
        
        //  ---------------------------- step ------------------------------
        
        
        view.addSubview(distanceDayLabel)
        distanceDayLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(distanceDayValue)
        distanceDayValue.snp.makeConstraints {(make) in
            make.leading.equalTo(distanceDayLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(distanceWeekLabel)
        distanceWeekLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(distanceWeekValue)
        distanceWeekValue.snp.makeConstraints {(make) in
            make.leading.equalTo(distanceWeekLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(distanceMonthLabel)
        distanceMonthLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(distanceMonthValue)
        distanceMonthValue.snp.makeConstraints {(make) in
            make.leading.equalTo(distanceMonthLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(distanceYearLabel)
        distanceYearLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(distanceYearValue)
        distanceYearValue.snp.makeConstraints {(make) in
            make.leading.equalTo(distanceYearLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetStepProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
        //  ---------------------------- step ------------------------------


        
        view.addSubview(dailyTargetDistanceProgress)
        dailyTargetDistanceProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }
        
        
        view.addSubview(dailyTargetDistanceProgressTextField)
        dailyTargetDistanceProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(dailyTargetDistanceProgress.snp.trailing).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }
        

        
        view.addSubview(weeklyTargetDistanceProgress)
        weeklyTargetDistanceProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }
        
        
        view.addSubview(weeklyTargetDistanceProgressTextField)
        weeklyTargetDistanceProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(weeklyTargetDistanceProgress.snp.trailing).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }

        
        view.addSubview(monthlyTargetDistanceProgress)
        monthlyTargetDistanceProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }
        
        
        view.addSubview(monthlyTargetDistanceProgressTextField)
        monthlyTargetDistanceProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(monthlyTargetDistanceProgress.snp.trailing).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }

        
        view.addSubview(yearlyTargetDistanceProgress)
        yearlyTargetDistanceProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }
        
        
        view.addSubview(yearlyTargetDistanceProgressTextField)
        yearlyTargetDistanceProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(yearlyTargetDistanceProgress.snp.trailing).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(distanceDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }
        //  ---------------------------- step ------------------------------
        
        // MARK: - AlertConstraint
        view.addSubview(alertBackground)
        view.addSubview(alertLabel)
        
        alertBackground.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertBackground.leadingAnchor.constraint(equalTo: hourlyStepChartView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            alertBackground.centerXAnchor.constraint(equalTo: hourlyStepChartView.centerXAnchor),
            alertBackground.centerYAnchor.constraint(equalTo: hourlyStepChartView.centerYAnchor),
            
            alertBackground.heightAnchor.constraint(equalToConstant: 120),
            
            
            alertLabel.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
        ])
        
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tStep = defaults.integer(forKey: "TargetStep")
        tDistance = defaults.integer(forKey: "TargetDistance")
        
        setupViewStep()
        stepviews()
        startDayStepGraph()
        //        print(halfSafeAreaWidth)
        
        stepDayLabel.alpha = 1.0
        stepDayValue.alpha = 1.0
        stepWeekLabel.alpha = 0.0
        stepWeekValue.alpha = 0.0
        stepMonthLabel.alpha = 0.0
        stepMonthValue.alpha = 0.0
        stepYearLabel.alpha = 0.0
        stepYearValue.alpha = 0.0
        
        distanceDayLabel.alpha = 1.0
        distanceDayValue.alpha = 1.0
        distanceWeekLabel.alpha = 0.0
        distanceWeekValue.alpha = 0.0
        distanceMonthLabel.alpha = 0.0
        distanceMonthValue.alpha = 0.0
        distanceYearLabel.alpha = 0.0
        distanceYearValue.alpha = 0.0
        

        dailyTargetStepProgress.alpha = 1.0
        dailyTargetStepProgressTextField.alpha = 1.0

        weeklyTargetStepProgress.alpha = 0.0
        weeklyTargetStepProgressTextField.alpha = 0.0

        monthlyTargetStepProgress.alpha = 0.0
        monthlyTargetStepProgressTextField.alpha = 0.0
        yearlyTargetStepProgress.alpha = 0.0
        yearlyTargetStepProgressTextField.alpha = 0.0
        
        dailyTargetDistanceProgress.alpha = 1.0
        dailyTargetDistanceProgressTextField.alpha = 1.0
        weeklyTargetDistanceProgress.alpha = 0.0
        weeklyTargetDistanceProgressTextField.alpha = 0.0
        monthlyTargetDistanceProgress.alpha = 0.0
        monthlyTargetDistanceProgressTextField.alpha = 0.0
        yearlyTargetDistanceProgress.alpha = 0.0
        yearlyTargetDistanceProgressTextField.alpha = 0.0
        
        
        dayStepButton.isSelected = true
        weekStepButton.isSelected  = false
        monthStepButton.isSelected = false
        yearStepButton.isSelected = false
        
        dateStepDisplay.isHidden = false
        weekStepDisplay.isHidden = true
        monthStepDisplay.isHidden = true
        yearStepDisplay.isHidden = true
        
        yesterdayHourlyStepButton.isHidden = false
        tomorrowHourlyStepButton.isHidden = false
        
        lastWeekStepButton.isHidden = true
        nextWeekStepButton.isHidden = true
        
        lastMonthStepButton.isHidden = true
        nextMonthStepButton.isHidden = true
        
        lastYearStepButton.isHidden = true
        nextYearStepButton.isHidden = true
        
        yesterdayHourlyStepButton.isEnabled = true
        tomorrowHourlyStepButton.isEnabled = true
        
        lastWeekStepButton.isEnabled = false
        nextWeekStepButton.isEnabled = false
        
        lastMonthStepButton.isEnabled = false
        nextMonthStepButton.isEnabled = false
        
        lastYearStepButton.isEnabled = false
        nextYearStepButton.isEnabled = false
        
        //        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(stepTimer), userInfo: nil, repeats: true)
    }
    
    
    //
    //    @objc func stepTimer(){
    //
    //        stepDayValue.text = String(sumOfHourlyStep)
    //        stepWeekValue.text = String(sumOfWeeklyStep)
    //        stepMonthValue.text = String(sumOfMonthlyStep)
    //        stepYearValue.text = String(sumOfYearlyStep)
    //
    //    }
    
    // MARK: - hourly
    func hourlyStepChartViewGraph(){
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        weeklyStepChartView.clear()
        hourlyStepChartView.clear()
        
        sumOfHourlyStep = 0
        sumOfHourlyDistance = 0
        
        alertFlag = false
        alertString = ""
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("\(stepChangeRealYear)/\(stepChangeRealMonth)/\(stepChangeRealDate)")
        let fileURL1 = directoryURL1.appendingPathComponent("/calandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if fileManager1.fileExists(atPath: filePath1){
            do {
                let data1 = try String(contentsOf: fileURL1)
                
                let hourlyStepData1 = data1.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfHourlyStepData = hourlyStepData1.count
                
                for i in 0 ..< numbersOfHourlyStepData - 1 {
                    let row1 = hourlyStepData1[i]
                    let columns1 = row1.components(separatedBy: ",")
                    let hourlyStepTimeRow = columns1[0]
                    let hourlyStepDataRow = Double(columns1[2])
                    let hourlyDistanceDataRow = Double(columns1[3])
                    
                    sumOfHourlyStep =  sumOfHourlyStep + Int(hourlyStepDataRow ?? 0)
                    sumOfHourlyDistance = sumOfHourlyDistance + Int(hourlyDistanceDataRow ?? 0)
                    
                    hourlyStepTimeData.append(hourlyStepTimeRow)
                    hourlyStepData.append(hourlyStepDataRow  ?? 0.0)
                    hourlyDistanceData.append(hourlyDistanceDataRow  ?? 0.0)
                    
                }
                
                
                stepDayValue.text = String(sumOfHourlyStep)
                
                
                let hourlylyDistanceKm = Double(sumOfHourlyDistance) / 1000.0
                
                
                distanceDayValue.text = String(format: "%.1f", hourlylyDistanceKm)
                
                
                let dailyStepRatio = Float(sumOfHourlyStep) / Float(tStep)
                let dailyPstepRatio = dailyStepRatio * 100
                dailyTargetStepProgress.progress = Float(dailyStepRatio)
                let dailyIntstepRatio = Int(dailyPstepRatio)
                
                
                dailyTargetStepProgressTextField.text = String(dailyIntstepRatio) + "%"
                
                let dailyDistanceRatio = Float(hourlylyDistanceKm) / Float(tDistance)
                let dailyPdistanceRatio = dailyDistanceRatio * 100
                dailyTargetDistanceProgress.progress = Float(dailyDistanceRatio)
                let dailyIntdistanceRatio = Int(dailyPdistanceRatio)
                
                
                dailyTargetDistanceProgressTextField.text = String(dailyIntdistanceRatio) + "%"
                
                
            } catch  {
                print("Error reading CSV file")
            }
            
            var hourlyDistanceDataEntries = [BarChartDataEntry]()
            var hourlyStepDataEntries = [BarChartDataEntry]()
            
            for i in 0 ..< numbersOfHourlyStepData - 1{
                let hourlyStepDataEntry = BarChartDataEntry(x: Double(i), y: hourlyStepData[i])
                hourlyStepDataEntries.append(hourlyStepDataEntry)
                
            }
            
            
            for i in 0 ..< numbersOfHourlyStepData - 1 {
                let hourlyDistanceDataEntry = BarChartDataEntry(x: Double(i), y: hourlyDistanceData[i] )
                hourlyDistanceDataEntries.append(hourlyDistanceDataEntry)
            }
            
            let hourlyStepChartDataSet = BarChartDataSet(entries: hourlyStepDataEntries, label: "걸음 (steps)")
            hourlyStepChartDataSet.setColor(NSUIColor.red)
            hourlyStepChartDataSet.drawValuesEnabled = false
            
            let hourlyDistanceChartDataSet = BarChartDataSet(entries:  hourlyDistanceDataEntries, label: "거리 (m)")
            hourlyDistanceChartDataSet.setColor(NSUIColor.blue)
            hourlyDistanceChartDataSet.drawValuesEnabled = false
            
            let dataSets: [BarChartDataSet] = [hourlyStepChartDataSet,hourlyDistanceChartDataSet]
            
            let chartData = BarChartData(dataSets: dataSets)
            
            let groupSpace = 0.3
            let barSpace = 0.05
            let barWidth = 0.3
            
            chartData.barWidth = barWidth
            
            hourlyStepChartView.xAxis.axisMinimum = Double(0)
            hourlyStepChartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(numbersOfHourlyStepData - 1)  // group count : 2
            chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
            
            hourlyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            hourlyStepChartView.noDataText = ""
            hourlyStepChartView.data = chartData
            hourlyStepChartView.xAxis.enabled = true
            hourlyStepChartView.xAxis.centerAxisLabelsEnabled = true
            hourlyStepChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hourlyStepTimeData)
            hourlyStepChartView.xAxis.granularity = 1
            hourlyStepChartView.xAxis.setLabelCount(numbersOfHourlyStepData, force: false)
            hourlyStepChartView.xAxis.labelPosition = .bottom
            hourlyStepChartView.xAxis.drawGridLinesEnabled = false
            
            hourlyStepChartView.leftAxis.granularityEnabled = true
            hourlyStepChartView.leftAxis.granularity = 1.0
            
            hourlyStepChartView.leftAxis.axisMinimum = 0
            hourlyStepChartView.rightAxis.enabled = false
            hourlyStepChartView.drawMarkers = false
            hourlyStepChartView.dragEnabled = false
            hourlyStepChartView.pinchZoomEnabled = false
            hourlyStepChartView.doubleTapToZoomEnabled = false
            hourlyStepChartView.highlightPerTapEnabled = false
            
            hourlyStepChartView.data?.notifyDataChanged()
            hourlyStepChartView.notifyDataSetChanged()
            hourlyStepChartView.moveViewToX(0)
            hourlyStepTimeData = []
            hourlyStepData = []
            hourlyDistanceData = []
            
        }
        else{
            alertFlag = true
            alertString += "\(stepChangeRealYear)/\(stepChangeRealMonth)/\(stepChangeRealDate)\n"
        }
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            alertLabel.text = alertString + "데이터가 없습니다."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "on \(stepChangeRealYear)/\(stepChangeRealMonth)/\(stepChangeRealDate)", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                // noncontactFlag = 0
//            })
//            alert.addAction(ok)
//            present(alert,animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    // MARK: - weekly
    func weeklyStepChartViewGraph(){
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        hourlyStepChartView.clear()
        weeklyStepChartView.clear()
        
        sumOfWeeklyStep = 0
        sumOfWeeklyDistance = 0
        
        var alertCheck = 0
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        numbersOfWeeklyStepData = defaults.integer(forKey:"numbersOfWeeklyStepData")
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if fileManager1.fileExists(atPath: filePath1) {
            
            do {
                let data1 = try String(contentsOf: fileURL1)
                
                let weeklyStepData1 = data1.components(separatedBy: .newlines)
                
                
                for i in numbersOfWeeklyStepData - 8 ..< numbersOfWeeklyStepData - 1{
                    let row1 = weeklyStepData1[i]
                    let columns = row1.components(separatedBy: ",")
                    let weeklyStepTimeRow = columns[3]
                    let weeklyStepDataRow = Double(columns[5])
                    let weeklyDistanceDataRow = Double(columns[6])
                    
                    sumOfWeeklyStep = sumOfWeeklyStep + Int(weeklyStepDataRow ?? 0)
                    sumOfWeeklyDistance = sumOfWeeklyDistance + Int(weeklyDistanceDataRow ?? 0)
                    
                    weeklyStepTimeData.append(weeklyStepTimeRow)
                    weeklyStepData.append(weeklyStepDataRow ?? 0.0)
                    weeklyDistanceData.append(weeklyDistanceDataRow ?? 0.0)
                    
                }
                
                // 데이터 체크
                for i in 0..<7 {
                    if weeklyDistanceData[i] == 0.0 {
                        alertCheck += 1
                    }
                    if weeklyStepData[i] == 0.0 {
                        alertCheck += 1
                    }
                    if alertCheck == 14 {
                        alertFlag = true
                    }
                    
                    // 영문 -> 한글
                    if weeklyStepTimeData[i] == "Mon" {
                        weeklyStepTimeData[i] = "월"
                    }
                    else if weeklyStepTimeData[i] == "Tue" {
                        weeklyStepTimeData[i] = "화"
                    }
                    else if weeklyStepTimeData[i] == "Wed" {
                        weeklyStepTimeData[i] = "수"
                    }
                    else if weeklyStepTimeData[i] == "Thu" {
                        weeklyStepTimeData[i] = "목"
                    }
                    else if weeklyStepTimeData[i] == "Fri" {
                        weeklyStepTimeData[i] = "금"
                    }
                    else if weeklyStepTimeData[i] == "Sat" {
                        weeklyStepTimeData[i] = "토"
                    }
                    else if weeklyStepTimeData[i] == "Sun" {
                        weeklyStepTimeData[i] = "일"
                    }
                }
                
                stepWeekValue.text = String(sumOfWeeklyStep)
                
                let weeklyDistanceKm = Double(sumOfWeeklyDistance) / 1000.0
                distanceWeekValue.text = String(format: "%.1f", weeklyDistanceKm)
                
                
                let weeklyStepRatio = Double(sumOfWeeklyStep) / Double(tStep * 7)
                let weeklyPstepRatio = weeklyStepRatio * 100
                weeklyTargetStepProgress.progress = Float(weeklyStepRatio)
                let weeklyIntstepRatio = Int(weeklyPstepRatio)
                
                
                
                weeklyTargetStepProgressTextField.text = String(weeklyIntstepRatio) + "%"
                
                
                let weeklyDistanceRatio = Double(weeklyDistanceKm) / Double(tDistance * 7)
                let weeklyPdistanceRatio = weeklyDistanceRatio * 100
                weeklyTargetDistanceProgress.progress = Float(weeklyDistanceRatio)
                let weeklyIntdistanceRatio = Int(weeklyPdistanceRatio)
                
                
                weeklyTargetDistanceProgressTextField.text = String(weeklyIntdistanceRatio) + "%"
                
            } catch  {
                print("Error reading CSV file")
                
            }
            
            let weekNumber = 7
            
            var weeklyStepDataEntries = [BarChartDataEntry]()
            var weeklyDistanceDataEntries = [BarChartDataEntry]()
            
            for i in 0 ..< weekNumber {
                let weeklyStepDataEntry = BarChartDataEntry(x: Double(i), y: weeklyStepData[i])
                weeklyStepDataEntries.append(weeklyStepDataEntry)
            }
            
            
            for i in 0 ..< weekNumber {
                let weeklyDistanceDataEntry = BarChartDataEntry(x: Double(i), y: weeklyDistanceData[i])
                weeklyDistanceDataEntries.append(weeklyDistanceDataEntry)
            }
            
            
            let weeklyStepChartDataSet = BarChartDataSet(entries: weeklyStepDataEntries, label: "걸음 (steps)")
            weeklyStepChartDataSet.setColor(NSUIColor.red)
            weeklyStepChartDataSet.drawValuesEnabled = false
            
            
            let weeklyDistanceChartDataSet = BarChartDataSet(entries: weeklyDistanceDataEntries, label: "거리 (m)")
            weeklyDistanceChartDataSet.setColor(NSUIColor.blue)
            weeklyDistanceChartDataSet.drawValuesEnabled = false
            
            let weeklyStepdataSets: [BarChartDataSet] = [weeklyStepChartDataSet,weeklyDistanceChartDataSet]
            
            let chartData = BarChartData(dataSets: weeklyStepdataSets)
            
            let groupSpace = 0.3
            let barSpace = 0.05
            let barWidth = 0.3
            
            chartData.barWidth = barWidth
            
            weeklyStepChartView.xAxis.axisMinimum = Double(0)
            weeklyStepChartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(7)  // group count : 2
            chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
            
            weeklyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            weeklyStepChartView.noDataText = ""
            weeklyStepChartView.data = chartData
            weeklyStepChartView.xAxis.enabled = true
            
            weeklyStepChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weeklyStepTimeData)
            weeklyStepChartView.xAxis.granularity = 1
            weeklyStepChartView.xAxis.setLabelCount(7, force: false)
            weeklyStepChartView.xAxis.centerAxisLabelsEnabled = true
            weeklyStepChartView.xAxis.labelPosition = .bottom
            weeklyStepChartView.xAxis.drawGridLinesEnabled = false
            weeklyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            weeklyStepChartView.leftAxis.granularityEnabled = true
            weeklyStepChartView.leftAxis.granularity = 1.0
            weeklyStepChartView.leftAxis.axisMinimum = 0
            weeklyStepChartView.rightAxis.enabled = false
            weeklyStepChartView.drawMarkers = false
            weeklyStepChartView.dragEnabled = false
            weeklyStepChartView.pinchZoomEnabled = false
            weeklyStepChartView.doubleTapToZoomEnabled = false
            weeklyStepChartView.highlightPerTapEnabled = false
            
            weeklyStepChartView.data?.notifyDataChanged()
            weeklyStepChartView.notifyDataSetChanged()
            weeklyStepChartView.moveViewToX(0)
            weeklyStepTimeData = []
            weeklyStepData = []
            weeklyDistanceData = []
            
        }
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            weeklyStepChartView.clear()
            alertLabel.text = "\(alertString)\n데이터가 없습니다."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                // noncontactFlag = 0
//            })
//            alert.addAction(ok)
//            present(alert,animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    // MARK: - monthly
    func monthlyStepChartViewGraph(){
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        hourlyStepChartView.clear()
        weeklyStepChartView.clear()
        
        var alertCheck = 0
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        for _ in 0..<20 {
            monthlyStepChartView.zoomOut()
        }
        
        numbersOfStepDaysForMonth = defaults.integer(forKey:"numbersOfStepDaysForMonth")
        
        
        stepMonthValue.text = String(sumOfMonthlyStep)
        
        let monthlylyDistanceKm = Double(sumOfMonthlyDistance) / 1000.0
        
        distanceMonthValue.text = String(format: "%.1f", monthlylyDistanceKm)
        
        
        let monthlyStepRatio = Double(sumOfMonthlyStep) / Double(tStep * numbersOfStepDaysForMonth)
        
        let monthlyPstepRatio = monthlyStepRatio * 100
        monthlyTargetStepProgress.progress = Float(monthlyStepRatio)
        let monthlyIntstepRatio = Int(monthlyPstepRatio)
        
        monthlyTargetStepProgressTextField.text = String(monthlyIntstepRatio) + "%"
        
        let monthlyDistanceRatio = Double(monthlylyDistanceKm) / Double(tDistance * numbersOfStepDaysForMonth)
        let monthlyPdistanceRatio = monthlyDistanceRatio * 100
        monthlyTargetDistanceProgress.progress = Float(monthlyDistanceRatio)
        let monthlyIntdistanceRatio = Int(monthlyPdistanceRatio)
        
        
        monthlyTargetDistanceProgressTextField.text = String(monthlyIntdistanceRatio) + "%"
        
        
        var monthlyStepDataEntries = [BarChartDataEntry]()
        var monthlyDistanceDataEntries = [BarChartDataEntry]()
        
        for i in 0 ..< numbersOfStepDaysForMonth {
            let monthlyStepDataEntry = BarChartDataEntry(x: Double(i), y: monthlyStepData[i])
            monthlyStepDataEntries.append(monthlyStepDataEntry)
            
            if monthlyStepData[i] == 0.0 {
                alertCheck += 1
            }
        }
        
        
        for i in 0 ..< numbersOfStepDaysForMonth {
            let monthlyDistanceDataEntry = BarChartDataEntry(x: Double(i), y: monthlyDistanceData[i])
            monthlyDistanceDataEntries.append(monthlyDistanceDataEntry)
            
            if monthlyDistanceData[i] == 0.0 {
                alertCheck += 1
            }
        }
        
        // 데이터가 다 비어있는지 체크
        if (numbersOfStepDaysForMonth * 2) == alertCheck {
            alertFlag = true
        }
        
        let monthlyStepChartDataSet = BarChartDataSet(entries: monthlyStepDataEntries, label: "걸음 (steps)")
        monthlyStepChartDataSet.setColor(NSUIColor.red)
        monthlyStepChartDataSet.drawValuesEnabled = false
        
        
        let monthlyDistanceChartDataSet = BarChartDataSet(entries: monthlyDistanceDataEntries, label: "거리 (m)")
        monthlyDistanceChartDataSet.setColor(NSUIColor.blue)
        monthlyDistanceChartDataSet.drawValuesEnabled = false
        
        let monthlyStepdataSets: [BarChartDataSet] = [monthlyStepChartDataSet,monthlyDistanceChartDataSet]
        
        let chartData = BarChartData(dataSets: monthlyStepdataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        chartData.barWidth = barWidth
        
        monthlyStepChartView.xAxis.axisMinimum = Double(0)
        monthlyStepChartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(numbersOfStepDaysForMonth)  // group count : 2
        chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        
        monthlyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        monthlyStepChartView.noDataText = ""
        monthlyStepChartView.data = chartData
        monthlyStepChartView.xAxis.enabled = true
        
        monthlyStepChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthlyStepTimeData)
        monthlyStepChartView.xAxis.granularity = 1.0
        monthlyStepChartView.xAxis.setLabelCount(numbersOfStepDaysForMonth, force: false)
        monthlyStepChartView.xAxis.centerAxisLabelsEnabled = true
        monthlyStepChartView.xAxis.labelPosition = .bottom
        monthlyStepChartView.xAxis.drawGridLinesEnabled = false
        monthlyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        monthlyStepChartView.setVisibleXRangeMaximum(10)
        
        monthlyStepChartView.leftAxis.granularityEnabled = true
//        monthlyStepChartView.leftAxis.granularity = 1.0
        monthlyStepChartView.leftAxis.axisMinimum = 0
        monthlyStepChartView.rightAxis.enabled = false
        monthlyStepChartView.drawMarkers = false
        monthlyStepChartView.dragEnabled = true
        monthlyStepChartView.pinchZoomEnabled = false
        monthlyStepChartView.doubleTapToZoomEnabled = false
        monthlyStepChartView.highlightPerTapEnabled = false
        
        monthlyStepChartView.data?.notifyDataChanged()
        monthlyStepChartView.notifyDataSetChanged()
        monthlyStepChartView.moveViewToX(Double(monthlyStepTimeData.count))
        monthlyStepTimeData = []
        monthlyStepData = []
        monthlyDistanceData = []
        
        numbersOfStepDaysForMonth = 0
        hourlyStepChartView.isUserInteractionEnabled = false
        weeklyStepChartView.isUserInteractionEnabled = false
        monthlyStepChartView.isUserInteractionEnabled = true
        yearlyStepChartView.isUserInteractionEnabled = false
        
        // 데이터가 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            monthlyStepChartView.clear()
            alertLabel.text = "\(alertString)\n데이터가 없습니다."
        }
    }
    
    // MARK: - yearly
    func yearlyStepChartViewGraph(){
        
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        hourlyStepChartView.clear()
        weeklyStepChartView.clear()
        
//        var alertCheck = 0
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        // 기능 구현 전까지 false
        lastYearStepButton.isEnabled = false
        nextYearStepButton.isEnabled = false
        
        numbersOfStepMonthsForYear = defaults.integer(forKey:"numbersOfStepMonthsForYear")
        
        currentStepYear = defaults.integer(forKey:"currentStepYear")
        
        baseStepMonthOfYear = defaults.integer(forKey:"baseStepMonthOfYear")
        numbersOfYearlyStepData = defaults.integer(forKey:"numbersOfYearlyStepData")
        sumOfYearlyStep = defaults.integer(forKey:"sumOfYearlyStep")
        sumOfYearlyDistance = defaults.integer(forKey:"sumOfYearlyDistance")
        numbersOfStepDaysForYear = defaults.integer(forKey:"numbersOfStepDaysForYear")
        
        
        
        
        stepYearValue.text = String(sumOfYearlyStep)
        
        let yearlyDistanceKm = Double(sumOfYearlyDistance) / 1000.0
        distanceYearValue.text = String(format: "%.1f", yearlyDistanceKm)
        
        
        let yearlyStepRatio = Double(sumOfYearlyStep) / Double(tStep * numbersOfStepDaysForYear)
        let yearlyPstepRatio = yearlyStepRatio * 100
        yearlyTargetStepProgress.progress = Float(yearlyStepRatio)
        let yearlyIntstepRatio = Int(yearlyPstepRatio)
        
        yearlyTargetStepProgressTextField.text = String(yearlyIntstepRatio) + "%"
        
        let yearlyDistanceRatio = Double(yearlyDistanceKm) / Double(tDistance * numbersOfStepDaysForYear)
        let yearlyPdistanceRatio = yearlyDistanceRatio * 100
        yearlyTargetDistanceProgress.progress = Float(yearlyDistanceRatio)
        let yearlyIntdistanceRatio = Int(yearlyPdistanceRatio)
        
        
        yearlyTargetDistanceProgressTextField.text = String(yearlyIntdistanceRatio) + "%"
        
        
        var yearlyStepDataEntries = [BarChartDataEntry]()
        var yearlyDistanceDataEntries = [BarChartDataEntry]()
        
        for i in 0 ..< numbersOfStepMonthsForYear {
            let yearlyStepDataEntry = BarChartDataEntry(x: Double(i), y: yearlyStepData[i])
            yearlyStepDataEntries.append(yearlyStepDataEntry)
        }
        
        
        for i in 0 ..< numbersOfStepMonthsForYear {
            let yearlyDistanceDataEntry = BarChartDataEntry(x: Double(i), y: yearlyDistanceData[i])
            yearlyDistanceDataEntries.append(yearlyDistanceDataEntry)
        }
        
        
        let yearlyStepChartDataSet = BarChartDataSet(entries: yearlyStepDataEntries, label: "걸음 (steps)")
        yearlyStepChartDataSet.setColor(NSUIColor.red)
        yearlyStepChartDataSet.drawValuesEnabled = false
        
        
        let yearlyDistanceChartDataSet = BarChartDataSet(entries: yearlyDistanceDataEntries, label: "거리 (m)")
        yearlyDistanceChartDataSet.setColor(NSUIColor.blue)
        yearlyDistanceChartDataSet.drawValuesEnabled = false
        
        let yearlyStepdataSets: [BarChartDataSet] = [yearlyStepChartDataSet, yearlyDistanceChartDataSet]
        
        let chartDataStep = BarChartData(dataSets: yearlyStepdataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        chartDataStep.barWidth = barWidth
        
        yearlyStepChartView.xAxis.axisMinimum = Double(0)
        yearlyStepChartView.xAxis.axisMaximum = Double(0) + chartDataStep.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(numbersOfStepMonthsForYear)  // group count : 2
        chartDataStep.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        
        yearlyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        yearlyStepChartView.noDataText = ""
        yearlyStepChartView.data = chartDataStep
        yearlyStepChartView.xAxis.enabled = true
        
        yearlyStepChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yearlyStepTimeData)
        yearlyStepChartView.xAxis.granularity = 1
        yearlyStepChartView.xAxis.setLabelCount(numbersOfStepMonthsForYear, force: false)
        yearlyStepChartView.xAxis.centerAxisLabelsEnabled = true
        yearlyStepChartView.xAxis.labelPosition = .bottom
        yearlyStepChartView.xAxis.drawGridLinesEnabled = false
        yearlyStepChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        yearlyStepChartView.leftAxis.granularityEnabled = true
        yearlyStepChartView.leftAxis.granularity = 1.0
        yearlyStepChartView.leftAxis.axisMinimum = 0
        yearlyStepChartView.rightAxis.enabled = false
        yearlyStepChartView.drawMarkers = false
        yearlyStepChartView.dragEnabled = false
        yearlyStepChartView.pinchZoomEnabled = false
        yearlyStepChartView.doubleTapToZoomEnabled = false
        yearlyStepChartView.highlightPerTapEnabled = false
        
        yearlyStepChartView.data?.notifyDataChanged()
        yearlyStepChartView.notifyDataSetChanged()
        yearlyStepChartView.moveViewToX(0)
        yearlyStepTimeData = []
        yearlyStepData = []
        yearlyDistanceData = []
        
        numbersOfStepMonthsForYear = 0
        numbersOfStepDaysForYear = 0
    }
    
    // MARK: -
    func startDayStepGraph() {
        
        defaults.set(realYear, forKey: "stepChangeRealYear")
        defaults.set(realMonth, forKey: "stepChangeRealMonth")
        defaults.set(realDate, forKey: "stepChangeRealDate")
        
        
        stepChangeRealYear = defaults.string(forKey:"stepChangeRealYear") ?? "\(realYear)"
        stepChangeRealMonth = defaults.string(forKey:"stepChangeRealMonth") ?? "\(realMonth)"
        stepChangeRealDate = defaults.string(forKey:"stepChangeRealDate") ?? "\(realDate)"
        
        dateStepDisplay.text = String("\(stepChangeRealYear)-\(stepChangeRealMonth)-\(stepChangeRealDate)")
        
        dayStepButton.isSelected = true
        weekStepButton.isSelected  = false
        monthStepButton.isSelected = false
        yearStepButton.isSelected = false
        
        dayStepButton.isUserInteractionEnabled = false
        weekStepButton.isUserInteractionEnabled = true
        monthStepButton.isUserInteractionEnabled = true
        yearStepButton.isUserInteractionEnabled = true
        
        dateStepDisplay.isHidden = false
        weekStepDisplay.isHidden = true
        monthStepDisplay.isHidden = true
        yearStepDisplay .isHidden = true
        
        stepDayLabel.alpha = 1.0
        stepDayValue.alpha = 1.0
        stepWeekLabel.alpha = 0.0
        stepWeekValue.alpha = 0.0
        stepMonthLabel.alpha = 0.0
        stepMonthValue.alpha = 0.0
        stepYearLabel.alpha = 0.0
        stepYearValue.alpha = 0.0
        
        distanceDayLabel.alpha = 1.0
        distanceDayValue.alpha = 1.0
        distanceWeekLabel.alpha = 0.0
        distanceWeekValue.alpha = 0.0
        distanceMonthLabel.alpha = 0.0
        distanceMonthValue.alpha = 0.0
        distanceYearLabel.alpha = 0.0
        distanceYearValue.alpha = 0.0
        
        dailyTargetStepProgress.alpha = 1.0
        dailyTargetStepProgressTextField.alpha = 1.0
        weeklyTargetStepProgress.alpha = 0.0
        weeklyTargetStepProgressTextField.alpha = 0.0
        monthlyTargetStepProgress.alpha = 0.0
        monthlyTargetStepProgressTextField.alpha = 0.0
        yearlyTargetStepProgress.alpha = 0.0
        yearlyTargetStepProgressTextField.alpha = 0.0
        
        dailyTargetDistanceProgress.alpha = 1.0
        dailyTargetDistanceProgressTextField.alpha = 1.0
        weeklyTargetDistanceProgress.alpha = 0.0
        weeklyTargetDistanceProgressTextField.alpha = 0.0
        monthlyTargetDistanceProgress.alpha = 0.0
        monthlyTargetDistanceProgressTextField.alpha = 0.0
        yearlyTargetDistanceProgress.alpha = 0.0
        yearlyTargetDistanceProgressTextField.alpha = 0.0
        
        yesterdayHourlyStepButton.isHidden = false
        tomorrowHourlyStepButton.isHidden = false
        
        lastWeekStepButton.isHidden = true
        nextWeekStepButton.isHidden = true
        
        lastMonthStepButton.isHidden = true
        nextMonthStepButton.isHidden = true
        
        lastYearStepButton.isHidden = true
        nextYearStepButton.isHidden = true
        
        yesterdayHourlyStepButton.isEnabled = true
        tomorrowHourlyStepButton.isEnabled = true
        
        lastWeekStepButton.isEnabled = false
        nextWeekStepButton.isEnabled = false
        
        lastMonthStepButton.isEnabled = false
        nextMonthStepButton.isEnabled = false
        
        lastYearStepButton.isEnabled = false
        nextYearStepButton.isEnabled = false
        
        hourlyStepChartViewGraph()
        
    }
    
    // MARK: - DayButton
    @objc func selectDayClick(sender: AnyObject) {
        
   
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -stepDateCount, to: stepTodayDate)!
        
        stepTodayDate = yesterday
        
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        
        stepChangeRealYear = syear.string(from: stepTodayDate)
        stepChangeRealMonth = smonth.string(from: stepTodayDate)
        stepChangeRealDate = sdate.string(from: stepTodayDate)
        
        
        defaults.set(stepChangeRealYear, forKey: "stepChangeRealYear")
        defaults.set(stepChangeRealMonth, forKey: "stepChangeRealMonth")
        defaults.set(stepChangeRealDate, forKey: "stepChangeRealDate")
        
        dateStepDisplay.text = String("\(stepChangeRealYear)-\(stepChangeRealMonth)-\(stepChangeRealDate)")
        
        dayStepButton.isSelected = true
        weekStepButton.isSelected  = false
        monthStepButton.isSelected = false
        yearStepButton.isSelected = false
        
        dayStepButton.isUserInteractionEnabled = false
        weekStepButton.isUserInteractionEnabled = true
        monthStepButton.isUserInteractionEnabled = true
        yearStepButton.isUserInteractionEnabled = true
        
        dateStepDisplay.isHidden = false
        weekStepDisplay.isHidden = true
        monthStepDisplay.isHidden = true
        yearStepDisplay .isHidden = true
        
        stepDayLabel.alpha = 1.0
        stepDayValue.alpha = 1.0
        stepWeekLabel.alpha = 0.0
        stepWeekValue.alpha = 0.0
        stepMonthLabel.alpha = 0.0
        stepMonthValue.alpha = 0.0
        stepYearLabel.alpha = 0.0
        stepYearValue.alpha = 0.0
        
        distanceDayLabel.alpha = 1.0
        distanceDayValue.alpha = 1.0
        distanceWeekLabel.alpha = 0.0
        distanceWeekValue.alpha = 0.0
        distanceMonthLabel.alpha = 0.0
        distanceMonthValue.alpha = 0.0
        distanceYearLabel.alpha = 0.0
        distanceYearValue.alpha = 0.0
        
        dailyTargetStepProgress.alpha = 1.0
        dailyTargetStepProgressTextField.alpha = 1.0
        weeklyTargetStepProgress.alpha = 0.0
        weeklyTargetStepProgressTextField.alpha = 0.0
        monthlyTargetStepProgress.alpha = 0.0
        monthlyTargetStepProgressTextField.alpha = 0.0
        yearlyTargetStepProgress.alpha = 0.0
        yearlyTargetStepProgressTextField.alpha = 0.0
        
        dailyTargetDistanceProgress.alpha = 1.0
        dailyTargetDistanceProgressTextField.alpha = 1.0
        weeklyTargetDistanceProgress.alpha = 0.0
        weeklyTargetDistanceProgressTextField.alpha = 0.0
        monthlyTargetDistanceProgress.alpha = 0.0
        monthlyTargetDistanceProgressTextField.alpha = 0.0
        yearlyTargetDistanceProgress.alpha = 0.0
        yearlyTargetDistanceProgressTextField.alpha = 0.0
        
        yesterdayHourlyStepButton.isHidden = false
        tomorrowHourlyStepButton.isHidden = false
        
        lastWeekStepButton.isHidden = true
        nextWeekStepButton.isHidden = true
        
        lastMonthStepButton.isHidden = true
        nextMonthStepButton.isHidden = true
        
        lastYearStepButton.isHidden = true
        nextYearStepButton.isHidden = true
        
        yesterdayHourlyStepButton.isEnabled = true
        tomorrowHourlyStepButton.isEnabled = true
        
        lastWeekStepButton.isEnabled = false
        nextWeekStepButton.isEnabled = false
        
        lastMonthStepButton.isEnabled = false
        nextMonthStepButton.isEnabled = false
        
        lastYearStepButton.isEnabled = false
        nextYearStepButton.isEnabled = false
        
        stepDateCount = 0
        
        hourlyStepChartViewGraph()
        
    }
    
    func stepYesterdayButton(){
        
        stepDateCount = stepDateCount - 1
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: stepTodayDate)!
        
        stepTodayDate = yesterday
        
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        
        stepChangeRealYear = syear.string(from: stepTodayDate)
        stepChangeRealMonth = smonth.string(from: stepTodayDate)
        stepChangeRealDate = sdate.string(from: stepTodayDate)
        
        
        dateStepDisplay.text = String("\(stepChangeRealYear)-\(stepChangeRealMonth)-\(stepChangeRealDate)")
        
        defaults.set(stepChangeRealYear, forKey:"stepChangeRealYear")
        defaults.set(stepChangeRealMonth, forKey:"stepChangeRealMonth")
        defaults.set(stepChangeRealDate, forKey:"stepChangeRealDate")
        
    }
    
    
    func stepTomorrowButton(){
        
        stepDateCount = stepDateCount + 1
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: stepTodayDate)!
        stepTodayDate = tomorrow
        
        
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        stepChangeRealYear = syear.string(from: stepTodayDate)
        stepChangeRealMonth = smonth.string(from: stepTodayDate)
        stepChangeRealDate = sdate.string(from: stepTodayDate)
        
        
        dateStepDisplay.text = String("\(stepChangeRealYear)-\(stepChangeRealMonth)-\(stepChangeRealDate)")
        
        defaults.set(stepChangeRealYear, forKey:"stepChangeRealYear")
        defaults.set(stepChangeRealMonth, forKey:"stepChangeRealMonth")
        defaults.set(stepChangeRealDate, forKey:"stepChangeRealDate")
    }
    
    
    //     ------------------------어제 내일 버튼들 시작 ----------------------
    
    
    @objc func yesterdaySelectStepButton(sender: AnyObject){
        stepYesterdayButton()
        hourlyStepChartViewGraph()
    }
    
    
    @objc func tomorrowSelectStepButton(sender: AnyObject){
        stepTomorrowButton()
        hourlyStepChartViewGraph()
    }
    
    //     ------------------------어제 내일 버튼들  끝 ----------------------
    
    //     ------------------------지난주 다음주 버튼들 시작 ----------------------
    
    // MARK: - WeekButton
    @objc func selectWeekClick(sender: AnyObject) {
        
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        hourlyStepChartView.clear()
        weeklyStepChartView.clear()
        
        
        dayStepButton.isSelected = false
        weekStepButton.isSelected  = true
        monthStepButton.isSelected = false
        yearStepButton.isSelected = false
        
        dayStepButton.isUserInteractionEnabled = true
        weekStepButton.isUserInteractionEnabled = false
        monthStepButton.isUserInteractionEnabled = true
        yearStepButton.isUserInteractionEnabled = true
        
        dateStepDisplay.isHidden = true
        weekStepDisplay.isHidden = false
        monthStepDisplay.isHidden = true
        yearStepDisplay .isHidden = true
        
        
        stepDayLabel.alpha = 0.0
        stepDayValue.alpha = 0.0
        stepWeekLabel.alpha = 1.0
        stepWeekValue.alpha = 1.0
        stepMonthLabel.alpha = 0.0
        stepMonthValue.alpha = 0.0
        stepYearLabel.alpha = 0.0
        stepYearValue.alpha = 0.0
        
        distanceDayLabel.alpha = 0.0
        distanceDayValue.alpha = 0.0
        distanceWeekLabel.alpha = 1.0
        distanceWeekValue.alpha = 1.0
        distanceMonthLabel.alpha = 0.0
        distanceMonthValue.alpha = 0.0
        distanceYearLabel.alpha = 0.0
        distanceYearValue.alpha = 0.0
        
 
        dailyTargetStepProgress.alpha = 0.0
        dailyTargetStepProgressTextField.alpha = 0.0
        weeklyTargetStepProgress.alpha = 1.0
        weeklyTargetStepProgressTextField.alpha = 1.0
        monthlyTargetStepProgress.alpha = 0.0
        monthlyTargetStepProgressTextField.alpha = 0.0
        yearlyTargetStepProgress.alpha = 0.0
        yearlyTargetStepProgressTextField.alpha = 0.0
        
        dailyTargetDistanceProgress.alpha = 0.0
        dailyTargetDistanceProgressTextField.alpha = 0.0
        weeklyTargetDistanceProgress.alpha = 1.0
        weeklyTargetDistanceProgressTextField.alpha = 1.0
        monthlyTargetDistanceProgress.alpha = 0.0
        monthlyTargetDistanceProgressTextField.alpha = 0.0
        yearlyTargetDistanceProgress.alpha = 0.0
        yearlyTargetDistanceProgressTextField.alpha = 0.0
        
        yesterdayHourlyStepButton.isHidden = true
        tomorrowHourlyStepButton.isHidden = true
        
        lastWeekStepButton.isHidden = false
        nextWeekStepButton.isHidden = false
        
        lastMonthStepButton.isHidden = true
        nextMonthStepButton.isHidden = true
        
        lastYearStepButton.isHidden = true
        nextYearStepButton.isHidden = true
        
        yesterdayHourlyStepButton.isEnabled = false
        tomorrowHourlyStepButton.isEnabled = false
        
        lastWeekStepButton.isEnabled = true
        nextWeekStepButton.isEnabled = true
        
        lastMonthStepButton.isEnabled = false
        nextMonthStepButton.isEnabled = false
        
        lastYearStepButton.isEnabled = false
        nextYearStepButton.isEnabled = false
        
        // 마지막 페이지에서 다른 페이지로 넘어갔을 경우 대비
        if nextWeekDataCheck == true {
            nextWeekDataCheck = false
            nextWeekStepButton.isEnabled = true
        }
        else if lastWeekDataCheck == true {
            lastWeekDataCheck = false
            lastWeekStepButton.isEnabled = true
        }
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                
                let numbersOfWeeklyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfWeeklyStepData = numbersOfWeeklyStepData2.count
                
                
                let weeklyStepData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyStepData10[numbersOfWeeklyStepData - 8]
                let columns10 = row10.components(separatedBy: ",")
                //                        let baseWeeklyArrYear1 = columns10[0]
                let baseWeeklyStepMonth1 = columns10[1]
                let baseWeeklyStepDate1 = columns10[2]
                
                
                
                let row20 = weeklyStepData10[numbersOfWeeklyStepData - 2]
                let columns20 = row20.components(separatedBy: ",")
                //                        let baseWeeklyArrYear2 = columns20[0]
                let baseWeeklyStepMonth2 = columns20[1]
                let baseWeeklyStepDate2 = columns20[2]
                
                
                weekStepDisplay.text = String("\(baseWeeklyStepMonth1).\(baseWeeklyStepDate1) ~ \(baseWeeklyStepMonth2).\(baseWeeklyStepDate2)")
                
                
                defaults.set(numbersOfWeeklyStepData, forKey:"numbersOfWeeklyStepData")
                
                weeklyStepChartViewGraph()
                
                newNumbersOfWeeklyStepData = numbersOfWeeklyStepData
                
            } catch  {
                print("Error reading CSV file")
            }
        }else {
            
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    
    
    
    func lastweekStepButton(){
        
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        numbersOfWeeklyStepData = defaults.integer(forKey:"numbersOfWeeklyStepData")
        numbersOfWeeklyStepData = numbersOfWeeklyStepData - 7
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && ((numbersOfWeeklyStepData - 8) > 0)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let weeklyStepData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyStepData10[numbersOfWeeklyStepData - 8]
                let columns10 = row10.components(separatedBy: ",")
                
                let baseWeeklyStepMonth1 = columns10[1]
                let baseWeeklyStepDate1 = columns10[2]
                
                let row20 = weeklyStepData10[numbersOfWeeklyStepData - 2]
                let columns20 = row20.components(separatedBy: ",")
                
                let baseWeeklyStepMonth2 = columns20[1]
                let baseWeeklyStepDate2 = columns20[2]
                
                
                weekStepDisplay.text = String("\(baseWeeklyStepMonth1).\(baseWeeklyStepDate1) ~ \(baseWeeklyStepMonth2).\(baseWeeklyStepDate2)")
                alertString = String("\(baseWeeklyStepMonth1).\(baseWeeklyStepDate1) ~ \(baseWeeklyStepMonth2).\(baseWeeklyStepDate2)")
                
                defaults.set(numbersOfWeeklyStepData, forKey:"numbersOfWeeklyStepData")
                
                weeklyStepChartViewGraph()
                weeklyStepButtonFlag = 0
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            lastWeekDataCheck = true
            lastWeekStepButton.isEnabled = false
            weeklyCalorieChartView.clear()
            defaults.set(numbersOfWeeklyStepData-7, forKey:"numbersOfWeeklyStepData")
            alertLabel.text = "이후 데이터가 없습니다.\n이전으로 돌아가세요."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "Go to next week", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                // noncontactFlag = 0
//            })
//            alert.addAction(ok)
//            present(alert,animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    
    func nextweekStepButton(){
        
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        numbersOfWeeklyStepData = defaults.integer(forKey:"numbersOfWeeklyStepData")
        numbersOfWeeklyStepData = numbersOfWeeklyStepData + 7
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && ((numbersOfWeeklyStepData - 2) < newNumbersOfWeeklyStepData) ){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let weeklyStepData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyStepData10[numbersOfWeeklyStepData - 8]
                let columns10 = row10.components(separatedBy: ",")
                //                    let baseWeeklyArrYear1 = columns10[0]
                let baseWeeklyStepMonth1 = columns10[1]
                let baseWeeklyStepDate1 = columns10[2]
                
                let row20 = weeklyStepData10[numbersOfWeeklyStepData - 2]
                let columns20 = row20.components(separatedBy: ",")
                //                    let baseWeeklyArrYear2 = columns20[0]
                let baseWeeklyStepMonth2 = columns20[1]
                let baseWeeklyStepDate2 = columns20[2]
                
                
                
                weekStepDisplay.text = String("\(baseWeeklyStepMonth1).\(baseWeeklyStepDate1) ~ \(baseWeeklyStepMonth2).\(baseWeeklyStepDate2)")
                alertString = String("\(baseWeeklyStepMonth1).\(baseWeeklyStepDate1) ~ \(baseWeeklyStepMonth2).\(baseWeeklyStepDate2)")
                
                defaults.set(numbersOfWeeklyStepData, forKey:"numbersOfWeeklyStepData")
                
                weeklyStepChartViewGraph()
                weeklyStepButtonFlag = 0
                
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            nextWeekDataCheck = true
            nextWeekStepButton.isEnabled = false
            weeklyStepChartView.clear()
            defaults.set(numbersOfWeeklyStepData+7, forKey:"numbersOfWeeklyStepData")
            alertLabel.text = "이후 데이터가 없습니다.\n이전으로 돌아가세요."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "Go to previous week", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                // noncontactFlag = 0
//            })
//            alert.addAction(ok)
//            present(alert,animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    
    @objc func lastWeekSelectStepButton(sender: AnyObject){
        
        if nextWeekDataCheck == true {
            defaults.set(numbersOfWeeklyStepData-7, forKey:"numbersOfWeeklyStepData")
            weeklyStepChartViewGraph()
            nextWeekDataCheck = false
            nextWeekStepButton.isEnabled = true
        }
        else{
            lastweekStepButton()
            weeklyStepButtonFlag = 1
        }
    }
    
    
    @objc func nextWeekSelectStepButton(sender: AnyObject){
        if lastWeekDataCheck == true {
            defaults.set(numbersOfWeeklyStepData+7, forKey:"numbersOfWeeklyStepData")
            weeklyStepChartViewGraph()
            lastWeekDataCheck = false
            lastWeekStepButton.isEnabled = true
        }
        else{
            weeklyStepButtonFlag = 1
            nextweekStepButton()
        }
    }
    //     ------------------------지난주 다음주  버튼들 끝  ----------------------
    
    //     ------------------------지난달 다음달 버튼들 시작 ----------------------
    
    
    // MARK: - MonthButton
    @objc func selectMonthClick(sender: AnyObject) {
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        hourlyStepChartView.clear()
        weeklyStepChartView.clear()
        
        
        sumOfMonthlyStep = 0
        sumOfMonthlyDistance = 0
        numbersOfStepDaysForMonth = 0
        
        dayStepButton.isSelected = false
        weekStepButton.isSelected  = false
        monthStepButton.isSelected = true
        yearStepButton.isSelected = false
        
        dayStepButton.isUserInteractionEnabled = true
        weekStepButton.isUserInteractionEnabled = true
        monthStepButton.isUserInteractionEnabled = false
        yearStepButton.isUserInteractionEnabled = true
        
        dateStepDisplay.isHidden = true
        weekStepDisplay.isHidden = true
        monthStepDisplay.isHidden = false
        yearStepDisplay .isHidden = true
        
        
        stepDayLabel.alpha = 0.0
        stepDayValue.alpha = 0.0
        stepWeekLabel.alpha = 0.0
        stepWeekValue.alpha = 0.0
        stepMonthLabel.alpha = 1.0
        stepMonthValue.alpha = 1.0
        stepYearLabel.alpha = 0.0
        stepYearValue.alpha = 0.0
        
        distanceDayLabel.alpha = 0.0
        distanceDayValue.alpha = 0.0
        distanceWeekLabel.alpha = 0.0
        distanceWeekValue.alpha = 0.0
        distanceMonthLabel.alpha = 1.0
        distanceMonthValue.alpha = 1.0
        distanceYearLabel.alpha = 0.0
        distanceYearValue.alpha = 0.0
        
        dailyTargetStepProgress.alpha = 0.0
        dailyTargetStepProgressTextField.alpha = 0.0
        weeklyTargetStepProgress.alpha = 0.0
        weeklyTargetStepProgressTextField.alpha = 0.0
        monthlyTargetStepProgress.alpha = 1.0
        monthlyTargetStepProgressTextField.alpha = 1.0
        yearlyTargetStepProgress.alpha = 0.0
        yearlyTargetStepProgressTextField.alpha = 0.0
        
        dailyTargetDistanceProgress.alpha = 0.0
        dailyTargetDistanceProgressTextField.alpha = 0.0
        weeklyTargetDistanceProgress.alpha = 0.0
        weeklyTargetDistanceProgressTextField.alpha = 0.0
        monthlyTargetDistanceProgress.alpha = 1.0
        monthlyTargetDistanceProgressTextField.alpha = 1.0
        yearlyTargetDistanceProgress.alpha = 0.0
        yearlyTargetDistanceProgressTextField.alpha = 0.0
        
        yesterdayHourlyStepButton.isHidden = true
        tomorrowHourlyStepButton.isHidden = true
        
        lastWeekStepButton.isHidden =  true
        nextWeekStepButton.isHidden =  true
        
        lastMonthStepButton.isHidden = false
        nextMonthStepButton.isHidden = false
        
        lastYearStepButton.isHidden = true
        nextYearStepButton.isHidden = true
        
        yesterdayHourlyStepButton.isEnabled = false
        tomorrowHourlyStepButton.isEnabled = false
        
        lastWeekStepButton.isEnabled = false
        nextWeekStepButton.isEnabled = false
        
        lastMonthStepButton.isEnabled = true
        nextMonthStepButton.isEnabled = true
        
        lastYearStepButton.isEnabled = false
        nextYearStepButton.isEnabled = false
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                
                let numbersOfMonthlyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyStepData = numbersOfMonthlyStepData2.count
                
                
                let weeklyStepData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyStepData - 1{
                    let row1 = weeklyStepData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let stepMonth = columns[1]
                    let stepDay = columns[2]
                    let monthlyStepDataRow = Double(columns[5])
                    let monthlyDistanceDataRow = Double(columns[6])
                    
                    if (stepMonth == realMonth){
                        
                        monthlyStepTimeData.append(stepDay)
                        monthlyStepData.append(monthlyStepDataRow ?? 0.0)
                        monthlyDistanceData.append(monthlyDistanceDataRow ?? 0.0)
                        
                        sumOfMonthlyStep = sumOfMonthlyStep + Int(monthlyStepDataRow ?? 0)
                        sumOfMonthlyDistance = sumOfMonthlyDistance + Int(monthlyDistanceDataRow ?? 0)
                        numbersOfStepDaysForMonth +=  1
                    }
                }
                
                baseStepDayOfMonth = Int(realMonth) ?? 0
                monthStepDisplay.text = String("\(realYear).\(realMonth)")
                alertString = String("\(realYear).\(realMonth)")
                
                defaults.set(sumOfMonthlyStep, forKey:"sumOfMonthlyStep")
                defaults.set(sumOfMonthlyDistance, forKey:"sumOfMonthlyDistance")
                defaults.set(baseStepDayOfMonth, forKey:"baseStepDayOfMonth")
                defaults.set(numbersOfStepDaysForMonth, forKey:"numbersOfStepDaysForMonth")
                monthlyStepChartViewGraph()
                
            } catch  {
                print("Error reading CSV file")
            }
        }else {
            
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    func lookingBottomStepDayOfMonth(){
        
        monthlyStepData = []
        monthlyDistanceData = []
        sumOfMonthlyStep = 0
        sumOfMonthlyDistance = 0
        numbersOfStepDaysForMonth = 0
        
        baseStepDayOfMonth = defaults.integer(forKey:"baseStepDayOfMonth")
        
        var s_baseStepDayOfMonth = String(baseStepDayOfMonth - 1)
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && (baseStepDayOfMonth - 1 >= 1)  {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfMonthlyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyStepData = numbersOfMonthlyStepData2.count
                
                let weeklyStepData30 = data2.components(separatedBy: .newlines)
                
                
                for i in 0 ..< numbersOfMonthlyStepData - 1{
                    let row1 = weeklyStepData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let stepMonth = columns[1]
                    let stepDay = columns[2]
                    let monthlyStepDataRow = Double(columns[5])
                    let monthlyDistanceDataRow = Double(columns[6])
                    
                    let intStepMonth = Int(stepMonth)
                    
                    if (intStepMonth == baseStepDayOfMonth - 1){
                        
                        monthlyStepTimeData.append(stepDay)
                        monthlyStepData.append(monthlyStepDataRow ?? 0.0)
                        monthlyDistanceData.append(monthlyDistanceDataRow ?? 0.0)
                        
                        s_baseStepDayOfMonth = stepMonth
                        
                        sumOfMonthlyStep = sumOfMonthlyStep + Int(monthlyStepDataRow ?? 0)
                        sumOfMonthlyDistance = sumOfMonthlyDistance + Int(monthlyDistanceDataRow ?? 0)
                        
                        numbersOfStepDaysForMonth +=  1
                    }
                }
                
                monthStepDisplay.text = String("\(realYear).\(s_baseStepDayOfMonth)")
                alertString = String("\(realYear).\(s_baseStepDayOfMonth)")
                
                defaults.set(sumOfMonthlyStep, forKey:"sumOfMonthlyStep")
                defaults.set(sumOfMonthlyDistance, forKey:"sumOfMonthlyDistance")
                defaults.set(numbersOfStepDaysForMonth, forKey:"numbersOfStepDaysForMonth")
                defaults.set(baseStepDayOfMonth - 1, forKey:"baseStepDayOfMonth")
                
                //                print(baseArrDayOfMonth - 1)
                
                monthlyStepChartViewGraph()
                monthlyStepButtonFlag = 0
            }
            catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            lastMonthDataCheck = true
            lastMonthStepButton.isEnabled = false
            monthlyStepChartView.clear()
            defaults.set(baseStepDayOfMonth - 1, forKey:"baseStepDayOfMonth")
            alertLabel.text = "이후 데이터가 없습니다.\n이전으로 돌아가세요."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "Go to Next Month", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                // noncontactFlag = 0
//            })
//            alert.addAction(ok)
//            present(alert,animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    
    @objc func lastMonthSelectStepButton(sender: AnyObject){
        
        monthlyStepButtonFlag = 1
        lookingBottomStepDayOfMonth()
        nextMonthStepButton.isEnabled = true
    }
    
    
    func lookingUpperStepDayOfMonth(){
        
        monthlyStepData = []
        monthlyDistanceData = []
        numbersOfStepDaysForMonth = 0
        sumOfMonthlyStep = 0
        sumOfMonthlyDistance = 0
        
        var thisMonthForStep = 0
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        lastMonthStepButton.isEnabled = true
        
        baseStepDayOfMonth = defaults.integer(forKey:"baseStepDayOfMonth")
        
        var s_baseStepDayOfMonth = String(baseStepDayOfMonth + 1)
        
        thisMonthForStep = Int(realMonth)!
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if ((fileManager1.fileExists(atPath: filePath1)) && ((baseStepDayOfMonth + 1) < (thisMonthForStep + 1))){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfMonthlyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyStepData = numbersOfMonthlyStepData2.count
                
                let weeklyStepData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyStepData - 1{
                    let row1 = weeklyStepData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let stepMonth = columns[1]
                    let stepDay = columns[2]
                    let monthlyStepDataRow = Double(columns[5])
                    let monthlyDistanceDataRow = Double(columns[6])
                    
                    let intStepMonth = Int(stepMonth)
                    
                    if (intStepMonth == baseStepDayOfMonth + 1){
                        
                        monthlyStepTimeData.append(stepDay)
                        monthlyStepData.append(monthlyStepDataRow ?? 0.0)
                        monthlyDistanceData.append(monthlyDistanceDataRow ?? 0.0)
                        
                        s_baseStepDayOfMonth = stepMonth
                        sumOfMonthlyStep = sumOfMonthlyStep + Int(monthlyStepDataRow ?? 0)
                        sumOfMonthlyDistance = sumOfMonthlyDistance + Int(monthlyDistanceDataRow ?? 0)
                        numbersOfStepDaysForMonth +=  1
                    }
                }
                
                defaults.set(sumOfMonthlyStep, forKey:"sumOfMonthlyStep")
                defaults.set(sumOfMonthlyDistance, forKey:"sumOfMonthlyDistance")
                
                monthStepDisplay.text = String("\(realYear).\(s_baseStepDayOfMonth)")
                alertString = String("\(realYear).\(s_baseStepDayOfMonth)")
                
                defaults.set(numbersOfStepDaysForMonth, forKey:"numbersOfStepDaysForMonth")
                defaults.set(baseStepDayOfMonth + 1, forKey:"baseStepDayOfMonth")
                
                //                print(baseArrDayOfMonth + 1)
                
                monthlyStepChartViewGraph()
                
                monthlyStepButtonFlag = 0
                
            }
            catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            nextMonthDataCheck = true
            nextMonthStepButton.isEnabled = false
            monthlyStepChartView.clear()
            defaults.set(baseStepDayOfMonth + 1, forKey:"baseStepDayOfMonth")
            alertLabel.text = "이후 데이터가 없습니다.\n이전으로 돌아가세요."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "Go to Previous Month", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                // noncontactFlag = 0
//            })
//            alert.addAction(ok)
//            present(alert,animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    
    @objc func nextMonthSelectStepButton(sender: AnyObject){
        
        monthlyStepButtonFlag = 1
        lookingUpperStepDayOfMonth()
        lastMonthStepButton.isEnabled = true
    }
    //     ------------------------지난달 다음달 버튼들 끝  ----------------------
    
    //     ------------------------지난해 다음해 버튼들 시작 ----------------------
    
    // MARK: - YearButton
    @objc func selectYearClick(sender: AnyObject) {
        
        yearlyStepChartView.clear()
        monthlyStepChartView.clear()
        hourlyStepChartView.clear()
        weeklyStepChartView.clear()
        
        sumOfYearlyStep = 0
        sumOfYearlyDistance = 0
        
        numbersOfStepMonthsForYear = 0
        
        
        dayStepButton.isSelected = false
        weekStepButton.isSelected  = false
        monthStepButton.isSelected = false
        yearStepButton.isSelected = true
        
        dayStepButton.isUserInteractionEnabled = true
        weekStepButton.isUserInteractionEnabled = true
        monthStepButton.isUserInteractionEnabled = true
        yearStepButton.isUserInteractionEnabled = false
        
        dateStepDisplay.isHidden = true
        weekStepDisplay.isHidden = true
        monthStepDisplay.isHidden = true
        yearStepDisplay .isHidden = false
        
        stepDayLabel.alpha = 0.0
        stepDayValue.alpha = 0.0
        stepWeekLabel.alpha = 0.0
        stepWeekValue.alpha = 0.0
        stepMonthLabel.alpha = 0.0
        stepMonthValue.alpha = 0.0
        stepYearLabel.alpha = 1.0
        stepYearValue.alpha = 1.0
        
        distanceDayLabel.alpha = 0.0
        distanceDayValue.alpha = 0.0
        distanceWeekLabel.alpha = 0.0
        distanceWeekValue.alpha = 0.0
        distanceMonthLabel.alpha = 0.0
        distanceMonthValue.alpha = 0.0
        distanceYearLabel.alpha = 1.0
        distanceYearValue.alpha = 1.0
        
        dailyTargetStepProgress.alpha = 0.0
        dailyTargetStepProgressTextField.alpha = 0.0
        weeklyTargetStepProgress.alpha = 0.0
        weeklyTargetStepProgressTextField.alpha = 0.0
        monthlyTargetStepProgress.alpha = 0.0
        monthlyTargetStepProgressTextField.alpha = 0.0
        yearlyTargetStepProgress.alpha = 1.0
        yearlyTargetStepProgressTextField.alpha = 1.0
        
        dailyTargetDistanceProgress.alpha = 0.0
        dailyTargetDistanceProgressTextField.alpha = 0.0
        weeklyTargetDistanceProgress.alpha = 0.0
        weeklyTargetDistanceProgressTextField.alpha = 0.0
        monthlyTargetDistanceProgress.alpha = 0.0
        monthlyTargetDistanceProgressTextField.alpha = 0.0
        yearlyTargetDistanceProgress.alpha = 1.0
        yearlyTargetDistanceProgressTextField.alpha = 1.0
        
        yesterdayHourlyStepButton.isHidden = true
        tomorrowHourlyStepButton.isHidden = true
        
        lastWeekStepButton.isHidden =  true
        nextWeekStepButton.isHidden =  true
        
        lastMonthStepButton.isHidden = true
        nextMonthStepButton.isHidden = true
        
        lastYearStepButton.isHidden = false
        nextYearStepButton.isHidden = false
        
        yesterdayHourlyStepButton.isEnabled = false
        tomorrowHourlyStepButton.isEnabled = false
        
        lastWeekStepButton.isEnabled = false
        nextWeekStepButton.isEnabled = false
        
        lastMonthStepButton.isEnabled = false
        nextMonthStepButton.isEnabled = false
        
        lastYearStepButton.isEnabled = true
        nextYearStepButton.isEnabled = true
        
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyStepData = numbersOfYearlyStepData2.count
                
                
                let yearlyStepData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyStepData - 1{
                    let row1 = yearlyStepData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let stepYear = columns[0]
                    let stepMonth = columns[1]
                    let yearlyStepDataRow = Double(columns[3])
                    let yearlyDistanceDataRow = Double(columns[4])
                    
                    intStepYear = Int(stepYear) ?? 0
                    
                    if (stepYear == realYear){
                        
                        yearlyStepTimeData.append(stepMonth)
                        yearlyStepData.append(yearlyStepDataRow ?? 0.0)
                        yearlyDistanceData.append(yearlyDistanceDataRow ?? 0.0)
                        
                        sumOfYearlyStep = sumOfYearlyStep + Int(yearlyStepDataRow ?? 0)
                        sumOfYearlyDistance = sumOfYearlyDistance + Int(yearlyDistanceDataRow ?? 0)
                        
                        numbersOfStepMonthsForYear +=  1
                    }
                }
                
                stepYearValue.text = String("\(sumOfYearlyStep)")
                distanceYearValue.text = String("\(sumOfYearlyDistance)")
                
                yearStepDisplay.text = String("\(realYear)")
                
                
                baseStepMonthOfYear  = numbersOfYearlyStepData - numbersOfStepMonthsForYear
                
                defaults.set(sumOfYearlyStep, forKey:"sumOfYearlyStep")
                defaults.set(sumOfYearlyDistance, forKey:"sumOfYearlyDistance")
                
                defaults.set(intStepYear, forKey:"currentStepYear")
                defaults.set(baseStepMonthOfYear, forKey:"baseStepMonthOfYear")
                defaults.set(numbersOfYearlyStepData, forKey:"numbersOfYearlyStepData")
                defaults.set(numbersOfStepMonthsForYear, forKey:"numbersOfStepMonthsForYear") // total number of month
                
                
                
                let fileManager2 = FileManager.default
                let documentsURL2 = fileManager2.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let directoryURL2 = documentsURL2.appendingPathComponent("dailyData")
                let fileURL2 = directoryURL2.appendingPathComponent("/dailyCalandDistanceData.csv")
                
                let filePath2 = fileURL2.path
                
                if (fileManager2.fileExists(atPath: filePath2)) && (yearlyStepButtonFlag == 0) {
                    
                    
                    do {
                        let data3 = try String(contentsOf: fileURL2)
                        
                        let numbersOfMonthlyStepData3 = data3.components(separatedBy: .newlines)
                        // 파일 데이터 행 전체 갯
                        numbersOfMonthlyStepData = numbersOfMonthlyStepData3.count
                        
                        let weeklyStepData40 = data3.components(separatedBy: .newlines)
                        
                        for i in 0 ..< numbersOfMonthlyStepData - 1{
                            let row1 = weeklyStepData40[i]
                            let columns = row1.components(separatedBy: ",")
                            let stepYear = columns[0]
                            
                            let intCountStepYear = Int(stepYear)
                            
//                            print("년도 비교: \(intCountStepYear), \(intStepYear)")
                            
                            if (intCountStepYear == intStepYear){
                                
                                numbersOfStepDaysForYear +=  1
                            }
                        }
                        
                        defaults.set(numbersOfStepDaysForYear, forKey:"numbersOfStepDaysForYear")
                        
                        if numbersOfStepDaysForYear == 0 {
                            
                            
                            
                            let alert = UIAlertController(title: "No data", message: "", preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
                                
                                // noncontactFlag = 0
                            })
                            alert.addAction(ok)
                            present(alert,animated: true, completion: nil)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alert.dismiss(animated: true, completion: nil)
                            }
                            
                        }
                    } catch  {
                        print("Error reading CSV file")
                    }
                }
                
            } catch  {
                print("Error reading CSV file")
            }
            
            yearlyStepChartViewGraph()
            
        }else {
            
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    func  lookingBottomStepMonthOfYear (){
        
        yearlyStepData = []
        yearlyDistanceData = []
        sumOfYearlyStep = 0
        sumOfYearlyDistance = 0
        
        numbersOfStepMonthsForYear = 0
        numbersOfYearlyStepData = 0
        numbersOfStepDaysForYear = 0
        
        
        baseStepMonthOfYear = defaults.integer(forKey:"baseStepMonthOfYear")
        currentStepYear = defaults.integer(forKey:"currentStepYear")
        numbersOfYearlyStepData = defaults.integer(forKey:"numbersOfYearlyStepData")
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && ((numbersOfYearlyStepData - baseStepMonthOfYear) > 1) {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyStepData = numbersOfYearlyStepData2.count
                
                let weeklyStepData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyStepData  - 1 {
                    let row1 = weeklyStepData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let stepYear = columns[0]
                    let stepMonth = columns[1]
                    let yearlyStepDataRow = Double(columns[3])
                    let yearlyDistanceDataRow = Double(columns[4])
                    
                    intStepYear = Int(stepYear) ?? 0
                    
                    if (intStepYear == currentStepYear - 1){
                        
                        numbersOfStepMonthsForYear +=  1
                        
                        yearlyStepTimeData.append(stepMonth)
                        yearlyStepData.append(yearlyStepDataRow ?? 0.0)
                        yearlyDistanceData.append(yearlyDistanceDataRow ?? 0.0)
                        
                        sumOfYearlyStep = sumOfYearlyStep + Int(yearlyStepDataRow ?? 0)
                        sumOfYearlyDistance = sumOfYearlyDistance + Int(yearlyDistanceDataRow ?? 0)
                    }
                }
                
                stepYearValue.text = String("\(sumOfYearlyStep)")
                distanceYearValue.text = String("\(sumOfYearlyDistance)")
                
                yearStepDisplay.text = String("\(intStepYear)")
                
                baseStepMonthOfYear  = numbersOfYearlyStepData - baseStepMonthOfYear - numbersOfStepMonthsForYear
                
                defaults.set(sumOfYearlyStep, forKey:"sumOfYearlyStep")
                defaults.set(sumOfYearlyDistance, forKey:"sumOfYearlyDistance")
                
                defaults.set(intStepYear, forKey:"currentStepYear")
                defaults.set(baseStepMonthOfYear, forKey:"baseStepMonthOfYear")
                defaults.set(numbersOfYearlyStepData, forKey:"numbersOfYearlyStepData")
                defaults.set(numbersOfStepMonthsForYear, forKey:"numbersOfStepMonthsForYear")
                
                
                
                let fileManager2 = FileManager.default
                let documentsURL2 = fileManager2.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let directoryURL2 = documentsURL2.appendingPathComponent("dailyData")
                let fileURL2 = directoryURL2.appendingPathComponent("/dailyCalandDistanceData.csv")
                
                let filePath2 = fileURL2.path
                
                if (fileManager2.fileExists(atPath: filePath2)) && (yearlyStepButtonFlag == 1) {
                    
                    
                    do {
                        let data3 = try String(contentsOf: fileURL2)
                        
                        let numbersOfMonthlyStepData3 = data3.components(separatedBy: .newlines)
                        // 파일 데이터 행 전체 갯
                        numbersOfMonthlyStepData = numbersOfMonthlyStepData3.count
                        
                        let weeklyStepData40 = data3.components(separatedBy: .newlines)
                        
                        for i in 0 ..< numbersOfMonthlyStepData - 1{
                            let row1 = weeklyStepData40[i]
                            let columns = row1.components(separatedBy: ",")
                            let stepYear = columns[0]
                            
                            let intCountStepYear = Int(stepYear)
                            
                            if (intCountStepYear == intStepYear){
                                
                                numbersOfStepDaysForYear +=  1
                            }
                            
                            defaults.set(numbersOfStepDaysForYear, forKey:"numbersOfStepDaysForYear")
                        }
                        
                        if numbersOfStepDaysForYear == 0 {
                            
                            let alert = UIAlertController(title: "No data", message: "", preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
                                
                                // noncontactFlag = 0
                            })
                            alert.addAction(ok)
                            present(alert,animated: true, completion: nil)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alert.dismiss(animated: true, completion: nil)
                            }
                            
                        }
                        
                    } catch  {
                        print("Error reading CSV file")
                    }
                }
                
            }
            catch  {
                print("Error reading CSV file")
            }
            
            yearlyStepChartViewGraph()
            
            
        }else {
            
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    
    @objc func lastYearSelectStepButton(sender: AnyObject){
        yearlyStepButtonFlag = 1
        lookingBottomStepMonthOfYear ()
    }
    
    func lookingUpperStepMonthOfYear(){
        
        
        yearlyStepData = []
        yearlyDistanceData = []
        sumOfYearlyStep = 0
        sumOfYearlyDistance = 0
        numbersOfYearlyStepData = 0
        numbersOfStepDaysForYear = 0
        yearlyStepButtonFlag = 0
        
        baseStepMonthOfYear = defaults.integer(forKey:"baseStepMonthOfYear")
        currentStepYear = defaults.integer(forKey:"currentStepYear")
        numbersOfYearlyStepData = defaults.integer(forKey:"numbersOfYearlyStepData")
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && ((numbersOfYearlyStepData - baseStepMonthOfYear) > 1) {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyStepData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyStepData = numbersOfYearlyStepData2.count
                
                let weeklyStepData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyStepData - 1 {
                    let row1 = weeklyStepData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let stepYear = columns[0]
                    let stepMonth = columns[1]
                    let yearlyStepDataRow = Double(columns[3])
                    let yearlyDistanceDataRow = Double(columns[4])
                    
                    intStepYear = Int(stepYear) ?? 0
                    
                    if (intStepYear == baseStepYear + 1){
                        
                        numbersOfStepMonthsForYear +=  1
                        yearlyStepTimeData.append(stepMonth)
                        
                        yearlyStepData.append(yearlyStepDataRow ?? 0.0)
                        yearlyDistanceData.append(yearlyDistanceDataRow ?? 0.0)
                        
                        sumOfYearlyStep = sumOfYearlyStep + Int(yearlyStepDataRow ?? 0)
                        sumOfYearlyDistance = sumOfYearlyDistance + Int(yearlyDistanceDataRow ?? 0)
                    }
                }
                
                stepYearValue.text = String("\(sumOfYearlyStep)")
                distanceYearValue.text = String("\(sumOfYearlyDistance)")
                
                yearStepDisplay.text = String("\(intStepYear)")
                
                baseStepMonthOfYear  = numbersOfYearlyStepData - baseStepMonthOfYear  + numbersOfStepMonthsForYear
                
                defaults.set(sumOfYearlyStep, forKey:"sumOfYearlyStep")
                defaults.set(sumOfYearlyDistance, forKey:"sumOfYearlyDistance")
                
                defaults.set(intStepYear, forKey:"currentStepYear")
                defaults.set(baseStepMonthOfYear, forKey:"baseStepMonthOfYear")
                defaults.set(numbersOfYearlyStepData, forKey:"numbersOfYearlyStepDatar")
                defaults.set(numbersOfStepMonthsForYear, forKey:"numbersOfStepMonthsForYear")
                
                
                let fileManager2 = FileManager.default
                let documentsURL2 = fileManager2.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let directoryURL2 = documentsURL2.appendingPathComponent("dailyData")
                let fileURL2 = directoryURL2.appendingPathComponent("/dailyCalandDistanceData.csv")
                
                let filePath2 = fileURL2.path
                
                if (fileManager2.fileExists(atPath: filePath2)) && (yearlyStepButtonFlag == 0) {
                    
                    
                    do {
                        let data3 = try String(contentsOf: fileURL2)
                        
                        let numbersOfMonthlyStepData3 = data3.components(separatedBy: .newlines)
                        // 파일 데이터 행 전체 갯
                        numbersOfMonthlyStepData = numbersOfMonthlyStepData3.count
                        
                        let weeklyStepData40 = data3.components(separatedBy: .newlines)
                        
                        for i in 0 ..< numbersOfMonthlyStepData - 1{
                            let row1 = weeklyStepData40[i]
                            let columns = row1.components(separatedBy: ",")
                            let stepYear = columns[0]
                            
                            let intCountStepYear = Int(stepYear)
                            
                            if (intCountStepYear == intStepYear){
                                
                                numbersOfStepDaysForYear +=  1
                            }
                            
                            defaults.set(numbersOfStepDaysForYear, forKey:"numbersOfStepDaysForYear")
                        }
                        
                        if numbersOfStepDaysForYear == 0 {
                            
                            let alert = UIAlertController(title: "No data", message: "", preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
                                
                                // noncontactFlag = 0
                            })
                            alert.addAction(ok)
                            present(alert,animated: true, completion: nil)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alert.dismiss(animated: true, completion: nil)
                            }
                            
                        }
                        
                    } catch  {
                        print("Error reading CSV file")
                    }
                }
                
                
                yearlyStepChartViewGraph()
                yearlyStepButtonFlag = 0
            }
            catch  {
                print("Error reading CSV file")
            }
        }else {
            
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    
    @objc func nextYearSelectStepButton(sender: AnyObject){
        yearlyStepButtonFlag = 1
        lookingUpperStepMonthOfYear()
    }
    
    //     ------------------------지난해 다음해 버튼들 끝  ----------------------
}

