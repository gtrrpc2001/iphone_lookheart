//
//  graphVC.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/13.
//

import UIKit
import Foundation
import Charts

let arrChartView = LineChartView()
var arrDataEntries = [ChartDataEntry]()
var arrEcgData = [Double](repeating: 0.0, count: 500)
var arrDate = ""

var specificArrTime = ""

var changeRealYear:String = ""
var changeRealMonth:String = ""
var changeRealDate:String = ""

var arrTableTodayDate = Date()
var arrTableDateCount = 0

class arrVC : UIViewController, UITextFieldDelegate {
    
    private let safeAreaView = UIView()
    
    // Navigation title Label
    let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "LOOKHEART"
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy) // 크기, 굵음 정도 설정
        label.textColor = .black
        
        return label
    }()
    
    lazy var batteryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived(_:)), name: Notification.Name("Battery"), object: nil)
        
        return label
    }()

    @objc func dataReceived(_ notification: Notification){
        if let text = notification.object as? String {
            batteryLabel.text = text
            let progressString = text.trimmingCharacters(in: ["%"])
            let progressFloat = Float(progressString)!
            let max = 100
            batProgress.setProgress(progressFloat/Float(max), animated: false)
        }
    }
    
    // Navigation battery prograss
    lazy var batProgress: UIProgressView = {
        let battery = UIProgressView()

        let intBattery = UserDefaults.standard.integer(forKey: "MyBattery")
        let max = 100
        
        let batteryLevel: Float = Float(intBattery) / Float(max)// 프로그래스 바 값 설정
        
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
        customView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        return customView
    }()
    
    let arrStatus: UILabel = {
        let label = UILabel()

        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold) // 크기, 굵음 정도 설정
        label.textColor = .black
        
        return label
    }()
    
    let arrStatusLabel: UILabel = {
        let label = UILabel()

        label.text = "종류 : "
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium) // 크기, 굵음 정도 설정
        label.textColor = .darkGray
        
        return label
    }()
    
    let bodyStatus: UILabel = {
        let label = UILabel()

        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold) // 크기, 굵음 정도 설정
        label.textColor = .black
        
        return label
    }()
    
    let bodyStatusLabel: UILabel = {
        let label = UILabel()

        label.text = "상태 : "
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium) // 크기, 굵음 정도 설정
        label.textColor = .darkGray
        
        return label
    }()
    
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
    }
    
    var fCurTextfieldBottom: CGFloat = 0.0
    let scrollView = UIScrollView()
    let verticalStackView = UIStackView()
    let defaults = UserDefaults.standard
    let rowStack = UIStackView()
    
    lazy var arrChartView: LineChartView =  {
        let arrChartView = LineChartView()
        return arrChartView
    }()
    
    
    
    lazy var arrDateDispalay = UILabel().then {
        $0.text = "\(changeRealYear)-\(changeRealMonth)-\(changeRealDate)"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
    }

    lazy var yesterdayButton = UIButton().then {
        $0.setImage(leftArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(yesterdayButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var tomorrowButton = UIButton().then {
        $0.setImage(rightArrow, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(tomorrowButton(sender:)), for: .touchUpInside)
    }
    
    
    lazy var yearTextField = UITextField().then {
        $0.text = "\(realYear)\(realMonth)\(realDate)"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.borderStyle = .roundedRect
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 10
        $0.textAlignment = .center
   
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
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
    // MARK: - views
    func views(){

        
        view.addSubview(arrChartView)
        arrChartView.snp.makeConstraints {(make) in
            make.top.equalTo(self.safeAreaView.snp.top).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(250)
        }
        
//        view.addSubview(arrStatus)
//        arrStatus.snp.makeConstraints {(make) in
//            make.top.equalTo(self.safeAreaView.snp.bottom).offset(10)
//            make.trailing.equalTo(self.safeAreaView.snp.trailing).offset(20)
//            make.height.equalTo(20)
//        }
        
//        view.addSubview(arrStatusLabel)
//        arrStatusLabel.snp.makeConstraints {(make) in
//            make.top.equalTo(self.arrStatus.snp.top).offset(0)
//            make.trailing.equalTo(self.arrStatus.snp.leading).offset(10)
//        }
        
        view.addSubview(yesterdayButton)
        yesterdayButton.snp.makeConstraints {(make) in
            make.top.equalTo(arrChartView.snp.bottom).offset(40)
            make.leading.equalTo(self.safeAreaView.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(arrDateDispalay)
        arrDateDispalay.snp.makeConstraints {(make) in
            make.top.equalTo(arrChartView.snp.bottom).offset(40)
            make.leading.equalTo(yesterdayButton.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tomorrowButton)
        tomorrowButton.snp.makeConstraints {(make) in
            make.top.equalTo(arrChartView.snp.bottom).offset(40)
            make.leading.equalTo(arrDateDispalay.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaView.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
       
   
        scrollView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        verticalStackView.axis = .vertical
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        // add Scrollview to view
        self.view.addSubview(scrollView)
        
        // add stack view to scrollView
        scrollView.addSubview(verticalStackView)
        
        let safeG = view.safeAreaLayoutGuide
        
        // MARK: - AlertConstraint
        view.addSubview(alertBackground)
        view.addSubview(alertLabel)
        view.addSubview(arrStatus)
        view.addSubview(arrStatusLabel)
        view.addSubview(bodyStatus)
        view.addSubview(bodyStatusLabel)
        
        alertBackground.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        arrStatus.translatesAutoresizingMaskIntoConstraints = false
        arrStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyStatus.translatesAutoresizingMaskIntoConstraints = false
        bodyStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            // constrain scrollView
            //  50-pts from bottom of label
            //  Leading and Trailing to safe-area with 8-pts "padding"
            //  Bottom to safe-area with 8-pts "padding"
            scrollView.topAnchor.constraint(equalTo: arrDateDispalay.bottomAnchor, constant: 10.0),
            scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 8.0),
            scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -8.0),
            scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -8.0),
            
            // constrain vertical stack view to scrollView Content Layout Guide
            //  8-pts all around (so we have a little "padding")
            verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8.0),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8.0),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8.0),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8.0),
            
            alertBackground.leadingAnchor.constraint(equalTo: arrChartView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            alertBackground.centerXAnchor.constraint(equalTo: arrChartView.centerXAnchor),
            alertBackground.centerYAnchor.constraint(equalTo: arrChartView.centerYAnchor),
            
            alertBackground.heightAnchor.constraint(equalToConstant: 120),
            
            
            alertLabel.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
            
            arrStatus.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            arrStatus.topAnchor.constraint(equalTo: arrChartView.bottomAnchor, constant: 10),
            
            arrStatusLabel.trailingAnchor.constraint(equalTo: arrStatus.leadingAnchor, constant: -10),
            arrStatusLabel.topAnchor.constraint(equalTo: arrStatus.topAnchor),
            
            bodyStatus.trailingAnchor.constraint(equalTo: arrStatusLabel.leadingAnchor, constant: -10),
            bodyStatus.topAnchor.constraint(equalTo: arrStatusLabel.topAnchor),
            
            bodyStatusLabel.trailingAnchor.constraint(equalTo: bodyStatus.leadingAnchor, constant: -10),
            bodyStatusLabel.topAnchor.constraint(equalTo: bodyStatus.topAnchor),
            
        ])
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
    
        // Navigationbar Title 왼쪽 정렬
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
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
        
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -arrTableDateCount, to: arrTableTodayDate)!
        
        arrTableTodayDate = yesterday
        
        let syear = DateFormatter()
        let smonth = DateFormatter()
        let sdate = DateFormatter()
        
        syear.dateFormat = "yyyy"
        smonth.dateFormat = "MM"
        sdate.dateFormat = "dd"
        
        
        changeRealYear = syear.string(from: arrTableTodayDate)
        changeRealMonth = smonth.string(from: arrTableTodayDate)
        changeRealDate = sdate.string(from: arrTableTodayDate)
        
        arrStatus.isHidden = true
        arrStatusLabel.isHidden = true
        bodyStatus.isHidden = true
        bodyStatusLabel.isHidden = true
    
        setupView()
        views()
        arrTable()
        
        
        yearTextField.delegate = self
        yearTextField.returnKeyType = .done
        
        arrTableDateCount = 0
     
    }
    
 
    @objc func arrChartViewGraph(_ sender: UIButton!){
        
//        alertLabel.isHidden = true
//        alertBackground.isHidden = true
        
        bodyStatus.isHidden = false
        bodyStatusLabel.isHidden = false
        arrStatus.isHidden = false
        arrStatusLabel.isHidden = false
//        
        let  numbers = sender.title(for: .normal)
        let arrCntNumbers = Int(numbers!)

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL1 = documentsURL.appendingPathComponent("\(changeRealYear)/\(changeRealMonth)/\(changeRealDate)")
        let directoryURL = directoryURL1.appendingPathComponent("arrEcgData_\(changeRealYear)\(changeRealMonth)\(changeRealDate)")
        
        let fileURL = directoryURL.appendingPathComponent("/arrEcgData_\(arrCntNumbers ?? 0).csv")

        do {
            let data = try Data(contentsOf: fileURL)
            let arrEcgDataString = String(data: data, encoding: .utf8)
            
            let arrEcgData1 = arrEcgDataString?.components(separatedBy: ",") /// String 으로 정리
            
            // 상태값 설정
            setStatus(arrEcgData1?[2] ?? "null", arrEcgData1?[3] ?? "null")
            
            let arrEcgData2 = arrEcgData1!.compactMap { (value) -> Double? in
                return Double(value)   //// Double로 정리
            }

            specificArrTime = arrEcgData1?[0] ?? "0"
            arrEcgData = arrEcgData2 //Double Array
            
        } catch  let e  {
            print(e.localizedDescription)
        }
        
        
        arrDataEntries = [ChartDataEntry]()
        
        for i in 4 ..< 500 {
            let arrDataEntry = ChartDataEntry(x: Double(i), y: arrEcgData[i])
            arrDataEntries.append(arrDataEntry)
        }
        
       
//        let arrChartDataSet = LineChartDataSet(entries: arrDataEntries, label: "arr_Graph")
        let arrChartDataSet = LineChartDataSet(entries: arrDataEntries, label: "Peak")
        arrChartDataSet.drawCirclesEnabled = false
        arrChartDataSet.setColor(NSUIColor.blue)
        arrChartDataSet.mode = .linear
        arrChartDataSet.drawValuesEnabled = false
      
        
        // 2
        let arrChartData = LineChartData(dataSet: arrChartDataSet)
        arrChartView.data = arrChartData
        arrChartView.xAxis.enabled = false
        arrChartView.noDataText = ""
        
        arrChartView.leftAxis.axisMaximum = 1024
        arrChartView.leftAxis.axisMinimum = 0
        arrChartView.rightAxis.enabled = false
        arrChartView.drawMarkers = false
        arrChartView.dragEnabled = false
        arrChartView.pinchZoomEnabled = false
        arrChartView.doubleTapToZoomEnabled = false
        arrChartView.highlightPerTapEnabled = false
        arrChartView.chartDescription?.enabled = true
        arrChartView.chartDescription?.font = .systemFont(ofSize: 20)
        
        arrChartView.data?.notifyDataChanged()
        arrChartView.notifyDataSetChanged()
        arrChartView.moveViewToX(0)

        specificArrTime = ""
        arrEcgData = []
        
    }

    
    func yesterdayArrButton(){
          
        arrTableDateCount = arrTableDateCount - 1
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: arrTableTodayDate)!
          
        arrTableTodayDate = yesterday
          
          let tyear = DateFormatter()
          let tmonth = DateFormatter()
          let tdate = DateFormatter()


          tyear.dateFormat = "yyyy"
          tmonth.dateFormat = "MM"
          tdate.dateFormat = "dd"

          
          changeRealYear = tyear.string(from: arrTableTodayDate)
          changeRealMonth = tmonth.string(from: arrTableTodayDate)
          changeRealDate = tdate.string(from: arrTableTodayDate)

         
        arrDateDispalay.text = String("\(changeRealYear)-\(changeRealMonth)-\(changeRealDate)")
          
      }
      
      
  func tomorrowArrButton(){
      
      arrTableDateCount = arrTableDateCount + 1
          
          let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: arrTableTodayDate)!
           arrTableTodayDate = tomorrow

          
          let tyear = DateFormatter()
          let tmonth = DateFormatter()
          let tdate = DateFormatter()
        

          tyear.dateFormat = "yyyy"
          tmonth.dateFormat = "MM"
          tdate.dateFormat = "dd"


          changeRealYear = tyear.string(from: arrTableTodayDate)
          changeRealMonth = tmonth.string(from: arrTableTodayDate)
          changeRealDate = tdate.string(from: arrTableTodayDate)

          arrDateDispalay.text = String("\(changeRealYear)-\(changeRealMonth)-\(changeRealDate)")
      }
      
      @objc func yesterdayButton(sender: AnyObject){
          yesterdayArrButton()
          arrChartView.clear()
          arrTable()
      }
      
      
      @objc func tomorrowButton(sender: AnyObject){
          tomorrowArrButton()
          arrChartView.clear()
          arrTable()
         
      }
      
    
     func resetScrollView() {
        for  subview in self.verticalStackView.subviews
               {
                    subview.removeFromSuperview()
               }
        }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fCurTextfieldBottom = textField.frame.origin.y + textField.frame.height
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if fCurTextfieldBottom <= self.view.frame.height - keyboardSize.height {
                return
            }
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func endEditing() {
        yearTextField.resignFirstResponder()
     
    }
    
    //---------------------숫자만 넣기----------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let withDecimal = (
            string == NumberFormatter().decimalSeparator &&
            textField.text?.contains(string) == false
        )
        return isNumber || withDecimal
    }
    
    
    func arrTable(){
        
        resetScrollView()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        let directoryURL1 = documentsURL.appendingPathComponent("\(changeRealYear)/\(changeRealMonth)/\(changeRealDate)")
        
        
        let directoryURL = directoryURL1.appendingPathComponent("arrEcgData_\(changeRealYear)\(changeRealMonth)\(changeRealDate)")
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        

        
        let filePath = directoryURL.path
        
        let dirContents = try? fileManager.contentsOfDirectory(atPath: filePath)
        let count = dirContents?.count

        
        if (count == 0) {
            //tableView is empty. You can set a backgroundView for it.
            
            let rowStack = UIStackView()
            // add it to the vertical stack view
            verticalStackView.addArrangedSubview(rowStack)
        
            lazy var arrLabelView = UILabel().then {
//                $0.text = " No ARR Data on \(changeRealYear)/\(changeRealMonth)/\(changeRealDate)"
                $0.text = "비정상맥박 데이터가 없습니다."
                $0.textColor = .black
                //  $0.isEditable = false
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 18)
                
                $0.layer.borderWidth = 3
                $0.layer.cornerRadius = 10
                $0.layer.borderColor = UIColor.blue.cgColor
                
            }
            
            rowStack.addArrangedSubview(arrLabelView)
            NSLayoutConstraint.activate([
                //                arrLabelView.widthAnchor.constraint(equalToConstant: 300.0),
                arrLabelView.heightAnchor.constraint(equalToConstant: 50.0),
                arrLabelView.trailingAnchor.constraint(equalTo: self.safeAreaView.trailingAnchor)
                
            ])
   
        } else {
            
            // now let's create the buttons and add them
            var idx = 1
            
            for i in 1...count! {
                // create a "row" stack view
                let rowStack = UIStackView()
                // add it to the vertical stack view
                verticalStackView.addArrangedSubview(rowStack)
                
                
                let fileURL = directoryURL.appendingPathComponent("/arrEcgData_\(i).csv")

                do {
                    let data = try Data(contentsOf: fileURL)
                    let arrEcgDataString = String(data: data, encoding: .utf8)
                    
                    let arrEcgData1 = arrEcgDataString?.components(separatedBy: ",") /// String 으로 정리
      
                    specificArrTime = arrEcgData1?[0] ?? "0"
                } catch  let e  {
                    print(e.localizedDescription)
                }
 
                
                let arrButton = UIButton()
                arrButton.backgroundColor = .black
                arrButton.setTitle("\(idx)", for: .normal)
                arrButton.addTarget(self, action: #selector(arrChartViewGraph(_:)), for: .touchUpInside)
                
                lazy var arrLabelView = UILabel().then {
                    $0.text = "\(changeRealYear)-\(changeRealMonth)-\(changeRealDate) \(specificArrTime)"
                    $0.textColor = .black
                    //  $0.isEditable = false
                    $0.textAlignment = .center
                    $0.font = UIFont.systemFont(ofSize: 20)
                    $0.layer.borderWidth = 3
                    $0.layer.cornerRadius = 10
                    $0.layer.borderColor = UIColor.blue.cgColor
                }
                

                // add button to row stack view
                rowStack.addArrangedSubview(arrButton)
                rowStack.addArrangedSubview(arrLabelView)
                // buttons should be 50x50
                NSLayoutConstraint.activate([
                    
                    
                    arrButton.widthAnchor.constraint(equalToConstant: 50.0),
                    arrButton.heightAnchor.constraint(equalToConstant: 50.0),
                    
                    //                arrLabelView.widthAnchor.constraint(equalToConstant: 300.0),
                    arrLabelView.heightAnchor.constraint(equalToConstant: 50.0),
                    arrLabelView.trailingAnchor.constraint(equalTo: self.safeAreaView.trailingAnchor)
                ])
                
                idx += 1
            }
            
            verticalStackView.spacing = 8.0
            verticalStackView.arrangedSubviews.forEach { v in
                if let stack = v as? UIStackView {
                    stack.spacing = 20.0
                }
            }
        }
    }
    
    func setStatus(_ myBodyStatus:String, _ myArrStatus:String){
        
        switch (myBodyStatus){
        case "R":
            bodyStatus.text = "휴식"
        case "E":
            bodyStatus.text = "활동"
        case "S":
            bodyStatus.text = "수면"
        default:
            bodyStatus.text = "휴식"
        }

        switch (myArrStatus){
        case "arr":
            arrStatus.text = "비정상 맥박"
        case "fast":
            arrStatus.text = "빠른 맥박"
        case "slow":
            arrStatus.text = "느린 맥박"
        case "irregular":
            arrStatus.text = "비정상 맥박"
        default:
            arrStatus.text = "비정상 맥박"
        }
    }
}
