//
//  calorieGraph.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2023/05/10.
//

import UIKit
import Foundation
import Charts
import SnapKit
import Then

let hourlyCalorieChartView = BarChartView()
let weeklyCalorieChartView = BarChartView()
let monthlyCalorieChartView = BarChartView()
let yearlyCalorieChartView = BarChartView()



var teCal = 1000
var ttcal = 5000

var hourlyTcalCalorieData: [Double] = []
var hourlyEcalCalorieData: [Double] = []
var hourlyCalorieTimeData: [String] = []

var weeklyTcalCalorieData: [Double] = []
var weeklyEcalCalorieData: [Double] = []
var weeklyCalorieTimeData: [String] = []

var monthlyTcalCalorieData: [Double] = []
var monthlyEcalCalorieData: [Double] = []
var monthlyCalorieTimeData: [String] = []

var yearlyTcalCalorieData: [Double] = []
var yearlyEcalCalorieData: [Double] = []
var yearlyCalorieTimeData: [String] = []

var numbersOfHourlyCalorieData = 0
var numbersOfWeeklyCalorieData = 0
var numbersOfMonthlyCalorieData = 0
var numbersOfYearlyCalorieData = 0

var newNumbersOfWeeklyCalorieData = 0
var newNumbersOfMonthlyCalorieData = 0

var numbersOfCalorieDaysForMonth = 0
var numbersOfCalorieMonthsForYear = 0
var numbersOfCalorieDaysForYear = 0

var sumOfHourlyTcalCalorie = 0
var sumOfWeeklyTcalCalorie = 0
var sumOfMonthlyTcalCalorie = 0
var sumOfYearlyTcalCalorie = 0

var sumOfHourlyEcalCalorie = 0
var sumOfWeeklyEcalCalorie = 0
var sumOfMonthlyEcalCalorie = 0
var sumOfYearlyEcalCalorie = 0

var sumOfMonthlyCalorieDays = 0
var sumOfYearlyCalorieDays = 0


var weeklyCalorieButtonFlag = 0
var monthlyCalorieButtonFlag = 0
var yearlyCalorieButtonFlag = 0

var baseCalorieDayOfMonth = 0
var baseCalorieMonthOfYear = 0

var calorieChangeRealYear:String = ""
var calorieChangeRealMonth:String = ""
var calorieChangeRealDate:String = ""

var calorieTodayDate = Date()
var intCalorieYear = 0
var baseCalorieYear = 0
var currentCalorieYear = 0

var calorieDateCount = 0



class calorieGraphVC : UIViewController, UITextFieldDelegate {
    
    var fCurTextfieldBottom: CGFloat = 0.0
    
    private let safeAreaView = UIView()
    
    var alertString = ""
    var alertFlag = false
    
    var nextWeekDataCheck:Bool = false
    var lastWeekDataCheck:Bool = false
    
    var nextMonthDataCheck:Bool = false
    var lastMonthDataCheck:Bool = false
    
    private func setupViewCalorie() {
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
//        $0.addTarget(self, action: #selector(calorieBpmClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var arrButton = UIButton().then {
//        $0.setImage(irregularHB, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(calorieArrClick(sender:)), for: .touchUpInside)
//    }
//
//
//    lazy var calorieButton = UIButton().then {
//        $0.setImage(calorie, for: UIControl.State.normal)
//        $0.backgroundColor = .cyan
//    }
//
//    lazy var stepButton = UIButton().then {
//        $0.setImage(step, for: UIControl.State.normal)
//
//        $0.addTarget(self, action: #selector(calorieStepClick(sender:)), for: .touchUpInside)
//    }
//
//    lazy var temperatureButton = UIButton().then {
//        $0.setImage(temperature, for: UIControl.State.normal)
//        $0.addTarget(self, action: #selector(calorieTemperatureClick(sender:)), for: .touchUpInside)
//    }
    
    
    lazy var hourlyCalorieChartView: BarChartView =  {
        let hourlyCalorieChartView = BarChartView()
        hourlyCalorieChartView.noDataText = ""
        return hourlyCalorieChartView
        
    }()
    
    lazy var weeklyCalorieChartView: BarChartView =  {
        let weeklyCalorieChartView = BarChartView()
        weeklyCalorieChartView.noDataText = ""
        return weeklyCalorieChartView
    }()
    
    
    lazy var monthlyCalorieChartView: BarChartView =  {
        let monthlyCalorieChartView = BarChartView()
        monthlyCalorieChartView.noDataText = ""
        return monthlyCalorieChartView
    }()
    
    
    lazy var yearlyCalorieChartView: BarChartView =  {
        let yearlyCalorieChartView = BarChartView()
        yearlyCalorieChartView.noDataText = ""
        return yearlyCalorieChartView
    }()
    
    
    lazy var dayCalorieButton = UIButton().then {
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
    
    
    lazy var weekCalorieButton = UIButton().then {
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
    
    
    lazy var monthCalorieButton = UIButton().then {
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
    
    lazy var yearCalorieButton = UIButton().then {
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
    
    
    lazy var dateCalorieDisplay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)-\(realDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var weekCalorieDisplay = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var monthCalorieDisplay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var yearCalorieDisplay = UILabel().then {
        $0.text = "\(realYear)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    //    -----------------------------day button-------------------
    
    lazy var yesterdayHourlyCalorieButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(yesterdaySelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var tomorrowHourlyCalorieButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(tomorrowSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------day button-------------------
    
    
    //    -----------------------------weeek button-------------------
    
    lazy var lastWeekCalorieButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastWeekSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextWeekCalorieButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextWeekSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------weeek button-------------------
    
    
    
    //    -----------------------------month button-------------------
    
    lazy var lastMonthCalorieButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastMonthSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextMonthCalorieButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextMonthSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    //    -----------------------------month button-------------------
    
    
    //    -----------------------------yearkbutton------------------
    
    lazy var lastYearCalorieButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastYearSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    lazy var nextYearCalorieButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextYearSelectCalorieButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------yearkbutton------------------
    
    
    lazy var tCalorieDayLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "총 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
//        $0.layer.cornerRadius = 10
//        $0.layer.borderWidth = 3
//        $0.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var tCalorieDayValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
//        $0.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var tCalorieWeekLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "총 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.baselineAdjustment = .alignCenters
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var tCalorieWeekValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var tCalorieMonthLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "총 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var tCalorieMonthValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var tCalorieYearLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "총 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var tCalorieYearValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    
    
    lazy var eCalorieDayLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "활동 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var eCalorieDayValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var eCalorieWeekLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "활동 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.baselineAdjustment = .alignCenters
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var eCalorieWeekValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var eCalorieMonthLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "활동 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var eCalorieMonthValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var eCalorieYearLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "활동 칼로리 (Kcal)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var eCalorieYearValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = UIColor.lableBackground
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    

    lazy var dailyTargetTotalCalorieProgress = UIProgressView().then {
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
    
    
    lazy var dailyTargetTotalCalorieProgressTextField = UILabel().then {
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
    
    
    lazy var weeklyTargetTotalCalorieProgress = UIProgressView().then {
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
    
    
    lazy var weeklyTargetTotalCalorieProgressTextField = UILabel().then {
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
    

    lazy var monthlyTargetTotalCalorieProgress = UIProgressView().then {
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
    
    
    lazy var monthlyTargetTotalCalorieProgressTextField = UILabel().then {
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

    
    lazy var yearlyTargetTotalCalorieProgress = UIProgressView().then {
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
    
    
    lazy var yearlyTargetTotalCalorieProgressTextField = UILabel().then {
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

    
    lazy var dailyTargetExerciseCalorieProgress = UIProgressView().then {
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
    
    
    lazy var dailyTargetExerciseCalorieProgressTextField = UILabel().then {
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

    
    lazy var weeklyTargetExerciseCalorieProgress = UIProgressView().then {
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
    
    
    lazy var weeklyTargetExerciseCalorieProgressTextField = UILabel().then {
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

    lazy var monthlyTargetExerciseCalorieProgress = UIProgressView().then {
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
    
    
    lazy var monthlyTargetExerciseCalorieProgressTextField = UILabel().then {
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

    
    lazy var yearlyTargetExerciseCalorieProgress = UIProgressView().then {
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
    
    
    lazy var yearlyTargetExerciseCalorieProgressTextField = UILabel().then {
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
    func calorieviews(){
    
        view.addSubview(hourlyCalorieChartView)
        hourlyCalorieChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
        }
        
        view.addSubview(weeklyCalorieChartView)
        weeklyCalorieChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyCalorieChartView.snp.bottom)
        }
        
        view.addSubview(monthlyCalorieChartView)
        monthlyCalorieChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyCalorieChartView.snp.bottom)
        }
        
        view.addSubview(yearlyCalorieChartView)
        yearlyCalorieChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.width.equalTo(self.safeAreaView.snp.width)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyCalorieChartView.snp.bottom)
        }
        
        let buttonStackView2: UIStackView = {
            let buttonStackView2 = UIStackView(arrangedSubviews: [dayCalorieButton, weekCalorieButton, monthCalorieButton, yearCalorieButton])
            buttonStackView2.axis = .horizontal
            buttonStackView2.distribution = .fillEqually // default
            buttonStackView2.alignment = .fill // default
            buttonStackView2.spacing = 20.0
            //            buttonStackView2.backgroundColor = .gray
            
            view.addSubview(buttonStackView2)
            
            
            self.dayCalorieButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)

            }
            self.weekCalorieButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            
            self.monthCalorieButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            
            self.yearCalorieButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
                $0.trailing.equalTo(buttonStackView2)
                
            }
            
            return buttonStackView2
        }()
        
        
        buttonStackView2.snp.makeConstraints { (make) in
            
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.top.equalTo(self.hourlyCalorieChartView.snp.bottom)
            make.height.equalTo(50)
        }
        
        
        //        -----------------------day button position--------------------
        
        view.addSubview(yesterdayHourlyCalorieButton)
        yesterdayHourlyCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(dateCalorieDisplay)
        dateCalorieDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(yesterdayHourlyCalorieButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tomorrowHourlyCalorieButton)
        tomorrowHourlyCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(dateCalorieDisplay.snp.trailing).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------day button position--------------------
        
        
        //        -----------------------week button position--------------------
        
        view.addSubview(lastWeekCalorieButton)
        lastWeekCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(weekCalorieDisplay)
        weekCalorieDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(lastWeekCalorieButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(nextWeekCalorieButton)
        nextWeekCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(weekCalorieDisplay.snp.trailing).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------week button position--------------------
        
        
        //        -----------------------month button position--------------------
        
        
        view.addSubview(lastMonthCalorieButton)
        lastMonthCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(monthCalorieDisplay)
        monthCalorieDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(lastMonthCalorieButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextMonthCalorieButton)
        nextMonthCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(monthCalorieDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------month button position--------------------
        
        
        
        //        -----------------------year button position--------------------
        
        
        view.addSubview(lastYearCalorieButton)
        lastYearCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(yearCalorieDisplay)
        yearCalorieDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(lastYearCalorieButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextYearCalorieButton)
        nextYearCalorieButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(10)
            make.leading.equalTo(yearCalorieDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        
        //        -----------------------year button position--------------------
        
        view.addSubview(tCalorieDayLabel)
        tCalorieDayLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tCalorieDayValue)
        tCalorieDayValue.snp.makeConstraints {(make) in
            make.leading.equalTo(tCalorieDayLabel.snp.trailing)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tCalorieWeekLabel)
        tCalorieWeekLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tCalorieWeekValue)
        tCalorieWeekValue.snp.makeConstraints {(make) in
            make.leading.equalTo(tCalorieWeekLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tCalorieMonthLabel)
        tCalorieMonthLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tCalorieMonthValue)
        tCalorieMonthValue.snp.makeConstraints {(make) in
            make.leading.equalTo(tCalorieMonthLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tCalorieYearLabel)
        tCalorieYearLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tCalorieYearValue)
        tCalorieYearValue.snp.makeConstraints {(make) in
            make.leading.equalTo(tCalorieYearLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyCalorieButton.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        //  ---------------------------- calorie ------------------------------
        
        view.addSubview(dailyTargetTotalCalorieProgress)
        dailyTargetTotalCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
//            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(15)
            make.top.equalTo(tCalorieDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }

        view.addSubview(dailyTargetTotalCalorieProgressTextField)
        dailyTargetTotalCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(dailyTargetTotalCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }
        

        view.addSubview(weeklyTargetTotalCalorieProgress)
        weeklyTargetTotalCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(15)
            make.height.equalTo(12)
        }

        view.addSubview(weeklyTargetTotalCalorieProgressTextField)
        weeklyTargetTotalCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(weeklyTargetTotalCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }

        view.addSubview(monthlyTargetTotalCalorieProgress)
        monthlyTargetTotalCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(15)
            make.height.equalTo(12)
        }

        view.addSubview(monthlyTargetTotalCalorieProgressTextField)
        monthlyTargetTotalCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(monthlyTargetTotalCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }


        view.addSubview(yearlyTargetTotalCalorieProgress)
        yearlyTargetTotalCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(15)
            make.height.equalTo(12)
        }

        view.addSubview(yearlyTargetTotalCalorieProgressTextField)
        yearlyTargetTotalCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(yearlyTargetTotalCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(tCalorieDayValue.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }
        
        
        //  ---------------------------- calorie ------------------------------
        
        
        view.addSubview(eCalorieDayLabel)
        eCalorieDayLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }


        view.addSubview(eCalorieDayValue)
        eCalorieDayValue.snp.makeConstraints {(make) in
            make.leading.equalTo(eCalorieDayLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }


        view.addSubview(eCalorieWeekLabel)
        eCalorieWeekLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }


        view.addSubview(eCalorieWeekValue)
        eCalorieWeekValue.snp.makeConstraints {(make) in
            make.leading.equalTo(eCalorieWeekLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }

        view.addSubview(eCalorieMonthLabel)
        eCalorieMonthLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }


        view.addSubview(eCalorieMonthValue)
        eCalorieMonthValue.snp.makeConstraints {(make) in
            make.leading.equalTo(eCalorieMonthLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }


        view.addSubview(eCalorieYearLabel)
        eCalorieYearLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.width.equalTo(TwoOfThreeSafeAreaWidth)
            make.height.equalTo(40)
        }


        view.addSubview(eCalorieYearValue)
        eCalorieYearValue.snp.makeConstraints {(make) in
            make.leading.equalTo(eCalorieYearLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(dailyTargetTotalCalorieProgressTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
        //  ---------------------------- calorie ------------------------------
        view.addSubview(dailyTargetExerciseCalorieProgress)
        dailyTargetExerciseCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }


        view.addSubview(dailyTargetExerciseCalorieProgressTextField)
        dailyTargetExerciseCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(dailyTargetExerciseCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }

        
        view.addSubview(weeklyTargetExerciseCalorieProgress)
        weeklyTargetExerciseCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }


        view.addSubview(weeklyTargetExerciseCalorieProgressTextField)
        weeklyTargetExerciseCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(weeklyTargetExerciseCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }


        view.addSubview(monthlyTargetExerciseCalorieProgress)
        monthlyTargetExerciseCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }


        view.addSubview(monthlyTargetExerciseCalorieProgressTextField)
        monthlyTargetExerciseCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(monthlyTargetExerciseCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }

        view.addSubview(yearlyTargetExerciseCalorieProgress)
        yearlyTargetExerciseCalorieProgress.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(15)
            make.height.equalTo(12)
        }


        view.addSubview(yearlyTargetExerciseCalorieProgressTextField)
        yearlyTargetExerciseCalorieProgressTextField.snp.makeConstraints {(make) in
            make.leading.equalTo(yearlyTargetExerciseCalorieProgress.snp.trailing).offset(10)
            make.top.equalTo(eCalorieDayLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.width.equalTo(80)
        }
        //  ---------------------------- calorie ------------------------------
        // MARK: - AlertConstraint
        view.addSubview(alertBackground)
        view.addSubview(alertLabel)
        
        alertBackground.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertBackground.leadingAnchor.constraint(equalTo: hourlyCalorieChartView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            alertBackground.centerXAnchor.constraint(equalTo: hourlyCalorieChartView.centerXAnchor),
            alertBackground.centerYAnchor.constraint(equalTo: hourlyCalorieChartView.centerYAnchor),
            
            alertBackground.heightAnchor.constraint(equalToConstant: 120),
            
            
            alertLabel.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
        ])
        
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        teCal = defaults.integer(forKey: "TargeteCal")
        ttcal = defaults.integer(forKey: "TargettCal")
        
        setupViewCalorie()
        calorieviews()
        startDayCalorieGraph()
        
        tCalorieDayLabel.alpha = 1.0
        tCalorieDayValue.alpha = 1.0
        tCalorieWeekLabel.alpha = 0.0
        tCalorieWeekValue.alpha = 0.0
        tCalorieMonthLabel.alpha = 0.0
        tCalorieMonthValue.alpha = 0.0
        tCalorieYearLabel.alpha = 0.0
        tCalorieYearValue.alpha = 0.0
        
        eCalorieDayLabel.alpha = 1.0
        eCalorieDayValue.alpha = 1.0
        eCalorieWeekLabel.alpha = 0.0
        eCalorieWeekValue.alpha = 0.0
        eCalorieMonthLabel.alpha = 0.0
        eCalorieMonthValue.alpha = 0.0
        eCalorieYearLabel.alpha = 0.0
        eCalorieYearValue.alpha = 0.0
        
        dailyTargetTotalCalorieProgress.alpha = 1.0
        dailyTargetTotalCalorieProgressTextField.alpha = 1.0
        weeklyTargetTotalCalorieProgress.alpha = 0.0
        weeklyTargetTotalCalorieProgressTextField.alpha = 0.0
        monthlyTargetTotalCalorieProgress.alpha = 0.0
        monthlyTargetTotalCalorieProgressTextField.alpha = 0.0
        yearlyTargetTotalCalorieProgress.alpha = 0.0
        yearlyTargetTotalCalorieProgressTextField.alpha = 0.0
        
        dailyTargetExerciseCalorieProgress.alpha = 1.0
        dailyTargetExerciseCalorieProgressTextField.alpha = 1.0
        weeklyTargetExerciseCalorieProgress.alpha = 0.0
        weeklyTargetExerciseCalorieProgressTextField.alpha = 0.0
        monthlyTargetExerciseCalorieProgress.alpha = 0.0
        monthlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        yearlyTargetExerciseCalorieProgress.alpha = 0.0
        yearlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        
        
        dayCalorieButton.isSelected = true
        weekCalorieButton.isSelected  = false
        monthCalorieButton.isSelected = false
        yearCalorieButton.isSelected = false
        
        dateCalorieDisplay.isHidden = false
        weekCalorieDisplay.isHidden = true
        monthCalorieDisplay.isHidden = true
        yearCalorieDisplay.isHidden = true
        
        yesterdayHourlyCalorieButton.isHidden = false
        tomorrowHourlyCalorieButton.isHidden = false
        
        lastWeekCalorieButton.isHidden = true
        nextWeekCalorieButton.isHidden = true
        
        lastMonthCalorieButton.isHidden = true
        nextMonthCalorieButton.isHidden = true
        
        lastYearCalorieButton.isHidden = true
        nextYearCalorieButton.isHidden = true
        
        yesterdayHourlyCalorieButton.isEnabled = true
        tomorrowHourlyCalorieButton.isEnabled = true
        
        lastWeekCalorieButton.isEnabled = false
        nextWeekCalorieButton.isEnabled = false
        
        lastMonthCalorieButton.isEnabled = false
        nextMonthCalorieButton.isEnabled = false
        
        lastYearCalorieButton.isEnabled = false
        nextYearCalorieButton.isEnabled = false
        
//        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(calorieTimer), userInfo: nil, repeats: true)
    }
    
    
    
//    @objc func calorieTimer(){
//
//
//        tCalorieDayValue.text = String(sumOfHourlyTcalCalorie)
//        tCalorieWeekValue.text = String(sumOfWeeklyTcalCalorie)
//        tCalorieMonthValue.text = String(sumOfMonthlyTcalCalorie)
//        tCalorieYearValue.text = String(sumOfYearlyTcalCalorie)
//
//
//        eCalorieDayValue.text = String(sumOfHourlyEcalCalorie)
//        eCalorieWeekValue.text = String(sumOfWeeklyEcalCalorie)
//        eCalorieMonthValue.text = String(sumOfMonthlyEcalCalorie)
//        eCalorieYearValue.text = String(sumOfYearlyEcalCalorie)
//
//    }
//
    // MARK: - hourly
    func hourlyCalorieChartViewGraph(){
        
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        
        sumOfHourlyTcalCalorie = 0
        sumOfHourlyEcalCalorie = 0
        
        alertFlag = false
        alertString = ""
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("\(calorieChangeRealYear)/\(calorieChangeRealMonth)/\(calorieChangeRealDate)")
        let fileURL1 = directoryURL1.appendingPathComponent("/calandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if fileManager1.fileExists(atPath: filePath1){
            
            do {
                let data1 = try String(contentsOf: fileURL1)
                
                let hourlyCalorieData1 = data1.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfHourlyCalorieData = hourlyCalorieData1.count
                
                for i in 0 ..< numbersOfHourlyCalorieData - 1 {
                    let row1 = hourlyCalorieData1[i]
                    let columns1 = row1.components(separatedBy: ",")
                    let hourlyCalorieTimeRow = columns1[0]
                    let hourlyTcalCalorieDataRow = Double(columns1[4])
                    let hourlyEcalCalorieDataRow = Double(columns1[5])
                    
                    sumOfHourlyTcalCalorie = sumOfHourlyTcalCalorie + Int(hourlyTcalCalorieDataRow ?? 0)
                    sumOfHourlyEcalCalorie = sumOfHourlyEcalCalorie + Int(hourlyEcalCalorieDataRow ?? 0)
                    
                    hourlyCalorieTimeData.append(hourlyCalorieTimeRow)
                    hourlyTcalCalorieData.append(hourlyTcalCalorieDataRow  ?? 0.0)
                    hourlyEcalCalorieData.append(hourlyEcalCalorieDataRow  ?? 0.0)
                }
                
           
                tCalorieDayValue.text = String(sumOfHourlyTcalCalorie)
                eCalorieDayValue.text = String(sumOfHourlyEcalCalorie)
                     
                
                let dailyTcalorieRatio = Double(sumOfHourlyTcalCalorie) / Double(ttcal)
                let dailyPTcalorieRatio = dailyTcalorieRatio * 100
                dailyTargetTotalCalorieProgress.progress = Float(dailyTcalorieRatio)
                let dailyIntTcalorieRatio = Int(dailyPTcalorieRatio)
                
                dailyTargetTotalCalorieProgressTextField.text = String(dailyIntTcalorieRatio) + "%"
 
                let dailyEcalorieRatio = Double(sumOfHourlyEcalCalorie) / Double(teCal)
                let dailyPEcalorieRatio = dailyEcalorieRatio * 100
                dailyTargetExerciseCalorieProgress.progress = Float(dailyEcalorieRatio)
                let dailyIntEcalorieRatio = Int(dailyPEcalorieRatio)
                
                
                
                dailyTargetExerciseCalorieProgressTextField.text = String(dailyIntEcalorieRatio) + "%"
                
                
                
            } catch  {
                print("Error reading CSV file")
            }
            
            var hourlyTcalCalorieDataEntries = [BarChartDataEntry]()
            var hourlyEcalCalorieDataEntries = [BarChartDataEntry]()
            
            for i in 0 ..< numbersOfHourlyCalorieData - 1 {
                let hourlyTcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: hourlyTcalCalorieData[i])
                hourlyTcalCalorieDataEntries.append(hourlyTcalCalorieDataEntry)
            }
            
            
            for i in 0 ..< numbersOfHourlyCalorieData - 1 {
                let hourlyEcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: hourlyEcalCalorieData[i] )
                hourlyEcalCalorieDataEntries.append(hourlyEcalCalorieDataEntry)
            }
            
            let hourlyTcalCalorieChartDataSet = BarChartDataSet(entries: hourlyTcalCalorieDataEntries, label: "총 칼로리 (Kcal)                    ")
            hourlyTcalCalorieChartDataSet.setColor(NSUIColor.red)
            hourlyTcalCalorieChartDataSet.drawValuesEnabled = false
            
            let hourlyEcalCalorieChartDataSet = BarChartDataSet(entries:  hourlyEcalCalorieDataEntries, label: "활동 칼로리 (Kcal)")
            hourlyEcalCalorieChartDataSet.setColor(NSUIColor.blue)
            hourlyEcalCalorieChartDataSet.drawValuesEnabled = false
            
            let dataSets: [BarChartDataSet] = [hourlyTcalCalorieChartDataSet, hourlyEcalCalorieChartDataSet]
            
            let chartData = BarChartData(dataSets: dataSets)
            
            let groupSpace = 0.3
            let barSpace = 0.05
            let barWidth = 0.3
            
            chartData.barWidth = barWidth
            
            hourlyCalorieChartView.xAxis.axisMinimum = Double(0)
            hourlyCalorieChartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(numbersOfHourlyCalorieData - 1)  // group count : 2
            chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
            
            hourlyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            hourlyCalorieChartView.noDataText = ""
            hourlyCalorieChartView.data = chartData
            hourlyCalorieChartView.xAxis.enabled = true
            hourlyCalorieChartView.xAxis.centerAxisLabelsEnabled = true
            hourlyCalorieChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hourlyCalorieTimeData)
            hourlyCalorieChartView.xAxis.granularity = 1
            hourlyCalorieChartView.xAxis.setLabelCount(numbersOfHourlyCalorieData, force: false)
            hourlyCalorieChartView.xAxis.labelPosition = .bottom
            hourlyCalorieChartView.xAxis.drawGridLinesEnabled = false
            
            hourlyCalorieChartView.leftAxis.granularityEnabled = true
            hourlyCalorieChartView.leftAxis.granularity = 1.0
            
            hourlyCalorieChartView.leftAxis.axisMinimum = 0
            hourlyCalorieChartView.rightAxis.enabled = false
            hourlyCalorieChartView.drawMarkers = false
            hourlyCalorieChartView.dragEnabled = false
            hourlyCalorieChartView.pinchZoomEnabled = false
            hourlyCalorieChartView.doubleTapToZoomEnabled = false
            hourlyCalorieChartView.highlightPerTapEnabled = false
            
            hourlyCalorieChartView.data?.notifyDataChanged()
            hourlyCalorieChartView.notifyDataSetChanged()
            hourlyCalorieChartView.moveViewToX(0)
            hourlyCalorieTimeData = []
            hourlyTcalCalorieData = []
            hourlyEcalCalorieData = []
            
        }
        else{
            alertFlag = true
            alertString += "\(calorieChangeRealYear)/\(calorieChangeRealMonth)/\(calorieChangeRealDate)\n"
        }
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            alertLabel.text = alertString + "데이터가 없습니다."
        }
//        else {
//
//            let alert = UIAlertController(title: "No data", message: "on \(calorieChangeRealYear)/\(calorieChangeRealMonth)/\(calorieChangeRealDate)", preferredStyle: UIAlertController.Style.alert)
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
    func weeklyCalorieChartViewGraph(){
        
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        
        sumOfWeeklyTcalCalorie = 0
        sumOfWeeklyEcalCalorie = 0
        
        var alertCheck = 0
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true

        numbersOfWeeklyCalorieData = defaults.integer(forKey:"numbersOfWeeklyCalorieData")
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if fileManager1.fileExists(atPath: filePath1) {
            
            do {
                let data1 = try String(contentsOf: fileURL1)
                
                //
                let weeklyCalorieData1 = data1.components(separatedBy: .newlines)
                //                // 파일 데이터 행 전체 갯
                //                numbersOfHourlyArr = hourlyArrData1.count
                
                for i in numbersOfWeeklyCalorieData - 8 ..< numbersOfWeeklyCalorieData - 1{
                    let row1 = weeklyCalorieData1[i]
                    let columns = row1.components(separatedBy: ",")
                    let weeklyCalorieTimeRow = columns[3]
                    let weeklyTcalCalorieDataRow = Double(columns[7])
                    let weeklyEcalCalorieDataRow = Double(columns[8])
                    
                    sumOfWeeklyTcalCalorie = sumOfWeeklyTcalCalorie + Int(weeklyTcalCalorieDataRow ?? 0)
                    sumOfWeeklyEcalCalorie = sumOfWeeklyEcalCalorie + Int(weeklyEcalCalorieDataRow ?? 0)
                    
                    weeklyCalorieTimeData.append(weeklyCalorieTimeRow)
                    weeklyTcalCalorieData.append(weeklyTcalCalorieDataRow ?? 0.0)
                    weeklyEcalCalorieData.append(weeklyEcalCalorieDataRow ?? 0.0)
                    
                }
                
                // 데이터 체크
                for i in 0..<7 {
                    if weeklyTcalCalorieData[i] == 0.0 {
                        alertCheck += 1
                    }
                    if weeklyEcalCalorieData[i] == 0.0 {
                        alertCheck += 1
                    }
                    if alertCheck == 14 {
                        alertFlag = true
                    }
                    
                    // 영문 -> 한글
                    if weeklyCalorieTimeData[i] == "Mon" {
                        weeklyCalorieTimeData[i] = "월"
                    }
                    else if weeklyCalorieTimeData[i] == "Tue" {
                        weeklyCalorieTimeData[i] = "화"
                    }
                    else if weeklyCalorieTimeData[i] == "Wed" {
                        weeklyCalorieTimeData[i] = "수"
                    }
                    else if weeklyCalorieTimeData[i] == "Thu" {
                        weeklyCalorieTimeData[i] = "목"
                    }
                    else if weeklyCalorieTimeData[i] == "Fri" {
                        weeklyCalorieTimeData[i] = "금"
                    }
                    else if weeklyCalorieTimeData[i] == "Sat" {
                        weeklyCalorieTimeData[i] = "토"
                    }
                    else if weeklyCalorieTimeData[i] == "Sun" {
                        weeklyCalorieTimeData[i] = "일"
                    }
                }
                
                
                tCalorieWeekValue.text = String(sumOfWeeklyTcalCalorie)
                eCalorieWeekValue.text = String(sumOfWeeklyEcalCalorie)
             
                let weeklyTcalorieRatio = Double(sumOfWeeklyTcalCalorie) / Double(ttcal * 7)
                let weeklyPTcalorieRatio = weeklyTcalorieRatio * 100
                weeklyTargetTotalCalorieProgress.progress = Float(weeklyTcalorieRatio)
                let weeklyIntTcalorieRatio = Int(weeklyPTcalorieRatio)
                
                weeklyTargetTotalCalorieProgressTextField.text = String(weeklyIntTcalorieRatio) + "%"
                
                
                let weeklyEcalorieRatio = Double(sumOfWeeklyEcalCalorie) / Double(teCal * 7)
                let weeklyPEcalorieRatio = weeklyEcalorieRatio * 100
                weeklyTargetExerciseCalorieProgress.progress = Float(weeklyEcalorieRatio)
                let weeklyIntEcalorieRatio = Int(weeklyPEcalorieRatio)
                
                
                weeklyTargetExerciseCalorieProgressTextField.text = String(weeklyIntEcalorieRatio) + "%"
                
            } catch  {
                print("Error reading CSV file")
                
            }
            
            let weekNumber = 7
            
            var weeklyTcalCalorieDataEntries = [BarChartDataEntry]()
            var weeklyEcalCalorieDataEntries = [BarChartDataEntry]()
            
            for i in 0 ..< weekNumber {
                let weeklyTcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: weeklyTcalCalorieData[i])
                weeklyTcalCalorieDataEntries.append(weeklyTcalCalorieDataEntry)
            }
            
            
            for i in 0 ..< weekNumber {
                let weeklyEcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: weeklyEcalCalorieData[i])
                weeklyEcalCalorieDataEntries.append(weeklyEcalCalorieDataEntry)
            }
            
            
            let weeklyTcalCalorieChartDataSet = BarChartDataSet(entries: weeklyTcalCalorieDataEntries, label: "총 칼로리 (Kcal)                    ")
            weeklyTcalCalorieChartDataSet.setColor(NSUIColor.red)
            weeklyTcalCalorieChartDataSet.drawValuesEnabled = false
            
            
            let weeklyEcalCalorieChartDataSet = BarChartDataSet(entries: weeklyEcalCalorieDataEntries, label: "활동 칼로리 (Kcal)")
            weeklyEcalCalorieChartDataSet.setColor(NSUIColor.blue)
            weeklyEcalCalorieChartDataSet.drawValuesEnabled = false
            
            let weeklyCaloriedataSets: [BarChartDataSet] = [weeklyTcalCalorieChartDataSet, weeklyEcalCalorieChartDataSet]
            
            let chartData = BarChartData(dataSets: weeklyCaloriedataSets)
            
            let groupSpace = 0.3
            let barSpace = 0.05
            let barWidth = 0.3
            
            chartData.barWidth = barWidth
            
            weeklyCalorieChartView.xAxis.axisMinimum = Double(0)
            weeklyCalorieChartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(7)  // group count : 2
            chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
            
            weeklyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            weeklyCalorieChartView.noDataText = ""
            weeklyCalorieChartView.data = chartData
            weeklyCalorieChartView.xAxis.enabled = true
            
            weeklyCalorieChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weeklyCalorieTimeData)
            weeklyCalorieChartView.xAxis.granularity = 1
            weeklyCalorieChartView.xAxis.setLabelCount(7, force: false)
            weeklyCalorieChartView.xAxis.centerAxisLabelsEnabled = true
            weeklyCalorieChartView.xAxis.labelPosition = .bottom
            weeklyCalorieChartView.xAxis.drawGridLinesEnabled = false
            weeklyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            weeklyCalorieChartView.leftAxis.granularityEnabled = true
            weeklyCalorieChartView.leftAxis.granularity = 1.0
            weeklyCalorieChartView.leftAxis.axisMinimum = 0
            weeklyCalorieChartView.rightAxis.enabled = false
            weeklyCalorieChartView.drawMarkers = false
            weeklyCalorieChartView.dragEnabled = false
            weeklyCalorieChartView.pinchZoomEnabled = false
            weeklyCalorieChartView.doubleTapToZoomEnabled = false
            weeklyCalorieChartView.highlightPerTapEnabled = false
            
            weeklyCalorieChartView.data?.notifyDataChanged()
            weeklyCalorieChartView.notifyDataSetChanged()
            weeklyCalorieChartView.moveViewToX(0)
            weeklyCalorieTimeData = []
            weeklyTcalCalorieData = []
            weeklyEcalCalorieData = []
            
        }
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            weeklyCalorieChartView.clear()
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
    func monthlyCalorieChartViewGraph(){
        
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        
        var alertCheck = 0
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        for _ in 0..<20 {
            monthlyCalorieChartView.zoomOut()
        }
        numbersOfCalorieDaysForMonth = defaults.integer(forKey:"numbersOfCalorieDaysForMonth")
        
        let monthlyTcalorieRatio = Double(sumOfMonthlyTcalCalorie) / Double(ttcal * numbersOfCalorieDaysForMonth)
        let monthlyPTcalorieRatio = monthlyTcalorieRatio * 100
        monthlyTargetTotalCalorieProgress.progress = Float(monthlyTcalorieRatio)
        let monthlyIntTcalorieRatio = Int(monthlyPTcalorieRatio)

        monthlyTargetTotalCalorieProgressTextField.text = String(monthlyIntTcalorieRatio) + "%"

        let monthlyEcalorieRatio = Double(sumOfMonthlyEcalCalorie) / Double(teCal * numbersOfCalorieDaysForMonth)
        let monthlyPEcalorieRatio = monthlyEcalorieRatio * 100
        monthlyTargetExerciseCalorieProgress.progress = Float(monthlyEcalorieRatio)
        let monthlyIntEcalorieRatio = Int(monthlyPEcalorieRatio)
        
        
        monthlyTargetExerciseCalorieProgressTextField.text = String(monthlyIntEcalorieRatio) + "%"
  
        var monthlyTcalCalorieDataEntries = [BarChartDataEntry]()
        var monthlyEcalCalorieDataEntries = [BarChartDataEntry]()
        
        for i in 0 ..< numbersOfCalorieDaysForMonth {
            let monthlyTcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: monthlyTcalCalorieData[i])
            monthlyTcalCalorieDataEntries.append(monthlyTcalCalorieDataEntry)
            
            if monthlyTcalCalorieData[i] == 0.0 { // 데이터 체크
                alertCheck += 1
            }
        }
        
        
        for i in 0 ..< numbersOfCalorieDaysForMonth {
            let monthlyEcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: monthlyEcalCalorieData[i])
            monthlyEcalCalorieDataEntries.append(monthlyEcalCalorieDataEntry)
            
            if monthlyEcalCalorieData[i] == 0.0 { // 데이터 체크
                alertCheck += 1
            }
        }
        
        // 데이터가 다 비어있는지 체크
        if (monthlyCalorieTimeData.count * 2) == alertCheck {
            alertFlag = true
        }
        
        tCalorieMonthValue.text = String(sumOfMonthlyTcalCalorie)
        eCalorieMonthValue.text = String(sumOfMonthlyEcalCalorie)
       
        
        let monthlyTcalCalorieChartDataSet = BarChartDataSet(entries: monthlyTcalCalorieDataEntries, label: "총 칼로리 (Kcal)                    ")
        monthlyTcalCalorieChartDataSet.setColor(NSUIColor.red)
        monthlyTcalCalorieChartDataSet.drawValuesEnabled = false
        
        
        let monthlyEcalCalorieChartDataSet = BarChartDataSet(entries: monthlyEcalCalorieDataEntries, label: "활동 칼로리 (Kcal)")
        monthlyEcalCalorieChartDataSet.setColor(NSUIColor.blue)
        monthlyEcalCalorieChartDataSet.drawValuesEnabled = false
        
        let monthlyCaloriedataSets: [BarChartDataSet] = [monthlyTcalCalorieChartDataSet,monthlyEcalCalorieChartDataSet]
        
        let chartData = BarChartData(dataSets: monthlyCaloriedataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        chartData.barWidth = barWidth
        
        monthlyCalorieChartView.xAxis.axisMinimum = Double(0)
        monthlyCalorieChartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(numbersOfCalorieDaysForMonth)  // group count : 2
        chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        
        monthlyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        monthlyCalorieChartView.noDataText = ""
        monthlyCalorieChartView.data = chartData
        monthlyCalorieChartView.xAxis.enabled = true
        
        monthlyCalorieChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthlyCalorieTimeData)
        monthlyCalorieChartView.xAxis.granularity = 1.0
        monthlyCalorieChartView.xAxis.setLabelCount(numbersOfCalorieDaysForMonth, force: false)
        monthlyCalorieChartView.xAxis.centerAxisLabelsEnabled = true
        monthlyCalorieChartView.xAxis.labelPosition = .bottom
        monthlyCalorieChartView.xAxis.drawGridLinesEnabled = false
        monthlyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        monthlyCalorieChartView.setVisibleXRangeMaximum(10)
        monthlyCalorieChartView.leftAxis.granularityEnabled = true
        monthlyCalorieChartView.leftAxis.granularity = 1.0
        monthlyCalorieChartView.leftAxis.axisMinimum = 0
        monthlyCalorieChartView.rightAxis.enabled = false
        monthlyCalorieChartView.drawMarkers = false
        monthlyCalorieChartView.dragEnabled = true
        monthlyCalorieChartView.pinchZoomEnabled = false
        monthlyCalorieChartView.doubleTapToZoomEnabled = false
        monthlyCalorieChartView.highlightPerTapEnabled = false
        
        monthlyCalorieChartView.data?.notifyDataChanged()
        monthlyCalorieChartView.notifyDataSetChanged()
        monthlyCalorieChartView.moveViewToX(Double(monthlyCalorieTimeData.count)) // 끝부터 보여지게
        monthlyCalorieTimeData = []
        monthlyTcalCalorieData = []
        monthlyEcalCalorieData = []
        
        numbersOfCalorieDaysForMonth = 0
        
        hourlyCalorieChartView.isUserInteractionEnabled = false
        weeklyCalorieChartView.isUserInteractionEnabled = false
        monthlyCalorieChartView.isUserInteractionEnabled = true
        yearlyCalorieChartView.isUserInteractionEnabled = false
        
        // 데이터가 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            monthlyCalorieChartView.clear()
            alertLabel.text = "\(alertString)\n데이터가 없습니다."
        }
    }
    
    // MARK: - yearly
    func yearlyCalorieChartViewGraph(){
                               
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        
        var alertCheck = 0
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        // 기능 구현 전까지 false
        lastYearCalorieButton.isEnabled = false
        nextYearCalorieButton.isEnabled = false
        
        numbersOfCalorieMonthsForYear = defaults.integer(forKey:"numbersOfCalorieMonthsForYear")
        currentCalorieYear = defaults.integer(forKey:"currentCalorieYear")
        
        baseCalorieMonthOfYear = defaults.integer(forKey:"baseCalorieMonthOfYear")
        numbersOfYearlyCalorieData = defaults.integer(forKey:"numbersOfYearlyCalorieData")
        sumOfYearlyTcalCalorie = defaults.integer(forKey:"sumOfYearlyTcalCalorie")
        sumOfYearlyEcalCalorie = defaults.integer(forKey:"sumOfYearlyEcalCalorie")
        numbersOfCalorieDaysForYear = defaults.integer(forKey:"numbersOfCalorieDaysForYear")
        
        
        tCalorieYearValue.text = String(sumOfYearlyTcalCalorie)
        eCalorieYearValue.text = String(sumOfYearlyEcalCalorie)
        
        let yearlyTcalorieRatio = Double(sumOfYearlyTcalCalorie) / Double(ttcal * numbersOfCalorieDaysForYear)
        let yearlyPTcalorieRatio = yearlyTcalorieRatio * 100
        yearlyTargetTotalCalorieProgress.progress = Float(yearlyTcalorieRatio)
        let yearlyIntTcalorieRatio = Int(yearlyPTcalorieRatio)
        
        
        yearlyTargetTotalCalorieProgressTextField.text = String(yearlyIntTcalorieRatio) + "%"
        
        
        let yearlyEcalorieRatio = Double(sumOfYearlyEcalCalorie) / Double(teCal * numbersOfCalorieDaysForYear)
        let yearlyPEcalorieRatio = yearlyEcalorieRatio * 100
        yearlyTargetExerciseCalorieProgress.progress = Float(yearlyEcalorieRatio)
        let yearlyIntEcalorieRatio = Int(yearlyPEcalorieRatio)
        
        yearlyTargetExerciseCalorieProgressTextField.text = String(yearlyIntEcalorieRatio) + "%"
      
        var yearlyTcalCalorieDataEntries = [BarChartDataEntry]()
        var yearlyEcalCalorieDataEntries = [BarChartDataEntry]()
        
        for i in 0 ..< numbersOfCalorieMonthsForYear {
            let yearlyTcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: yearlyTcalCalorieData[i])
            yearlyTcalCalorieDataEntries.append(yearlyTcalCalorieDataEntry)
            
            if yearlyTcalCalorieData[i] == 0.0 {
                alertCheck += 1
            }
        }
        
        
        for i in 0 ..< numbersOfCalorieMonthsForYear {
            let yearlyEcalCalorieDataEntry = BarChartDataEntry(x: Double(i), y: yearlyEcalCalorieData[i])
            yearlyEcalCalorieDataEntries.append(yearlyEcalCalorieDataEntry)
            
            if yearlyEcalCalorieData[i] == 0.0 {
                alertCheck += 1
            }
        }
//        print(yearlyTcalCalorieData)
//        print(yearlyEcalCalorieData)
//        print(alertCheck)
        // 데이터가 없는 경우
        if numbersOfCalorieMonthsForYear == 0 {
            alertFlag = true
        }
        
        let yearlyTcalCalorieChartDataSet = BarChartDataSet(entries: yearlyTcalCalorieDataEntries, label: "총 칼로리 (Kcal)                    ")
        yearlyTcalCalorieChartDataSet.setColor(NSUIColor.red)
        yearlyTcalCalorieChartDataSet.drawValuesEnabled = false
        
        
        let yearlyEcalCalorieChartDataSet = BarChartDataSet(entries: yearlyEcalCalorieDataEntries, label: "활동 칼로리 (Kcal)")
        yearlyEcalCalorieChartDataSet.setColor(NSUIColor.blue)
        yearlyEcalCalorieChartDataSet.drawValuesEnabled = false
        
        let yearlyCaloriedataSets: [BarChartDataSet] = [yearlyTcalCalorieChartDataSet, yearlyEcalCalorieChartDataSet]
        
        let chartDataCalorie = BarChartData(dataSets: yearlyCaloriedataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        chartDataCalorie.barWidth = barWidth
        
        yearlyCalorieChartView.xAxis.axisMinimum = Double(0)
        yearlyCalorieChartView.xAxis.axisMaximum = Double(0) + chartDataCalorie.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(numbersOfCalorieMonthsForYear)  // group count : 2
        chartDataCalorie.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        
        yearlyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        yearlyCalorieChartView.noDataText = ""
        yearlyCalorieChartView.data = chartDataCalorie
        yearlyCalorieChartView.xAxis.enabled = true
        
        yearlyCalorieChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yearlyCalorieTimeData)
        yearlyCalorieChartView.xAxis.granularity = 1
        yearlyCalorieChartView.xAxis.setLabelCount(numbersOfCalorieMonthsForYear, force: false)
        yearlyCalorieChartView.xAxis.centerAxisLabelsEnabled = true
        yearlyCalorieChartView.xAxis.labelPosition = .bottom
        yearlyCalorieChartView.xAxis.drawGridLinesEnabled = false
        yearlyCalorieChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        yearlyCalorieChartView.leftAxis.granularityEnabled = true
        yearlyCalorieChartView.leftAxis.granularity = 1.0
        yearlyCalorieChartView.leftAxis.axisMinimum = 0
        yearlyCalorieChartView.rightAxis.enabled = false
        yearlyCalorieChartView.drawMarkers = false
        yearlyCalorieChartView.dragEnabled = false
        yearlyCalorieChartView.pinchZoomEnabled = false
        yearlyCalorieChartView.doubleTapToZoomEnabled = false
        yearlyCalorieChartView.highlightPerTapEnabled = false
        
        yearlyCalorieChartView.data?.notifyDataChanged()
        yearlyCalorieChartView.notifyDataSetChanged()
        yearlyCalorieChartView.moveViewToX(0)
        yearlyCalorieTimeData = []
        yearlyTcalCalorieData = []
        yearlyEcalCalorieData = []
        
        
        numbersOfCalorieMonthsForYear = 0
        numbersOfCalorieDaysForYear = 0
        
        // 데이터가 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    //MARK: -
    func startDayCalorieGraph(){
        defaults.set(realYear, forKey: "calorieChangeRealYear")
        defaults.set(realMonth, forKey: "calorieChangeRealMonth")
        defaults.set(realDate, forKey: "calorieChangeRealDate")
        
        
        calorieChangeRealYear = defaults.string(forKey:"calorieChangeRealYear") ?? "\(realYear)"
        calorieChangeRealMonth = defaults.string(forKey:"calorieChangeRealMonth") ?? "\(realMonth)"
        calorieChangeRealDate = defaults.string(forKey:"calorieChangeRealDate") ?? "\(realDate)"
        
        dateCalorieDisplay.text = String("\(calorieChangeRealYear)-\(calorieChangeRealMonth)-\(calorieChangeRealDate)")
        
        dayCalorieButton.isSelected = true
        weekCalorieButton.isSelected  = false
        monthCalorieButton.isSelected = false
        yearCalorieButton.isSelected = false
        
        dayCalorieButton.isUserInteractionEnabled = false
        weekCalorieButton.isUserInteractionEnabled = true
        monthCalorieButton.isUserInteractionEnabled = true
        yearCalorieButton.isUserInteractionEnabled = true
        
        dateCalorieDisplay.isHidden = false
        weekCalorieDisplay.isHidden = true
        monthCalorieDisplay.isHidden = true
        yearCalorieDisplay .isHidden = true
        
        
        tCalorieDayLabel.alpha = 1.0
        tCalorieDayValue.alpha = 1.0
        tCalorieWeekLabel.alpha = 0.0
        tCalorieWeekValue.alpha = 0.0
        tCalorieMonthLabel.alpha = 0.0
        tCalorieMonthValue.alpha = 0.0
        tCalorieYearLabel.alpha = 0.0
        tCalorieYearValue.alpha = 0.0
        
        eCalorieDayLabel.alpha = 1.0
        eCalorieDayValue.alpha = 1.0
        eCalorieWeekLabel.alpha = 0.0
        eCalorieWeekValue.alpha = 0.0
        eCalorieMonthLabel.alpha = 0.0
        eCalorieMonthValue.alpha = 0.0
        eCalorieYearLabel.alpha = 0.0
        eCalorieYearValue.alpha = 0.0
        
        dailyTargetTotalCalorieProgress.alpha = 1.0
        dailyTargetTotalCalorieProgressTextField.alpha = 1.0
        weeklyTargetTotalCalorieProgress.alpha = 0.0
        weeklyTargetTotalCalorieProgressTextField.alpha = 0.0
        monthlyTargetTotalCalorieProgress.alpha = 0.0
        monthlyTargetTotalCalorieProgressTextField.alpha = 0.0
        yearlyTargetTotalCalorieProgress.alpha = 0.0
        yearlyTargetTotalCalorieProgressTextField.alpha = 0.0
        
        dailyTargetExerciseCalorieProgress.alpha = 1.0
        dailyTargetExerciseCalorieProgressTextField.alpha = 1.0
        weeklyTargetExerciseCalorieProgress.alpha = 0.0
        weeklyTargetExerciseCalorieProgressTextField.alpha = 0.0
        monthlyTargetExerciseCalorieProgress.alpha = 0.0
        monthlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        yearlyTargetExerciseCalorieProgress.alpha = 0.0
        yearlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        
        yesterdayHourlyCalorieButton.isHidden = false
        tomorrowHourlyCalorieButton.isHidden = false
        
        lastWeekCalorieButton.isHidden = true
        nextWeekCalorieButton.isHidden = true
        
        lastMonthCalorieButton.isHidden = true
        nextMonthCalorieButton.isHidden = true
        
        lastYearCalorieButton.isHidden = true
        nextYearCalorieButton.isHidden = true
        
        yesterdayHourlyCalorieButton.isEnabled = true
        tomorrowHourlyCalorieButton.isEnabled = true
        
        lastWeekCalorieButton.isEnabled = false
        nextWeekCalorieButton.isEnabled = false
        
        lastMonthCalorieButton.isEnabled = false
        nextMonthCalorieButton.isEnabled = false
        
        lastYearCalorieButton.isEnabled = false
        nextYearCalorieButton.isEnabled = false
        
        hourlyCalorieChartViewGraph()
        
    }
    
    // MARK: - DayButtonClickEvent
    @objc func selectDayClick(sender: AnyObject) {
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -calorieDateCount, to: calorieTodayDate)!
        
        calorieTodayDate = yesterday
        
        let cyear = DateFormatter()
        let cmonth = DateFormatter()
        let cdate = DateFormatter()
        
        
        cyear.dateFormat = "yyyy"
        cmonth.dateFormat = "MM"
        cdate.dateFormat = "dd"
        
        calorieChangeRealYear = cyear.string(from: calorieTodayDate)
        calorieChangeRealMonth = cmonth.string(from: calorieTodayDate)
        calorieChangeRealDate = cdate.string(from: calorieTodayDate)
        
        
        defaults.set(calorieChangeRealYear, forKey: "calorieChangeRealYear")
        defaults.set(calorieChangeRealMonth, forKey: "calorieChangeRealMonth")
        defaults.set(calorieChangeRealDate, forKey: "calorieChangeRealDate")
        
        dateCalorieDisplay.text = String("\(calorieChangeRealYear)-\(calorieChangeRealMonth)-\(calorieChangeRealDate)")
        
        dayCalorieButton.isSelected = true
        weekCalorieButton.isSelected  = false
        monthCalorieButton.isSelected = false
        yearCalorieButton.isSelected = false
        
        dayCalorieButton.isUserInteractionEnabled = false
        weekCalorieButton.isUserInteractionEnabled = true
        monthCalorieButton.isUserInteractionEnabled = true
        yearCalorieButton.isUserInteractionEnabled = true
        
        dateCalorieDisplay.isHidden = false
        weekCalorieDisplay.isHidden = true
        monthCalorieDisplay.isHidden = true
        yearCalorieDisplay .isHidden = true
        
        
        tCalorieDayLabel.alpha = 1.0
        tCalorieDayValue.alpha = 1.0
        tCalorieWeekLabel.alpha = 0.0
        tCalorieWeekValue.alpha = 0.0
        tCalorieMonthLabel.alpha = 0.0
        tCalorieMonthValue.alpha = 0.0
        tCalorieYearLabel.alpha = 0.0
        tCalorieYearValue.alpha = 0.0
        
        eCalorieDayLabel.alpha = 1.0
        eCalorieDayValue.alpha = 1.0
        eCalorieWeekLabel.alpha = 0.0
        eCalorieWeekValue.alpha = 0.0
        eCalorieMonthLabel.alpha = 0.0
        eCalorieMonthValue.alpha = 0.0
        eCalorieYearLabel.alpha = 0.0
        eCalorieYearValue.alpha = 0.0
        
        dailyTargetTotalCalorieProgress.alpha = 1.0
        dailyTargetTotalCalorieProgressTextField.alpha = 1.0
        weeklyTargetTotalCalorieProgress.alpha = 0.0
        weeklyTargetTotalCalorieProgressTextField.alpha = 0.0
        monthlyTargetTotalCalorieProgress.alpha = 0.0
        monthlyTargetTotalCalorieProgressTextField.alpha = 0.0
        yearlyTargetTotalCalorieProgress.alpha = 0.0
        yearlyTargetTotalCalorieProgressTextField.alpha = 0.0
        
        dailyTargetExerciseCalorieProgress.alpha = 1.0
        dailyTargetExerciseCalorieProgressTextField.alpha = 1.0
        weeklyTargetExerciseCalorieProgress.alpha = 0.0
        weeklyTargetExerciseCalorieProgressTextField.alpha = 0.0
        monthlyTargetExerciseCalorieProgress.alpha = 0.0
        monthlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        yearlyTargetExerciseCalorieProgress.alpha = 0.0
        yearlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        
        yesterdayHourlyCalorieButton.isHidden = false
        tomorrowHourlyCalorieButton.isHidden = false
        
        lastWeekCalorieButton.isHidden = true
        nextWeekCalorieButton.isHidden = true
        
        lastMonthCalorieButton.isHidden = true
        nextMonthCalorieButton.isHidden = true
        
        lastYearCalorieButton.isHidden = true
        nextYearCalorieButton.isHidden = true
        
        yesterdayHourlyCalorieButton.isEnabled = true
        tomorrowHourlyCalorieButton.isEnabled = true
        
        lastWeekCalorieButton.isEnabled = false
        nextWeekCalorieButton.isEnabled = false
        
        lastMonthCalorieButton.isEnabled = false
        nextMonthCalorieButton.isEnabled = false
        
        lastYearCalorieButton.isEnabled = false
        nextYearCalorieButton.isEnabled = false
        
        
        calorieDateCount = 0
        hourlyCalorieChartViewGraph()
        
    }
    
    
    func calorieYesterdayButton(){
        
        calorieDateCount = calorieDateCount - 1
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: calorieTodayDate)!
        
        calorieTodayDate = yesterday
        
        let cyear = DateFormatter()
        let cmonth = DateFormatter()
        let cdate = DateFormatter()
        
        cyear.dateFormat = "yyyy"
        cmonth.dateFormat = "MM"
        cdate.dateFormat = "dd"
        
        
        calorieChangeRealYear = cyear.string(from: calorieTodayDate)
        calorieChangeRealMonth = cmonth.string(from: calorieTodayDate)
        calorieChangeRealDate = cdate.string(from: calorieTodayDate)
        
        
        dateCalorieDisplay.text = String("\(calorieChangeRealYear)-\(calorieChangeRealMonth)-\(calorieChangeRealDate)")
        
        defaults.set(calorieChangeRealYear, forKey:"calorieChangeRealYear")
        defaults.set(calorieChangeRealMonth, forKey:"calorieChangeRealMonth")
        defaults.set(calorieChangeRealDate, forKey:"calorieChangeRealDate")
        
    }
    
    
    func calorieTomorrowButton(){
        
        calorieDateCount = calorieDateCount + 1
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: calorieTodayDate)!
        calorieTodayDate = tomorrow
        
        
        let cyear = DateFormatter()
        let cmonth = DateFormatter()
        let cdate = DateFormatter()
        
        
        cyear.dateFormat = "yyyy"
        cmonth.dateFormat = "MM"
        cdate.dateFormat = "dd"
        
        calorieChangeRealYear = cyear.string(from: calorieTodayDate)
        calorieChangeRealMonth = cmonth.string(from: calorieTodayDate)
        calorieChangeRealDate = cdate.string(from: calorieTodayDate)
        
        
        dateCalorieDisplay.text = String("\(calorieChangeRealYear)-\(calorieChangeRealMonth)-\(calorieChangeRealDate)")
        
        defaults.set(calorieChangeRealYear, forKey:"calorieChangeRealYear")
        defaults.set(calorieChangeRealMonth, forKey:"calorieChangeRealMonth")
        defaults.set(calorieChangeRealDate, forKey:"calorieChangeRealDate")
    }
    
    
    //     ------------------------어제 내일 버튼들 시작 ----------------------
    
    
    @objc func yesterdaySelectCalorieButton(sender: AnyObject){
        calorieYesterdayButton()
        hourlyCalorieChartViewGraph()
    }
    
    
    @objc func tomorrowSelectCalorieButton(sender: AnyObject){
        calorieTomorrowButton()
        hourlyCalorieChartViewGraph()
    }
    
    //     ------------------------어제 내일 버튼들  끝 ----------------------
    
    //     ------------------------지난주 다음주 버튼들 시작 ----------------------
    
    // MARK: - WeekButtonClickEvent
    @objc func selectWeekClick(sender: AnyObject) {
        
        
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        dayCalorieButton.isSelected = false
        weekCalorieButton.isSelected  = true
        monthCalorieButton.isSelected = false
        yearCalorieButton.isSelected = false
        
        dayCalorieButton.isUserInteractionEnabled = true
        weekCalorieButton.isUserInteractionEnabled = false
        monthCalorieButton.isUserInteractionEnabled = true
        yearCalorieButton.isUserInteractionEnabled = true
        
        dateCalorieDisplay.isHidden = true
        weekCalorieDisplay.isHidden = false
        monthCalorieDisplay.isHidden = true
        yearCalorieDisplay .isHidden = true
        
        
        tCalorieDayLabel.alpha = 0.0
        tCalorieDayValue.alpha = 0.0
        tCalorieWeekLabel.alpha = 1.0
        tCalorieWeekValue.alpha = 1.0
        tCalorieMonthLabel.alpha = 0.0
        tCalorieMonthValue.alpha = 0.0
        tCalorieYearLabel.alpha = 0.0
        tCalorieYearValue.alpha = 0.0
        
        eCalorieDayLabel.alpha = 0.0
        eCalorieDayValue.alpha = 0.0
        eCalorieWeekLabel.alpha = 1.0
        eCalorieWeekValue.alpha = 1.0
        eCalorieMonthLabel.alpha = 0.0
        eCalorieMonthValue.alpha = 0.0
        eCalorieYearLabel.alpha = 0.0
        eCalorieYearValue.alpha = 0.0
        
        dailyTargetTotalCalorieProgress.alpha = 0.0
        dailyTargetTotalCalorieProgressTextField.alpha = 0.0
        weeklyTargetTotalCalorieProgress.alpha = 1.0
        weeklyTargetTotalCalorieProgressTextField.alpha = 1.0
        monthlyTargetTotalCalorieProgress.alpha = 0.0
        monthlyTargetTotalCalorieProgressTextField.alpha = 0.0
        yearlyTargetTotalCalorieProgress.alpha = 0.0
        yearlyTargetTotalCalorieProgressTextField.alpha = 0.0
        
        dailyTargetExerciseCalorieProgress.alpha = 0.0
        dailyTargetExerciseCalorieProgressTextField.alpha = 0.0
        weeklyTargetExerciseCalorieProgress.alpha = 1.0
        weeklyTargetExerciseCalorieProgressTextField.alpha = 1.0
        monthlyTargetExerciseCalorieProgress.alpha = 0.0
        monthlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        yearlyTargetExerciseCalorieProgress.alpha = 0.0
        yearlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        
        yesterdayHourlyCalorieButton.isHidden = true
        tomorrowHourlyCalorieButton.isHidden = true
        
        lastWeekCalorieButton.isHidden = false
        nextWeekCalorieButton.isHidden = false
        
        lastMonthCalorieButton.isHidden = true
        nextMonthCalorieButton.isHidden = true
        
        lastYearCalorieButton.isHidden = true
        nextYearCalorieButton.isHidden = true
        
        yesterdayHourlyCalorieButton.isEnabled = false
        tomorrowHourlyCalorieButton.isEnabled = false
        
        lastWeekCalorieButton.isEnabled = true
        nextWeekCalorieButton.isEnabled = true
        
        lastMonthCalorieButton.isEnabled = false
        nextMonthCalorieButton.isEnabled = false
        
        lastYearCalorieButton.isEnabled = false
        nextYearCalorieButton.isEnabled = false
        
        // 마지막 페이지에서 다른 페이지로 넘어갔을 경우 대비
        if nextWeekDataCheck == true {
            nextWeekDataCheck = false
            nextWeekCalorieButton.isEnabled = true
        }
        else if lastWeekDataCheck == true {
            lastWeekDataCheck = false
            lastWeekCalorieButton.isEnabled = true
        }
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                
                let numbersOfWeeklyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfWeeklyCalorieData = numbersOfWeeklyCalorieData2.count
                
                
                let weeklyCalorieData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyCalorieData10[numbersOfWeeklyCalorieData - 8]
                let columns10 = row10.components(separatedBy: ",")
                //                        let baseWeeklyArrYear1 = columns10[0]
                let baseWeeklyCalorieMonth1 = columns10[1]
                let baseWeeklyCalorieDate1 = columns10[2]
                
                
                
                let row20 = weeklyCalorieData10[numbersOfWeeklyCalorieData - 2]
                let columns20 = row20.components(separatedBy: ",")
                //                        let baseWeeklyArrYear2 = columns20[0]
                let baseWeeklyCalorieMonth2 = columns20[1]
                let baseWeeklyCalorieDate2 = columns20[2]
                
                
                weekCalorieDisplay.text = String("\(baseWeeklyCalorieMonth1).\(baseWeeklyCalorieDate1) ~ \(baseWeeklyCalorieMonth2).\(baseWeeklyCalorieDate2)")
                
                
                defaults.set(numbersOfWeeklyCalorieData, forKey:"numbersOfWeeklyCalorieData")
                
                weeklyCalorieChartViewGraph()
                
                
                newNumbersOfWeeklyCalorieData = numbersOfWeeklyCalorieData
                
                
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
    

    func lastweekCalorieButton(){
        
//        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        numbersOfWeeklyCalorieData = defaults.integer(forKey:"numbersOfWeeklyCalorieData")
        numbersOfWeeklyCalorieData = numbersOfWeeklyCalorieData - 7
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && ((numbersOfWeeklyCalorieData - 8) > 0)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let weeklyCalorieData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyCalorieData10[numbersOfWeeklyCalorieData - 8]
                let columns10 = row10.components(separatedBy: ",")
//                print(row10)
                let baseWeeklyCalorieMonth1 = columns10[1]
                let baseWeeklyCalorieDate1 = columns10[2]
                
                let row20 = weeklyCalorieData10[numbersOfWeeklyCalorieData - 2]
                let columns20 = row20.components(separatedBy: ",")
//                print(row20)
                let baseWeeklyCalorieMonth2 = columns20[1]
                let baseWeeklyCalorieDate2 = columns20[2]
                
                
                weekCalorieDisplay.text = String("\(baseWeeklyCalorieMonth1).\(baseWeeklyCalorieDate1) ~ \(baseWeeklyCalorieMonth2).\(baseWeeklyCalorieDate2)")
                alertString = String("\(baseWeeklyCalorieMonth1).\(baseWeeklyCalorieDate1) ~ \(baseWeeklyCalorieMonth2).\(baseWeeklyCalorieDate2)")
                
                defaults.set(numbersOfWeeklyCalorieData, forKey:"numbersOfWeeklyCalorieData")
                
                weeklyCalorieChartViewGraph()
                weeklyCalorieButtonFlag = 0
                
                
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            lastWeekDataCheck = true
            lastWeekCalorieButton.isEnabled = false
            weeklyCalorieChartView.clear()
            defaults.set(numbersOfWeeklyCalorieData-7, forKey:"numbersOfWeeklyCalorieData")
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
    
    
    @objc func lastWeekSelectCalorieButton(sender: AnyObject){
        if nextWeekDataCheck == true {
            defaults.set(numbersOfWeeklyCalorieData-7, forKey:"numbersOfWeeklyCalorieData")
            weeklyCalorieChartViewGraph()
            nextWeekDataCheck = false
            nextWeekCalorieButton.isEnabled = true
        }
        else{
            lastweekCalorieButton()
            weeklyCalorieButtonFlag = 1
        }
    }
    
    
    
    func nextweekCalorieButton(){
        
//        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        lastWeekCalorieButton.isEnabled = true
        
        numbersOfWeeklyCalorieData = defaults.integer(forKey:"numbersOfWeeklyCalorieData")
        numbersOfWeeklyCalorieData = numbersOfWeeklyCalorieData + 7
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && ((numbersOfWeeklyCalorieData - 2) < newNumbersOfWeeklyCalorieData) ){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let weeklyCalorieData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyCalorieData10[numbersOfWeeklyCalorieData - 8]
                let columns10 = row10.components(separatedBy: ",")
                //                    let baseWeeklyArrYear1 = columns10[0]
                let baseWeeklyCalorieMonth1 = columns10[1]
                let baseWeeklyCalorieDate1 = columns10[2]
                
                let row20 = weeklyCalorieData10[numbersOfWeeklyCalorieData - 2]
                let columns20 = row20.components(separatedBy: ",")
                //                    let baseWeeklyArrYear2 = columns20[0]
                let baseWeeklyCalorieMonth2 = columns20[1]
                let baseWeeklyCalorieDate2 = columns20[2]
                
                
                
                weekCalorieDisplay.text = String("\(baseWeeklyCalorieMonth1).\(baseWeeklyCalorieDate1) ~ \(baseWeeklyCalorieMonth2).\(baseWeeklyCalorieDate2)")
                alertString = String("\(baseWeeklyCalorieMonth1).\(baseWeeklyCalorieDate1) ~ \(baseWeeklyCalorieMonth2).\(baseWeeklyCalorieDate2)")
                defaults.set(numbersOfWeeklyCalorieData, forKey:"numbersOfWeeklyCalorieData")
                
                weeklyCalorieChartViewGraph()
                weeklyCalorieButtonFlag = 0
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            nextWeekDataCheck = true
            nextWeekCalorieButton.isEnabled = false
            weeklyCalorieChartView.clear()
            defaults.set(numbersOfWeeklyCalorieData+7, forKey:"numbersOfWeeklyCalorieData")
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
    
    
    
    @objc func nextWeekSelectCalorieButton(sender: AnyObject){
        if lastWeekDataCheck == true {
            defaults.set(numbersOfWeeklyCalorieData+7, forKey:"numbersOfWeeklyCalorieData")
            weeklyCalorieChartViewGraph()
            lastWeekDataCheck = false
            lastWeekCalorieButton.isEnabled = true
        }
        else{
            weeklyCalorieButtonFlag = 1
            nextweekCalorieButton()
        }
    }
    //     ------------------------지난주 다음주  버튼들 끝  ----------------------
    
    //     ------------------------지난달 다음달 버튼들 시작 ----------------------
    
    
    // MARK: - MonthButtonClickEvent
    @objc func selectMonthClick(sender: AnyObject) {
        
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        
        
        sumOfMonthlyTcalCalorie = 0
        sumOfMonthlyEcalCalorie = 0
        numbersOfCalorieDaysForMonth = 0
        
        dayCalorieButton.isSelected = false
        weekCalorieButton.isSelected  = false
        monthCalorieButton.isSelected = true
        yearCalorieButton.isSelected = false
        
        dayCalorieButton.isUserInteractionEnabled = true
        weekCalorieButton.isUserInteractionEnabled = true
        monthCalorieButton.isUserInteractionEnabled = false
        yearCalorieButton.isUserInteractionEnabled = true
        
        dateCalorieDisplay.isHidden = true
        weekCalorieDisplay.isHidden = true
        monthCalorieDisplay.isHidden = false
        yearCalorieDisplay .isHidden = true
        
        
        tCalorieDayLabel.alpha = 0.0
        tCalorieDayValue.alpha = 0.0
        tCalorieWeekLabel.alpha = 0.0
        tCalorieWeekValue.alpha = 0.0
        tCalorieMonthLabel.alpha = 1.0
        tCalorieMonthValue.alpha = 1.0
        tCalorieYearLabel.alpha = 0.0
        tCalorieYearValue.alpha = 0.0
        
        eCalorieDayLabel.alpha = 0.0
        eCalorieDayValue.alpha = 0.0
        eCalorieWeekLabel.alpha = 0.0
        eCalorieWeekValue.alpha = 0.0
        eCalorieMonthLabel.alpha = 1.0
        eCalorieMonthValue.alpha = 1.0
        eCalorieYearLabel.alpha = 0.0
        eCalorieYearValue.alpha = 0.0
        
        dailyTargetTotalCalorieProgress.alpha = 0.0
        dailyTargetTotalCalorieProgressTextField.alpha = 0.0
        weeklyTargetTotalCalorieProgress.alpha = 0.0
        weeklyTargetTotalCalorieProgressTextField.alpha = 0.0
        monthlyTargetTotalCalorieProgress.alpha = 1.0
        monthlyTargetTotalCalorieProgressTextField.alpha = 1.0
        yearlyTargetTotalCalorieProgress.alpha = 0.0
        yearlyTargetTotalCalorieProgressTextField.alpha = 0.0
        
        dailyTargetExerciseCalorieProgress.alpha = 0.0
        dailyTargetExerciseCalorieProgressTextField.alpha = 0.0
        weeklyTargetExerciseCalorieProgress.alpha = 0.0
        weeklyTargetExerciseCalorieProgressTextField.alpha = 0.0
        monthlyTargetExerciseCalorieProgress.alpha = 1.0
        monthlyTargetExerciseCalorieProgressTextField.alpha = 1.0
        yearlyTargetExerciseCalorieProgress.alpha = 0.0
        yearlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        
        yesterdayHourlyCalorieButton.isHidden = true
        tomorrowHourlyCalorieButton.isHidden = true
        
        lastWeekCalorieButton.isHidden =  true
        nextWeekCalorieButton.isHidden =  true
        
        lastMonthCalorieButton.isHidden = false
        nextMonthCalorieButton.isHidden = false
        
        lastYearCalorieButton.isHidden = true
        nextYearCalorieButton.isHidden = true
        
        yesterdayHourlyCalorieButton.isEnabled = false
        tomorrowHourlyCalorieButton.isEnabled = false
        
        lastWeekCalorieButton.isEnabled = false
        nextWeekCalorieButton.isEnabled = false
        
        lastMonthCalorieButton.isEnabled = true
        nextMonthCalorieButton.isEnabled = true
        
        lastYearCalorieButton.isEnabled = false
        nextYearCalorieButton.isEnabled = false
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                
                let numbersOfMonthlyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyCalorieData = numbersOfMonthlyCalorieData2.count
                
                
                let weeklyCalorieData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyCalorieData - 1{
                    let row1 = weeklyCalorieData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let calorieMonth = columns[1]
                    let calorieDay = columns[2]
                    let monthlyTcalCalorieDataRow = Double(columns[7])
                    let monthlyEcalCalorieDataRow = Double(columns[8])
                    
                    
                    if (calorieMonth == realMonth){
                        
                        
                        monthlyCalorieTimeData.append(calorieDay)
                        monthlyTcalCalorieData.append(monthlyTcalCalorieDataRow ?? 0.0)
                        monthlyEcalCalorieData.append(monthlyEcalCalorieDataRow ?? 0.0)
                        
                        sumOfMonthlyTcalCalorie = sumOfMonthlyTcalCalorie + Int(monthlyTcalCalorieDataRow ?? 0)
                        sumOfMonthlyEcalCalorie = sumOfMonthlyEcalCalorie + Int(monthlyEcalCalorieDataRow ?? 0)
                        numbersOfCalorieDaysForMonth +=  1
                    }
                }
                
                baseCalorieDayOfMonth = Int(realMonth) ?? 0
                monthCalorieDisplay.text = String("\(realYear).\(realMonth)")
                alertString = String("\(realYear)년 \(realMonth)월")
                
                
                defaults.set(baseCalorieDayOfMonth, forKey:"baseCalorieDayOfMonth")
                defaults.set(numbersOfCalorieDaysForMonth, forKey:"numbersOfCalorieDaysForMonth")
                
                
                defaults.set(sumOfMonthlyTcalCalorie, forKey:"sumOfMonthlyTcalCalorie")
                defaults.set(sumOfMonthlyEcalCalorie, forKey:"sumOfMonthlyEcalCalorie")
                
                
                monthlyCalorieChartViewGraph()
                
                
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
    
    func lookingBottomCalorieDayOfMonth(){
        
        monthlyTcalCalorieData = []
        monthlyEcalCalorieData = []
        sumOfMonthlyTcalCalorie = 0
        sumOfMonthlyEcalCalorie = 0
        numbersOfCalorieDaysForMonth = 0
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        nextMonthCalorieButton.isEnabled = true

        
        baseCalorieDayOfMonth = defaults.integer(forKey:"baseCalorieDayOfMonth")
        
        var s_baseCalorieDayOfMonth = String(baseCalorieDayOfMonth - 1)
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && (baseCalorieDayOfMonth - 1 >= 1) {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfMonthlyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyCalorieData = numbersOfMonthlyCalorieData2.count
                
                let weeklyCalorieData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyCalorieData - 1{
                    let row1 = weeklyCalorieData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let calorieMonth = columns[1]
                    let calorieDay = columns[2]
                    let monthlyTcalCalorieDataRow = Double(columns[7])
                    let monthlyEcalCalorieDataRow = Double(columns[8])
                    
                    let intCalorieMonth = Int(calorieMonth)
                    
                    if (intCalorieMonth == baseCalorieDayOfMonth - 1){
                        
                        monthlyCalorieTimeData.append(calorieDay)
                        monthlyTcalCalorieData.append(monthlyTcalCalorieDataRow ?? 0.0)
                        monthlyEcalCalorieData.append(monthlyEcalCalorieDataRow ?? 0.0)
                        
                        
                        s_baseCalorieDayOfMonth = calorieMonth
                        
                        sumOfMonthlyTcalCalorie = sumOfMonthlyTcalCalorie + Int(monthlyTcalCalorieDataRow ?? 0)
                        sumOfMonthlyEcalCalorie = sumOfMonthlyEcalCalorie + Int(monthlyEcalCalorieDataRow ?? 0)
                        
                        numbersOfCalorieDaysForMonth +=  1
                    }
                }
                
                monthCalorieDisplay.text = String("\(realYear).\(s_baseCalorieDayOfMonth)")
                alertString = String("\(realYear)년 \(s_baseCalorieDayOfMonth)월")
                
                defaults.set(sumOfMonthlyTcalCalorie, forKey:"sumOfMonthlyTcalCalorie")
                defaults.set(sumOfMonthlyEcalCalorie, forKey:"sumOfMonthlyEcalCalorie")
                defaults.set(numbersOfCalorieDaysForMonth, forKey:"numbersOfCalorieDaysForMonth")
                defaults.set(baseCalorieDayOfMonth - 1, forKey:"baseCalorieDayOfMonth")
                
                //                print(baseArrDayOfMonth - 1)
                
                monthlyCalorieChartViewGraph()
                monthlyCalorieButtonFlag = 0
            }
            catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            lastMonthDataCheck = true
            lastMonthCalorieButton.isEnabled = false
            monthlyCalorieChartView.clear()
            defaults.set(baseCalorieDayOfMonth - 1, forKey:"baseCalorieDayOfMonth")
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
    
    
    
    
    @objc func lastMonthSelectCalorieButton(sender: AnyObject){
        
        monthlyCalorieButtonFlag = 1
        lookingBottomCalorieDayOfMonth()
        nextMonthCalorieButton.isEnabled = true
    }
    
    
    func lookingUpperCalorieDayOfMonth(){
        
        monthlyTcalCalorieData = []
        monthlyEcalCalorieData = []
        sumOfMonthlyTcalCalorie = 0
        sumOfMonthlyEcalCalorie = 0
        numbersOfCalorieDaysForMonth = 0
        
        var thisMonthForCalorie = 0
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        lastMonthCalorieButton.isEnabled = true
        
        
        baseCalorieDayOfMonth = defaults.integer(forKey:"baseCalorieDayOfMonth")
        
        var s_baseCalorieDayOfMonth = String(baseCalorieDayOfMonth + 1)
        
        thisMonthForCalorie = Int(realMonth)!
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if ((fileManager1.fileExists(atPath: filePath1)) && ((baseCalorieDayOfMonth + 1) < (thisMonthForCalorie + 1))){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfMonthlyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyCalorieData = numbersOfMonthlyCalorieData2.count
                
                let weeklyCalorieData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyCalorieData - 1{
                    let row1 = weeklyCalorieData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let calorieMonth = columns[1]
                    let calorieDay = columns[2]
                    let monthlyTcalCalorieDataRow = Double(columns[7])
                    let monthlyEcalCalorieDataRow = Double(columns[8])
                    
                    let intCalorieMonth = Int(columns[1])
                    
                    if (intCalorieMonth == baseCalorieDayOfMonth + 1){
                        
                        monthlyCalorieTimeData.append(calorieDay)
                        monthlyTcalCalorieData.append(monthlyTcalCalorieDataRow ?? 0.0)
                        monthlyEcalCalorieData.append(monthlyEcalCalorieDataRow ?? 0.0)
                        
                        s_baseCalorieDayOfMonth = calorieMonth
                        
                        sumOfMonthlyTcalCalorie = sumOfMonthlyTcalCalorie + Int(monthlyTcalCalorieDataRow ?? 0)
                        sumOfMonthlyEcalCalorie = sumOfMonthlyEcalCalorie + Int(monthlyEcalCalorieDataRow ?? 0)
                        
                        numbersOfCalorieDaysForMonth +=  1
                    }
                }
                
                defaults.set(sumOfMonthlyTcalCalorie, forKey:"sumOfMonthlyTcalCalorie")
                defaults.set(sumOfMonthlyEcalCalorie, forKey:"sumOfMonthlyEcalCalorie")
                
                
                monthCalorieDisplay.text = String("\(realYear).\(s_baseCalorieDayOfMonth)")
                alertString = String("\(realYear)년 \(s_baseCalorieDayOfMonth)월")
                
                defaults.set(numbersOfCalorieDaysForMonth, forKey:"numbersOfCalorieDaysForMonth")
                defaults.set(baseCalorieDayOfMonth + 1, forKey:"baseCalorieDayOfMonth")
                
                //                print(baseArrDayOfMonth + 1)
                
                
                monthlyCalorieChartViewGraph()
                
                monthlyCalorieButtonFlag = 0
            }
            catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            nextMonthDataCheck = true
            nextMonthCalorieButton.isEnabled = false
            monthlyCalorieChartView.clear()
            defaults.set(baseCalorieDayOfMonth + 1, forKey:"baseCalorieDayOfMonth")
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
    
    
    @objc func nextMonthSelectCalorieButton(sender: AnyObject){
        
        monthlyCalorieButtonFlag = 1
        lookingUpperCalorieDayOfMonth()
        lastMonthCalorieButton.isEnabled = true
    }
    //     ------------------------지난달 다음달 버튼들 끝  ----------------------
    
    //     ------------------------지난해 다음해 버튼들 시작 ----------------------
    
    // MARK: - YearButtonClickEvent
    @objc func selectYearClick(sender: AnyObject) {
        
        yearlyCalorieChartView.clear()
        monthlyCalorieChartView.clear()
        hourlyCalorieChartView.clear()
        weeklyCalorieChartView.clear()
        
        sumOfYearlyTcalCalorie = 0
        sumOfYearlyEcalCalorie = 0
        yearlyCalorieButtonFlag = 0
        
        numbersOfCalorieDaysForYear = 0
        
        dayCalorieButton.isSelected = false
        weekCalorieButton.isSelected  = false
        monthCalorieButton.isSelected = false
        yearCalorieButton.isSelected = true
        
        dayCalorieButton.isUserInteractionEnabled = true
        weekCalorieButton.isUserInteractionEnabled = true
        monthCalorieButton.isUserInteractionEnabled = true
        yearCalorieButton.isUserInteractionEnabled = false
        
        dateCalorieDisplay.isHidden = true
        weekCalorieDisplay.isHidden = true
        monthCalorieDisplay.isHidden = true
        yearCalorieDisplay .isHidden = false
        
        
        tCalorieDayLabel.alpha = 0.0
        tCalorieDayValue.alpha = 0.0
        tCalorieWeekLabel.alpha = 0.0
        tCalorieWeekValue.alpha = 0.0
        tCalorieMonthLabel.alpha = 0.0
        tCalorieMonthValue.alpha = 0.0
        tCalorieYearLabel.alpha = 1.0
        tCalorieYearValue.alpha = 1.0
        
        eCalorieDayLabel.alpha = 0.0
        eCalorieDayValue.alpha = 0.0
        eCalorieWeekLabel.alpha = 0.0
        eCalorieWeekValue.alpha = 0.0
        eCalorieMonthLabel.alpha = 0.0
        eCalorieMonthValue.alpha = 0.0
        eCalorieYearLabel.alpha = 1.0
        eCalorieYearValue.alpha = 1.0
        
        dailyTargetTotalCalorieProgress.alpha = 0.0
        dailyTargetTotalCalorieProgressTextField.alpha = 0.0
        weeklyTargetTotalCalorieProgress.alpha = 0.0
        weeklyTargetTotalCalorieProgressTextField.alpha = 0.0
        monthlyTargetTotalCalorieProgress.alpha = 0.0
        monthlyTargetTotalCalorieProgressTextField.alpha = 0.0
        yearlyTargetTotalCalorieProgress.alpha = 1.0
        yearlyTargetTotalCalorieProgressTextField.alpha = 1.0
        
        dailyTargetExerciseCalorieProgress.alpha = 0.0
        dailyTargetExerciseCalorieProgressTextField.alpha = 0.0
        weeklyTargetExerciseCalorieProgress.alpha = 0.0
        weeklyTargetExerciseCalorieProgressTextField.alpha = 0.0
        monthlyTargetExerciseCalorieProgress.alpha = 0.0
        monthlyTargetExerciseCalorieProgressTextField.alpha = 0.0
        yearlyTargetExerciseCalorieProgress.alpha = 1.0
        yearlyTargetExerciseCalorieProgressTextField.alpha = 1.0
        
        yesterdayHourlyCalorieButton.isHidden = true
        tomorrowHourlyCalorieButton.isHidden = true
        
        lastWeekCalorieButton.isHidden =  true
        nextWeekCalorieButton.isHidden =  true
        
        lastMonthCalorieButton.isHidden = true
        nextMonthCalorieButton.isHidden = true
        
        lastYearCalorieButton.isHidden = false
        nextYearCalorieButton.isHidden = false
        
        yesterdayHourlyCalorieButton.isEnabled = false
        tomorrowHourlyCalorieButton.isEnabled = false
        
        lastWeekCalorieButton.isEnabled = false
        nextWeekCalorieButton.isEnabled = false
        
        lastMonthCalorieButton.isEnabled = false
        nextMonthCalorieButton.isEnabled = false
        
        lastYearCalorieButton.isEnabled = true
        nextYearCalorieButton.isEnabled = true
        
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyCalorieData = numbersOfYearlyCalorieData2.count
                
                
                let yearlyCalorieData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyCalorieData - 1{
                    let row1 = yearlyCalorieData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let calorieYear = columns[0]
                    let calorieMonth = columns[1]
                    let yearlyTcalCalorieDataRow = Double(columns[5])
                    let yearlyEcalCalorieDataRow = Double(columns[6])
                    
                    intCalorieYear = Int(calorieYear) ?? 0
                    
                    
                    //                    print("\(calorieYear),\(realYear)")
                    
                    if (calorieYear == realYear){
                        
                        yearlyCalorieTimeData.append(calorieMonth)
                        yearlyTcalCalorieData.append(yearlyTcalCalorieDataRow ?? 0.0)
                        yearlyEcalCalorieData.append(yearlyEcalCalorieDataRow ?? 0.0)
                        
                        sumOfYearlyTcalCalorie = sumOfYearlyTcalCalorie + Int(yearlyTcalCalorieDataRow ?? 0)
                        sumOfYearlyEcalCalorie = sumOfYearlyEcalCalorie + Int(yearlyEcalCalorieDataRow ?? 0)
                        
                        numbersOfCalorieMonthsForYear +=  1
                    }
                }
                
                tCalorieYearValue.text = String("\(sumOfYearlyTcalCalorie)")
                
                eCalorieYearValue.text = String("\(sumOfYearlyEcalCalorie)")
                yearCalorieDisplay.text = String("\(realYear)")
                
                
                baseCalorieMonthOfYear  = numbersOfYearlyCalorieData - numbersOfCalorieMonthsForYear
                
                defaults.set(sumOfYearlyTcalCalorie, forKey:"sumOfYearlyTcalCalorie")
                defaults.set(sumOfYearlyEcalCalorie, forKey:"sumOfYearlyEcalCalorie")
                
                
                defaults.set(intCalorieYear, forKey:"currentCalorieYear")
                defaults.set(baseCalorieMonthOfYear, forKey:"baseCalorieMonthOfYear")
                defaults.set(numbersOfYearlyCalorieData, forKey:"numbersOfYearlyCalorieData") // total number of month
                defaults.set(numbersOfCalorieMonthsForYear, forKey:"numbersOfCalorieMonthsForYear")
                
                
                
                let fileManager2 = FileManager.default
                let documentsURL2 = fileManager2.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let directoryURL2 = documentsURL2.appendingPathComponent("dailyData")
                let fileURL2 = directoryURL2.appendingPathComponent("/dailyCalandDistanceData.csv")
                
                let filePath2 = fileURL2.path
                
                if fileManager2.fileExists(atPath: filePath2) {
                    
                    
                    do {
                        let data3 = try String(contentsOf: fileURL2)
                        
                        let numbersOfMonthlyCalorieData3 = data3.components(separatedBy: .newlines)
                        // 파일 데이터 행 전체 갯
                        numbersOfMonthlyCalorieData = numbersOfMonthlyCalorieData3.count
                        
                        let weeklyCalorieData40 = data3.components(separatedBy: .newlines)
                        
                        for i in 0 ..< numbersOfMonthlyCalorieData - 1{
                            let row1 = weeklyCalorieData40[i]
                            let columns = row1.components(separatedBy: ",")
                            let calorieYear = columns[0]
                            
                            let intCountCalorieYear = Int(calorieYear)
                            
                            if (intCountCalorieYear == intCalorieYear){
                                
                                numbersOfCalorieDaysForYear +=  1
                            }
                        }
                        
                        
                        defaults.set(numbersOfCalorieDaysForYear, forKey:"numbersOfCalorieDaysForYear")
                        
                        
                        if numbersOfCalorieDaysForYear == 0 {
                            let alert = UIAlertController(title: "No data", message: "", preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
                                
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
            yearlyCalorieChartViewGraph()
        }
        else {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    func  lookingBottomCalorieMonthOfYear (){
        
        yearlyTcalCalorieData = []
        yearlyEcalCalorieData = []
        
        sumOfYearlyTcalCalorie = 0
        sumOfYearlyEcalCalorie = 0
        
        numbersOfYearlyCalorieData = 0
        numbersOfCalorieDaysForYear = 0
        numbersOfCalorieMonthsForYear = 0
        
        baseCalorieMonthOfYear = defaults.integer(forKey:"baseCalorieMonthOfYear")
        currentCalorieYear = defaults.integer(forKey:"currentCalorieYear")
        numbersOfYearlyCalorieData = defaults.integer(forKey:"numbersOfYearlyCalorieData")
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && ((numbersOfYearlyCalorieData - baseCalorieMonthOfYear) > 1) && yearlyCalorieButtonFlag == 1 {
            print("fileManager1")
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyCalorieData = numbersOfYearlyCalorieData2.count
                
                let weeklyCalorieData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyCalorieData  - 1 {
                    let row1 = weeklyCalorieData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let calorieYear = columns[0]
                    let calorieMonth = columns[1]
                    let yearlyTcalCalorieDataRow = Double(columns[5])
                    let yearlyEcalCalorieDataRow = Double(columns[6])
                    
                    intCalorieYear = Int(calorieYear) ?? 0
                    
                    if (intCalorieYear == baseCalorieYear - 1){
                        
                        yearlyCalorieTimeData.append(calorieMonth)
                        yearlyTcalCalorieData.append(yearlyTcalCalorieDataRow ?? 0.0)
                        yearlyEcalCalorieData.append(yearlyEcalCalorieDataRow ?? 0.0)
                        
                        sumOfYearlyTcalCalorie = sumOfYearlyTcalCalorie + Int(yearlyTcalCalorieDataRow ?? 0)
                        sumOfYearlyEcalCalorie = sumOfYearlyEcalCalorie + Int(yearlyEcalCalorieDataRow ?? 0)
                        
                        numbersOfCalorieMonthsForYear +=  1
                    }
                }
                
                defaults.set(sumOfYearlyTcalCalorie, forKey:"sumOfYearlyTcalCalorie")
                defaults.set(sumOfYearlyEcalCalorie, forKey:"sumOfYearlyEcalCalorie")
                
                tCalorieYearValue.text = String("\(sumOfYearlyTcalCalorie)")
                
                eCalorieYearValue.text = String("\(sumOfYearlyEcalCalorie)")
                yearCalorieDisplay.text = String("\(intCalorieYear)")
                
                baseCalorieMonthOfYear  = numbersOfYearlyCalorieData - baseCalorieMonthOfYear - numbersOfCalorieMonthsForYear
                
                defaults.set(intCalorieYear, forKey:"currentCalorieYear")
                defaults.set(baseCalorieMonthOfYear, forKey:"baseCalorieMonthOfYear")
                defaults.set(numbersOfYearlyCalorieData, forKey:"numbersOfYearlyCalorieData")
                defaults.set(numbersOfCalorieMonthsForYear, forKey:"numbersOfCalorieMonthsForYear")
                
                
                
                
                
                let fileManager2 = FileManager.default
                let documentsURL2 = fileManager2.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let directoryURL2 = documentsURL2.appendingPathComponent("dailyData")
                let fileURL2 = directoryURL2.appendingPathComponent("/dailyCalandDistanceData.csv")
                
                let filePath2 = fileURL2.path
                
                if (fileManager2.fileExists(atPath: filePath2)) && (yearlyCalorieButtonFlag == 1) {
                    print("fileManager2")
                    
                    do {
                        let data3 = try String(contentsOf: fileURL2)
                        
                        let numbersOfMonthlyCalorieData3 = data3.components(separatedBy: .newlines)
                        // 파일 데이터 행 전체 갯
                        numbersOfMonthlyCalorieData = numbersOfMonthlyCalorieData3.count
                        
                        let weeklyCalorieData40 = data3.components(separatedBy: .newlines)
                        
                        for i in 0 ..< numbersOfMonthlyCalorieData - 1{
                            let row1 = weeklyCalorieData40[i]
                            let columns = row1.components(separatedBy: ",")
                            let calorieYear = columns[0]
                            
                            let intCountCalorieYear = Int(calorieYear)
                            
                            if (intCountCalorieYear == intCalorieYear){
                                
                                numbersOfCalorieDaysForYear +=  1
                            }
                            
                            defaults.set(numbersOfCalorieDaysForYear, forKey:"numbersOfCalorieDaysForYear")
                        }
                        
                        
//                        if numbersOfCalorieDaysForYear == 0 {
//                            print("numbersOfCalorieDaysForYear")
//                            let alert = UIAlertController(title: "No data", message: "", preferredStyle: UIAlertController.Style.alert)
//                            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
//
//                                // noncontactFlag = 0
//                            })
//                            alert.addAction(ok)
//                            present(alert,animated: true, completion: nil)
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                alert.dismiss(animated: true, completion: nil)
//                            }
//
//                        }

                        // 데이터 없음
//                        if (sumOfYearlyTcalCalorie + sumOfYearlyEcalCalorie) == 0 {
//                            lastYearCalorieButton.isEnabled = false
//                        }
                        
                    } catch  {
                        print("Error reading CSV file")
                    }
                }
 
            }
            catch  {
                print("Error reading CSV file")
            }
            
            
            yearlyCalorieChartViewGraph()
            yearlyCalorieButtonFlag = 0
            
        }else {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    
    @objc func lastYearSelectCalorieButton(sender: AnyObject){
        yearlyCalorieButtonFlag = 1
        lookingBottomCalorieMonthOfYear ()
    }
    
    func lookingUpperCalorieMonthOfYear(){
        
        
        yearlyTcalCalorieData = []
        yearlyEcalCalorieData = []
        sumOfYearlyTcalCalorie = 0
        sumOfYearlyEcalCalorie = 0
        
        numbersOfYearlyCalorieData = 0
        numbersOfCalorieDaysForYear = 0
        numbersOfCalorieMonthsForYear = 0
        
        
        baseCalorieMonthOfYear = defaults.integer(forKey:"baseCalorieMonthOfYear")
        currentCalorieYear = defaults.integer(forKey:"currentCalorieYear")
        numbersOfYearlyCalorieData = defaults.integer(forKey:"numbersOfYearlyCalorieData")
        
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && ((numbersOfYearlyCalorieData - baseCalorieMonthOfYear) > 1) && yearlyCalorieButtonFlag == 1  {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyCalorieData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyCalorieData = numbersOfYearlyCalorieData2.count
                
                let weeklyCalorieData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyCalorieData - 1 {
                    let row1 = weeklyCalorieData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let calorieYear = columns[0]
                    let calorieMonth = columns[1]
                    let yearlyTcalCalorieDataRow = Double(columns[5])
                    let yearlyEcalCalorieDataRow = Double(columns[6])
                    
                    intCalorieYear = Int(calorieYear) ?? 0
                    
                    if (intCalorieYear == baseCalorieYear + 1){
                        
                        numbersOfCalorieMonthsForYear +=  1
                        
                        yearlyCalorieTimeData.append(calorieMonth)
                        yearlyTcalCalorieData.append(yearlyTcalCalorieDataRow ?? 0.0)
                        yearlyEcalCalorieData.append(yearlyEcalCalorieDataRow ?? 0.0)
                        
                        sumOfYearlyTcalCalorie = sumOfYearlyTcalCalorie + Int(yearlyTcalCalorieDataRow ?? 0)
                        sumOfYearlyEcalCalorie = sumOfYearlyEcalCalorie + Int(yearlyEcalCalorieDataRow ?? 0)
                        
                    }
                }
                defaults.set(sumOfYearlyTcalCalorie, forKey:"sumOfYearlyTcalCalorie")
                defaults.set(sumOfYearlyEcalCalorie, forKey:"sumOfYearlyEcalCalorie")
                tCalorieYearValue.text = String("\(sumOfYearlyTcalCalorie)")
                
                eCalorieYearValue.text = String("\(sumOfYearlyEcalCalorie)")
                yearCalorieDisplay.text = String("\(intCalorieYear)")
                
                baseCalorieMonthOfYear  = numbersOfYearlyCalorieData - baseCalorieMonthOfYear + numbersOfCalorieMonthsForYear
                
                defaults.set(intCalorieYear, forKey:"currentCalorieYear")
                defaults.set(baseCalorieMonthOfYear, forKey:"baseCalorieMonthOfYear")
                defaults.set(numbersOfYearlyCalorieData, forKey:"numbersOfYearlyCalorieData")
                defaults.set(numbersOfCalorieMonthsForYear, forKey:"numbersOfCalorieMonthsForYear")
                
                
                let fileManager2 = FileManager.default
                let documentsURL2 = fileManager2.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let directoryURL2 = documentsURL2.appendingPathComponent("dailyData")
                let fileURL2 = directoryURL2.appendingPathComponent("/dailyCalandDistanceData.csv")
                
                let filePath2 = fileURL2.path
                
                if (fileManager2.fileExists(atPath: filePath2)) && (yearlyCalorieButtonFlag == 0) {
                    
                    
                    do {
                        let data3 = try String(contentsOf: fileURL2)
                        
                        let numbersOfMonthlyCalorieData3 = data3.components(separatedBy: .newlines)
                        // 파일 데이터 행 전체 갯
                        numbersOfMonthlyCalorieData = numbersOfMonthlyCalorieData3.count
                        
                        let weeklyCalorieData40 = data3.components(separatedBy: .newlines)
                        
                        for i in 0 ..< numbersOfMonthlyCalorieData - 1{
                            let row1 = weeklyCalorieData40[i]
                            let columns = row1.components(separatedBy: ",")
                            let calorieYear = columns[0]
                            
                            let intCountCalorieYear = Int(calorieYear)
                            
                            if (intCountCalorieYear == intCalorieYear){
                                
                                numbersOfCalorieDaysForYear +=  1
                            }
                            
                            defaults.set(numbersOfCalorieDaysForYear, forKey:"numbersOfCalorieDaysForYear")
                        }
                        
                        if numbersOfCalorieDaysForYear == 0 {
                            
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
            
            
            yearlyCalorieChartViewGraph()
            yearlyCalorieButtonFlag = 0
        }else {
            
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyCalorieChartView.clear()
//            alertLabel.text = "\(alertString)\n데이터가 없습니다."
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    
    @objc func nextYearSelectCalorieButton(sender: AnyObject){
        yearlyCalorieButtonFlag = 1
        lookingUpperCalorieMonthOfYear()
    }
    // MARK: -
    //     ------------------------지난해 다음해 버튼들 끝  ----------------------
    
}
