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


let tempChartView = LineChartView()
let twoDaysTempChartView = LineChartView()
let threeDaysTempChartView = LineChartView()

var tempArrayData1: [Double] = []
var tempTimeData1: [String] = []
var numbersOfTemp1 = 0


var tempArrayData2: [Double] = []
var tempTimeData2: [String] = []
var numbersOfTemp2 = 0

var tempArrayData3: [Double] = []
var tempTimeData3: [String] = []
var numbersOfTemp3 = 0

var tempArrayData4: [Double] = []
var tempTimeData4: [String] = []
var numbersOfTemp4 = 0


var tempArrayData5: [Double] = []
var tempTimeData5: [String] = []
var numbersOfTemp5 = 0

var tempThreeArrayData1: [Double] = []
var tempThreeTimeData1: [String] = []
var numbersOfThreeTemp1 = 0

var tempThreeArrayData2: [Double] = []
var tempThreeTimeData2: [String] = []
var numbersOfThreeTemp2 = 0

var tempThreeArrayData3: [Double] = []
var tempThreeTimeData3: [String] = []
var numbersOfThreeTemp3 = 0

var tempThreeArrayData4: [Double] = []
var tempThreeTimeData4: [String] = []
var numbersOfThreeTemp4 = 0

var tempThreeArrayData5: [Double] = []
var tempThreeTimeData5: [String] = []
var numbersOfThreeTemp5 = 0

var tempThreeArrayData6: [Double] = []
var tempThreeTimeData6: [String] = []
var numbersOfThreeTemp6 = 0

var tempThreeArrayData7: [Double] = []
var tempThreeTimeData7: [String] = []
var numbersOfThreeTemp7 = 0

var numbersOfThreeTemp = 0
var tempTodayDate = Date()
var twoDaysTempTodayDate = Date()
var tempThreeDays = Date()

var tempChangeRealYear:String = ""
var tempChangeRealMonth:String = ""
var tempChangeRealDate:String = ""

var tempChangeTwoDaysYear:String = ""
var tempChangeTwoDaysMonth:String = ""
var tempChangeTwoDaysDate:String = ""

var tempBaseTwoDaysYear:String = ""
var tempBaseTwoDaysMonth:String = ""
var tempBaseTwoDaysDate:String = ""


var tempBaseThreeDaysYear:String = ""
var tempBaseThreeDaysMonth:String = ""
var tempBaseThreeDaysDate:String = ""

var tempChangeThreeDaysYear:String = ""
var tempChangeThreeDaysMonth:String = ""
var tempChangeThreeDaysDate:String = ""

var tempChangeThreeDaysYear1:String = ""
var tempChangeThreeDaysMonth1:String = ""
var tempChangeThreeDaysDate1:String = ""

var tempChangeThreeDaysYear2:String = ""
var tempChangeThreeDaysMonth2:String = ""
var tempChangeThreeDaysDate2:String = ""

var tempChangeThreeDaysYear3:String = ""
var tempChangeThreeDaysMonth3:String = ""
var tempChangeThreeDaysDate3:String = ""

var lastTwoDaysTempButtonFlag = 0
var nextTwoDaysTempButtonFlag = 0

var previousArrowTempFlag = 0
var nextArrowTempFlag = 0
var baseArrowTempFlag = 0

var tempDateCount = 0
var tempTwodateCount = 0
var tempThreeDateCount = 0

var numberOfTempTimeData1 = 0.0
var numberOfTempTimeData2 = 0.0

var templVSum = 0.0
var templVMin = 0.0
var templVMax = 0.0
var templVAvg = 0.0


class temperatureGraphVC : UIViewController {
    
    var fCurTextfieldBottom: CGFloat = 0.0
    
    private let safeAreaView = UIView()
    
    var saveThreeDaysDate = Date()
    var lastButtonFlag = false
    var nextButtonFlag = false
    
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
    
    
    lazy var tempChartView: LineChartView =  {
        let tempChartView = LineChartView()
        tempChartView.noDataText = ""
        return tempChartView
        
    }()
    
    
    lazy var twoDaysTempChartView: LineChartView =  {
        let twoDaysTempChartView = LineChartView()
        twoDaysTempChartView.noDataText = ""
        return twoDaysTempChartView
        
    }()
    
    
    lazy var threeDaysTempChartView: LineChartView =  {
        let threeDaysTempChartView = LineChartView()
        threeDaysTempChartView.noDataText = ""
        return threeDaysTempChartView
        
    }()
    
  
    
//    lazy var oneDayTempButton = UIButton().then {
//        $0.setTitle ("Today", for: .normal )
//        $0.setTitleColor(.white, for: .normal)
//        $0.setBackgroundColor(.lightGray, for: .normal)
//        $0.setBackgroundColor(.buttonBackground!, for: .selected)
//        $0.setBackgroundColor(.lightGray, for: .disabled)
//        $0.layer.masksToBounds = true
//        $0.layer.cornerRadius = 5
//        $0.titleLabel?.font = .systemFont(ofSize: 18)
//        $0.addTarget(self, action: #selector(selectOneDayClick(sender:)), for: .touchUpInside)
//
//    }
//
//
//    lazy var twoDaysTempButton = UIButton().then {
//        $0.setTitle ("2 Days", for: .normal )
//        $0.setTitleColor(.white, for: .normal)
//        $0.setBackgroundColor(.lightGray, for: .normal)
//        $0.setBackgroundColor(.buttonBackground!, for: .selected)
//        $0.setBackgroundColor(.lightGray, for: .disabled)
//        $0.layer.masksToBounds = true
//        $0.layer.cornerRadius = 5
//        $0.titleLabel?.font = .systemFont(ofSize: 18)
//        $0.addTarget(self, action: #selector(selectTwoDaysClick(sender:)), for: .touchUpInside)
//    }
//
//
//    lazy var threeDaysTempButton = UIButton().then {
//        $0.setTitle ("3 Days", for: .normal )
//        $0.setTitleColor(.white, for: .normal)
//        $0.setBackgroundColor(.lightGray, for: .normal)
//        $0.setBackgroundColor(.buttonBackground!, for: .selected)
//        $0.setBackgroundColor(.lightGray, for: .disabled)
//        $0.layer.masksToBounds = true
//        $0.layer.cornerRadius = 5
//        $0.titleLabel?.font = .systemFont(ofSize: 18)
//        $0.addTarget(self, action: #selector(selectThreeDaysClick(sender:)), for: .touchUpInside)
//    }
    
    lazy var oneDayTempButton = UIButton().then {
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
    
    
    lazy var twoDaysTempButton = UIButton().then {
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
    
    
    lazy var threeDaysTempButton = UIButton().then {
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
    
    lazy var todayTempDispalay = UILabel().then {
        $0.text = "\(realYear)-\(realMonth)-\(realDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var twoDaysTempDispalay = UILabel().then {
        $0.text = "\(tempChangeTwoDaysYear).\(tempChangeTwoDaysDate) ~ \(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var threeDaysTempDispalay = UILabel().then {
        $0.text = "\(tempChangeThreeDaysMonth).\(tempChangeThreeDaysMonth) ~ \(tempChangeThreeDaysMonth).\(tempChangeThreeDaysMonth)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    //    -----------------------------day button-------------------
    
    
    lazy var yesterdayTempButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(yesterdaySelectTempButton(sender:)), for: .touchUpInside)
    }
    
    lazy var tomorrowTempButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(tomorrowSelectTempButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------day button-------------------
    
    
    //    -----------------------------2days button-------------------
    lazy var lastTwoDaysTempButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastTwoDaysSelectTempButton(sender:)), for: .touchUpInside)
    }
    
    
    
    lazy var nextTwoDaysTempButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextTwoDaysSelectTempButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------2days button-------------------
    
    
    
    //    -----------------------------7days button-------------------
    lazy var lastThreeDaysTempButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(lastThreeDaysSelectTempButton(sender:)), for: .touchUpInside)
    }
    
    
    
    lazy var nextThreeDaysTempButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(nextThreeDaysSelectTempButton(sender:)), for: .touchUpInside)
    }
    
    //    -----------------------------v button-------------------
    
    
    
    lazy var tempLabel = UILabel().then {
        //        $0.text = "맥박"
        $0.text = "전극온도"
        $0.textColor = .black
        //        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    lazy var tempValue = UILabel().then {
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
    
    lazy var minTemp = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    lazy var aveTemp = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    lazy var maxTemp = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let plusImage =  UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    let minusImage =  UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    let refreshImage =  UIImage(systemName: "arrow.clockwise.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
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
                tempChartView.zoomOut()
                twoDaysTempChartView.zoomOut()
                threeDaysTempChartView.zoomOut()
            }
        }
        else if sender.tag == 2 {
            tempChartView.zoomOut()
            twoDaysTempChartView.zoomOut()
            threeDaysTempChartView.zoomOut()
        }
        else if sender.tag == 3 {
            tempChartView.zoomIn()
            twoDaysTempChartView.zoomIn()
            threeDaysTempChartView.zoomIn()
        }
    }
    
    
    // MARK: - View
    func tempviews(){
        
        view.addSubview(tempChartView)
        tempChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            
        }
        
        view.addSubview(twoDaysTempChartView)
        twoDaysTempChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(tempChartView.snp.bottom)
        }
        
        
        view.addSubview(threeDaysTempChartView)
        threeDaysTempChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.bottom.equalTo(tempChartView.snp.bottom)
        }
        
 
        let buttonStackView2: UIStackView = {
            let buttonStackView2 = UIStackView(arrangedSubviews: [oneDayTempButton, twoDaysTempButton, threeDaysTempButton])
            buttonStackView2.axis = .horizontal
            buttonStackView2.distribution = .fillEqually // default
            buttonStackView2.alignment = .fill // default
            buttonStackView2.spacing = 50.0
            //            buttonStackView2.backgroundColor = .gray
            
            view.addSubview(buttonStackView2)
            
            
            self.oneDayTempButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            self.twoDaysTempButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
            }
            
            self.threeDaysTempButton.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonStackView2)
                $0.trailing.equalTo(buttonStackView2)
            }
            
            return buttonStackView2
        }()
        
        
        buttonStackView2.snp.makeConstraints { (make) in
            
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.top.equalTo(self.tempChartView.snp.bottom)
            make.height.equalTo(50)
        }
        
        
        //        -----------------------day button position--------------------
        
        view.addSubview(yesterdayTempButton)
        yesterdayTempButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(todayTempDispalay)
        todayTempDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(yesterdayTempButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tomorrowTempButton)
        tomorrowTempButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(todayTempDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------day button position--------------------
        
        
        //        -----------------------2 days button position--------------------
        view.addSubview(lastTwoDaysTempButton)
        lastTwoDaysTempButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(twoDaysTempDispalay)
        twoDaysTempDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastTwoDaysTempButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(nextTwoDaysTempButton)
        nextTwoDaysTempButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(twoDaysTempDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------2 days button position--------------------
        
        
        //        -----------------------7 days button position--------------------
        view.addSubview(lastThreeDaysTempButton)
        lastThreeDaysTempButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(threeDaysTempDispalay)
        threeDaysTempDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(lastThreeDaysTempButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(nextThreeDaysTempButton)
        nextThreeDaysTempButton.snp.makeConstraints {(make) in
            make.top.equalTo(buttonStackView2.snp.bottom).offset(20)
            make.leading.equalTo(threeDaysTempDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //        -----------------------7 days button position--------------------
        
        
        
        let bpmVCStackView1: UIStackView = {
            let bpmVCStackView1 = UIStackView(arrangedSubviews: [tempLabel, tempValue, currentTime])
            bpmVCStackView1.axis = .horizontal
            bpmVCStackView1.distribution = .fillEqually // default
            bpmVCStackView1.alignment = .fill // default
            bpmVCStackView1.backgroundColor = .white
            
            view.addSubview(bpmVCStackView1)
            
            
            self.tempLabel.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView1)
                $0.trailing.equalTo(tempValue.snp.leading)
            }
            self.tempValue.snp.makeConstraints {
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
            let bpmVCStackView2 = UIStackView(arrangedSubviews: [minTemp, aveTemp, maxTemp])
            bpmVCStackView2.axis = .horizontal // default
            bpmVCStackView2.distribution = .fillEqually // default
            bpmVCStackView2.alignment = .fill // default
            bpmVCStackView2.backgroundColor = .white
            
            view.addSubview(bpmVCStackView2)
            
            self.minTemp.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView2)
                $0.trailing.equalTo(self.aveTemp.snp.leading)
            }
            self.aveTemp.snp.makeConstraints {
                $0.top.bottom.equalTo(bpmVCStackView2)
                $0.trailing.equalTo(self.maxTemp.snp.leading)
            }
            
            self.maxTemp.snp.makeConstraints {
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
                make.top.equalTo(self.yesterdayTempButton.snp.bottom).offset(20)
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
        
        // MARK: - AlertConstraint
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
            alertBackground.leadingAnchor.constraint(equalTo: twoDaysTempChartView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            alertBackground.centerXAnchor.constraint(equalTo: twoDaysTempChartView.centerXAnchor),
            alertBackground.centerYAnchor.constraint(equalTo: twoDaysTempChartView.centerYAnchor),
            
            alertBackground.heightAnchor.constraint(equalToConstant: 120),
            
            
            alertLabel.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
            
            refreshButton.topAnchor.constraint(equalTo: twoDaysTempChartView.topAnchor, constant: 10),
            refreshButton.trailingAnchor.constraint(equalTo: twoDaysTempChartView.trailingAnchor, constant: -5),
            
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
        tempviews()
        tempTimer()
        
        tempChartViewGraph()
        
        oneDayTempButton.isSelected = true
        twoDaysTempButton.isSelected  = false
        threeDaysTempButton.isSelected = false
        
        
        todayTempDispalay.isHidden = false
        twoDaysTempDispalay.isHidden = true
        threeDaysTempDispalay.isHidden = true
        
        yesterdayTempButton.isHidden = false
        tomorrowTempButton.isHidden = false
        lastTwoDaysTempButton.isHidden = true
        nextTwoDaysTempButton.isHidden = true
        lastThreeDaysTempButton.isHidden = true
        nextThreeDaysTempButton.isHidden = true
        
        yesterdayTempButton.isEnabled = true
        tomorrowTempButton.isEnabled = true
        lastTwoDaysTempButton.isEnabled = false
        nextTwoDaysTempButton.isEnabled = false
        lastThreeDaysTempButton.isEnabled = false
        nextThreeDaysTempButton.isEnabled = false
        
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tempTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func tempTimer(){
        
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
        tempValue.text = String(dtemp)
        
        minTemp.text = "최소: " + String(format: "%.1f", templVMin)
        maxTemp.text = "최대: " + String(format: "%.1f", templVMax)
        aveTemp.text = "평균: " + String(format: "%.1f", templVAvg)
    }
    
    // MARK: - today Graph
    func tempChartViewGraph(){
        
        tempChartView.clear()
        twoDaysTempChartView.clear()
        threeDaysTempChartView.clear()
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        plusButton.isHidden = false
        minusButton.isHidden = false
        refreshButton.isHidden = false
        
        tempChangeRealYear = defaults.string(forKey: "tempChangeRealYear") ?? "\(realYear)"
        tempChangeRealMonth = defaults.string(forKey: "tempChangeRealMonth") ?? "\(realMonth)"
        tempChangeRealDate = defaults.string(forKey: "tempChangeRealDate") ?? "\(realDate)"
        
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("\(tempChangeRealYear)/\(tempChangeRealMonth)/\(tempChangeRealDate)")
        
        let fileURL = directoryURL.appendingPathComponent("/BpmData.csv")
        
        let filePath = fileURL.path
        
        print("tempChangeRealYear : \(tempChangeRealYear)")
        print("tempChangeRealMonth : \(tempChangeRealMonth)")
        print("tempChangeRealDate : \(tempChangeRealDate)")
        
        if fileManager.fileExists(atPath: filePath){
            
            do {
                let data1 = try String(contentsOf: fileURL)
                let tempData1 = data1.components(separatedBy: .newlines)
                
                numbersOfTemp1 = tempData1.count
                
                for i in 0..<numbersOfTemp1 - 1{
                    let row = tempData1[i]
                    let columns1 = row.components(separatedBy: ",")
                    let tempDataRow1 = Double(columns1[4])
                    
                    let tempTimeCheck = columns1[0].components(separatedBy: ":")
                    let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1]
                
                    
                    tempTimeData1.append(MyTempTimeRow)
                    tempArrayData1.append(tempDataRow1 ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
            
            var tempDataEntries1 = [ChartDataEntry]()
            
            for i in 0 ..< numbersOfTemp1 - 1 {
                let tempDataEntry:ChartDataEntry
                tempDataEntry = ChartDataEntry(x: Double(i), y: tempArrayData1[i])
                tempDataEntries1.append(tempDataEntry)
            }
            
            
            let tempChartDataSet = LineChartDataSet(entries: tempDataEntries1, label: "HRV")
            tempChartDataSet.drawCirclesEnabled = false
            tempChartDataSet.setColor(NSUIColor.blue)
            tempChartDataSet.mode = .linear
            tempChartDataSet.lineWidth = 0.5
            tempChartDataSet.drawValuesEnabled = true
            
            
            // 2
            let tempChartData = LineChartData(dataSet: tempChartDataSet)
            tempChartView.data = tempChartData
            tempChartView.noDataText = ""
            tempChartView.xAxis.enabled = true
            tempChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            tempChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: tempTimeData1)
            tempChartView.setVisibleXRangeMaximum(500) // 처음 보여지는 x축 범위
            tempChartView.xAxis.granularity = 1
            tempChartView.xAxis.labelPosition = .bottom
            tempChartView.xAxis.drawGridLinesEnabled = false
            
            tempChartView.leftAxis.axisMaximum = 150.0
            tempChartView.leftAxis.axisMinimum = 0.0
            tempChartView.rightAxis.enabled = false
            tempChartView.drawMarkers = false
            tempChartView.dragEnabled = true
            tempChartView.pinchZoomEnabled = false
            tempChartView.doubleTapToZoomEnabled = false
            tempChartView.highlightPerTapEnabled = false
            
            tempChartView.data?.notifyDataChanged()
            tempChartView.notifyDataSetChanged()
            tempChartView.moveViewToX(0)
            
            tempTimeData1 = []
            tempArrayData1 = []
            
            tempChartView.isUserInteractionEnabled = true
            twoDaysTempChartView.isUserInteractionEnabled = false
            threeDaysTempChartView.isUserInteractionEnabled = false
            
            // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
            for _ in 0..<20 {
                tempChartView.zoomOut()
            }
        }
        else{
            alertFlag = true
            alertString += "\(tempChangeRealYear)/\(tempChangeRealMonth)/\(tempChangeRealDate)\n"
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
    func twoDaysTempChartViewGraph(){
        
        tempChartView.clear()
        twoDaysTempChartView.clear()
        threeDaysTempChartView.clear()
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        plusButton.isHidden = false
        minusButton.isHidden = false
        refreshButton.isHidden = false
        
        // time table : 그래프에 보여줄 시간 저장 배열
        var timeTable: [String] = []
        
        tempBaseTwoDaysYear = defaults.string(forKey:"tempBaseTwoDaysYer") ?? "\(realYear)"
        tempBaseTwoDaysMonth = defaults.string(forKey:"tempBaseTwoDaysMonth") ?? "\(realMonth)"
        tempBaseTwoDaysDate = defaults.string(forKey:"tempBaseTwoDaysDate") ?? "\(realDate)"
        
        
        tempChangeTwoDaysYear = defaults.string(forKey:"tempChangeTwoDaysYear") ?? "\(realYear)"
        tempChangeTwoDaysMonth = defaults.string(forKey:"tempChangeTwoDaysMonth") ?? "\(realMonth)"
        tempChangeTwoDaysDate = defaults.string(forKey:"tempChangeTwoDaysDate") ?? "\(realDate)"
        
        // 버튼을 여러번 클릭하였을때 값이 섞이는 것을 방지
        tempTimeData2 = []
        tempArrayData2 = []
        
        tempTimeData3 = []
        tempArrayData3 = []
        
        tempTimeData4 = []
        tempArrayData4 = []
        
        tempTimeData5 = []
        tempArrayData5 = []
        
        if ((previousArrowTempFlag == 1) || (baseArrowTempFlag == 1)){
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL = documentsURL.appendingPathComponent("\(tempChangeTwoDaysYear)/\(tempChangeTwoDaysMonth)/\(tempChangeTwoDaysDate)")
            
            let fileURL = directoryURL.appendingPathComponent("/BpmData.csv")
            
            let filePath = fileURL.path
            
            
            if fileManager.fileExists(atPath: filePath){
                
                do {
                    let data = try String(contentsOf: fileURL)
                    let tempData = data.components(separatedBy: .newlines)
                    
                    numbersOfTemp2 = tempData.count
                    
                    for i in 0..<numbersOfTemp2 - 1{
                        let row = tempData[i]
                        let columns = row.components(separatedBy: ",")
                        
                        let tempTimeCheck = columns[0].components(separatedBy: ":")
                        let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                        
                        tempTimeData2.append(MyTempTimeRow)
                        tempArrayData2.append(Double(columns[4]) ?? 0.0)
                    }
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(tempChangeTwoDaysYear)/\(tempChangeTwoDaysMonth)/\(tempChangeTwoDaysDate),\n"
            }
            
            let fileManager1 = FileManager.default
            let documentsURL1 = fileManager1.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL1 = documentsURL1.appendingPathComponent("\(tempBaseTwoDaysYear)/\(tempBaseTwoDaysMonth)/\(tempBaseTwoDaysDate)")
            
            let fileURL1 = directoryURL1.appendingPathComponent("/BpmData.csv")
            
            let filePath1 = fileURL1.path
            
            if fileManager1.fileExists(atPath: filePath1){
                
                do {
                    let data = try String(contentsOf: fileURL1)
                    let tempData = data.components(separatedBy: .newlines)
                    
                    numbersOfTemp3 = tempData.count
                    
                    for i in 0..<numbersOfTemp3 - 1{
                        let row = tempData[i]
                        let columns = row.components(separatedBy: ",")
                        
                        let tempTimeCheck = columns[0].components(separatedBy: ":")
                        let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                        
                        tempTimeData3.append(MyTempTimeRow)
                        tempArrayData3.append(Double(columns[4]) ?? 0.0)
                        
                    }
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(tempBaseTwoDaysYear)/\(tempBaseTwoDaysMonth)/\(tempBaseTwoDaysDate),\n"
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
                
                lastTwoDaysTempButton.isEnabled = true
                nextTwoDaysTempButton.isEnabled = true
                
                /*
                 X 축 타임 테이블을 위해 시작 시간과 종료 시간을 구함
                 */
                let startOfYesterday = tempTimeData2.first!.components(separatedBy: ":") // 어제의 시작
                let endOfYesterday =  tempTimeData2.last!.components(separatedBy: ":") // 어제의 마지막
                
                let startOfToday = tempTimeData3.first!.components(separatedBy: ":") // 오늘의 시작
                let endOfToday = tempTimeData3.last!.components(separatedBy: ":") // 오늘의 마지막
                
                var startTime = [String]()
                var endTime = [String]()
                
                var copyEndHour = ""
                var copyStartHour = 0
                
                var minuteDifference = 0 // 분 차이
                var hourDifference = 0 // 시간 차이
                
                var totalXValue = 0 // 전체 x value
                
                // 전체 시작 시간 비교(total)
                if ( Int(startOfYesterday[0])! > Int(startOfToday[0])! ||
                     ((Int(startOfYesterday[0])! == Int(startOfToday[0])!) &&
                      (Int(startOfYesterday[1])! > Int(startOfToday[1])!))){
                    startTime = tempTimeData3.first!.components(separatedBy: ":")
                }
                else{
                    startTime = tempTimeData2.first!.components(separatedBy: ":")
                }
                
                // 전체 종료 시간 비교(total)
                if ( Int(endOfYesterday[0])! > Int(endOfToday[0])! ||
                     ((Int(endOfYesterday[0])! == Int(endOfToday[0])!) &&
                      (Int(endOfYesterday[1])! > Int(endOfToday[1])!))){
                    endTime = tempTimeData2.last!.components(separatedBy: ":")
                }
                else{
                    endTime = tempTimeData3.last!.components(separatedBy: ":")
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
                
                                
                var tempDataEntries2 = [ChartDataEntry]()
                var tempDataEntries3 = [ChartDataEntry]()
                
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
                
                var tempTimeCount = 0
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
                    var tempTime = tempTimeData3[tempTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                    
//                    print("------------------------------------------")
//                    print("timeTable : \(timeTable[timeTableCount])")
//                    print("bpmTime : \(tempTime)")
//                    print("bpmSecond : \(String(tempTime[2]))")
//                    print("bpmTimeFirst : \(String(tempTime[2].first!))")
//                    print("checkTimeTable : \(checkTimeTable[2])")
                    
                    // 값이 있는 경우
                    if tempTime[0] == checkTimeTable[0] { // hour
                        if tempTime[1] == checkTimeTable[1] { // minute
                            if String(tempTime[2].first!) == checkTimeTable[2]{ // second
//                                print("----> \(tempTimeData3[tempTimeCount]) CheckCount : \(tempTimeCount)")
                                let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData3[tempTimeCount])
                                tempDataEntries3.append(tempDataEntry)
                                
                                tempTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData3[tempTimeCount-1])
                            tempDataEntries3.append(tempDataEntry)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData3[tempTimeCount-1])
                        tempDataEntries3.append(tempDataEntry)
                    }
                                        
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && tempTimeData3.count > tempTimeCount{
                        tempTime = tempTimeData3[tempTimeCount].components(separatedBy: ":")
                        
                        while String(tempTime[2].first!) == checkTimeTable[2] {
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData3[tempTimeCount])
                            tempDataEntries3.append(tempDataEntry)
                            tempTimeCount += 1
                            tempTime = tempTimeData3[tempTimeCount].components(separatedBy: ":")
                        }
                    }

                    timeTableCount += 1
                    
                    // 마지막 값
                    if tempTime[0] == endOfToday[0] && tempTime[1] == endOfToday[1] && tempTime[2] == endOfToday[2] || totalXValue == timeTableCount || tempTimeData3.count == tempTimeCount {
                        break
                    }
                }
                
                tempTimeCount = 0
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
                    var tempTime = tempTimeData2[tempTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
//                    print("------------------------------------------")
//                    print("timeTable : \(timeTable[timeTableCount])")
//                    print("bpmTime : \(tempTime)")
//                    print("bpmSecond : \(String(tempTime[2]))")
//                    print("bpmTimeFirst : \(String(tempTime[2].first!))")
//                    print("checkTimeTable : \(checkTimeTable[2])")
                    // 값이 있는 경우
                    if tempTime[0] == checkTimeTable[0] { // hour
                        if tempTime[1] == checkTimeTable[1] { // minute
                            if String(tempTime[2].first!) == checkTimeTable[2]{ // second
//                                print("----> \(tempTimeData2[tempTimeCount]) CheckCount : \(tempTimeCount)")
                                let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData2[tempTimeCount])
                                tempDataEntries2.append(tempDataEntry)
                                
                                tempTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData2[tempTimeCount-1])
                            tempDataEntries2.append(tempDataEntry)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData2[tempTimeCount-1])
                        tempDataEntries2.append(tempDataEntry)
                    }
                    
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && tempTimeData2.count > tempTimeCount{
                        tempTime = tempTimeData2[tempTimeCount].components(separatedBy: ":")

                        while String(tempTime[2].first!) == checkTimeTable[2] {
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData2[tempTimeCount])
                            tempDataEntries2.append(tempDataEntry)
                            tempTimeCount += 1
                            tempTime = tempTimeData2[tempTimeCount].components(separatedBy: ":")
                        }
                    }
                    
                    timeTableCount += 1
                    
                    // 마지막 값
                    if tempTime[0] == endOfYesterday[0] && tempTime[1] == endOfYesterday[1] && tempTime[2] == endOfYesterday[2] || totalXValue == timeTableCount || tempTimeData2.count == tempTimeCount {
                        
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
                
                let tempChartDataSet1 = LineChartDataSet(entries: tempDataEntries2, label: "\(tempChangeTwoDaysMonth)-\(tempChangeTwoDaysDate)")
                tempChartDataSet1.drawCirclesEnabled = false
                tempChartDataSet1.setColor(NSUIColor.red)
                tempChartDataSet1.mode = .linear
                tempChartDataSet1.lineWidth = 0.5
                tempChartDataSet1.drawValuesEnabled = true
                
                
                let tempChartDataSet2 = LineChartDataSet(entries: tempDataEntries3, label: "\(tempBaseTwoDaysMonth)-\(tempBaseTwoDaysDate)")
                tempChartDataSet2.drawCirclesEnabled = false
                tempChartDataSet2.setColor(NSUIColor.blue)
                tempChartDataSet2.mode = .linear
                tempChartDataSet2.lineWidth = 0.5
                tempChartDataSet2.drawValuesEnabled = true
                
                let twoDaysTempChartdataSets: [LineChartDataSet] = [tempChartDataSet1, tempChartDataSet2]
                
                let twoDaysTempChartData = LineChartData(dataSets: twoDaysTempChartdataSets)
                
                twoDaysTempChartView.data = twoDaysTempChartData
                twoDaysTempChartView.noDataText = ""
                twoDaysTempChartView.xAxis.enabled = true
                twoDaysTempChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
                twoDaysTempChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeTable)
                
                twoDaysTempChartView.xAxis.granularity = 1
                twoDaysTempChartView.xAxis.axisMinimum = 0
                twoDaysTempChartView.xAxis.axisMaximum = Double(totalXValue)
                twoDaysTempChartView.setVisibleXRangeMaximum(1000)
                twoDaysTempChartView.xAxis.labelPosition = .bottom
                twoDaysTempChartView.xAxis.drawGridLinesEnabled = false
                
                twoDaysTempChartView.leftAxis.axisMaximum = 150.0
                twoDaysTempChartView.leftAxis.axisMinimum = 0.0
                twoDaysTempChartView.rightAxis.enabled = false
                twoDaysTempChartView.drawMarkers = false
                twoDaysTempChartView.dragEnabled = true
                twoDaysTempChartView.pinchZoomEnabled = false
                twoDaysTempChartView.doubleTapToZoomEnabled = true
                twoDaysTempChartView.highlightPerTapEnabled = false
                
                twoDaysTempChartView.data?.notifyDataChanged()
                twoDaysTempChartView.notifyDataSetChanged()
                twoDaysTempChartView.moveViewToX(0)
                
                tempTimeData2 = []
                tempArrayData2 = []
                
                tempTimeData3 = []
                tempArrayData3 = []
                
                tempTimeData4 = []
                tempArrayData4 = []
                
                tempTimeData5 = []
                tempArrayData5 = []
                
                tempChartView.isUserInteractionEnabled = false
                twoDaysTempChartView.isUserInteractionEnabled = true
                threeDaysTempChartView.isUserInteractionEnabled = false
                
                // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
                for _ in 0..<20 {
                    twoDaysTempChartView.zoomOut()
                }
                
            }
            
        }
        // Next Button Event
        else if (nextArrowTempFlag  == 1) {
            
            
            let fileManager4 = FileManager.default
            let documentsURL4 = fileManager4.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL4 = documentsURL4.appendingPathComponent("\(tempBaseTwoDaysYear)/\(tempBaseTwoDaysMonth)/\(tempBaseTwoDaysDate)")
            
            let fileURL4 = directoryURL4.appendingPathComponent("/BpmData.csv")
            
            let filePath4 = fileURL4.path
            
            if fileManager4.fileExists(atPath: filePath4){
                
                do {
                    let data = try String(contentsOf: fileURL4)
                    let tempData = data.components(separatedBy: .newlines)
                    
                    numbersOfTemp4 = tempData.count
                    
                    for i in 0..<numbersOfTemp4 - 1{
                        let row = tempData[i]
                        let columns = row.components(separatedBy: ",")
                        
                        let tempTimeCheck = columns[0].components(separatedBy: ":")
                        let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                        
                        
                        tempTimeData4.append(MyTempTimeRow)
                        tempArrayData4.append(Double(columns[2]) ?? 0.0)
                    }
                    
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(tempBaseTwoDaysYear)/\(tempBaseTwoDaysMonth)/\(tempBaseTwoDaysDate),\n"
            }
            
            let fileManager5 = FileManager.default
            let documentsURL5 = fileManager5.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL5 = documentsURL5.appendingPathComponent("\(tempChangeTwoDaysYear)/\(tempChangeTwoDaysMonth)/\(tempChangeTwoDaysDate)")
            
            let fileURL5 = directoryURL5.appendingPathComponent("/BpmData.csv")
            
            let filePath5 = fileURL5.path
            
            if fileManager5.fileExists(atPath: filePath5){
                
                do {
                    let data = try String(contentsOf: fileURL5)
                    let tempData = data.components(separatedBy: .newlines)
                    
                    numbersOfTemp5 = tempData.count
                    
                    for i in 0..<numbersOfTemp5 - 1{
                        let row = tempData[i]
                        let columns = row.components(separatedBy: ",")
                        
                        let tempTimeCheck = columns[0].components(separatedBy: ":")
                        let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                        
                        tempTimeData5.append(MyTempTimeRow)
                        tempArrayData5.append(Double(columns[2]) ?? 0.0)
                        
                    }
                    
                } catch  {
                    print("Error reading CSV file")
                }
            }
            else{
                alertFlag = true
                alertString += "\(tempChangeTwoDaysYear)/\(tempChangeTwoDaysMonth)/\(tempChangeTwoDaysDate),\n"
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
            if (fileManager4.fileExists(atPath: filePath4) && fileManager5.fileExists(atPath: filePath5)){
               
                lastTwoDaysTempButton.isEnabled = true
                nextTwoDaysTempButton.isEnabled = true
                
                /*
                 X 축 타임 테이블을 위해 시작 시간과 종료 시간을 구함
                 */
                let startOfYesterday = tempTimeData4.first!.components(separatedBy: ":") // 어제의 시작
                let endOfYesterday =  tempTimeData4.last!.components(separatedBy: ":") // 어제의 마지막
                
                let startOfToday = tempTimeData5.first!.components(separatedBy: ":") // 오늘의 시작
                let endOfToday = tempTimeData5.last!.components(separatedBy: ":") // 오늘의 마지막
                
                var startTime = [String]()
                var endTime = [String]()
                
                var copyEndHour = ""
                var copyStartHour = 0
                
                var minuteDifference = 0 // 분 차이
                var hourDifference = 0 // 시간 차이
                
                var totalXValue = 0 // 전체 x value
                
                // 전체 시작 시간 비교(total)
                if ( Int(startOfYesterday[0])! > Int(startOfToday[0])! ||
                     ((Int(startOfYesterday[0])! == Int(startOfToday[0])!) &&
                      (Int(startOfYesterday[1])! > Int(startOfToday[1])!))){
                    startTime = tempTimeData5.first!.components(separatedBy: ":")
                }
                else{
                    startTime = tempTimeData4.first!.components(separatedBy: ":")
                }
                
                // 전체 종료 시간 비교(total)
                if ( Int(endOfYesterday[0])! > Int(endOfToday[0])! ||
                     ((Int(endOfYesterday[0])! == Int(endOfToday[0])!) &&
                      (Int(endOfYesterday[1])! > Int(endOfToday[1])!))){
                    endTime = tempTimeData4.last!.components(separatedBy: ":")
                }
                else{
                    endTime = tempTimeData5.last!.components(separatedBy: ":")
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
                
                                
                var tempDataEntries4 = [ChartDataEntry]()
                var tempDataEntries5 = [ChartDataEntry]()
                
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
                
                var tempTimeCount = 0
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
                    var tempTime = tempTimeData5[tempTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                    
                    // 값이 있는 경우
                    if tempTime[0] == checkTimeTable[0] { // hour
                        if tempTime[1] == checkTimeTable[1] { // minute
                            if String(tempTime[2].first!) == checkTimeTable[2]{ // second
                                
                                let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData5[tempTimeCount])
                                tempDataEntries5.append(tempDataEntry)
                                
                                tempTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData5[tempTimeCount-1])
                            tempDataEntries5.append(tempDataEntry)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData5[tempTimeCount-1])
                        tempDataEntries5.append(tempDataEntry)
                    }
                                        
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && tempTimeData5.count > tempTimeCount{
                        tempTime = tempTimeData5[tempTimeCount].components(separatedBy: ":")

                        while String(tempTime[2].first!) == checkTimeTable[2] {
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData5[tempTimeCount])
                            tempDataEntries5.append(tempDataEntry)
                            tempTimeCount += 1
                            tempTime = tempTimeData5[tempTimeCount].components(separatedBy: ":")
                        }
                    }

                    timeTableCount += 1
                    
                    // 마지막 값
                    if tempTime[0] == endOfToday[0] && tempTime[1] == endOfToday[1] && tempTime[2] == endOfToday[2] || totalXValue == timeTableCount || tempTimeData5.count == tempTimeCount {
                        break
                    }
                }
                
                tempTimeCount = 0
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
                    var tempTime = tempTimeData4[tempTimeCount].components(separatedBy: ":")
                    let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                    var checkFlag = false
                
                    // 값이 있는 경우
                    if tempTime[0] == checkTimeTable[0] { // hour
                        if tempTime[1] == checkTimeTable[1] { // minute
                            if String(tempTime[2].first!) == checkTimeTable[2]{ // second
                                
                                let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData4[tempTimeCount])
                                tempDataEntries4.append(tempDataEntry)
                                
                                tempTimeCount += 1 // 값이 있으니까 +1
                                checkFlag = true
                            }
                        }
                        else{
                            // 분 값이 없는 경우 이전 값을 씀
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData4[tempTimeCount-1])
                            tempDataEntries4.append(tempDataEntry)
                        }
                    }
                    else{
                        // 시간 값이 없는 경우 이전 값을 씀
                        let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData4[tempTimeCount-1])
                        tempDataEntries4.append(tempDataEntry)
                    }
                    
                    // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                    if checkFlag == true && tempTimeData4.count > tempTimeCount{
                        tempTime = tempTimeData4[tempTimeCount].components(separatedBy: ":")

                        while String(tempTime[2].first!) == checkTimeTable[2] {
                            let tempDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempArrayData4[tempTimeCount])
                            tempDataEntries4.append(tempDataEntry)
                            tempTimeCount += 1
                            tempTime = tempTimeData4[tempTimeCount].components(separatedBy: ":")
                        }
                    }
                    
                    timeTableCount += 1
                    
                    // 마지막 값
                    if tempTime[0] == endOfYesterday[0] && tempTime[1] == endOfYesterday[1] && tempTime[2] == endOfYesterday[2] || totalXValue == timeTableCount || tempTimeData4.count == tempTimeCount {
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
                
                let tempChartDataSet4 = LineChartDataSet(entries: tempDataEntries4, label: "\(tempBaseTwoDaysMonth)-\(tempBaseTwoDaysDate)")
                tempChartDataSet4.drawCirclesEnabled = false
                tempChartDataSet4.setColor(NSUIColor.red)
                tempChartDataSet4.mode = .linear
                tempChartDataSet4.lineWidth = 0.5
                tempChartDataSet4.drawValuesEnabled = true
                
                
                let tempChartDataSet5 = LineChartDataSet(entries: tempDataEntries5, label: "\(tempChangeTwoDaysMonth)-\(tempChangeTwoDaysDate)")
                tempChartDataSet5.drawCirclesEnabled = false
                tempChartDataSet5.setColor(NSUIColor.blue)
                tempChartDataSet5.mode = .linear
                tempChartDataSet5.lineWidth = 0.5
                tempChartDataSet5.drawValuesEnabled = true
                
                let twoDaysTempChartdataSets2: [LineChartDataSet] = [tempChartDataSet4, tempChartDataSet5]
                
                let twoDaysTempChartData2 = LineChartData(dataSets: twoDaysTempChartdataSets2)
                // 2
                
                
                twoDaysTempChartView.data = twoDaysTempChartData2
                twoDaysTempChartView.noDataText = ""
                twoDaysTempChartView.xAxis.enabled = true
                twoDaysTempChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
                twoDaysTempChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeTable)
                twoDaysTempChartView.xAxis.granularity = 1
                twoDaysTempChartView.xAxis.axisMinimum = 0
                twoDaysTempChartView.xAxis.axisMaximum = Double(totalXValue)
                twoDaysTempChartView.xAxis.labelPosition = .bottom
                twoDaysTempChartView.xAxis.drawGridLinesEnabled = false
                
                twoDaysTempChartView.leftAxis.axisMaximum = 43.0
                twoDaysTempChartView.leftAxis.axisMinimum = 28.0
                twoDaysTempChartView.rightAxis.enabled = false
                twoDaysTempChartView.drawMarkers = false
                twoDaysTempChartView.dragEnabled = true
                twoDaysTempChartView.pinchZoomEnabled = false
                twoDaysTempChartView.doubleTapToZoomEnabled = true
                twoDaysTempChartView.highlightPerTapEnabled = false
                
                twoDaysTempChartView.data?.notifyDataChanged()
                twoDaysTempChartView.notifyDataSetChanged()
                twoDaysTempChartView.moveViewToX(0)
                
                tempTimeData2 = []
                tempArrayData2 = []
                
                tempTimeData3 = []
                tempArrayData3 = []
                
                tempTimeData4 = []
                tempArrayData4 = []
                
                tempTimeData5 = []
                tempArrayData5 = []
                
                tempChartView.isUserInteractionEnabled = false
                twoDaysTempChartView.isUserInteractionEnabled = true
                threeDaysTempChartView.isUserInteractionEnabled = false
                
                // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
                for _ in 0..<20 {
                    twoDaysTempChartView.zoomOut()
                }
            }
        } else { let alert = UIAlertController(title: "more data need", message: "", preferredStyle: UIAlertController.Style.alert)
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
    func threeDaysTempChartViewGraph(){
        
        tempChartView.clear()
        twoDaysTempChartView.clear()
        threeDaysTempChartView.clear()
        
        var alertString = ""
        var alertFlag = false
        alertLabel.isHidden = true
        alertBackground.isHidden = true
        plusButton.isHidden = false
        minusButton.isHidden = false
        refreshButton.isHidden = false
        
        // time table : 그래프에 보여줄 시간 배열
        var timeTable: [String] = []
        
        // 버튼을 여러번 클릭하였을때 값이 섞이는 것을 방지
        tempThreeTimeData1 = []
        tempThreeArrayData1 = []
        
        tempThreeTimeData2 = []
        tempThreeArrayData2 = []
        
        tempThreeTimeData3 = []
        tempThreeArrayData3 = []
    
        
        tempChangeThreeDaysYear1 = defaults.string(forKey:"tempChangeThreeDaysYear1") ?? "\(realYear)"
        tempChangeThreeDaysMonth1 = defaults.string(forKey:"tempChangeThreeDaysMonth1") ?? "\(realMonth)"
        tempChangeThreeDaysDate1 = defaults.string(forKey:"tempChangeThreeDaysDate1") ?? "\(realDate)"

        tempChangeThreeDaysYear2 = defaults.string(forKey:"tempChangeThreeDaysYear2") ?? "\(realYear)"
        tempChangeThreeDaysMonth2 = defaults.string(forKey:"tempChangeThreeDaysMonth2") ?? "\(realMonth)"
        tempChangeThreeDaysDate2 = defaults.string(forKey:"tempChangeThreeDaysDate2") ?? "\(realDate)"

        tempChangeThreeDaysYear3 = defaults.string(forKey:"tempChangeThreeDaysYear3") ?? "\(realYear)"
        tempChangeThreeDaysMonth3 = defaults.string(forKey:"tempChangeThreeDaysMonth3") ?? "\(realMonth)"
        tempChangeThreeDaysDate3 = defaults.string(forKey:"tempChangeThreeDaysDate3") ?? "\(realDate)"
        
        
        // test
//        tempChangeThreeDaysYear1 = "2023"
//        tempChangeThreeDaysMonth1 = "06"
//        tempChangeThreeDaysDate1 = "15"
//
//        tempChangeThreeDaysYear2 = "2023"
//        tempChangeThreeDaysMonth2 = "06"
//        tempChangeThreeDaysDate2 = "14"
//
//        tempChangeThreeDaysYear3 = "2023"
//        tempChangeThreeDaysMonth3 = "06"
//        tempChangeThreeDaysDate3 = "13"
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        
        let directoryURL1 = documentsURL.appendingPathComponent("\(tempChangeThreeDaysYear1)/\(tempChangeThreeDaysMonth1)/\(tempChangeThreeDaysDate1)")
        
        let fileURL1 = directoryURL1.appendingPathComponent("/BpmData.csv")
        
        let filePath1 = fileURL1.path
        
        // 기준일
        if fileManager.fileExists(atPath: filePath1){
            
            do {
                let data = try String(contentsOf: fileURL1)
                let tempData = data.components(separatedBy: .newlines)
                
                numbersOfThreeTemp1 = tempData.count
                
                for i in 0..<numbersOfThreeTemp1 - 1{
                    let row = tempData[i]
                    let columns = row.components(separatedBy: ",")
                    
                    let tempTimeCheck = columns[0].components(separatedBy: ":")
                    let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                    
                    tempThreeTimeData1.append(MyTempTimeRow)
                    tempThreeArrayData1.append(Double(columns[4]) ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertFlag = true
            alertString += "\(tempChangeThreeDaysYear1)/\(tempChangeThreeDaysMonth1)/\(tempChangeThreeDaysDate1),\n"
        }
        
        
        let directoryURL2 = documentsURL.appendingPathComponent("\(tempChangeThreeDaysYear2)/\(tempChangeThreeDaysMonth2)/\(tempChangeThreeDaysDate2)")
        
        let fileURL2 = directoryURL2.appendingPathComponent("/BpmData.csv")
        
        let filePath2 = fileURL2.path
        
        // 기준일(-1)
        if fileManager.fileExists(atPath: filePath2){
            
            do {
                let data = try String(contentsOf: fileURL2)
                let tempData = data.components(separatedBy: .newlines)
                
                numbersOfThreeTemp2 = tempData.count
                
                for i in 0..<numbersOfThreeTemp2 - 1{
                    let row = tempData[i]
                    let columns = row.components(separatedBy: ",")
                    
                    let tempTimeCheck = columns[0].components(separatedBy: ":")
                    let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                    
                    tempThreeTimeData2.append(MyTempTimeRow)
                    tempThreeArrayData2.append(Double(columns[4]) ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertFlag = true
            alertString += "\(tempChangeThreeDaysYear2)/\(tempChangeThreeDaysMonth2)/\(tempChangeThreeDaysDate2),\n"
        }
        
        
        
        let directoryURL3 = documentsURL.appendingPathComponent("\(tempChangeThreeDaysYear3)/\(tempChangeThreeDaysMonth3)/\(tempChangeThreeDaysDate3)")
        
        let fileURL3 = directoryURL3.appendingPathComponent("/BpmData.csv")
        
        let filePath3 = fileURL3.path
        // 기준일(-2)
        if fileManager.fileExists(atPath: filePath3){
            
            do {
                let data = try String(contentsOf: fileURL3)
                let tempData = data.components(separatedBy: .newlines)
                
                numbersOfThreeTemp3 = tempData.count
                
                for i in 0..<numbersOfThreeTemp3 - 1{
                    let row = tempData[i]
                    let columns = row.components(separatedBy: ",")
                    
                    let tempTimeCheck = columns[0].components(separatedBy: ":")
                    let MyTempTimeRow = tempTimeCheck[0] + ":" + tempTimeCheck[1] + ":" + (tempTimeCheck[safe: 2] ?? "00")
                    
                    
                    tempThreeTimeData3.append(MyTempTimeRow)
                    tempThreeArrayData3.append(Double(columns[4]) ?? 0.0)
                    
                }
            } catch  {
                print("Error reading CSV file")
            }
        }
        else{
            alertFlag = true
            alertString += "\(tempChangeThreeDaysYear3)/\(tempChangeThreeDaysMonth3)/\(tempChangeThreeDaysDate3),\n"
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
    
        
        // 세 개의 그래프가 있는 경우(fileExists) 두 개의 그래프 표시
        if (fileManager.fileExists(atPath: filePath1) && fileManager.fileExists(atPath: filePath2) && fileManager.fileExists(atPath: filePath3)){
            
            lastTwoDaysTempButton.isEnabled = true
            nextTwoDaysTempButton.isEnabled = true
            
            var tempThreeDataEntries1 = [ChartDataEntry]()
            var tempThreeDataEntries2 = [ChartDataEntry]()
            var tempThreeDataEntries3 = [ChartDataEntry]()
            
            /*
             X 축 타임 테이블을 위해 시작 시간과 종료 시간을 구함
             */
            let firstTwoDaysAgoTime = tempThreeTimeData3.first!.components(separatedBy: ":") // 이틀전 시작
            let lastTwoDaysAgoTime =  tempThreeTimeData3.last!.components(separatedBy: ":") // 이틀전 마지막
            
            let firstYesterdayTime = tempThreeTimeData2.first!.components(separatedBy: ":") // 어제 시작
            let lastYesterdayTime =  tempThreeTimeData2.last!.components(separatedBy: ":") // 어제 마지막
            
            let firstSelectTime = tempThreeTimeData1.first!.components(separatedBy: ":") // 오늘 시작
            let lastSelectTime = tempThreeTimeData1.last!.components(separatedBy: ":") // 오늘 마지막
            
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
                startTime = tempThreeTimeData1.first!.components(separatedBy: ":")
            }
            else{
                // 어제가 빠름
                startTime = tempThreeTimeData2.first!.components(separatedBy: ":")
            }
            // 빠른 날과 이틀전 비교
            if ( Int(firstTwoDaysAgoTime[0])! > Int(startTime[0])! ||
                 ((Int(firstTwoDaysAgoTime[0])! == Int(startTime[0])!) &&
                  (Int(firstTwoDaysAgoTime[1])! > Int(startTime[1])!))){
                // 기존에 빠른 날이 제일 빠름
            }
            else{
                // 이틀전이 제일 빠름
                startTime = tempThreeTimeData3.first!.components(separatedBy: ":")
            }
            
            // 전체 종료 시간 비교
            // 오늘과 어제 비교
            if ( Int(lastYesterdayTime[0])! > Int(lastSelectTime[0])! ||
                 ((Int(lastYesterdayTime[0])! == Int(lastSelectTime[0])!) &&
                  (Int(lastYesterdayTime[1])! > Int(lastSelectTime[1])!))){
                // 어제가 느림
                endTime = tempThreeTimeData2.last!.components(separatedBy: ":")
            }
            else{
                // 오늘이 느림
                endTime = tempThreeTimeData1.last!.components(separatedBy: ":")
            }
            // 느린 날과 이틀전 비교
            if ( Int(lastTwoDaysAgoTime[0])! > Int(endTime[0])! ||
                 ((Int(lastTwoDaysAgoTime[0])! == Int(endTime[0])!) &&
                  (Int(lastTwoDaysAgoTime[1])! > Int(endTime[1])!))){
                // 이틀전이 제일 느림
                endTime = tempThreeTimeData3.last!.components(separatedBy: ":")
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
            var tempTimeCount = 0
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
                var tempTime = tempThreeTimeData1[tempTimeCount].components(separatedBy: ":")
                let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                var checkFlag = false
//
//                print("------------------------------------------")
//                print("timeTable : \(timeTable[timeTableCount])")
//                print("bpmTime : \(tempTime)")
//                print("bpmSecond : \(String(tempTime[2]))")
//                print("bpmTimeFirst : \(String(tempTime[2].first!))")
//                print("checkTimeTable : \(checkTimeTable[2])")
//
                // 값이 있는 경우
                if tempTime[0] == checkTimeTable[0] { // hour
                    if tempTime[1] == checkTimeTable[1] { // minute
                        if String(tempTime[2].first!) == checkTimeTable[2]{ // second
//                            print("----> \(tempThreeTimeData1[tempTimeCount]) CheckCount : \(tempTimeCount)")
                            
                            let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData1[tempTimeCount])
                            tempThreeDataEntries1.append(tempThreeDataEntry)
                            
                            tempTimeCount += 1 // 값이 있으니까 +1
                            checkFlag = true
                        }
                    }
                    else{
                        // 분 값이 없는 경우 이전 값을 씀
                        let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData1[tempTimeCount-1])
                        tempThreeDataEntries1.append(tempThreeDataEntry)
                    }
                }
                else{
                    // 시간 값이 없는 경우
                    let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData1[tempTimeCount-1])
                    tempThreeDataEntries1.append(tempThreeDataEntry)
                }
                
                // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                if checkFlag == true && tempThreeTimeData1.count > tempTimeCount{
                    tempTime = tempThreeTimeData1[tempTimeCount].components(separatedBy: ":")

                    while String(tempTime[2].first!) == checkTimeTable[2] {
                        let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData1[tempTimeCount])
                        tempThreeDataEntries1.append(tempThreeDataEntry)
                        tempTimeCount += 1
                        tempTime = tempThreeTimeData1[tempTimeCount].components(separatedBy: ":")
                    }
                }
                
                timeTableCount += 1
                
                // 마지막 값
                if tempTime[0] == lastSelectTime[0] && tempTime[1] == lastSelectTime[1] && tempTime[2] == lastSelectTime[2] || totalXValue == timeTableCount || tempThreeTimeData1.count == tempTimeCount {
                    break
                }
            }
            
            tempTimeCount = 0
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
            
            // yesterday
            for _ in 0 ..< totalXValue {
                var tempTime = tempThreeTimeData2[tempTimeCount].components(separatedBy: ":")
                let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                var checkFlag = false
                
                // 값이 있는 경우
                if tempTime[0] == checkTimeTable[0] { // hour
                    if tempTime[1] == checkTimeTable[1] { // minute
                        if String(tempTime[2].first!) == checkTimeTable[2]{ // second
                            
                            let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData2[tempTimeCount])
                            tempThreeDataEntries2.append(tempThreeDataEntry)
                            
                            tempTimeCount += 1 // 값이 있으니까 +1
                            checkFlag = true
                        }
                    }
                    else{
                        // 분 값이 없는 경우 이전 값을 씀
                        let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData2[tempTimeCount-1])
                        tempThreeDataEntries2.append(tempThreeDataEntry)
                    }
                }
                else{
                    // 시간 값이 없는 경우 이전 값을 씀
                    let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData2[tempTimeCount-1])
                    tempThreeDataEntries2.append(tempThreeDataEntry)
                }
                
                // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                if checkFlag == true && tempThreeTimeData2.count > tempTimeCount{
                    tempTime = tempThreeTimeData2[tempTimeCount].components(separatedBy: ":")

                    while String(tempTime[2].first!) == checkTimeTable[2] {
                        let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData2[tempTimeCount])
                        tempThreeDataEntries2.append(tempThreeDataEntry)
                        tempTimeCount += 1
                        tempTime = tempThreeTimeData2[tempTimeCount].components(separatedBy: ":")
                    }
                }
                
                timeTableCount += 1
                
                // 마지막 값
                if tempTime[0] == lastSelectTime[0] && tempTime[1] == lastSelectTime[1] && tempTime[2] == lastSelectTime[2] || totalXValue == timeTableCount || tempThreeTimeData2.count == tempTimeCount {
                    break
                }
            }
            
            tempTimeCount = 0
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
                    // 44 - 6 = 38
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
                var tempTime = tempThreeTimeData3[tempTimeCount].components(separatedBy: ":")
                let checkTimeTable = timeTable[timeTableCount].components(separatedBy: ":")
                var checkFlag = false
                
                // 값이 있는 경우
                if tempTime[0] == checkTimeTable[0] { // hour
                    if tempTime[1] == checkTimeTable[1] { // minute
                        if String(tempTime[2].first!) == checkTimeTable[2]{ // second
                            
                            let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData3[tempTimeCount])
                            tempThreeDataEntries3.append(tempThreeDataEntry)
                            
                            tempTimeCount += 1 // 값이 있으니까 +1
                            checkFlag = true
                        }
                    }
                    else{
                        // 분 값이 없는 경우 이전 값을 씀
                        if tempTimeCount > 0 {
                            let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData3[tempTimeCount-1])
                            tempThreeDataEntries3.append(tempThreeDataEntry)
                        }
                    }
                }
                else{
                    // 시간 값이 없는 경우 이전 값을 씀
                    if tempTimeCount > 0 {
                        let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData3[tempTimeCount-1])
                        tempThreeDataEntries3.append(tempThreeDataEntry)
                    }
                }
                
                // 같은 초가 나오는 경우 현재 타임 테이블 값과 다음값 비교 (ex: 10 -> 19)
                if checkFlag == true && tempThreeTimeData3.count > tempTimeCount{
                    tempTime = tempThreeTimeData3[tempTimeCount].components(separatedBy: ":")

                    while String(tempTime[2].first!) == checkTimeTable[2] {
                        let tempThreeDataEntry = ChartDataEntry(x: Double(timeTableCount), y: tempThreeArrayData3[tempTimeCount])
                        tempThreeDataEntries3.append(tempThreeDataEntry)
                        tempTimeCount += 1
                        tempTime = tempThreeTimeData3[tempTimeCount].components(separatedBy: ":")
                    }
                }
                
                timeTableCount += 1
                
                // 마지막 값
                if tempTime[0] == lastSelectTime[0] && tempTime[1] == lastSelectTime[1] && tempTime[2] == lastSelectTime[2] || totalXValue == timeTableCount || tempThreeTimeData3.count == tempTimeCount {
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
            
            let tempThreeChartDataSet1 = LineChartDataSet(entries: tempThreeDataEntries1, label: "\(tempChangeThreeDaysMonth1)-\(tempChangeThreeDaysDate1)")
            tempThreeChartDataSet1.drawCirclesEnabled = false
            tempThreeChartDataSet1.setColor(NSUIColor.red)
            tempThreeChartDataSet1.mode = .linear
            tempThreeChartDataSet1.lineWidth = 0.5
            tempThreeChartDataSet1.drawValuesEnabled = true
            
            
            let tempThreeChartDataSet2 = LineChartDataSet(entries: tempThreeDataEntries2, label: "\(tempChangeThreeDaysMonth2)-\(tempChangeThreeDaysDate2)")
            tempThreeChartDataSet2.drawCirclesEnabled = false
            tempThreeChartDataSet2.setColor(NSUIColor.blue)
            tempThreeChartDataSet2.mode = .linear
            tempThreeChartDataSet2.lineWidth = 0.5
            tempThreeChartDataSet2.drawValuesEnabled = true
            
            let tempThreeChartDataSet3 = LineChartDataSet(entries: tempThreeDataEntries3, label: "\(tempChangeThreeDaysMonth3)-\(tempChangeThreeDaysDate3)")
            tempThreeChartDataSet3.drawCirclesEnabled = false
            tempThreeChartDataSet3.setColor(NSUIColor.lineGreen!)
            tempThreeChartDataSet3.mode = .linear
            tempThreeChartDataSet3.lineWidth = 0.5
            tempThreeChartDataSet3.drawValuesEnabled = true
            
            
            
            let  tempThreeChartdataSets: [LineChartDataSet] = [tempThreeChartDataSet3, tempThreeChartDataSet2, tempThreeChartDataSet1]
            
            let tempThreeChartchartData = LineChartData(dataSets: tempThreeChartdataSets)
            // 2
            
            threeDaysTempChartView.data = tempThreeChartchartData
            threeDaysTempChartView.noDataText = ""
            threeDaysTempChartView.xAxis.enabled = true
            threeDaysTempChartView.legend.font = .systemFont(ofSize: 15, weight: .bold)
            threeDaysTempChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeTable)
            threeDaysTempChartView.xAxis.axisMaximum = Double(totalXValue) // x축 범위
            threeDaysTempChartView.setVisibleXRangeMaximum(1000)
            threeDaysTempChartView.xAxis.granularity = 1
            threeDaysTempChartView.xAxis.labelPosition = .bottom
            threeDaysTempChartView.xAxis.drawGridLinesEnabled = false
            
            threeDaysTempChartView.leftAxis.axisMaximum = 150.0
            threeDaysTempChartView.leftAxis.axisMinimum = 0.0
            threeDaysTempChartView.rightAxis.enabled = false
            threeDaysTempChartView.drawMarkers = false
            threeDaysTempChartView.dragEnabled = true
            threeDaysTempChartView.pinchZoomEnabled = false
            threeDaysTempChartView.doubleTapToZoomEnabled = true // 더블 줌
            threeDaysTempChartView.highlightPerTapEnabled = false
            
            threeDaysTempChartView.data?.notifyDataChanged()
            threeDaysTempChartView.notifyDataSetChanged()
            threeDaysTempChartView.moveViewToX(0)
            
            tempThreeArrayData1 = []
            tempThreeTimeData1 = []
            
            tempThreeArrayData2 = []
            tempThreeTimeData2 = []
            
            tempThreeArrayData3 = []
            tempThreeTimeData3 = []
            
            tempChartView.isUserInteractionEnabled = false
            twoDaysTempChartView.isUserInteractionEnabled = false
            threeDaysTempChartView.isUserInteractionEnabled = true
            
            // 줌 인 상태에서 다른 그래프 봤을 경우 대비 줌 아웃
            for _ in 0..<20 {
                threeDaysTempChartView.zoomOut()
            }
        }
    }
    
    
    
    // MARK: - todayButton
    @objc func selectOneDayClick(sender: AnyObject) {
        
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -tempDateCount, to: tempTodayDate)!
        
        tempTodayDate = yesterday
        
        let tyear = DateFormatter()
        let tmonth = DateFormatter()
        let tdate = DateFormatter()
        
        
        tyear.dateFormat = "yyyy"
        tmonth.dateFormat = "MM"
        tdate.dateFormat = "dd"
        
        tempChangeRealYear = tyear.string(from: tempTodayDate)
        tempChangeRealMonth = tmonth.string(from: tempTodayDate)
        tempChangeRealDate = tdate.string(from: tempTodayDate)
        
        
        defaults.set(tempChangeRealYear, forKey: "tempChangeRealYear")
        defaults.set(tempChangeRealMonth, forKey: "tempChangeRealMonth")
        defaults.set(tempChangeRealDate, forKey: "tempChangeRealDate")
        
        todayTempDispalay.text = String("\(tempChangeRealYear)-\(tempChangeRealMonth)-\(tempChangeRealDate)")
        
        
        oneDayTempButton.isSelected = true
        twoDaysTempButton.isSelected  = false
        threeDaysTempButton.isSelected = false
        
        oneDayTempButton.isUserInteractionEnabled = false
        twoDaysTempButton.isUserInteractionEnabled  = true
        threeDaysTempButton.isUserInteractionEnabled = true
        
        todayTempDispalay.isHidden = false
        twoDaysTempDispalay.isHidden = true
        threeDaysTempDispalay.isHidden = true
        
        yesterdayTempButton.isHidden = false
        tomorrowTempButton.isHidden = false
        lastTwoDaysTempButton.isHidden = true
        nextTwoDaysTempButton.isHidden = true
        lastThreeDaysTempButton.isHidden = true
        nextThreeDaysTempButton.isHidden = true
        
        
        yesterdayTempButton.isEnabled = true
        tomorrowTempButton.isEnabled = true
        lastTwoDaysTempButton.isEnabled = false
        nextTwoDaysTempButton.isEnabled = false
        lastThreeDaysTempButton.isEnabled = false
        nextThreeDaysTempButton.isEnabled = false
        
        tempDateCount = 0
        
        tempChartViewGraph()
    }
    
    func yesterdayButton(){
        
        tempDateCount = tempDateCount - 1
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: tempTodayDate)!
        
        tempTodayDate = yesterday
        
        let tyear = DateFormatter()
        let tmonth = DateFormatter()
        let tdate = DateFormatter()
        
        
        tyear.dateFormat = "yyyy"
        tmonth.dateFormat = "MM"
        tdate.dateFormat = "dd"
        
        tempChangeRealYear = tyear.string(from: tempTodayDate)
        tempChangeRealMonth = tmonth.string(from: tempTodayDate)
        tempChangeRealDate = tdate.string(from: tempTodayDate)
        
        todayTempDispalay.text = String("\(tempChangeRealYear)-\(tempChangeRealMonth)-\(tempChangeRealDate)")
        
        defaults.set(tempChangeRealYear, forKey:"tempChangeRealYear")
        defaults.set(tempChangeRealMonth, forKey:"tempChangeRealMonth")
        defaults.set(tempChangeRealDate, forKey:"tempChangeRealDate")
        
    }
    
    
    func tomorrowButton(){
        
        tempDateCount = tempDateCount + 1
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: tempTodayDate)!
        tempTodayDate = tomorrow
        
        
        let tyear = DateFormatter()
        let tmonth = DateFormatter()
        let tdate = DateFormatter()
        
        
        tyear.dateFormat = "yyyy"
        tmonth.dateFormat = "MM"
        tdate.dateFormat = "dd"
        
        
        
        tempChangeRealYear = tyear.string(from: tempTodayDate)
        tempChangeRealMonth = tmonth.string(from: tempTodayDate)
        tempChangeRealDate = tdate.string(from: tempTodayDate)
        
        
        todayTempDispalay.text = String("\(tempChangeRealYear)-\(tempChangeRealMonth)-\(tempChangeRealDate)")
        
        
        defaults.set(tempChangeRealYear, forKey:"tempChangeRealYear")
        defaults.set(tempChangeRealMonth, forKey:"tempChangeRealMonth")
        defaults.set(tempChangeRealDate, forKey:"tempChangeRealDate")
        
    }
    
    
    
    //     ------------------------어제 내일 버튼들 시작 ----------------------
    
    @objc func yesterdaySelectTempButton(sender: AnyObject){
        
        yesterdayButton()
        tempChartViewGraph()
    }
    
    
    @objc func tomorrowSelectTempButton(sender: AnyObject){
        
        tomorrowButton()
        tempChartViewGraph()
    }
    
    //     ------------------------어제 내일 버튼들  끝 ----------------------
    
    
    
    //     ------------------------2 Days 버튼들 시작 ----------------------
    
    // MARK: - twodaysButton
    @objc func selectTwoDaysClick(sender: AnyObject) {
        
        
        let twoDaysYesterday0 = Calendar.current.date(byAdding: .day, value: -tempTwodateCount, to: twoDaysTempTodayDate)!
        
        twoDaysTempTodayDate = twoDaysYesterday0
        
        let ryear = DateFormatter()
        let rmonth = DateFormatter()
        let rdate = DateFormatter()
        
        
        ryear.dateFormat = "yyyy"
        rmonth.dateFormat = "MM"
        rdate.dateFormat = "dd"
        
        tempBaseTwoDaysYear = ryear.string(from: twoDaysTempTodayDate)
        tempBaseTwoDaysMonth = rmonth.string(from: twoDaysTempTodayDate)
        tempBaseTwoDaysDate = rdate.string(from: twoDaysTempTodayDate)
        
        
        defaults.set(tempBaseTwoDaysYear, forKey: "tempBaseTwoDaysYear")
        defaults.set(tempBaseTwoDaysMonth, forKey: "tempBaseTwoDaysMonth")
        defaults.set(tempBaseTwoDaysDate, forKey: "tempBaseTwoDaysDate")
        
        
        let twoDaysYesterday = Calendar.current.date(byAdding: .day, value: -1, to: twoDaysTempTodayDate)!
        
        twoDaysTempTodayDate = twoDaysYesterday
        
        let yyear = DateFormatter()
        let ymonth = DateFormatter()
        let ydate = DateFormatter()
        
        
        yyear.dateFormat = "yyyy"
        ymonth.dateFormat = "MM"
        ydate.dateFormat = "dd"
        
        tempChangeTwoDaysYear = yyear.string(from: twoDaysTempTodayDate)
        tempChangeTwoDaysMonth = ymonth.string(from: twoDaysTempTodayDate)
        tempChangeTwoDaysDate = ydate.string(from: twoDaysTempTodayDate)
        
        defaults.set(tempChangeTwoDaysYear, forKey: "tempChangeTwoDaysYear")
        defaults.set(tempChangeTwoDaysMonth, forKey: "tempChangeTwoDaysMonth")
        defaults.set(tempChangeTwoDaysDate, forKey: "tempChangeTwoDaysDate")
        
        
        twoDaysTempDispalay.text = String("\(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate) ~ \(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate)")
        
        let twoDaysTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: twoDaysTempTodayDate)!
        
        twoDaysTempTodayDate = twoDaysTomorrow
        
        oneDayTempButton.isSelected = false
        twoDaysTempButton.isSelected  = true
        threeDaysTempButton.isSelected = false
        
        oneDayTempButton.isUserInteractionEnabled = true
        twoDaysTempButton.isUserInteractionEnabled  = false
        threeDaysTempButton.isUserInteractionEnabled = true
        
        todayTempDispalay.isHidden = true
        twoDaysTempDispalay.isHidden = false
        threeDaysTempDispalay.isHidden = true
        
        yesterdayTempButton.isHidden = true
        tomorrowTempButton.isHidden = true
        lastTwoDaysTempButton.isHidden = false
        nextTwoDaysTempButton.isHidden = false
        lastThreeDaysTempButton.isHidden = true
        nextThreeDaysTempButton.isHidden = true
        
        
        yesterdayTempButton.isEnabled = false
        tomorrowTempButton.isEnabled = false
        lastTwoDaysTempButton.isEnabled = true
        nextTwoDaysTempButton.isEnabled = true
        lastThreeDaysTempButton.isEnabled = false
        nextThreeDaysTempButton.isEnabled = false
        
        previousArrowTempFlag = 0
        nextArrowTempFlag = 0
        baseArrowTempFlag = 1
        
        tempTwodateCount = 0
        
        twoDaysTempChartViewGraph()
    }
    
    
    func lastTwoDaysButton(){
        
        
        if ((baseArrowTempFlag == 1) && (previousArrowTempFlag == 1) && (nextArrowTempFlag == 0)){
            
            tempBaseTwoDaysYear = defaults.string(forKey:"tempChangeTwoDaysYear") ?? "\(realYear)"
            tempBaseTwoDaysMonth = defaults.string(forKey:"tempChangeTwoDaysMonth") ?? "\(realMonth)"
            tempBaseTwoDaysDate = defaults.string(forKey:"tempChangeTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays1 = Calendar.current.date(byAdding: .day, value: -1, to: twoDaysTempTodayDate)!
            
            twoDaysTempTodayDate = TwoDays1
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            tempChangeTwoDaysYear = tyear.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysMonth = tmonth.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysDate = tdate.string(from: twoDaysTempTodayDate)
            
            
            
            defaults.set(tempChangeTwoDaysYear, forKey:"tempChangeTwoDaysYear")
            defaults.set(tempChangeTwoDaysMonth, forKey:"tempChangeTwoDaysMonth")
            defaults.set(tempChangeTwoDaysDate, forKey:"tempChangeTwoDaysDate")
            
            defaults.set(tempBaseTwoDaysYear, forKey:"tempBaseTwoDaysYear")
            defaults.set(tempBaseTwoDaysMonth, forKey:"tempBaseTwoDaysMonth")
            defaults.set(tempBaseTwoDaysDate, forKey:"tempBaseTwoDaysDate")
            //
            
            
            twoDaysTempDispalay.text = String("\(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate) ~ \(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate)")
            
            previousArrowTempFlag = 1
            nextArrowTempFlag = 0
            baseArrowTempFlag = 0
            
            tempTwodateCount = tempTwodateCount - 1
            
            
            twoDaysTempChartViewGraph()
        }
        
        if ((baseArrowTempFlag == 0) && (previousArrowTempFlag == 1) && (nextArrowTempFlag == 0)){
            
            tempBaseTwoDaysYear = defaults.string(forKey:"tempChangeTwoDaysYear") ?? "\(realYear)"
            tempBaseTwoDaysMonth = defaults.string(forKey:"tempChangeTwoDaysMonth") ?? "\(realMonth)"
            tempBaseTwoDaysDate = defaults.string(forKey:"tempChangeTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays2 = Calendar.current.date(byAdding: .day, value: -1, to: twoDaysTempTodayDate)!
            
            twoDaysTempTodayDate = TwoDays2
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            tempChangeTwoDaysYear = tyear.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysMonth = tmonth.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysDate = tdate.string(from: twoDaysTempTodayDate)
            
            
            
            defaults.set(tempChangeTwoDaysYear, forKey:"tempChangeTwoDaysYear")
            defaults.set(tempChangeTwoDaysMonth, forKey:"tempChangeTwoDaysMonth")
            defaults.set(tempChangeTwoDaysDate, forKey:"tempChangeTwoDaysDate")
            
            defaults.set(tempBaseTwoDaysYear, forKey:"tempBaseTwoDaysYear")
            defaults.set(tempBaseTwoDaysMonth, forKey:"tempBaseTwoDaysMonth")
            defaults.set(tempBaseTwoDaysDate, forKey:"tempBaseTwoDaysDate")
            //
            
            
            twoDaysTempDispalay.text = String("\(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate) ~ \(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate)")
            
            previousArrowTempFlag = 1
            nextArrowTempFlag = 0
            baseArrowTempFlag = 0
            
            tempTwodateCount = tempTwodateCount - 1
            
            
            twoDaysTempChartViewGraph()
        }
        
        
        
        if ((baseArrowFlag == 0) && (previousArrowTempFlag == 1) && (nextArrowTempFlag == 1)){
            
            tempBaseTwoDaysYear = defaults.string(forKey:"tempBaseTwoDaysYear") ?? "\(realYear)"
            tempBaseTwoDaysMonth = defaults.string(forKey:"tempBaseTwoDaysMonth") ?? "\(realMonth)"
            tempBaseTwoDaysDate = defaults.string(forKey:"tempBaseTwoDaysDate") ?? "\(realDate)"
            
            let TwoDays3 = Calendar.current.date(byAdding: .day, value: -2, to: twoDaysTempTodayDate)!
            
            twoDaysTempTodayDate = TwoDays3
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            tempChangeTwoDaysYear = tyear.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysMonth = tmonth.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysDate = tdate.string(from: twoDaysTempTodayDate)
            
            defaults.set(tempChangeTwoDaysYear, forKey:"tempChangeTwoDaysYear")
            defaults.set(tempChangeTwoDaysMonth, forKey:"tempChangeTwoDaysMonth")
            defaults.set(tempChangeTwoDaysDate, forKey:"tempChangeTwoDaysDate")
            
            defaults.set(tempBaseTwoDaysYear, forKey:"tempBaseTwoDaysYear")
            defaults.set(tempBaseTwoDaysMonth, forKey:"tempBaseTwoDaysMonth")
            defaults.set(tempBaseTwoDaysDate, forKey:"tempBaseTwoDaysDate")
            
            twoDaysTempDispalay.text = String("\(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate) ~ \(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate)")
            
            previousArrowTempFlag = 1
            nextArrowTempFlag = 0
            baseArrowTempFlag = 0
            
            tempTwodateCount = tempTwodateCount - 2
            twoDaysTempChartViewGraph()
            
        }
    }
    
    
    func nextTwoDaysButton(){
        
        
        if ((baseArrowFlag == 1) && (previousArrowTempFlag == 0) && (nextArrowTempFlag == 1)){
            
            tempBaseTwoDaysYear = defaults.string(forKey:"tempBaseTwoDaysYear") ?? "\(realYear)"
            tempBaseTwoDaysMonth = defaults.string(forKey:"tempBaseTwoDaysMonth") ?? "\(realMonth)"
            tempBaseTwoDaysDate = defaults.string(forKey:"tempBaseTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays4 = Calendar.current.date(byAdding: .day, value: 1, to: twoDaysTempTodayDate)!
            
            twoDaysTempTodayDate = TwoDays4
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            tempChangeTwoDaysYear = tyear.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysMonth = tmonth.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysDate = tdate.string(from: twoDaysTempTodayDate)
            
            defaults.set(tempChangeTwoDaysYear, forKey:"tempChangeTwoDaysYear")
            defaults.set(tempChangeTwoDaysMonth, forKey:"tempChangeTwoDaysMonth")
            defaults.set(tempChangeTwoDaysDate, forKey:"tempChangeTwoDaysDate")
            
            defaults.set(tempBaseTwoDaysYear, forKey:"tempBaseTwoDaysYear")
            defaults.set(tempBaseTwoDaysMonth, forKey:"tempBaseTwoDaysMonth")
            defaults.set(tempBaseTwoDaysDate, forKey:"tempBaseTwoDaysDate")
            
            
            twoDaysTempDispalay.text = String("\(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate) ~ \(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate)")
            
            previousArrowTempFlag = 0
            nextArrowTempFlag = 1
            baseArrowTempFlag = 0
            
            tempTwodateCount = tempTwodateCount + 1
            
            twoDaysTempChartViewGraph()
        }
        
        if ((baseArrowFlag == 0) && (previousArrowTempFlag == 0) && (nextArrowTempFlag == 1)){
            
            tempBaseTwoDaysYear = defaults.string(forKey:"tempChangeTwoDaysYear") ?? "\(realYear)"
            tempBaseTwoDaysMonth = defaults.string(forKey:"tempChangeTwoDaysMonth") ?? "\(realMonth)"
            tempBaseTwoDaysDate = defaults.string(forKey:"tempChangeTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays5 = Calendar.current.date(byAdding: .day, value: 1, to: twoDaysTempTodayDate)!
            
            twoDaysTempTodayDate = TwoDays5
            
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            tempChangeTwoDaysYear = tyear.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysMonth = tmonth.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysDate = tdate.string(from: twoDaysTempTodayDate)
            
            defaults.set(tempChangeTwoDaysYear, forKey:"tempChangeTwoDaysYear")
            defaults.set(tempChangeTwoDaysMonth, forKey:"tempChangeTwoDaysMonth")
            defaults.set(tempChangeTwoDaysDate, forKey:"tempChangeTwoDaysDate")
            
            defaults.set(tempBaseTwoDaysYear, forKey:"tempBaseTwoDaysYear")
            defaults.set(tempBaseTwoDaysMonth, forKey:"tempBaseTwoDaysMonth")
            defaults.set(tempBaseTwoDaysDate, forKey:"tempBaseTwoDaysDate")
            
            
            twoDaysTempDispalay.text = String("\(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate) ~ \(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate)")
            
            previousArrowTempFlag = 0
            nextArrowTempFlag = 1
            baseArrowTempFlag = 0
            
            tempTwodateCount = tempTwodateCount + 1
            
            twoDaysTempChartViewGraph()
            
        }
        
        
        if ((baseArrowFlag == 0) && (previousArrowTempFlag == 1) && (nextArrowTempFlag == 1)){
            
            tempBaseTwoDaysYear = defaults.string(forKey:"tempBaseTwoDaysYear") ?? "\(realYear)"
            tempBaseTwoDaysMonth = defaults.string(forKey:"tempBaseTwoDaysMonth") ?? "\(realMonth)"
            tempBaseTwoDaysDate = defaults.string(forKey:"tempBaseTwoDaysDate") ?? "\(realDate)"
            
            
            let TwoDays6 = Calendar.current.date(byAdding: .day, value: 2, to: twoDaysTempTodayDate)!
            
            twoDaysTempTodayDate = TwoDays6
            
            let tyear = DateFormatter()
            let tmonth = DateFormatter()
            let tdate = DateFormatter()
            
            tyear.dateFormat = "yyyy"
            tmonth.dateFormat = "MM"
            tdate.dateFormat = "dd"
            
            tempChangeTwoDaysYear = tyear.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysMonth = tmonth.string(from: twoDaysTempTodayDate)
            tempChangeTwoDaysDate = tdate.string(from: twoDaysTempTodayDate)
            
            defaults.set(tempChangeTwoDaysYear, forKey:"tempChangeTwoDaysYear")
            defaults.set(tempChangeTwoDaysMonth, forKey:"tempChangeTwoDaysMonth")
            defaults.set(tempChangeTwoDaysDate, forKey:"tempChangeTwoDaysDate")
            
            defaults.set(tempBaseTwoDaysYear, forKey:"tempBaseTwoDaysYear")
            defaults.set(tempBaseTwoDaysMonth, forKey:"tempBaseTwoDaysMonth")
            defaults.set(tempBaseTwoDaysDate, forKey:"tempBaseTwoDaysDate")
            
            
            twoDaysTempDispalay.text = String("\(tempBaseTwoDaysMonth).\(tempBaseTwoDaysDate) ~ \(tempChangeTwoDaysMonth).\(tempChangeTwoDaysDate)")
            
            
            previousArrowTempFlag = 0
            nextArrowTempFlag = 1
            baseArrowTempFlag = 0
            
            tempTwodateCount = tempTwodateCount + 2
            twoDaysTempChartViewGraph()
        }
    }
    
    
    
    @objc func lastTwoDaysSelectTempButton(sender: AnyObject){
        
        previousArrowTempFlag = 1
        
        lastTwoDaysButton()
    }
    
    
    @objc func nextTwoDaysSelectTempButton(sender: AnyObject){
        
        nextArrowTempFlag = 1
        
        nextTwoDaysButton()
    }
    
    //     ------------------------2 Days  버튼들 끝  ----------------------
    
    
    // MARK: - threedaysButton
    @objc func selectThreeDaysClick(sender: AnyObject) {
        
        oneDayTempButton.isSelected = false
        twoDaysTempButton.isSelected  = false
        threeDaysTempButton.isSelected = true
        
        oneDayTempButton.isUserInteractionEnabled = true
        twoDaysTempButton.isUserInteractionEnabled  = true
        threeDaysTempButton.isUserInteractionEnabled = false
        
        todayTempDispalay.isHidden = true
        twoDaysTempDispalay.isHidden = true
        threeDaysTempDispalay.isHidden = false
        
        
        yesterdayTempButton.isHidden = true
        tomorrowTempButton.isHidden = true
        lastTwoDaysTempButton.isHidden = true
        nextTwoDaysTempButton.isHidden = true
        lastThreeDaysTempButton.isHidden = false
        nextThreeDaysTempButton.isHidden = false
        
        yesterdayTempButton.isEnabled = false
        tomorrowTempButton.isEnabled = false
        lastTwoDaysTempButton.isEnabled = false
        nextTwoDaysTempButton.isEnabled = false
        lastThreeDaysTempButton.isEnabled = true
        nextThreeDaysTempButton.isEnabled = true
        
        // 초기화
        tempThreeDateCount = 0
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
        
        tempBaseThreeDaysYear = syear.string(from: toDays)
        tempBaseThreeDaysMonth = smonth.string(from: toDays)
        tempBaseThreeDaysDate = sdate.string(from: toDays)
        
        defaults.set(tempBaseThreeDaysYear, forKey:"tempBaseThreeDaysYear1")
        defaults.set(tempBaseThreeDaysMonth, forKey:"tempBaseThreeDaysMonth1")
        defaults.set(tempBaseThreeDaysDate, forKey:"tempBaseThreeDaysDate1")
        
        let oneDays = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        
        tempChangeThreeDaysYear = syear.string(from: oneDays)
        tempChangeThreeDaysMonth = smonth.string(from: oneDays)
        tempChangeThreeDaysDate = sdate.string(from: oneDays)
        
        defaults.set(tempChangeThreeDaysYear, forKey:"tempChangeThreeDaysYear2")
        defaults.set(tempChangeThreeDaysMonth, forKey:"tempChangeThreeDaysMonth2")
        defaults.set(tempChangeThreeDaysDate, forKey:"tempChangeThreeDaysDate2")
        
        let twoDays = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
        
        tempChangeThreeDaysYear = syear.string(from: twoDays)
        tempChangeThreeDaysMonth = smonth.string(from: twoDays)
        tempChangeThreeDaysDate = sdate.string(from: twoDays)
        
        defaults.set(tempChangeThreeDaysYear, forKey:"tempChangeThreeDaysYear3")
        defaults.set(tempChangeThreeDaysMonth, forKey:"tempChangeThreeDaysMonth3")
        defaults.set(tempChangeThreeDaysDate, forKey:"tempChangeThreeDaysDate3")
        
        threeDaysTempDispalay.text = String("\(tempChangeThreeDaysMonth).\(tempChangeThreeDaysDate) ~ \(tempBaseThreeDaysMonth).\(tempBaseThreeDaysDate)")
        
        threeDaysTempChartViewGraph()
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
        
        tempThreeDateCount = -1
        lastButtonFlag = true
        
        toDay = Calendar.current.date(byAdding: .day, value: tempThreeDateCount, to: saveThreeDaysDate)!
        
        // 다음 버튼이 눌린 상태
        if nextButtonFlag == true {
            
            tempThreeDateCount = 1
            nextButtonFlag = false
            
            toDay = Calendar.current.date(byAdding: .day, value: tempThreeDateCount, to: saveThreeDaysDate)!
            
        }
        
        tempBaseThreeDaysYear = syear.string(from: toDay)
        tempBaseThreeDaysMonth = smonth.string(from: toDay)
        tempBaseThreeDaysDate = sdate.string(from: toDay)
        
        defaults.set(tempBaseThreeDaysYear, forKey:"tempChangeThreeDaysYear1")
        defaults.set(tempBaseThreeDaysMonth, forKey:"tempChangeThreeDaysMonth1")
        defaults.set(tempBaseThreeDaysDate, forKey:"tempChangeThreeDaysDate1")
        
        
        let oneDays = Calendar.current.date(byAdding: .day, value: tempThreeDateCount-1, to: saveThreeDaysDate)!
        
        tempChangeThreeDaysYear = syear.string(from: oneDays)
        tempChangeThreeDaysMonth = smonth.string(from: oneDays)
        tempChangeThreeDaysDate = sdate.string(from: oneDays)
        
        defaults.set(tempChangeThreeDaysYear, forKey:"tempChangeThreeDaysYear2")
        defaults.set(tempChangeThreeDaysMonth, forKey:"tempChangeThreeDaysMonth2")
        defaults.set(tempChangeThreeDaysDate, forKey:"tempChangeThreeDaysDate2")
        
        let twoDays = Calendar.current.date(byAdding: .day, value: tempThreeDateCount-2, to: saveThreeDaysDate)!
        
        tempChangeThreeDaysYear = syear.string(from: twoDays)
        tempChangeThreeDaysMonth = smonth.string(from: twoDays)
        tempChangeThreeDaysDate = sdate.string(from: twoDays)
        
        defaults.set(tempChangeThreeDaysYear, forKey:"tempChangeThreeDaysYear3")
        defaults.set(tempChangeThreeDaysMonth, forKey:"tempChangeThreeDaysMonth3")
        defaults.set(tempChangeThreeDaysDate, forKey:"tempChangeThreeDaysDate3")
        
        // 라벨 텍스트
        threeDaysTempDispalay.text = String("\(tempChangeThreeDaysMonth).\(tempChangeThreeDaysDate) ~ \(tempBaseThreeDaysMonth).\(tempBaseThreeDaysDate)")
        
        // 기준 값 저장
        saveThreeDaysDate = dateFormatter.date(from: "\(tempBaseThreeDaysYear)- \(tempBaseThreeDaysMonth)-\(tempBaseThreeDaysDate)")!
        
        threeDaysTempChartViewGraph()
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
        
        tempThreeDateCount = 1
        nextButtonFlag = true
        
        toDay = Calendar.current.date(byAdding: .day, value: tempThreeDateCount, to: saveThreeDaysDate)!
        
        // 이전 버튼이 눌린 상태
        if lastButtonFlag == true {
            
            tempThreeDateCount = -1
            lastButtonFlag = false
            
            toDay = Calendar.current.date(byAdding: .day, value: tempThreeDateCount, to: saveThreeDaysDate)!
            
        }
        
        tempBaseThreeDaysYear = syear.string(from: toDay)
        tempBaseThreeDaysMonth = smonth.string(from: toDay)
        tempBaseThreeDaysDate = sdate.string(from: toDay)
        
        defaults.set(tempBaseThreeDaysYear, forKey:"tempChangeThreeDaysYear3")
        defaults.set(tempBaseThreeDaysMonth, forKey:"tempChangeThreeDaysMonth3")
        defaults.set(tempBaseThreeDaysDate, forKey:"tempChangeThreeDaysDate3")
        
        let oneDays = Calendar.current.date(byAdding: .day, value: tempThreeDateCount+1, to: saveThreeDaysDate)!
        
        tempChangeThreeDaysYear = syear.string(from: oneDays)
        tempChangeThreeDaysMonth = smonth.string(from: oneDays)
        tempChangeThreeDaysDate = sdate.string(from: oneDays)
        
        defaults.set(tempChangeThreeDaysYear, forKey:"tempChangeThreeDaysYear2")
        defaults.set(tempChangeThreeDaysMonth, forKey:"tempChangeThreeDaysMonth2")
        defaults.set(tempChangeThreeDaysDate, forKey:"tempChangeThreeDaysDate2")
        
        let twoDays = Calendar.current.date(byAdding: .day, value: tempThreeDateCount+2, to: saveThreeDaysDate)!
        
        tempChangeThreeDaysYear = syear.string(from: twoDays)
        tempChangeThreeDaysMonth = smonth.string(from: twoDays)
        tempChangeThreeDaysDate = sdate.string(from: twoDays)
        
        defaults.set(tempChangeThreeDaysYear, forKey:"tempChangeThreeDaysYear1")
        defaults.set(tempChangeThreeDaysMonth, forKey:"tempChangeThreeDaysMonth1")
        defaults.set(tempChangeThreeDaysDate, forKey:"tempChangeThreeDaysDate1")
                        
        // 라벨 텍스트
        threeDaysTempDispalay.text = String("\(tempBaseThreeDaysMonth).\(tempBaseThreeDaysDate) ~ \(tempChangeThreeDaysMonth).\(tempChangeThreeDaysDate)")
        
        // 기준 값 저장
        saveThreeDaysDate = dateFormatter.date(from: "\(tempBaseThreeDaysYear)- \(tempBaseThreeDaysMonth)-\(tempBaseThreeDaysDate)")!
        
        threeDaysTempChartViewGraph()
    }
    
    
    //     ------------------------7 Days 버튼들 시작 ----------------------
    @objc func lastThreeDaysSelectTempButton(sender: AnyObject){
        lastThreeDaysButton()
       
    }
    
    
    @objc func nextThreeDaysSelectTempButton(sender: AnyObject){
        nextThreeDaysButton()
//        threeDaysTempChartViewGraph()
        
    }
    //     ------------------------7 Days 버튼들 끝  ----------------------
}

