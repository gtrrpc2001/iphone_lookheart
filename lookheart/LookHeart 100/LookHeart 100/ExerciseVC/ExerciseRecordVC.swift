//import Foundation
//import Charts
//import UIKit
//
//class ExerciseRecordVC: BaseViewController {
//    
//    let scrollView = UIScrollView()
//    let verticalStackView = UIStackView()
//    var buttons: [UIButton] = []
//    
//    let minusImage =  UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
//    
//    let arrowImage =  UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
//    
//    lazy var chartView: LineChartView =  {
//        let chartView = LineChartView()
//        return chartView
//        
//    }()
//    
//    let topLine: UIView = {
//        let view = UILabel()
//        
//        view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
//        view.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
//        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 10
//        
//        return view
//    }()
//    
//    let bottomLine: UIView = {
//        let view = UILabel()
//        
//        view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
//        view.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
//        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 10
//        
//        return view
//    }()
//    
//    let bottomBackground: UIView = {
//        let view = UILabel()
//        
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        view.clipsToBounds = true
//        
//        return view
//    }()
//    
//    
//    let line: UIView = {
//        let view = UILabel()
//        
//        view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
//        view.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
//        view.layer.borderWidth = 1
//        
//        return view
//    }()
//    
//    let alertBox: UIView = {
//        let view = UILabel()
//        
//        view.backgroundColor = .white
//        view.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
//        view.layer.borderWidth = 2
//        view.layer.cornerRadius = 15
//        
//        return view
//    }()
//    
//    let alertString: UILabel = {
//        let label = UILabel()
//
//        label.text = "운동을 기록하고 심박수를 확인해보세요!!"
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let noDataAlertString: UILabel = {
//        let label = UILabel()
//
//        label.text = "데이터가 없습니다"
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    lazy var fileNotFoundt = UILabel().then {
//        $0.text = "기록된 운동이 없습니다"
//        $0.font = UIFont.systemFont(ofSize: 14)
//        $0.textColor = .darkGray
//        $0.textAlignment = .center
//        $0.layer.borderWidth = 2
//        $0.layer.cornerRadius = 10
//        $0.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
//        $0.backgroundColor = .white
//    }
//    
//    
//    let exerciseName: UILabel = {
//        let label = UILabel()
//
//        label.text = "운동 : "
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let exerciseTime: UILabel = {
//        let label = UILabel()
//
//        label.text = "운동 시간 : 00:00"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let bottomExerciseName: UILabel = {
//        let label = UILabel()
//
//        label.text = "운동"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textColor = .darkGray
//        label.textAlignment = .center
//        
//        return label
//    }()
//    
//    let bottomExerciseDate: UILabel = {
//        let label = UILabel()
//
//        label.text = "운동 날짜"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textColor = .darkGray
//        label.textAlignment = .center
//        
//        return label
//    }()
//    
//    let bottomExerciseTime: UILabel = {
//        let label = UILabel()
//
//        label.text = "운동 시간"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textColor = .darkGray
//        label.textAlignment = .center
//        
//        return label
//    }()
//    
//    let deleteLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "삭제"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textColor = .darkGray
//        label.textAlignment = .center
//        
//        return label
//    }()
//    
//    let bpmBackground: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
////        label.layer.borderWidth = 3
////        label.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
////        label.layer.cornerRadius = 20
//        return label
//    }()
//    
//    let averageBpmBackground: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    
//    let myAverageBpmLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "평균 심박수"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//
//    let workAverageBpmValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "0"
//        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let bpmValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "bpm"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
//        label.textColor = .lightGray
//        
//        return label
//    }()
//    
//    let maxBpmLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "최대"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//
//    let maxBpmValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "0"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let maxValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "bpm"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
//        label.textColor = .lightGray
//        
//        return label
//    }()
//    
//    let minBpmLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "최소"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//
//    let minBpmValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "0"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let minValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "bpm"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
//        label.textColor = .lightGray
//        
//        return label
//    }()
//    
//    
//    let stepLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "걸음"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//
//    let workStepValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "0"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let stepValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "step"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
//        label.textColor = .lightGray
//        
//        return label
//    }()
//    
//    
//    let distanceLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "거리"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//
//    let workdistanceValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "0"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let distanceValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "km"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
//        label.textColor = .lightGray
//        
//        return label
//    }()
//    
//    
//    let stepAndDistanceBackground: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
////        label.layer.borderWidth = 3
////        label.layer.borderColor = UIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0).cgColor
////        label.layer.cornerRadius = 20
//        return label
//    }()
//    
//    let myACalLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "활동 칼로리"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//
//    let workeCalValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "0"
//        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy) // 크기, 굵음 정도 설정
//        label.textColor = .darkGray
//        
//        return label
//    }()
//    
//    let calValue: UILabel = {
//        let label = UILabel()
//
//        label.text = "cal"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
//        label.textColor = .lightGray
//        
//        return label
//    }()
//    
//    
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [bpmBackground, stepAndDistanceBackground])
//        
//        stackView.spacing = 0
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.alignment = .fill
//        
//        return stackView
//    }()
//    
//    lazy var bpmStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [])
//
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//
//        return stackView
//    }()
//    
//    lazy var minMaxBpmstackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [maxBpmLabel, minBpmLabel])
//
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.alignment = .leading
//        
//        return stackView
//    }()
//    
//    lazy var calStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [])
//
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.alignment = .center
//
//        return stackView
//    }()
//
//    lazy var stepStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [stepLabel, distanceLabel])
//
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.alignment = .leading
//
//        return stackView
//    }()
//    
//    lazy var bottomStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [bottomExerciseName, bottomExerciseDate, bottomExerciseTime, deleteLabel])
//
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.distribution = .fillEqually // default
//
//        return stackView
//    }()
//    
//    
//    // MARK: - viewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        // navi, view, constraints 설정
//        setNavigation()
//        setup()
//        Constraints()
//        exerciseTable()
//    }
//    
//    func exerciseTable() {
//        
//        chartView.noDataText = ""
//        noDataAlertString.isHidden = true
//        fileNotFoundt.isHidden = true
//        
//        let fileManager = FileManager.default
//        
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryURL = documentsURL.appendingPathComponent("exerciseData")
//        
//        let fileURL = directoryURL.appendingPathComponent("/myExerciseData.csv")
//        
//        let filePath = fileURL.path
//        
//        if fileManager.fileExists(atPath: filePath){
//            do {
//                let data = try Data(contentsOf: fileURL)
//                
//                if let csvString = String(data: data, encoding: .utf8) {
//                    let rows = csvString.components(separatedBy: "\n")
//                    
//                    for i in 0..<rows.count - 1{
//                        let columns = rows[i].components(separatedBy: ",")
//                        // 운동 이름[0], 시작 날짜[1], 시작 시간[2], 종료 시간[3], 평균 맥박[4], 걸음[5], 거리[6], 활동 칼로리[7], 총칼로리[8]
//                        
//                        let stratTime = columns[2].dropLast(3)
//                        let endTime = columns[3].dropLast(3)
//                        
//                        let exerciseButton = UIButton().then {
//                            $0.setTitleColor(.clear, for: .normal)
//                            $0.layer.borderWidth = 2
//                            $0.layer.cornerRadius = 10
//                            $0.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
//                            $0.setBackgroundColor(UIColor.white, for: .normal)
//                            $0.setBackgroundColor(UIColor.white, for: .normal)
//                            $0.setBackgroundImage(nil, for: .normal)
//                        }
//                        
//                        lazy var exerciseName = UILabel().then {
//                            $0.text = columns[0]
//                            $0.font = UIFont.systemFont(ofSize: 12)
//                            $0.textColor = .darkGray
//                            $0.textAlignment = .center
//                        }
//                        lazy var exerciseDate = UILabel().then {
//                            $0.text = columns[1]
//                            $0.font = UIFont.systemFont(ofSize: 12)
//                            $0.textColor = .darkGray
//                            $0.textAlignment = .center
//                        }
//                        lazy var exerciseTime = UILabel().then {
//                            $0.text = "\(stratTime) ~ \(endTime)"
//                            $0.font = UIFont.systemFont(ofSize: 12)
//                            $0.textColor = .darkGray
//                            $0.textAlignment = .center
//                        }
//                        let deleteButton = UIButton().then {
//                            $0.setTitleColor(.clear, for: .normal)
//                            $0.setImage(minusImage, for: .normal)
//                        }
//                        
//                        exerciseButton.setTitle(String(i), for: .normal)
//                        deleteButton.setTitle(String(i), for: .normal)
//                        
//                        exerciseButton.addTarget(self, action: #selector(exerciseChartViewGraph(_:)), for: .touchUpInside)
//                        
//                        deleteButton.addTarget(self, action: #selector(deleteData(_:)), for: .touchUpInside)
//                        
//                        buttons.append(exerciseButton)
//                        
//                        
//                        verticalStackView.addArrangedSubview(exerciseButton)
//                        exerciseButton.addSubview(exerciseName)
//                        exerciseButton.addSubview(exerciseDate)
//                        exerciseButton.addSubview(exerciseTime)
//                        exerciseButton.addSubview(deleteButton)
//                        
//                        exerciseName.translatesAutoresizingMaskIntoConstraints = false
//                        exerciseDate.translatesAutoresizingMaskIntoConstraints = false
//                        exerciseTime.translatesAutoresizingMaskIntoConstraints = false
//                        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//                        
//                        NSLayoutConstraint.activate([
//                            exerciseButton.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 20),
//                            exerciseButton.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
//                            exerciseButton.heightAnchor.constraint(equalToConstant: 40),
//                            
//                            exerciseDate.centerYAnchor.constraint(equalTo: exerciseButton.centerYAnchor),
//                            exerciseDate.centerXAnchor.constraint(equalTo: bottomExerciseDate.centerXAnchor),
//
//                            exerciseName.centerYAnchor.constraint(equalTo: exerciseButton.centerYAnchor),
//                            exerciseName.centerXAnchor.constraint(equalTo: bottomExerciseName.centerXAnchor),
//                            
//                            exerciseTime.centerYAnchor.constraint(equalTo: exerciseButton.centerYAnchor),
//                            exerciseTime.centerXAnchor.constraint(equalTo: bottomExerciseTime.centerXAnchor),
//                            
//                            deleteButton.centerYAnchor.constraint(equalTo: exerciseButton.centerYAnchor),
//                            deleteButton.centerXAnchor.constraint(equalTo: deleteLabel.centerXAnchor),
//                            deleteButton.widthAnchor.constraint(equalToConstant: 25),
//                        ])
//                    }
//                    verticalStackView.spacing = 8.0
//
//                    if buttons.count == 0 {
//                        // 저장된 데이터가 없는 경우
//                        fileNotFoundt.isHidden = false
//                    }
//                }
//            } catch {
//                print("Failed to read CSV file:", error.localizedDescription)
//            }
//        }
//        else
//        {
//            // csv 파일이 없는 경우
//            fileNotFoundt.isHidden = false
//        }
//    }
//    
//    @objc func deleteData(_ sender: UIButton!){
//        
//        var convertedTitle = ""
//        
//        let alert = UIAlertController(title: "알림", message: "운동 기록을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
//        let ok = UIAlertAction(title: "확인", style: .destructive, handler: { [self] Action in
//            
//            // 버튼 index
//            if let buttonTitle = sender.title(for: .normal) {
//                convertedTitle = String(buttonTitle)
//            }
//            
//            // 해당 index의 버튼과 csv row 삭제
//            for button in buttons {
//                if button.title(for: .normal)! == convertedTitle {
//                    deleteCsvRowData(Int(convertedTitle)!)
//                    button.removeFromSuperview()
//                }
//            }
//            
//            // INIT
//            chartView.clear()
//            noDataAlertString.isHidden = false
//            
//            exerciseName.text = "운동 : "
//            exerciseTime.text = "운동 시간 : 00:00"
//            workAverageBpmValue.text = "0"
//            workStepValue.text = "0"
//            workdistanceValue.text = "0"
//            workeCalValue.text = "0"
//            minBpmValue.text = "0"
//            maxBpmValue.text = "0"
//            
//            // 버튼 제거
//            for button in buttons {
//                button.removeFromSuperview()
//            }
//            
//            // 버튼이 없는 경우 알림
//            if buttons.count == 1 {
//                alertBox.isHidden = false
//                alertString.isHidden = false
//            }
//            
//            buttons = []
//            exerciseTable()
//        })
//        
//        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
//        alert.addAction(cancel)
//        alert.addAction(ok)
//        self.present(alert, animated: false)
//    }
//    
//    // delete csv row Data
//    func deleteCsvRowData(_ myRow: Int) {
//        
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryURL = documentsURL.appendingPathComponent("exerciseData")
//        
//        let fileURL = directoryURL.appendingPathComponent("/myExerciseData.csv")
//        
//        let filePath = fileURL.path
//        
//        do {
//            _ = try Data(contentsOf: fileURL)
//            
//            // CSV 파일을 문자열로 읽어옴
//            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
//            
//            // 각 행별로 데이터를 배열로 분할
//            var rows = csvString.components(separatedBy: "\n")
//            
//            // 삭제할 행 인덱스 유효성 검사
//            guard myRow >= 0 && myRow < rows.count else {
//                print("Invalid row index.")
//                return
//            }
//            
//            rows.remove(at: myRow)
//            
//            // 수정된 데이터를 문자열로 다시 조합
//            let modifiedCSVString = rows.joined(separator: "\n")
//                    
//            // 수정된 데이터를 CSV 파일로 저장
//            try modifiedCSVString.write(toFile: filePath, atomically: true, encoding: .utf8)
//                
//            print("Row deleted successfully.")
//        }catch {
//            print("Error deleting row: \(error)")
//        }
//    }
//    
//    @objc func exerciseChartViewGraph(_ sender: UIButton!){
//        
//        chartView.clear()
//        alertBox.isHidden = true
//        alertString.isHidden = true
//        noDataAlertString.isHidden = true
//        
//        // 터치 유무에 따라 버튼 색상 변경
//        for button in buttons {
//            if button == sender {
//                // 선택된 버튼 배경
//                button.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0)
//                
//            } else {
//                // 미선택된 버튼들의 배경
//                button.backgroundColor = .white
//            }
//        }
//        
//        // INIT
//        exerciseName.text = "운동 : "
//        exerciseTime.text = "운동 시간 : 00:00"
//        workAverageBpmValue.text = "0"
//        workStepValue.text = "0"
//        workdistanceValue.text = "0"
//        workeCalValue.text = "0"
//        minBpmValue.text = "0"
//        maxBpmValue.text = "0"
//        
//        let numbers = sender.title(for: .normal)
//        let rowNumber = Int(numbers!)
//        
//        var startTime = ""
//        var endTime = ""
//        
//        var exerciseYear = ""
//        var exerciseMonth = ""
//        var exerciseDate = ""
//        
//        var bpmArrayData: [Double] = []
//        var bpmTimeData: [String] = []
//        
//        var bpmCount = 0
//        var nilDataCheck:Bool = false
//        
//        var workoutName = ""
//        var workoutTime = ""
//        var avgBpm = ""
//        var step = ""
//        var distance = ""
//        var eCal = ""
//        var minBpm = ""
//        var maxBpm = ""
//        
//        
//        let fileManager = FileManager.default
//        
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryURL = documentsURL.appendingPathComponent("exerciseData")
//        
//        let fileURL = directoryURL.appendingPathComponent("/myExerciseData.csv")
//        
//        let filePath = fileURL.path
//        
//        // myExerciseData read
//        if fileManager.fileExists(atPath: filePath){
//            do {
//                let data = try Data(contentsOf: fileURL)
//                // 운동 이름[0], 시작 날짜[1], 시작 시간[2], 종료 시간[3], 평균 맥박[4], 걸음[5], 거리[6], 활동 칼로리[7], minBpm[8], maxBpm[9]
//                if let csvString = String(data: data, encoding: .utf8) {
//                    let rows = csvString.components(separatedBy: "\n")
//                    let columns = rows[rowNumber!].components(separatedBy: ",")
//                    
//                    workoutName = columns[0] // 운동 이름
//                    startTime = columns[2] //시작 시간
//                    endTime = columns[3] // 종료 시간
//                    avgBpm = columns[4] // 평균 맥박
//                    step = columns[5]   // 걸음
//                    distance = columns[6]   // 거리
//                    eCal = columns[7]   // 활동 칼로리
//                    minBpm = columns[8] // 최소 비피엠
//                    maxBpm = columns[9] // 최대 비피엠
//                    
//                    // 시간 차이 계산
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    // 타입 변환
//                    let exerciseStartTime = dateFormatter.date(from: startTime)
//                    let exerciseEndTime = dateFormatter.date(from: endTime)
//                    // 계산
//                    let components = calendar.dateComponents([.hour, .minute, .second], from: exerciseStartTime!, to: exerciseEndTime!)
//                    
//                    var hours = ""
//                    var minutes = ""
//                    
//                    // 시간, 분 데이터 저장
//                    if Int(components.hour ?? 0) < 10 {
//                        hours = "0\(components.hour ?? 0)"
//                    }
//                    else{
//                        hours = String(components.hour ?? 0)
//                    }
//                    if Int(components.minute ?? 0) < 10 {
//                        minutes = "0\(components.minute ?? 0)"
//                    }
//                    else{
//                        minutes = String(components.minute ?? 0)
//                    }
//                    
//                    workoutTime = "\(hours):\(minutes)"
//                    
//                    // bpm data file을 찾기 위한 시간값 저장
//                    let date = columns[1].components(separatedBy: "-")
//                    exerciseYear = date[0]
//                    exerciseMonth = date[1]
//                    exerciseDate = date[2]
//                }
//            }catch {
//                print("Failed to read CSV file:", error.localizedDescription)
//            }
//        }
//        
//        let bpmFileManager = FileManager.default
//        let bpmDocumentsURL = bpmFileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let bpmDirectoryURL = bpmDocumentsURL.appendingPathComponent("\(exerciseYear)/\(exerciseMonth)/\(exerciseDate)")
//        
//        let bpmFileURL = bpmDirectoryURL.appendingPathComponent("/BpmData.csv")
//        
//        let bpmFilePath = bpmFileURL.path
//        
//        if bpmFileManager.fileExists(atPath: bpmFilePath){
//            do {
//                let data = try String(contentsOf: bpmFileURL)
//                let bpmData = data.components(separatedBy: .newlines)
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "HH:mm:ss"
//                
//                bpmCount = bpmData.count
//                
//                for i in 0..<bpmCount - 1{
//                    
//                    let row = bpmData[i]
//                    let columns = row.components(separatedBy: ",")
//                    let bpmDataRow = Double(columns[2])
//                    
//                    // 시간 데이터
//                    let bpmTimeCheck = columns[0].components(separatedBy: ":")
//                    let MybpmTimeRow = bpmTimeCheck[0] + ":" + bpmTimeCheck[1]
//                    
//                    // 시간 비교를 위한 상수
//                    let bpmTime = dateFormatter.date(from: columns[0])
//                    let exerciseStartTime = dateFormatter.date(from: startTime)
//                    let exerciseEndTime = dateFormatter.date(from: endTime)
//
//                    
//                    if let startTime = exerciseStartTime, let exerciseBpmTime = bpmTime, let endTime = exerciseEndTime {
//                        
//                        if startTime <= exerciseBpmTime && endTime >= exerciseBpmTime {
//                            // 운동 시간 안의 시간 데이터와 bpm 데이터만 저장
//                            bpmTimeData.append(MybpmTimeRow)
//                            bpmArrayData.append(bpmDataRow ?? 0.0)
//                        }
//                    }
//                    else {
//                    }
//                }
//            }catch  {
//                // 파일이 존재하지 않는 경우
//                nilDataCheck = true
//                print("Error reading CSV file")
//            }
//            
//            
//            if nilDataCheck == true || bpmTimeData.count == 0{
//                //데이터가 없는 경우
//                noDataAlertString.isHidden = false
//                alertBox.isHidden = false
//            }
//            else {
//                // 데이터가 있는 경우
//                
//                exerciseName.text = "운동 : \(workoutName)"
//                exerciseTime.text = "운동 시간 : \(workoutTime)"
//                
//                workAverageBpmValue.text = avgBpm
//                workStepValue.text = step
//                workdistanceValue.text = distance
//                workeCalValue.text = eCal
//                minBpmValue.text = minBpm
//                maxBpmValue.text = maxBpm
//                
//                
//                var bpmDataEntries = [ChartDataEntry]()
//                
//                for i in 0..<bpmTimeData.count {
//                    let bpmDataEntry = ChartDataEntry(x: Double(i), y: bpmArrayData[i])
//                    bpmDataEntries.append(bpmDataEntry)
//                }
//                
//                let bpmChartDataSet = LineChartDataSet(entries: bpmDataEntries, label: "BPM")
//                bpmChartDataSet.drawCirclesEnabled = false
//                bpmChartDataSet.setColor(NSUIColor(red: 83/255, green: 136/255, blue: 247/255, alpha: 1.0))
//                bpmChartDataSet.mode = .linear
//                bpmChartDataSet.lineWidth = 1
//                bpmChartDataSet.drawValuesEnabled = false
//
//                let bpmChartData = LineChartData(dataSet: bpmChartDataSet)
//                chartView.data = bpmChartData
//                chartView.noDataText = ""
//                chartView.xAxis.enabled = true
//                chartView.legend.font = .systemFont(ofSize: 10, weight: .medium)
//                chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: bpmTimeData)
//                chartView.xAxis.axisMinimum = 0
//                chartView.setVisibleXRangeMaximum(Double(bpmTimeData.count))   // 처음 보여지는 x축 범위
//                chartView.xAxis.granularity = 1
//                chartView.xAxis.labelPosition = .bottom
//                chartView.xAxis.drawGridLinesEnabled = false
//
//                chartView.leftAxis.axisMaximum = 200
//                chartView.leftAxis.axisMinimum = 40
//                chartView.rightAxis.enabled = false
//                chartView.drawMarkers = false
//                chartView.dragEnabled = true
//                chartView.pinchZoomEnabled = false
//                chartView.doubleTapToZoomEnabled = false
//                chartView.highlightPerTapEnabled = false
//
//                chartView.data?.notifyDataChanged()
//                chartView.notifyDataSetChanged()
//                chartView.moveViewToX(0)
//                
//                for _ in 0..<20 {
//                    chartView.zoomOut()
//                }
//            }
//        }
//    }
//    
//    func setup(){
//        view.backgroundColor = .white
//        addViews()
//        setSafeAreaView()
//    }
//    
//    // MARK: - addViews
//    func addViews(){
//        view.addSubview(safeAreaView)
//        view.addSubview(chartView)
//        
//        view.addSubview(topLine)
//        view.addSubview(exerciseName)
//        view.addSubview(exerciseTime)
//        
//        
//        view.addSubview(stackView)
//        
//        view.addSubview(bpmStackView)
//        view.addSubview(myAverageBpmLabel)
//        view.addSubview(bpmValue)
//        view.addSubview(workAverageBpmValue)
//        
//        view.addSubview(minMaxBpmstackView)
//        view.addSubview(minValue)
//        view.addSubview(minBpmValue)
//        view.addSubview(maxValue)
//        view.addSubview(maxBpmValue)
//
//        view.addSubview(calStackView)
//        view.addSubview(myACalLabel)
//        view.addSubview(calValue)
//        view.addSubview(workeCalValue)
//        
//        view.addSubview(stepStackView)
//        view.addSubview(stepValue)
//        view.addSubview(workStepValue)
//        view.addSubview(distanceValue)
//        view.addSubview(workdistanceValue)
//        
//        view.addSubview(bottomLine)
//        view.addSubview(bottomBackground)
//        
//        view.addSubview(bottomStackView)
//        
//        view.addSubview(line)
//        
//        view.addSubview(alertBox)
//        view.addSubview(alertString)
//        view.addSubview(noDataAlertString)
//        
//        view.addSubview(scrollView)
//        scrollView.addSubview(verticalStackView)
//        verticalStackView.addArrangedSubview(fileNotFoundt)
//        
//        
//        verticalStackView.axis = .vertical
//        scrollView.backgroundColor = .clear
//        verticalStackView.backgroundColor = .clear
//        
//        
//    }
//    // MARK: - Constraints
//    func Constraints(){
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        topLine.translatesAutoresizingMaskIntoConstraints = false
//        exerciseName.translatesAutoresizingMaskIntoConstraints = false
//        exerciseTime.translatesAutoresizingMaskIntoConstraints = false
//        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        bpmStackView.translatesAutoresizingMaskIntoConstraints = false
//        myAverageBpmLabel.translatesAutoresizingMaskIntoConstraints = false
//        bpmValue.translatesAutoresizingMaskIntoConstraints = false
//        workAverageBpmValue.translatesAutoresizingMaskIntoConstraints = false
//        
//        minMaxBpmstackView.translatesAutoresizingMaskIntoConstraints = false
//        minValue.translatesAutoresizingMaskIntoConstraints = false
//        minBpmValue.translatesAutoresizingMaskIntoConstraints = false
//        
//        maxValue.translatesAutoresizingMaskIntoConstraints = false
//        maxBpmValue.translatesAutoresizingMaskIntoConstraints = false
//        
//        calStackView.translatesAutoresizingMaskIntoConstraints = false
//        myACalLabel.translatesAutoresizingMaskIntoConstraints = false
//        calValue.translatesAutoresizingMaskIntoConstraints = false
//        workeCalValue.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        stepStackView.translatesAutoresizingMaskIntoConstraints = false
//        workStepValue.translatesAutoresizingMaskIntoConstraints = false
//        stepValue.translatesAutoresizingMaskIntoConstraints = false
//        distanceValue.translatesAutoresizingMaskIntoConstraints = false
//        workdistanceValue.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        bottomLine.translatesAutoresizingMaskIntoConstraints = false
//        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
//        
//        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        line.translatesAutoresizingMaskIntoConstraints = false
//        
//        alertBox.translatesAutoresizingMaskIntoConstraints = false
//        alertString.translatesAutoresizingMaskIntoConstraints = false
//        noDataAlertString.translatesAutoresizingMaskIntoConstraints = false
//        fileNotFoundt.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            chartView.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 0),
//            chartView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
//            chartView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
//            chartView.heightAnchor.constraint(equalToConstant: 220),
//            
//            topLine.topAnchor.constraint(equalTo: chartView.bottomAnchor),
//            topLine.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 20),
//            topLine.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
//            topLine.heightAnchor.constraint(equalToConstant: 30),
//            
//            exerciseName.centerYAnchor.constraint(equalTo: topLine.centerYAnchor),
//            exerciseName.leadingAnchor.constraint(equalTo: topLine.leadingAnchor, constant: 40),
//            
//            exerciseTime.centerYAnchor.constraint(equalTo: topLine.centerYAnchor),
//            exerciseTime.leadingAnchor.constraint(equalTo: topLine.centerXAnchor, constant: 30),
//            
//            stackView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 0),
//            stackView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
//            stackView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: 0),
//
//            bpmStackView.topAnchor.constraint(equalTo: bpmBackground.topAnchor),
//            bpmStackView.leadingAnchor.constraint(equalTo: bpmBackground.leadingAnchor),
//            bpmStackView.trailingAnchor.constraint(equalTo: bpmBackground.centerXAnchor, constant: 10),
//            bpmStackView.bottomAnchor.constraint(equalTo: bpmBackground.bottomAnchor),
//
//            myAverageBpmLabel.centerYAnchor.constraint(equalTo: bpmStackView.centerYAnchor),
//            myAverageBpmLabel.leadingAnchor.constraint(equalTo: bpmStackView.leadingAnchor, constant: 20),
//            
//            bpmValue.centerYAnchor.constraint(equalTo: bpmStackView.centerYAnchor),
//            bpmValue.trailingAnchor.constraint(equalTo: bpmStackView.trailingAnchor, constant: -10),
//            
//            workAverageBpmValue.bottomAnchor.constraint(equalTo: bpmValue.bottomAnchor),
//            workAverageBpmValue.trailingAnchor.constraint(equalTo: bpmValue.leadingAnchor, constant: -5),
//            
//            minMaxBpmstackView.topAnchor.constraint(equalTo: bpmBackground.topAnchor),
//            minMaxBpmstackView.leadingAnchor.constraint(equalTo: bpmBackground.centerXAnchor, constant: 20),
//            minMaxBpmstackView.trailingAnchor.constraint(equalTo: bpmBackground.trailingAnchor),
//            minMaxBpmstackView.bottomAnchor.constraint(equalTo: bpmBackground.bottomAnchor),
//
//            minValue.trailingAnchor.constraint(equalTo: minMaxBpmstackView.trailingAnchor, constant: -20),
//            minValue.centerYAnchor.constraint(equalTo: minBpmLabel.centerYAnchor),
//            
//            minBpmValue.bottomAnchor.constraint(equalTo: minValue.bottomAnchor),
//            minBpmValue.trailingAnchor.constraint(equalTo: minValue.leadingAnchor, constant: -5),
//            
//            maxValue.trailingAnchor.constraint(equalTo: minMaxBpmstackView.trailingAnchor, constant: -20),
//            maxValue.centerYAnchor.constraint(equalTo: maxBpmLabel.centerYAnchor),
//            
//            maxBpmValue.bottomAnchor.constraint(equalTo: maxValue.bottomAnchor),
//            maxBpmValue.trailingAnchor.constraint(equalTo: maxValue.leadingAnchor, constant: -5),
//            
//            // cal
//            calStackView.topAnchor.constraint(equalTo: stepAndDistanceBackground.topAnchor),
//            calStackView.leadingAnchor.constraint(equalTo: stepAndDistanceBackground.leadingAnchor),
//            calStackView.trailingAnchor.constraint(equalTo: stepAndDistanceBackground.centerXAnchor, constant: 0),
//            calStackView.bottomAnchor.constraint(equalTo: stepAndDistanceBackground.bottomAnchor),
//            
//            myACalLabel.centerYAnchor.constraint(equalTo: calStackView.centerYAnchor),
//            myACalLabel.leadingAnchor.constraint(equalTo: calStackView.leadingAnchor, constant: 20),
//            
//            calValue.centerYAnchor.constraint(equalTo: calStackView.centerYAnchor),
//            calValue.trailingAnchor.constraint(equalTo: calStackView.trailingAnchor, constant: 0),
//            
//            workeCalValue.bottomAnchor.constraint(equalTo: calValue.bottomAnchor),
//            workeCalValue.trailingAnchor.constraint(equalTo: calValue.leadingAnchor, constant: -14),
//            
//            
//            // step
//            stepStackView.topAnchor.constraint(equalTo: stepAndDistanceBackground.topAnchor),
//            stepStackView.leadingAnchor.constraint(equalTo: stepAndDistanceBackground.centerXAnchor, constant: 20),
//            stepStackView.trailingAnchor.constraint(equalTo: stepAndDistanceBackground.trailingAnchor, constant: 0),
//            stepStackView.bottomAnchor.constraint(equalTo: stepAndDistanceBackground.bottomAnchor),
//            
//            stepValue.trailingAnchor.constraint(equalTo: stepStackView.trailingAnchor, constant: -20),
//            stepValue.centerYAnchor.constraint(equalTo: stepLabel.centerYAnchor),
//            
//            workStepValue.bottomAnchor.constraint(equalTo: stepValue.bottomAnchor),
//            workStepValue.trailingAnchor.constraint(equalTo: stepValue.leadingAnchor, constant: -5),
//            
//            distanceValue.trailingAnchor.constraint(equalTo: stepStackView.trailingAnchor, constant: -20),
//            distanceValue.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor),
//            
//            workdistanceValue.bottomAnchor.constraint(equalTo: distanceValue.bottomAnchor),
//            workdistanceValue.trailingAnchor.constraint(equalTo: distanceValue.leadingAnchor, constant: -13),
//
//            scrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 0),
//            scrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: 0),
//            scrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
//            scrollView.heightAnchor.constraint(equalToConstant: 190),
//            
//            verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
//            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
//            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
//            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            
//            
//            bottomLine.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -30),
//            bottomLine.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 10),
//            bottomLine.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -10),
//            bottomLine.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: 0),
//            
//            bottomBackground.topAnchor.constraint(equalTo: bottomLine.topAnchor, constant: 30),
//            bottomBackground.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: -5),
//            bottomBackground.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 5),
//            bottomBackground.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5),
//            
//            
//            bottomStackView.topAnchor.constraint(equalTo: bottomLine.topAnchor, constant: 0),
//            bottomStackView.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor, constant: 20),
//            bottomStackView.trailingAnchor.constraint(equalTo: bottomLine.trailingAnchor),
//            bottomStackView.heightAnchor.constraint(equalToConstant: 30),
//            
//            line.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
//            line.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 20),
//            line.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
//            line.heightAnchor.constraint(equalToConstant: 1),
//            
//            alertBox.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
//            alertBox.centerYAnchor.constraint(equalTo: chartView.centerYAnchor),
//            alertBox.heightAnchor.constraint(equalToConstant: 60),
//            alertBox.leadingAnchor.constraint(equalTo: alertString.leadingAnchor, constant: -20),
//            alertBox.trailingAnchor.constraint(equalTo: alertString.trailingAnchor, constant: 20),
//            
//            alertString.centerYAnchor.constraint(equalTo: alertBox.centerYAnchor),
//            alertString.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor),
//            
//            noDataAlertString.centerYAnchor.constraint(equalTo: alertBox.centerYAnchor),
//            noDataAlertString.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor),
//            
//            fileNotFoundt.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 20),
//            fileNotFoundt.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
//            fileNotFoundt.heightAnchor.constraint(equalToConstant: 40),
//        ])
//    }
//    
//    // MARK: -
//    // navigation 설정
//    func setNavigation() {
//        // keybord dismiss by touching anywhere in the view
//        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
//        view.addGestureRecognizer(tapGesture)
//        
//        self.navigationItem.title = "운동 기록"
//        
//        let backButton = UIBarButtonItem(image: arrowImage, style: .plain, target: self, action: #selector(backButtonTapped))
//        
//        // 네비게이션 바 왼쪽에 백버튼 설정
//        navigationItem.leftBarButtonItem = backButton
//            
//        //Programatically
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Bold", size: 25)!]
//    }
//    
//    @objc func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//}
