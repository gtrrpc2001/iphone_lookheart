//
//  arrgraph.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2023/05/10.
//


import UIKit
import Foundation
import Charts
import SnapKit
import Then


let hourlyArrChartView = BarChartView()
let weeklyArrChartView = BarChartView()
let monthlyArrChartView = BarChartView()
let yearlyArrChartView = BarChartView()

var hourlyArrData: [Double] = []
var hourlyArrTimeData: [String] = []

var weeklyArrData: [Double] = []
var weeklyArrTimeData: [String] = []


var monthlyArrData: [Double] = []
var monthlyArrTimeData: [String] = []

var yearlyArrData: [Double] = []
var yearlyArrTimeData: [String] = []

var numbersOfHourlyArrData = 0
var numbersOfWeeklyArrData = 0
var numbersOfMonthlyArrData = 0
var numbersOfYearlyArrData = 0

var newNumbersOfWeeklyArrData = 0
var newNumbersOfMonthlyArrData = 0

var numbersOfArrDaysForMonth = 0
var numbersOfArrMonthsForYear = 0

var arrTodayDate = Date()


var sumOfdailyARR = 0
var sumOfWeeklyARR = 0
var sumOfMonthlyARR = 0
var sumOfYearlyARR = 0


var weeklyArrButtonFlag = 0
var monthlyArrButtonFlag = 0
var yearlyArrButtonFlag = 0

var baseArrDayOfMonth = 0
var baseArrMonthOfYear = 0
var currentArrYear = 0
var baseArrYear = 0
var intArrYear = 0

var safeAreaHeight = 0
var safeAreaWidth = 0
var halfSafeAreaHeight = 0
var halfSafeAreaWidth = 0
var TwoOfThreeSafeAreaHeight = 0
var TwoOfThreeSafeAreaWidth = 0


var arrChangeRealYear:String = ""
var arrChangeRealMonth:String = ""
var arrChangeRealDate:String = ""

var pre_arrChangeRealYear:String = ""
var pre_arrChangeRealMonth:String = ""
var pre_arrChangeRealDate:String = ""

var arrDateCount = 0

var saveAlertString = ""

class arrGraphVC: UIViewController, UITextFieldDelegate {
    
    var fCurTextfieldBottom: CGFloat = 0.0
    
    private let safeAreaView = UIView()
    
    var alertString = ""
    var alertFlag = false
    
    var saveFirstWeekValue = 0
    var saveFirstWeekValueFlag = false
    var weekAlertString = ""
            
    var nextWeekDataCheck:Bool = false
    var lastWeekDataCheck:Bool = false
    
    var nextMonthDataCheck:Bool = false
    var lastMonthDataCheck:Bool = false
    
    var saveLastPoint:Bool = false
    var saveLastPointValue = 0
    
    var saveNextPoint:Bool = false
    
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
    
    
    lazy var hourlyArrChartView: BarChartView =  {
        let hourlyArrChartView = BarChartView()
        hourlyArrChartView.noDataText = ""
        return hourlyArrChartView
    }()
    
    lazy var weeklyArrChartView: BarChartView =  {
        let weeklyArrChartView = BarChartView()
        weeklyArrChartView.noDataText = ""
        return weeklyArrChartView
    }()
    
    
    lazy var monthlyArrChartView: BarChartView =  {
        let monthlyArrChartView = BarChartView()
        monthlyArrChartView.noDataText = ""
        return monthlyArrChartView
    }()
    
    
    lazy var yearlyArrChartView: BarChartView =  {
        let yearlyArrChartView = BarChartView()
        yearlyArrChartView.noDataText = ""
        return yearlyArrChartView
    }()
    
    
    lazy var dayArrButton = UIButton().then {
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
    
    
    lazy var weekArrButton = UIButton().then {
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
    
    
    lazy var monthArrButton = UIButton().then {
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
    
    lazy var yearArrButton = UIButton().then {
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
    
    
    
    lazy var dateArrDisplay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)-\(realDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var weekArrDisplay = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var monthArrDisplay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var yearArrDisplay = UILabel().then {
        $0.text = "\(realYear)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    //    lazy var bpmButton = UIButton().then {
    //        $0.setImage(HeartBeat, for: UIControl.State.normal)
    //        $0.addTarget(self, action: #selector(arrBpmClick(sender:)), for: .touchUpInside)
    //    }
    //
    //    lazy var arrButton = UIButton().then {
    //        $0.setImage(irregularHB, for: UIControl.State.normal)
    //        $0.backgroundColor = .cyan
    //        //        $0.addTarget(self, action: #selector(arrArrClick(sender:)), for: .touchUpInside)
    //    }
    //
    //
    //    lazy var calorieButton = UIButton().then {
    //        $0.setImage(calorie, for: UIControl.State.normal)
    //        $0.addTarget(self, action: #selector(arrCalorieClick(sender:)), for: .touchUpInside)
    //    }
    //
    //    lazy var stepButton = UIButton().then {
    //        $0.setImage(step, for: UIControl.State.normal)
    //        $0.addTarget(self, action: #selector(arrStepClick(sender:)), for: .touchUpInside)
    //    }
    //
    //    lazy var temperatureButton = UIButton().then {
    //        $0.setImage(temperature, for: UIControl.State.normal)
    //        $0.addTarget(self, action: #selector(arrTemperatureClick(sender:)), for: .touchUpInside)
    //    }
    //
    //    -----------------------------day button-------------------
    
    lazy var yesterdayHourlyArrButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(yesterdayHourlySelectArrButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var tomorrowHourlyArrButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(tomorrowHourlySelectArrButton(sender:)), for: .touchUpInside)
    }
    
    
    //    -----------------------------day button-------------------
    
    
    //    -----------------------------weeek button-------------------
    
    lazy var lastWeekArrButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastWeekSelectArrButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextWeekArrButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextWeekSelectArrButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------weeek button-------------------
    
    
    
    //    -----------------------------month button-------------------
    
    lazy var lastMonthArrButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastMonthSelectArrButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextMonthArrButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextMonthSelectArrButton(sender:)), for: .touchUpInside)
    }
    
    
    //    -----------------------------month button-------------------
    
    
    
    //    -----------------------------yearkbutton------------------
    
    lazy var lastYearArrButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastyearSelectArrButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var nextYearArrButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextyearSelectArrButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------yearkbutton------------------
    
    
    lazy var arrBackground = UILabel().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 3
    }
    
    lazy var arrDayLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "비정상맥박\n(times/Day)"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.numberOfLines = 2
        $0.backgroundColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var arrDayValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var arrWeekLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "비정상맥박\n(times/Week)"
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.baselineAdjustment = .alignCenters
        $0.textAlignment = .center
        $0.backgroundColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var arrWeekValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.backgroundColor = .white
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    
    lazy var arrMonthLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "비정상맥박\n(times/Month)"
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var arrMonthValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = .white
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var arrYearLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "비정상맥박\n(times/Year)"
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var arrYearValue = UILabel().then {
        $0.text = ""
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.backgroundColor = .white
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
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
    
    func arrviews(){
        
        //        let buttonStackView1: UIStackView = {
        //            let buttonStackView1 = UIStackView(arrangedSubviews: [bpmButton, arrButton, calorieButton, stepButton, temperatureButton])
        //            buttonStackView1.axis = .horizontal
        //            buttonStackView1.distribution = .fillEqually // default
        //            buttonStackView1.alignment = .fill // default
        //            buttonStackView1.spacing = 10.0
        //            buttonStackView1.backgroundColor = .white
        //
        //            view.addSubview(buttonStackView1)
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
        
        view.addSubview(hourlyArrChartView)
        hourlyArrChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            
        }
        
        view.addSubview(weeklyArrChartView)
        weeklyArrChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyArrChartView.snp.bottom)
        }
        
        view.addSubview(monthlyArrChartView)
        monthlyArrChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyArrChartView.snp.bottom)
            //            make.height.equalTo(250)
        }
        
        
        view.addSubview(yearlyArrChartView)
        yearlyArrChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(hourlyArrChartView.snp.bottom)
        }
        
        let buttonStackView2: UIStackView = {
            let buttonStackView2 = UIStackView(arrangedSubviews: [dayArrButton, weekArrButton, monthArrButton, yearArrButton])
            buttonStackView2.axis = .horizontal
            buttonStackView2.distribution = .fillEqually // default
            buttonStackView2.alignment = .fill // default
            buttonStackView2.spacing = 20.0
            
            view.addSubview(buttonStackView2)
            
            
            self.dayArrButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            self.weekArrButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            
            self.monthArrButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            
            self.yearArrButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
                $0.trailing.equalTo(buttonStackView2)
                
            }
            
            return buttonStackView2
        }()
        
        
        buttonStackView2.snp.makeConstraints { (make) in
            
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.top.equalTo(self.hourlyArrChartView.snp.bottom)
            make.height.equalTo(50)
        }
        
        
        //        -----------------------day button position--------------------
        
        
        view.addSubview(yesterdayHourlyArrButton)
        yesterdayHourlyArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(dateArrDisplay)
        dateArrDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(yesterdayHourlyArrButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(tomorrowHourlyArrButton)
        tomorrowHourlyArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(dateArrDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        //        -----------------------day button position--------------------
        
        
        //        -----------------------week button position--------------------
        
        
        view.addSubview(lastWeekArrButton)
        lastWeekArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(weekArrDisplay)
        weekArrDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastWeekArrButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextWeekArrButton)
        nextWeekArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(weekArrDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------week button position--------------------
        
        
        //        -----------------------month button position--------------------
        
        
        view.addSubview(lastMonthArrButton)
        lastMonthArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(monthArrDisplay)
        monthArrDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastMonthArrButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextMonthArrButton)
        nextMonthArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(monthArrDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------month button position--------------------
        
        
        
        //        -----------------------year button position--------------------
        
        view.addSubview(lastYearArrButton)
        lastYearArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(yearArrDisplay)
        yearArrDisplay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastYearArrButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(nextYearArrButton)
        nextYearArrButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(yearArrDisplay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        //        -----------------------year button position--------------------
        
        view.addSubview(arrDayLabel)
        arrDayLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.width.equalTo(halfSafeAreaWidth)
            make.height.equalTo(100)
        }
        
        
        view.addSubview(arrDayValue)
        arrDayValue.snp.makeConstraints {(make) in
            make.leading.equalTo(arrDayLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.height.equalTo(100)
        }
        
        
        view.addSubview(arrWeekLabel)
        arrWeekLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.width.equalTo(halfSafeAreaWidth)
            make.height.equalTo(100)
        }
        
        
        view.addSubview(arrWeekValue)
        arrWeekValue.snp.makeConstraints {(make) in
            make.leading.equalTo(arrWeekLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.height.equalTo(100)
        }
        
        view.addSubview(arrMonthLabel)
        arrMonthLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.width.equalTo(halfSafeAreaWidth)
            make.height.equalTo(100)
        }
        
        
        view.addSubview(arrMonthValue)
        arrMonthValue.snp.makeConstraints {(make) in
            make.leading.equalTo(arrMonthLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.height.equalTo(100)
        }
        
        
        view.addSubview(arrYearLabel)
        arrYearLabel.snp.makeConstraints {(make) in
            make.leading.equalTo(safeAreaView.snp.leading)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.width.equalTo(halfSafeAreaWidth)
            make.height.equalTo(100)
        }
        
        
        view.addSubview(arrYearValue)
        arrYearValue.snp.makeConstraints {(make) in
            make.leading.equalTo(arrYearLabel.snp.trailing)
            make.trailing.equalTo(safeAreaView.snp.trailing)
            make.top.equalTo(yesterdayHourlyArrButton.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaView.snp.bottom)
            make.height.equalTo(100)
        }
        
        view.addSubview(arrBackground)
        arrBackground.snp.makeConstraints {(make) in
            make.top.equalTo(arrDayLabel.snp.top)
            make.leading.equalTo(arrDayLabel.snp.leading)
            make.trailing.equalTo(arrDayValue.snp.trailing)
            make.bottom.equalTo(arrDayLabel.snp.bottom)
        }
        // MARK: - AlertConstraint
        view.addSubview(alertBackground)
        view.addSubview(alertLabel)
        
        alertBackground.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertBackground.leadingAnchor.constraint(equalTo: hourlyArrChartView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: hourlyArrChartView.trailingAnchor, constant: -20),
            alertBackground.centerXAnchor.constraint(equalTo: hourlyArrChartView.centerXAnchor),
            alertBackground.centerYAnchor.constraint(equalTo: hourlyArrChartView.centerYAnchor),

            alertBackground.heightAnchor.constraint(equalToConstant: 120),


            alertLabel.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
        ])
        
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView1()
        arrviews()
        
        startDayArrGraph()
        
        arrDayLabel.alpha = 1.0
        arrDayValue.alpha = 1.0
        arrWeekLabel.alpha = 0.0
        arrWeekValue.alpha = 0.0
        arrMonthLabel.alpha = 0.0
        arrMonthValue.alpha = 0.0
        arrYearLabel.alpha = 0.0
        arrYearValue.alpha = 0.0
        
        dayArrButton.isSelected = true
        weekArrButton.isSelected  = false
        monthArrButton.isSelected = false
        yearArrButton.isSelected = false
        
        dateArrDisplay.isHidden = false
        weekArrDisplay.isHidden = true
        monthArrDisplay.isHidden = true
        yearArrDisplay.isHidden = true
        
        yesterdayHourlyArrButton.isHidden = false
        tomorrowHourlyArrButton.isHidden = false
        
        lastWeekArrButton.isHidden = true
        nextWeekArrButton.isHidden = true
        
        lastMonthArrButton.isHidden = true
        nextMonthArrButton.isHidden = true
        
        lastYearArrButton.isHidden = true
        nextYearArrButton.isHidden = true
        
        
        yesterdayHourlyArrButton.isEnabled = true
        tomorrowHourlyArrButton.isEnabled = true
        
        lastWeekArrButton.isEnabled = false
        nextWeekArrButton.isEnabled = false
        
        lastMonthArrButton.isEnabled = false
        nextMonthArrButton.isEnabled = false
        
        lastYearArrButton.isEnabled = false
        nextYearArrButton.isEnabled = false
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(arrTimer), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func arrTimer(){
        
        arrDayValue.text = String(sumOfdailyARR)
        arrWeekValue.text = String(sumOfWeeklyARR)
        arrMonthValue.text = String(sumOfMonthlyARR)
        arrYearValue.text = String(sumOfYearlyARR)
        
    }
    
    // MARK: - hourlyArrChartViewGraph
    func hourlyArrChartViewGraph(){
        
        sumOfdailyARR = 0
        
        var dailyARR = 0
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        weeklyArrChartView.clear()
        hourlyArrChartView.clear()
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("\(arrChangeRealYear)/\(arrChangeRealMonth)/\(arrChangeRealDate)")
        let fileURL1 = directoryURL1.appendingPathComponent("/calandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if fileManager1.fileExists(atPath: filePath1){
            
            do {
                let data1 = try String(contentsOf: fileURL1)
                
                let hourlyArrData1 = data1.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfHourlyArrData = hourlyArrData1.count
                
                for i in 0 ..< numbersOfHourlyArrData - 1{
                    let row1 = hourlyArrData1[i]
                    let columns1 = row1.components(separatedBy: ",")
                    let hourlyArrTimeRow = columns1[0]
                    let hourlyArrDataRow = Double(columns1[6])
                    
                    dailyARR = dailyARR + Int(hourlyArrDataRow ?? 0)
                    
                    hourlyArrTimeData.append(hourlyArrTimeRow)
                    hourlyArrData.append(hourlyArrDataRow ?? 0.0)
                }
                
                sumOfdailyARR = dailyARR
                
                
            } catch  {
                print("Error reading CSV file")
                
            }
            
            var hourlyArrDataEntries = [BarChartDataEntry]()
            
            for i in 0 ..< numbersOfHourlyArrData - 1 {
                let hourlyArrDataEntry = BarChartDataEntry(x: Double(i), y: hourlyArrData[i])
                hourlyArrDataEntries.append(hourlyArrDataEntry)
            }
            
            
            let hourlyArrChartDataSet = BarChartDataSet(entries: hourlyArrDataEntries, label: "비정상맥박(times)")
            
            hourlyArrChartDataSet.setColor(NSUIColor.red)
            // bar 상단에 value값 보여지게 설정
            hourlyArrChartDataSet.drawValuesEnabled = true
            
            hourlyArrChartDataSet.valueFormatter = IntegerValueFormatter()
            hourlyArrChartDataSet.valueFormatter = NonZeroValueFormatter()
            
            let hourlyArrChartData = BarChartData(dataSet: hourlyArrChartDataSet)
            
            hourlyArrChartView.noDataText = ""
            hourlyArrChartView.data = hourlyArrChartData
            hourlyArrChartView.xAxis.enabled = true
            
            hourlyArrChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hourlyArrTimeData)
            hourlyArrChartView.xAxis.granularity = 1
            hourlyArrChartView.xAxis.setLabelCount(numbersOfHourlyArrData, force: false)
            hourlyArrChartView.xAxis.labelPosition = .bottom
            hourlyArrChartView.xAxis.drawGridLinesEnabled = false
            hourlyArrChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            hourlyArrChartView.leftAxis.granularityEnabled = true
            hourlyArrChartView.leftAxis.granularity = 1.0
            hourlyArrChartView.leftAxis.axisMinimum = 0
            hourlyArrChartView.rightAxis.enabled = false
            hourlyArrChartView.drawMarkers = false
            hourlyArrChartView.dragEnabled = false
            hourlyArrChartView.pinchZoomEnabled = false
            hourlyArrChartView.doubleTapToZoomEnabled = false
            hourlyArrChartView.highlightPerTapEnabled = false
            
            
            hourlyArrChartView.data?.notifyDataChanged()
            hourlyArrChartView.notifyDataSetChanged()
            hourlyArrChartView.moveViewToX(0)
            hourlyArrTimeData = []
            hourlyArrData = []
            
        }
        else{
            alertFlag = true
            alertString += "\(arrChangeRealYear)/\(arrChangeRealMonth)/\(arrChangeRealDate)\n"
        }
        // file이 없는 경우
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            alertLabel.text = alertString + "데이터가 없습니다."
        }
    }
    
    // MARK: - weekly
    func weeklyArrChartViewGraph(){
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        hourlyArrChartView.clear()
        weeklyArrChartView.clear()
        
        var weeklyArrDataCount = 0
        //        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        sumOfWeeklyARR = 0
        
        numbersOfWeeklyArrData = defaults.integer(forKey:"numbersOfWeeklyArrData")
        
        // 초기값 저장을 위함
        if saveFirstWeekValueFlag == false {
            saveFirstWeekValue = numbersOfWeeklyArrData
            saveFirstWeekValueFlag = true
        }
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if fileManager1.fileExists(atPath: filePath1) {
            
            do {
                let data1 = try String(contentsOf: fileURL1)
                
                //
                let weeklyArrData1 = data1.components(separatedBy: .newlines)
                //                // 파일 데이터 행 전체 갯
                //                numbersOfHourlyArr = hourlyArrData1.count
                
                for i in numbersOfWeeklyArrData - 8 ..< numbersOfWeeklyArrData - 1{
                    let row1 = weeklyArrData1[i]
                    let columns = row1.components(separatedBy: ",")
                    let weeklyArrTimeRow = columns[3]
                    let weeklyArrDataRow = Double(columns[9])
                    
                    sumOfWeeklyARR = sumOfWeeklyARR + Int(weeklyArrDataRow ?? 0)
                    
                    weeklyArrTimeData.append(weeklyArrTimeRow)
                    weeklyArrData.append(weeklyArrDataRow ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
                
            }
            
            for i in 0..<weeklyArrData.count {
                // 데이터가 있는지 없는지 확인
                if weeklyArrData[i] == 0.0{
                    weeklyArrDataCount += 1
                }
                // 데이터가 다 없는 경우 알림창을 띄우기 위한 조건
                if weeklyArrDataCount == 7{
                    alertFlag = true
                }
                // 영문 -> 한글
                if weeklyArrTimeData[i] == "Mon" {
                    weeklyArrTimeData[i] = "월"
                }
                else if weeklyArrTimeData[i] == "Tue" {
                    weeklyArrTimeData[i] = "화"
                }
                else if weeklyArrTimeData[i] == "Wed" {
                    weeklyArrTimeData[i] = "수"
                }
                else if weeklyArrTimeData[i] == "Thu" {
                    weeklyArrTimeData[i] = "목"
                }
                else if weeklyArrTimeData[i] == "Fri" {
                    weeklyArrTimeData[i] = "금"
                }
                else if weeklyArrTimeData[i] == "Sat" {
                    weeklyArrTimeData[i] = "토"
                }
                else if weeklyArrTimeData[i] == "Sun" {
                    weeklyArrTimeData[i] = "일"
                }
            }
            
            let weekNumber = 7
            
            var weeklyArrDataEntries = [BarChartDataEntry]()
            
            for i in 0 ..< weekNumber {
                let weeklyArrDataEntry = BarChartDataEntry(x: Double(i), y: weeklyArrData[i])
                weeklyArrDataEntries.append(weeklyArrDataEntry)
            }
            
            
            let weeklyArrChartDataSet = BarChartDataSet(entries: weeklyArrDataEntries, label: "비정상맥박(times)")
            
            weeklyArrChartDataSet.setColor(NSUIColor.red)
            weeklyArrChartDataSet.drawValuesEnabled = false
            
            
            let weeklyArrChartData = BarChartData(dataSet: weeklyArrChartDataSet)
            
            weeklyArrChartView.noDataText = ""
            weeklyArrChartView.data = weeklyArrChartData
            weeklyArrChartView.xAxis.enabled = true
            
            weeklyArrChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weeklyArrTimeData)
            weeklyArrChartView.xAxis.granularity = 1
            weeklyArrChartView.xAxis.setLabelCount(7, force: false)
            weeklyArrChartView.xAxis.labelPosition = .bottom
            weeklyArrChartView.xAxis.drawGridLinesEnabled = false
            weeklyArrChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            
            weeklyArrChartView.leftAxis.granularityEnabled = true
            weeklyArrChartView.leftAxis.granularity = 1.0
            weeklyArrChartView.leftAxis.axisMinimum = 0
            weeklyArrChartView.rightAxis.enabled = false
            weeklyArrChartView.drawMarkers = false
            weeklyArrChartView.dragEnabled = false
            weeklyArrChartView.pinchZoomEnabled = false
            weeklyArrChartView.doubleTapToZoomEnabled = false
            weeklyArrChartView.highlightPerTapEnabled = false
            
            weeklyArrChartView.data?.notifyDataChanged()
            weeklyArrChartView.notifyDataSetChanged()
            weeklyArrChartView.moveViewToX(0)
            weeklyArrTimeData = []
            weeklyArrData = []
            
            
            
        }
        else{
            alertFlag = true
        }
        // file이나 data가 없는 경우
        if alertFlag == true {
            weeklyArrChartView.clear()
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            alertLabel.text = "데이터가 없습니다."
        }
    }
    
    
    //MARK: - monthly
    func monthlyArrChartViewGraph(){
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        hourlyArrChartView.clear()
        weeklyArrChartView.clear()
        
        var monthlyArrDataCount = 0
        //        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        
        
        sumOfMonthlyARR = defaults.integer(forKey:"sumOfMonthlyARR")
        numbersOfArrDaysForMonth = defaults.integer(forKey:"numbersOfArrDaysForMonth")
        
        var monthlyArrDataEntries = [BarChartDataEntry]()
        
        for _ in 0..<20 {
            monthlyArrChartView.zoomOut()
        }
        
        for i in 0 ..< numbersOfArrDaysForMonth  {
            let monthlyArrDataEntry = BarChartDataEntry(x: Double(i), y: monthlyArrData[i])
            monthlyArrDataEntries.append(monthlyArrDataEntry)
            
            // 데이터 체크
            if monthlyArrData[i] == 0.0{
                monthlyArrDataCount += 1
            }
        }
        // 데이터가 없음
        if numbersOfArrDaysForMonth == monthlyArrDataCount {
            alertFlag = true
        }
        
        let monthlyArrChartDataSet = BarChartDataSet(entries: monthlyArrDataEntries, label: "비정상맥박(times)")
        
        monthlyArrChartDataSet.setColor(NSUIColor.red)
        monthlyArrChartDataSet.drawValuesEnabled = false
        
        let monthlyArrChartData = BarChartData(dataSet: monthlyArrChartDataSet)
        
        monthlyArrChartView.noDataText = ""
        monthlyArrChartView.data = monthlyArrChartData
        monthlyArrChartView.xAxis.enabled = true
        
        monthlyArrChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthlyArrTimeData)
        monthlyArrChartView.xAxis.granularity = 1.0
        monthlyArrChartView.xAxis.setLabelCount(numbersOfArrDaysForMonth, force: false)
        monthlyArrChartView.xAxis.labelPosition = .bottom
        monthlyArrChartView.xAxis.drawGridLinesEnabled = false
        monthlyArrChartView.setVisibleXRangeMaximum(15)   // 처음 보여지는 x축 범위
        monthlyArrChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        monthlyArrChartView.leftAxis.granularityEnabled = true
        monthlyArrChartView.leftAxis.granularity = 1.0
        monthlyArrChartView.leftAxis.axisMinimum = 0
        monthlyArrChartView.rightAxis.enabled = false
        monthlyArrChartView.drawMarkers = false
        monthlyArrChartView.dragEnabled = true
        monthlyArrChartView.pinchZoomEnabled = false
        monthlyArrChartView.doubleTapToZoomEnabled = false
        monthlyArrChartView.highlightPerTapEnabled = false
        
        monthlyArrChartView.data?.notifyDataChanged()
        monthlyArrChartView.notifyDataSetChanged()
        monthlyArrChartView.moveViewToX(Double(monthlyArrTimeData.count)) // 끝부터 보여지게
        monthlyArrTimeData = []
        monthlyArrData = []
        
        numbersOfArrDaysForMonth = 0
        
        hourlyArrChartView.isUserInteractionEnabled = false
        weeklyArrChartView.isUserInteractionEnabled = false
        monthlyArrChartView.isUserInteractionEnabled = true
        yearlyArrChartView.isUserInteractionEnabled = false
        
        if alertFlag == true {
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            monthlyArrChartView.clear()
            alertLabel.text = saveAlertString + "\n데이터가 없습니다."
        }
        
    }
    
    //MARK: - yearlyArrChartViewGraph
    func yearlyArrChartViewGraph(){
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        hourlyArrChartView.clear()
        weeklyArrChartView.clear()
        
//        alertLabel.isHidden = true
//        alertBackground.isHidden = true
        // 기능 구현 전까지 false
        lastYearArrButton.isEnabled = false
        nextYearArrButton.isEnabled = false
        
        numbersOfArrMonthsForYear = defaults.integer(forKey:"numbersOfArrMonthsForYear")
        
        
        var yearlyArrDataEntries = [BarChartDataEntry]()
        
        for i in 0 ..< numbersOfArrMonthsForYear {
            let yearlyArrDataEntry = BarChartDataEntry(x: Double(i), y: yearlyArrData[i])
            yearlyArrDataEntries.append(yearlyArrDataEntry)
        }
        
        
        let yearlyArrChartDataSet = BarChartDataSet(entries: yearlyArrDataEntries, label: "비정상맥박(times)")
        
        yearlyArrChartDataSet.setColor(NSUIColor.red)
        yearlyArrChartDataSet.drawValuesEnabled = false
        
        
        let yearlyArrChartData = BarChartData(dataSet: yearlyArrChartDataSet)
        
        yearlyArrChartView.noDataText = ""
        yearlyArrChartView.data = yearlyArrChartData
        yearlyArrChartView.xAxis.enabled = true
        
        yearlyArrChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yearlyArrTimeData)
        yearlyArrChartView.xAxis.granularity = 1
        yearlyArrChartView.xAxis.setLabelCount(numbersOfArrMonthsForYear, force: false)
        yearlyArrChartView.xAxis.labelPosition = .bottom
        yearlyArrChartView.xAxis.drawGridLinesEnabled = false
        
        yearlyArrChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
        
        yearlyArrChartView.leftAxis.granularityEnabled = true
        yearlyArrChartView.leftAxis.granularity = 1.0
        yearlyArrChartView.leftAxis.axisMinimum = 0
        yearlyArrChartView.rightAxis.enabled = false
        yearlyArrChartView.drawMarkers = false
        yearlyArrChartView.dragEnabled = false
        yearlyArrChartView.pinchZoomEnabled = false
        yearlyArrChartView.doubleTapToZoomEnabled = false
        yearlyArrChartView.highlightPerTapEnabled = false
        
        yearlyArrChartView.data?.notifyDataChanged()
        yearlyArrChartView.notifyDataSetChanged()
        yearlyArrChartView.moveViewToX(0)
        yearlyArrTimeData = []
        yearlyArrData = []
        
        numbersOfArrMonthsForYear = 0
        
    }
    
    func startDayArrGraph(){
        defaults.set(realYear, forKey: "arrChangeRealYear")
        defaults.set(realMonth, forKey: "arrChangeRealMonth")
        defaults.set(realDate, forKey: "arrChangeRealDate")
        
        
        arrChangeRealYear = defaults.string(forKey:"arrChangeRealYear") ?? "\(realYear)"
        arrChangeRealMonth = defaults.string(forKey:"arrChangeRealMonth") ?? "\(realMonth)"
        arrChangeRealDate = defaults.string(forKey:"arrChangeRealDate") ?? "\(realDate)"
        
        
        dateArrDisplay.text = String("\(arrChangeRealYear)-\(arrChangeRealMonth)-\(arrChangeRealDate)")
        
        dayArrButton.isSelected = true
        weekArrButton.isSelected  = false
        monthArrButton.isSelected = false
        yearArrButton.isSelected = false
        
        dayArrButton.isUserInteractionEnabled = false
        weekArrButton.isUserInteractionEnabled = true
        monthArrButton.isUserInteractionEnabled = true
        yearArrButton.isUserInteractionEnabled = true
        
        dateArrDisplay.isHidden = false
        weekArrDisplay.isHidden = true
        monthArrDisplay.isHidden = true
        yearArrDisplay.isHidden = true
        
        
        arrDayLabel.alpha = 1.0
        arrDayValue.alpha = 1.0
        arrWeekLabel.alpha = 0.0
        arrWeekValue.alpha = 0.0
        arrMonthLabel.alpha = 0.0
        arrMonthValue.alpha = 0.0
        arrYearLabel.alpha = 0.0
        arrYearValue.alpha = 0.0
        
        yesterdayHourlyArrButton.isHidden = false
        tomorrowHourlyArrButton.isHidden = false
        
        lastWeekArrButton.isHidden = true
        nextWeekArrButton.isHidden = true
        
        lastMonthArrButton.isHidden = true
        nextMonthArrButton.isHidden = true
        
        lastYearArrButton.isHidden = true
        nextYearArrButton.isHidden = true
        
        yesterdayHourlyArrButton.isEnabled = true
        tomorrowHourlyArrButton.isEnabled = true
        
        lastWeekArrButton.isEnabled = false
        nextWeekArrButton.isEnabled = false
        
        lastMonthArrButton.isEnabled = false
        nextMonthArrButton.isEnabled = false
        
        lastYearArrButton.isEnabled = false
        nextYearArrButton.isEnabled = false
        
        hourlyArrChartViewGraph()
        
    }
    
    @objc func selectDayClick(sender: AnyObject) {
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -arrDateCount, to: arrTodayDate)!
        
        arrTodayDate = yesterday
        
        let ayear = DateFormatter()
        let amonth = DateFormatter()
        let adate = DateFormatter()
        
        ayear.dateFormat = "yyyy"
        amonth.dateFormat = "MM"
        adate.dateFormat = "dd"
        
        arrChangeRealYear = ayear.string(from: arrTodayDate)
        arrChangeRealMonth = amonth.string(from: arrTodayDate)
        arrChangeRealDate = adate.string(from: arrTodayDate)
        
        
        dateArrDisplay.text = String("\(arrChangeRealYear)-\(arrChangeRealMonth)-\(arrChangeRealDate)")
        
        dayArrButton.isSelected = true
        weekArrButton.isSelected  = false
        monthArrButton.isSelected = false
        yearArrButton.isSelected = false
        
        dayArrButton.isUserInteractionEnabled = false
        weekArrButton.isUserInteractionEnabled = true
        monthArrButton.isUserInteractionEnabled = true
        yearArrButton.isUserInteractionEnabled = true
        
        dateArrDisplay.isHidden = false
        weekArrDisplay.isHidden = true
        monthArrDisplay.isHidden = true
        yearArrDisplay.isHidden = true
        
        
        arrDayLabel.alpha = 1.0
        arrDayValue.alpha = 1.0
        arrWeekLabel.alpha = 0.0
        arrWeekValue.alpha = 0.0
        arrMonthLabel.alpha = 0.0
        arrMonthValue.alpha = 0.0
        arrYearLabel.alpha = 0.0
        arrYearValue.alpha = 0.0
        
        yesterdayHourlyArrButton.isHidden = false
        tomorrowHourlyArrButton.isHidden = false
        
        lastWeekArrButton.isHidden = true
        nextWeekArrButton.isHidden = true
        
        lastMonthArrButton.isHidden = true
        nextMonthArrButton.isHidden = true
        
        lastYearArrButton.isHidden = true
        nextYearArrButton.isHidden = true
        
        yesterdayHourlyArrButton.isEnabled = true
        tomorrowHourlyArrButton.isEnabled = true
        
        lastWeekArrButton.isEnabled = false
        nextWeekArrButton.isEnabled = false
        
        lastMonthArrButton.isEnabled = false
        nextMonthArrButton.isEnabled = false
        
        lastYearArrButton.isEnabled = false
        nextYearArrButton.isEnabled = false
        
        arrDateCount = 0
        
        hourlyArrChartViewGraph()
    }
    
    func yesterdayArrButton(){
        
        arrDateCount = arrDateCount - 1
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: arrTodayDate)!
        
        arrTodayDate = yesterday
        
        let ayear = DateFormatter()
        let amonth = DateFormatter()
        let adate = DateFormatter()
        
        ayear.dateFormat = "yyyy"
        amonth.dateFormat = "MM"
        adate.dateFormat = "dd"
        
        arrChangeRealYear = ayear.string(from: arrTodayDate)
        arrChangeRealMonth = amonth.string(from: arrTodayDate)
        arrChangeRealDate = adate.string(from: arrTodayDate)
        
        dateArrDisplay.text = String("\(arrChangeRealYear)-\(arrChangeRealMonth)-\(arrChangeRealDate)")
        
        defaults.set(arrChangeRealYear, forKey:"arrChangeRealYear")
        defaults.set(arrChangeRealMonth, forKey:"arrChangeRealMonth")
        defaults.set(arrChangeRealDate, forKey:"arrChangeRealDate")
        
    }
    
    
    func tomorrowArrButton(){
        
        arrDateCount = arrDateCount + 1
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: arrTodayDate)!
        arrTodayDate = tomorrow
        
        let ayear = DateFormatter()
        let amonth = DateFormatter()
        let adate = DateFormatter()
        
        
        ayear.dateFormat = "yyyy"
        amonth.dateFormat = "MM"
        adate.dateFormat = "dd"
        
        arrChangeRealYear = ayear.string(from: arrTodayDate)
        arrChangeRealMonth = amonth.string(from: arrTodayDate)
        arrChangeRealDate = adate.string(from: arrTodayDate)
        
        dateArrDisplay.text = String("\(arrChangeRealYear)-\(arrChangeRealMonth)-\(arrChangeRealDate)")
        
        
        defaults.set(arrChangeRealYear, forKey:"arrChangeRealYear")
        defaults.set(arrChangeRealMonth, forKey:"arrChangeRealMonth")
        defaults.set(arrChangeRealDate, forKey:"arrChangeRealDate")
        
    }
    
    
    //     ------------------------어제 내일 버튼들 시작 ----------------------
    
    
    @objc func yesterdayHourlySelectArrButton(sender: AnyObject){
        yesterdayArrButton()
        hourlyArrChartViewGraph()
    }
    
    
    @objc func tomorrowHourlySelectArrButton(sender: AnyObject){
        tomorrowArrButton()
        hourlyArrChartViewGraph()
    }
    
    
    //     ------------------------어제 내일 버튼들  끝 ----------------------
    
    
    
    
    //     ------------------------지난주 다음주 버튼들 시작 ----------------------
    
    // MARK: - WeekButtonClickEvent
    @objc func selectWeekClick(sender: AnyObject) {
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        hourlyArrChartView.clear()
        weeklyArrChartView.clear()
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        dayArrButton.isSelected = false
        weekArrButton.isSelected  = true
        monthArrButton.isSelected = false
        yearArrButton.isSelected = false
        
        dayArrButton.isUserInteractionEnabled = true
        weekArrButton.isUserInteractionEnabled = false
        monthArrButton.isUserInteractionEnabled = true
        yearArrButton.isUserInteractionEnabled = true
        
        dateArrDisplay.isHidden = true
        weekArrDisplay.isHidden = false
        monthArrDisplay.isHidden = true
        yearArrDisplay.isHidden = true
        
        
        arrDayLabel.alpha = 0.0
        arrDayValue.alpha = 0.0
        arrWeekLabel.alpha = 1.0
        arrWeekValue.alpha = 1.0
        arrMonthLabel.alpha = 0.0
        arrMonthValue.alpha = 0.0
        arrYearLabel.alpha = 0.0
        arrYearValue.alpha = 0.0
        
        yesterdayHourlyArrButton.isHidden = true
        tomorrowHourlyArrButton.isHidden = true
        
        lastWeekArrButton.isHidden = false
        nextWeekArrButton.isHidden = false
        
        lastMonthArrButton.isHidden = true
        nextMonthArrButton.isHidden = true
        
        lastYearArrButton.isHidden = true
        nextYearArrButton.isHidden = true
        
        yesterdayHourlyArrButton.isEnabled = false
        tomorrowHourlyArrButton.isEnabled = false
        
        lastWeekArrButton.isEnabled = true
        nextWeekArrButton.isEnabled = true
        
        lastMonthArrButton.isEnabled = false
        nextMonthArrButton.isEnabled = false
        
        lastYearArrButton.isEnabled = false
        nextYearArrButton.isEnabled = false
        
        // 마지막 페이지에서 다른 페이지로 넘어갔을 경우 대비
        if nextWeekDataCheck == true {
            nextWeekDataCheck = false
            nextWeekArrButton.isEnabled = true
        }
        else if lastWeekDataCheck == true {
            lastWeekDataCheck = false
            lastWeekArrButton.isEnabled = true
        }
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && (weeklyArrButtonFlag == 0)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                
                let numbersOfWeeklyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfWeeklyArrData = numbersOfWeeklyArrData2.count
                
                let weeklyArrData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyArrData10[numbersOfWeeklyArrData - 8]
                let columns10 = row10.components(separatedBy: ",")
                //                        let baseWeeklyArrYear1 = columns10[0]
                let baseWeeklyArrMonth1 = columns10[1]
                let baseWeeklyArrDate1 = columns10[2]
                
                
                
                let row20 = weeklyArrData10[numbersOfWeeklyArrData - 2]
                let columns20 = row20.components(separatedBy: ",")
                //                        let baseWeeklyArrYear2 = columns20[0]
                let baseWeeklyArrMonth2 = columns20[1]
                let baseWeeklyArrDate2 = columns20[2]
                
                
                weekArrDisplay.text = String("\(baseWeeklyArrMonth1).\(baseWeeklyArrDate1) ~ \(baseWeeklyArrMonth2).\(baseWeeklyArrDate2)")
                
                // 초기값 저장을 위함
                if saveFirstWeekValueFlag == false {
                    weekAlertString = String("\(baseWeeklyArrMonth1).\(baseWeeklyArrDate1) ~ \(baseWeeklyArrMonth2).\(baseWeeklyArrDate2)")
                }
                
                defaults.set(numbersOfWeeklyArrData, forKey:"numbersOfWeeklyArrData")
                
                
                newNumbersOfWeeklyArrData = numbersOfWeeklyArrData
                weeklyArrChartViewGraph()
                
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else {
            // 데이터가 없는 마지막 페이지까지 갔다가 다시 돌아올 경우 초기 페이지로 돌아가게 함
            defaults.set(saveFirstWeekValue, forKey:"numbersOfWeeklyArrData")
            weekArrDisplay.text = weekAlertString
            weeklyArrChartViewGraph()
        }
    }
    
    
    
    func lastweekArrButton(){
        
        //        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        numbersOfWeeklyArrData = defaults.integer(forKey:"numbersOfWeeklyArrData")
        numbersOfWeeklyArrData = numbersOfWeeklyArrData - 7
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && ((numbersOfWeeklyArrData - 8) > 0)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let weeklyArrData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyArrData10[numbersOfWeeklyArrData - 8]
                let columns10 = row10.components(separatedBy: ",")
                
                let baseWeeklyArrMonth1 = columns10[1]
                let baseWeeklyArrDate1 = columns10[2]
                
                let row20 = weeklyArrData10[numbersOfWeeklyArrData - 2]
                let columns20 = row20.components(separatedBy: ",")
                
                let baseWeeklyArrMonth2 = columns20[1]
                let baseWeeklyArrDate2 = columns20[2]
                
                
                weekArrDisplay.text = String("\(baseWeeklyArrMonth1 ).\(baseWeeklyArrDate1) ~ \(baseWeeklyArrMonth2).\(baseWeeklyArrDate2)")
                saveAlertString = String("\(baseWeeklyArrMonth1 ).\(baseWeeklyArrDate1) ~ \(baseWeeklyArrMonth2).\(baseWeeklyArrDate2)")
                defaults.set(numbersOfWeeklyArrData, forKey:"numbersOfWeeklyArrData")
                
                weeklyArrChartViewGraph()
                weeklyArrButtonFlag = 0
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            lastWeekDataCheck = true
            lastWeekArrButton.isEnabled = false
            weeklyArrChartView.clear()
            defaults.set(numbersOfWeeklyArrData-7, forKey:"numbersOfWeeklyArrData")
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
    
    
    func nextweekArrButton(){
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        numbersOfWeeklyArrData = defaults.integer(forKey:"numbersOfWeeklyArrData")
        numbersOfWeeklyArrData = numbersOfWeeklyArrData + 7
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && ((numbersOfWeeklyArrData - 2) < newNumbersOfWeeklyArrData) ){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let weeklyArrData10 = data2.components(separatedBy: .newlines)
                
                
                let row10 = weeklyArrData10[numbersOfWeeklyArrData - 8]
                let columns10 = row10.components(separatedBy: ",")
                //                    let baseWeeklyArrYear1 = columns10[0]
                let baseWeeklyArrMonth1 = columns10[1]
                let baseWeeklyArrDate1 = columns10[2]
                
                let row20 = weeklyArrData10[numbersOfWeeklyArrData - 2]
                let columns20 = row20.components(separatedBy: ",")
                //                    let baseWeeklyArrYear2 = columns20[0]
                let baseWeeklyArrMonth2 = columns20[1]
                let baseWeeklyArrDate2 = columns20[2]
                
                
                
                weekArrDisplay.text = String("\(baseWeeklyArrMonth1 ).\(baseWeeklyArrDate1) ~ \(baseWeeklyArrMonth2).\(baseWeeklyArrDate2)")
                saveAlertString = String("\(baseWeeklyArrMonth1 ).\(baseWeeklyArrDate1) ~ \(baseWeeklyArrMonth2).\(baseWeeklyArrDate2)")
                
                defaults.set(numbersOfWeeklyArrData, forKey:"numbersOfWeeklyArrData")
                
                weeklyArrChartViewGraph()
                
                weeklyArrButtonFlag = 0
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            nextWeekDataCheck = true
            nextWeekArrButton.isEnabled = false
            weeklyArrChartView.clear()
            defaults.set(numbersOfWeeklyArrData+7, forKey:"numbersOfWeeklyArrData")
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
    
    
    @objc func lastWeekSelectArrButton(sender: AnyObject){
        if nextWeekDataCheck == true {
            defaults.set(numbersOfWeeklyArrData-7, forKey:"numbersOfWeeklyArrData")
            weeklyArrChartViewGraph()
            nextWeekDataCheck = false
            nextWeekArrButton.isEnabled = true
        }
        else{
            weeklyArrButtonFlag = 1
            lastweekArrButton()
        }
    }
    
    
    @objc func nextWeekSelectArrButton(sender: AnyObject){
        if lastWeekDataCheck == true {
            defaults.set(numbersOfWeeklyArrData+7, forKey:"numbersOfWeeklyArrData")
            weeklyArrChartViewGraph()
            lastWeekDataCheck = false
            lastWeekArrButton.isEnabled = true
        }
        else{
            weeklyArrButtonFlag = 1
            nextweekArrButton()
        }
    }
    
    //     ------------------------지난주 다음주  버튼들 끝  ----------------------
    
    //     ------------------------지난달 다음달 버튼들 시작 ----------------------
    
    
    // MARK: - MonthButtonClickEvent
    @objc func selectMonthClick(sender: AnyObject) {
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        hourlyArrChartView.clear()
        weeklyArrChartView.clear()
        
        numbersOfArrDaysForMonth = 0
        
        sumOfMonthlyARR = 0
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        dayArrButton.isSelected = false
        weekArrButton.isSelected  = false
        monthArrButton.isSelected = true
        yearArrButton.isSelected = false
        
        dayArrButton.isUserInteractionEnabled = true
        weekArrButton.isUserInteractionEnabled = true
        monthArrButton.isUserInteractionEnabled = false
        yearArrButton.isUserInteractionEnabled = true
        
        dateArrDisplay.isHidden = true
        weekArrDisplay.isHidden = true
        monthArrDisplay.isHidden = false
        yearArrDisplay.isHidden = true
        
        
        arrDayLabel.alpha = 0.0
        arrDayValue.alpha = 0.0
        arrWeekLabel.alpha = 0.0
        arrWeekValue.alpha = 0.0
        arrMonthLabel.alpha = 1.0
        arrMonthValue.alpha = 1.0
        arrYearLabel.alpha = 0.0
        arrYearValue.alpha = 0.0
        
        
        yesterdayHourlyArrButton.isHidden = true
        tomorrowHourlyArrButton.isHidden = true
        
        lastWeekArrButton.isHidden = true
        nextWeekArrButton.isHidden = true
        
        
        lastMonthArrButton.isHidden = false
        nextMonthArrButton.isHidden = false
        
        lastYearArrButton.isHidden = true
        nextYearArrButton.isHidden = true
        
        yesterdayHourlyArrButton.isEnabled = false
        tomorrowHourlyArrButton.isEnabled = false
        
        lastWeekArrButton.isEnabled = false
        nextWeekArrButton.isEnabled = false
        
        lastMonthArrButton.isEnabled = true
        nextMonthArrButton.isEnabled = true
        
        lastYearArrButton.isEnabled = false
        nextYearArrButton.isEnabled = false
        
        
        // 마지막 페이지에서 다른 페이지로 넘어갔을 경우 대비
        if nextMonthDataCheck == true {
            nextMonthDataCheck = false
            nextMonthArrButton.isEnabled = true
        }
        else if lastWeekDataCheck == true {
            lastMonthDataCheck = false
            lastMonthArrButton.isEnabled = true
        }
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1) && (monthlyArrButtonFlag == 0)){
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                
                let numbersOfMonthlyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyArrData = numbersOfMonthlyArrData2.count
                
                
                let weeklyArrData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyArrData - 1{
                    let row1 = weeklyArrData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let arrMonth = columns[1]
                    let arrDay = columns[2]
                    let monthlyArrDataRow = Double(columns[9])
                    
                    if (arrMonth == realMonth){
                        
                        monthlyArrTimeData.append(arrDay)
                        monthlyArrData.append(monthlyArrDataRow ?? 0.0)
                        
                        sumOfMonthlyARR = sumOfMonthlyARR + Int(monthlyArrDataRow ?? 0)
                        numbersOfArrDaysForMonth +=  1
                    }
                }
                
                baseArrDayOfMonth = Int(realMonth) ?? 0
                monthArrDisplay.text = String("\(realYear ).\(realMonth) ")
                
                saveAlertString = String("\(realYear )년 \(realMonth)월")
                
                defaults.set(sumOfMonthlyARR, forKey:"sumOfMonthlyARR")
                defaults.set(baseArrDayOfMonth, forKey:"baseArrDayOfMonth")
                defaults.set(numbersOfArrDaysForMonth, forKey:"numbersOfArrDaysForMonth")
                
                saveLastPointValue = baseArrDayOfMonth
                
                monthlyArrChartViewGraph()
                
                
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else {
            // 데이터가 없는 마지막 페이지까지 갔다가 다시 돌아올 경우 초기 페이지로 돌아가게 함
            if saveLastPoint == true {
                saveLastPoint = false
                monthlyArrButtonFlag = 1
                nextMonthArrButton.isEnabled = true
                
                for _ in 0..<saveLastPointValue {
                    lookingUpperDayOfMonth ()
                }
            }
            else {
                monthlyArrButtonFlag = 1
                lookingBottomDayOfMonth ()
                lastMonthArrButton.isEnabled = true
            }
        }
    }
    
    func lookingBottomDayOfMonth(){
        
        monthlyArrData = []
        sumOfMonthlyARR = 0
        numbersOfArrDaysForMonth = 0
        
        baseArrDayOfMonth = defaults.integer(forKey:"baseArrDayOfMonth")
        
        var s_baseArrDayOfMonth = String(baseArrDayOfMonth-1)
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && (baseArrDayOfMonth - 1 >= 1) {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfMonthlyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyArrData = numbersOfMonthlyArrData2.count
                
                let weeklyArrData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfMonthlyArrData - 1{
                    let row1 = weeklyArrData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let arrMonth = columns[1]
                    let arrDay = columns[2]
                    let monthlyArrDataRow = Double(columns[9])
                    
                    let intArrMonth = Int(columns[1])
                    
                    if (intArrMonth == baseArrDayOfMonth - 1){
                        
                        s_baseArrDayOfMonth = arrMonth
                        
                        sumOfMonthlyARR = sumOfMonthlyARR + Int(monthlyArrDataRow ?? 0)
                        
                        numbersOfArrDaysForMonth +=  1
                        monthlyArrTimeData.append(arrDay)
                        monthlyArrData.append(monthlyArrDataRow ?? 0.0)
                    }
                }
                
                monthArrDisplay.text = String("\(realYear).\(s_baseArrDayOfMonth) ")
                saveAlertString = String("\(realYear)년 \(s_baseArrDayOfMonth)월 ")
                
                defaults.set(sumOfMonthlyARR, forKey:"sumOfMonthlyARR")
                
                defaults.set(numbersOfArrDaysForMonth, forKey:"numbersOfArrDaysForMonth")
                defaults.set(baseArrDayOfMonth - 1, forKey:"baseArrDayOfMonth")
                
                //                print(baseArrDayOfMonth - 1)
                
                monthlyArrChartViewGraph()
                
                monthlyArrButtonFlag = 0
            }
            catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            
            lastMonthDataCheck = true
            nextMonthDataCheck = false
            
            saveLastPoint = true
            
            lastMonthArrButton.isEnabled = false
            
            monthlyArrChartView.clear()
            defaults.set(baseArrDayOfMonth - 1, forKey:"baseArrDayOfMonth")
            alertLabel.text = "데이터가 없습니다."
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
    
    
    @objc func lastMonthSelectArrButton(sender: AnyObject){
        
        monthlyArrButtonFlag = 1
        lookingBottomDayOfMonth ()
        nextMonthArrButton.isEnabled = true
    }
    
    
    func lookingUpperDayOfMonth(){
        
        monthlyArrData = []
        numbersOfArrDaysForMonth = 0
        sumOfMonthlyARR = 0
        var thisMonthForArr = 0
        
        baseArrDayOfMonth = defaults.integer(forKey:"baseArrDayOfMonth")
        
        var s_baseArrDayOfMonth = String(baseArrDayOfMonth+1)
        
        thisMonthForArr = Int(realMonth)!
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("dailyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/dailyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if ((fileManager1.fileExists(atPath: filePath1)) && ((baseArrDayOfMonth + 1) < (thisMonthForArr + 1))){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfMonthlyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfMonthlyArrData = numbersOfMonthlyArrData2.count
                
                let weeklyArrData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< (numbersOfMonthlyArrData) - 1{
                    let row1 = weeklyArrData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let arrMonth = columns[1]
                    let arrDay = columns[2]
                    let monthlyArrDataRow = Double(columns[9])
                    
                    let intArrMonth = Int(columns[1])
                    
                    if (intArrMonth == baseArrDayOfMonth + 1){
                        
                        monthlyArrTimeData.append(arrDay)
                        monthlyArrData.append(monthlyArrDataRow ?? 0.0)
                        
                        s_baseArrDayOfMonth = arrMonth
                        sumOfMonthlyARR = sumOfMonthlyARR + Int(monthlyArrDataRow ?? 0)
                        numbersOfArrDaysForMonth +=  1
                    }
                }
                
                defaults.set(sumOfMonthlyARR, forKey:"sumOfMonthlyARR")
                
                defaults.set(numbersOfArrDaysForMonth, forKey:"numbersOfArrDaysForMonth")
                defaults.set(baseArrDayOfMonth + 1, forKey:"baseArrDayOfMonth")
                
                //                print(baseArrDayOfMonth + 1)
                
                monthArrDisplay.text = String("\(realYear).\(s_baseArrDayOfMonth) ")
                saveAlertString = String("\(realYear)년 \(s_baseArrDayOfMonth)월 ")
                monthlyArrChartViewGraph()
                
                monthlyArrButtonFlag = 0
            }
            catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            
            nextMonthDataCheck = true
            lastMonthDataCheck = false
            
            saveLastPoint = false
            
            nextMonthArrButton.isEnabled = false
            
            monthlyArrChartView.clear()
            defaults.set(baseArrDayOfMonth + 1, forKey:"baseArrDayOfMonth")
            alertLabel.text = "데이터가 없습니다."
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
    
    
    @objc func nextMonthSelectArrButton(sender: AnyObject){
        monthlyArrButtonFlag = 1
        lookingUpperDayOfMonth ()
        lastMonthArrButton.isEnabled = true
    }
    //     ------------------------지난달 다음달 버튼들 끝  ----------------------
    
    
    //MARK: - YearButtonClickEvent
    //     ------------------------지난해 다음해 버튼들 시작 ----------------------
    @objc func selectYearClick(sender: AnyObject) {
        
        yearlyArrChartView.clear()
        monthlyArrChartView.clear()
        hourlyArrChartView.clear()
        weeklyArrChartView.clear()
        
        numbersOfArrMonthsForYear = 0
        sumOfYearlyARR = 0
        
        alertString = ""
        alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        
        dayArrButton.isSelected = false
        weekArrButton.isSelected  = false
        monthArrButton.isSelected = false
        yearArrButton.isSelected = true
        
        dayArrButton.isUserInteractionEnabled = true
        weekArrButton.isUserInteractionEnabled = true
        monthArrButton.isUserInteractionEnabled = true
        yearArrButton.isUserInteractionEnabled = false
        
        dateArrDisplay.isHidden = true
        weekArrDisplay.isHidden = true
        monthArrDisplay.isHidden = true
        yearArrDisplay.isHidden = false
        
        
        arrDayLabel.alpha = 0.0
        arrDayValue.alpha = 0.0
        arrWeekLabel.alpha = 0.0
        arrWeekValue.alpha = 0.0
        arrMonthLabel.alpha = 0.0
        arrMonthValue.alpha = 0.0
        arrYearLabel.alpha = 1.0
        arrYearValue.alpha = 1.0
        
        
        yesterdayHourlyArrButton.isHidden = true
        tomorrowHourlyArrButton.isHidden = true
        
        
        lastWeekArrButton.isHidden = true
        nextWeekArrButton.isHidden = true
        
        
        lastMonthArrButton.isHidden = true
        nextMonthArrButton.isHidden = true
        
        lastYearArrButton.isHidden = false
        nextYearArrButton.isHidden = false
        
        yesterdayHourlyArrButton.isEnabled = false
        tomorrowHourlyArrButton.isEnabled = false
        
        lastWeekArrButton.isEnabled = false
        nextWeekArrButton.isEnabled = false
        
        lastMonthArrButton.isEnabled = false
        nextMonthArrButton.isEnabled = false
        
        lastYearArrButton.isEnabled = true
        nextYearArrButton.isEnabled = true
        
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)){
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyArrData = numbersOfYearlyArrData2.count
                
                
                let yearlyArrData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyArrData - 1{
                    let row1 = yearlyArrData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let arrYear = columns[0]
                    let arrMonth = columns[1]
                    let yearlyArrDataRow = Double(columns[7])
                    
                    intArrYear = Int(arrYear) ?? 0
                    
                    if (arrYear == realYear){
                        
                        yearlyArrTimeData.append(arrMonth)
                        yearlyArrData.append(yearlyArrDataRow ?? 0.0)
                        
                        sumOfYearlyARR = sumOfYearlyARR + Int(yearlyArrDataRow ?? 0)
                        
                        numbersOfArrMonthsForYear +=  1
                    }
                }
                
                arrYearValue.text = String("\(sumOfYearlyARR)")
                
                
                yearArrDisplay.text = String("\(realYear)")
                
                
                baseArrMonthOfYear  = numbersOfYearlyArrData - numbersOfArrMonthsForYear
                
                defaults.set(intArrYear, forKey:"currentArrYear")
                
                defaults.set(baseArrMonthOfYear, forKey:"baseArrMonthOfYear")
                
                defaults.set(numbersOfArrMonthsForYear, forKey:"numbersOfArrMonthsForYear") // total number of month
                
                defaults.set(numbersOfYearlyArrData, forKey:"numbersOfYearlyArrData")
                
                yearlyArrChartViewGraph()
                
            } catch  {
                print("Error reading CSV file")
            }
        }
        else {
            nextYearArrButton.isEnabled = false
            lastYearArrButton.isEnabled = false
            alertLabel.isHidden = false
            alertBackground.isHidden = false
            yearlyArrChartView.clear()
            alertLabel.text = "데이터가 없습니다."
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
    
    
    func lookingBottomArrMonthOfYear(){
        
        yearlyArrData = []
        sumOfYearlyARR = 0
        numbersOfArrMonthsForYear = 0
        
        
        currentArrYear = defaults.integer(forKey:"currentArrYear")
        baseArrMonthOfYear = defaults.integer(forKey:"baseArrMonthOfYear")
        numbersOfYearlyArrData = defaults.integer(forKey:"numbersOfYearlyArrData")
        
        
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && ((numbersOfYearlyArrData - baseArrMonthOfYear) > 1) {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyArrData = numbersOfYearlyArrData2.count
                
                let weeklyArrData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyArrData - 1{
                    let row1 = weeklyArrData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let arrYear = columns[0]
                    let arrMonth = columns[1]
                    let yearlyArrDataRow = Double(columns[7])
                    
                    intArrYear = Int(arrYear) ?? 0
                    
                    if (intArrYear == currentArrYear - 1){
                        
                        sumOfYearlyARR = sumOfYearlyARR + Int(yearlyArrDataRow ?? 0)
                        
                        numbersOfArrMonthsForYear +=  1
                        monthlyArrTimeData.append(arrMonth)
                        monthlyArrData.append(yearlyArrDataRow ?? 0.0)
                    }
                    
                }
                
                arrYearValue.text = String("\(sumOfYearlyARR)")
                
                yearArrDisplay.text = String("\(intArrYear)")
                baseArrMonthOfYear  = numbersOfYearlyArrData - baseArrMonthOfYear - numbersOfArrMonthsForYear
                
                defaults.set(intArrYear, forKey:"currentArrYear")
                defaults.set(baseArrMonthOfYear, forKey:"baseArrMonthOfYear")
                defaults.set(numbersOfYearlyArrData, forKey:"numbersOfYearlyArrData")
                defaults.set(numbersOfArrMonthsForYear, forKey:"numbersOfArrMonthsForYear")
                
                
                yearlyArrChartViewGraph()
                
                yearlyArrButtonFlag = 0
                
            }
            catch  {
                print("Error reading CSV file")
            }
        }else {
            
            let alert = UIAlertController(title: "No data", message: "Go to next year", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
                
                // noncontactFlag = 0
            })
            alert.addAction(ok)
            present(alert,animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func lastyearSelectArrButton(sender: AnyObject){
        yearlyArrButtonFlag = 1
        lookingBottomArrMonthOfYear ()
    }
    
    
    
    func lookingUpperArrMonthOfYear(){
        
        
        yearlyArrData = []
        sumOfYearlyARR = 0
        numbersOfArrMonthsForYear = 0
        
        
        baseArrMonthOfYear = defaults.integer(forKey:"baseArrMonthOfYear")
        currentArrYear = defaults.integer(forKey:"currentArrYear")
        numbersOfYearlyArrData = defaults.integer(forKey:"numbersOfYearlyArrData")
        
        
        let fileManager1 = FileManager.default
        let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryURL1 = documentsURL1.appendingPathComponent("monthlyData")
        let fileURL1 = directoryURL1.appendingPathComponent("/monthlyCalandDistanceData.csv")
        
        let filePath1 = fileURL1.path
        
        if (fileManager1.fileExists(atPath: filePath1)) && ((numbersOfYearlyArrData - baseArrMonthOfYear) > 1) {
            
            
            do {
                let data2 = try String(contentsOf: fileURL1)
                
                let numbersOfYearlyArrData2 = data2.components(separatedBy: .newlines)
                // 파일 데이터 행 전체 갯
                numbersOfYearlyArrData = numbersOfYearlyArrData2.count
                
                let weeklyArrData30 = data2.components(separatedBy: .newlines)
                
                for i in 0 ..< numbersOfYearlyArrData - 1{
                    let row1 = weeklyArrData30[i]
                    let columns = row1.components(separatedBy: ",")
                    let arrYear = columns[0]
                    let arrMonth = columns[1]
                    let yearlyArrDataRow = Double(columns[7])
                    
                    intArrYear = Int(arrYear) ?? 0
                    
                    if (intArrYear == currentArrYear + 1){
                        
                        sumOfYearlyARR = sumOfYearlyARR + Int(yearlyArrDataRow ?? 0)
                        
                        numbersOfArrMonthsForYear +=  1
                        yearlyArrTimeData.append(arrMonth)
                        yearlyArrData.append(yearlyArrDataRow ?? 0.0)
                    }
                }
                yearArrDisplay.text = String("\(intArrYear)")
                arrYearValue.text = String("\(sumOfYearlyARR)")
                
                baseArrMonthOfYear  = numbersOfYearlyArrData - baseArrMonthOfYear  + numbersOfArrMonthsForYear
                
                defaults.set(intArrYear, forKey:"currentArrYear")
                defaults.set(baseArrMonthOfYear, forKey:"baseArrMonthOfYear")
                defaults.set(numbersOfYearlyArrData, forKey:"numbersOfYearlyArrData")
                defaults.set(numbersOfArrMonthsForYear, forKey:"numbersOfArrMonthsForYear")
                
                yearlyArrChartViewGraph()
                
                yearlyArrButtonFlag = 0
                
            }
            catch  {
                print("Error reading CSV file")
            }
        }else {
            
            let alert = UIAlertController(title: "No data", message: "Go to previous year", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Confirm", style: .destructive, handler: { Action in
                
                // noncontactFlag = 0
            })
            alert.addAction(ok)
            present(alert,animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func nextyearSelectArrButton(sender: AnyObject){
        yearlyArrButtonFlag = 1
        lookingUpperArrMonthOfYear()
    }
}
    //     ------------------------지난해 다음해 버튼들 끝  ----------------------

// bar 상단에 보여지는 value 값을 정수로 표시
class IntegerValueFormatter: DefaultValueFormatter {
    override func stringForValue(_ value: Double,
                                 entry: ChartDataEntry,
                                 dataSetIndex: Int,
                                 viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.0f", value)
    }
}
// bar 상단에 보여지는 value 값을 0이 아닌 경우에만 표시하기
class NonZeroValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return value == 0 ? "" : String(format: "%.0f", value)
    }
}
