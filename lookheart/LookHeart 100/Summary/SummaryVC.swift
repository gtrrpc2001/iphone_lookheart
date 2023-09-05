import UIKit

class SummaryVC : UIViewController {
    
    private let safeAreaView = UIView()

    // MARK: - Navigation
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
    
    // MARK: - top Button
    lazy var bpmButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("심박", for: .normal)
       button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0)
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 15
        
        button.titleEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
       button.isEnabled = true
       button.isUserInteractionEnabled = true
        
       button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var bpmImage: UIImageView = {
        var imageView = UIImageView()
        // record.circle
        let image = UIImage(named: "myHeartbeat")?.withRenderingMode(.alwaysTemplate)
        
        imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.white
        
        return imageView
    }()
    
    lazy var arrButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("비정상맥박", for: .normal)
       button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 15
        
        button.titleEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
       button.isEnabled = true
       button.isUserInteractionEnabled = true
        
       button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var arrImage: UIImageView = {
        var imageView = UIImageView()
        
        let image = UIImage(named: "myArr")?.withRenderingMode(.alwaysTemplate)
        
        imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.lightGray
        
        return imageView
    }()
    
    lazy var calorieButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("칼로리", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 15
        
        button.titleEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
         
        button.isEnabled = true
        button.isUserInteractionEnabled = true
         
        button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
         
        return button
   }()
    lazy var calorieImage: UIImageView = {
        var imageView = UIImageView()
        // record.circle
        let image = UIImage(named: "myCalorie")?.withRenderingMode(.alwaysTemplate)
        
        imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.lightGray
        
        return imageView
    }()
    
    
    lazy var stepButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("걸음", for: .normal)
       button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 15
        
        button.titleEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
       button.isEnabled = true
       button.isUserInteractionEnabled = true
        
       button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    lazy var stepImage: UIImageView = {
        var imageView = UIImageView()
        
        let image = UIImage(named: "myStep")?.withRenderingMode(.alwaysTemplate)
        
        imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.lightGray
        
        return imageView
    }()
    
    lazy var temperatureButton: UIButton = {
       let button = UIButton()
       
       button.setTitle("맥박변동률", for: .normal)
       button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.titleLabel?.contentMode = .center
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 15
        
        button.titleEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
       button.isEnabled = true
       button.isUserInteractionEnabled = true
        
       button.addTarget(self, action: #selector(ButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    lazy var temperatureImage: UIImageView = {
        var imageView = UIImageView()
        
        let image = UIImage(named: "myTemperature")?.withRenderingMode(.alwaysTemplate)
        
        imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.lightGray
        
        return imageView
    }()
    
    @objc func ButtonEvent(_ sender: UIButton) {
        let buttons = [bpmButton, arrButton, calorieButton, stepButton, temperatureButton]
        
        for button in buttons {
            if button == sender {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(red: 45/255, green: 63/255, blue: 100/255, alpha: 1.0)
                button.layer.borderWidth = 0
            } else {
                button.setTitleColor(.lightGray, for: .normal)
                button.backgroundColor = .white
                button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
                button.layer.borderWidth = 3
            }
        }
        
        if sender.tag == 1 { // bpm
            bpmImage.tintColor = UIColor.white
            arrImage.tintColor = UIColor.lightGray
            calorieImage.tintColor = UIColor.lightGray
            stepImage.tintColor = UIColor.lightGray
            temperatureImage.tintColor = UIColor.lightGray
            
            addChild(bpmView, in: self.view)
            removeChild(arrView)
            removeChild(calView)
            removeChild(stepView)
            removeChild(temperatureView)
        }
        else if sender.tag == 2 { // arr
            bpmImage.tintColor = UIColor.lightGray
            arrImage.tintColor = UIColor.white
            calorieImage.tintColor = UIColor.lightGray
            stepImage.tintColor = UIColor.lightGray
            temperatureImage.tintColor = UIColor.lightGray
            
            addChild(arrView, in: self.view)
            removeChild(bpmView)
            removeChild(calView)
            removeChild(stepView)
            removeChild(temperatureView)
        }
        else if sender.tag == 3 { // cal
            bpmImage.tintColor = UIColor.lightGray
            arrImage.tintColor = UIColor.lightGray
            calorieImage.tintColor = UIColor.white
            stepImage.tintColor = UIColor.lightGray
            temperatureImage.tintColor = UIColor.lightGray
            
            addChild(calView, in: self.view)
            removeChild(bpmView)
            removeChild(arrView)
            removeChild(stepView)
            removeChild(temperatureView)
        }
        else if sender.tag == 4 { // step
            bpmImage.tintColor = UIColor.lightGray
            arrImage.tintColor = UIColor.lightGray
            calorieImage.tintColor = UIColor.lightGray
            stepImage.tintColor = UIColor.white
            temperatureImage.tintColor = UIColor.lightGray
            
            addChild(stepView, in: self.view)
            removeChild(bpmView)
            removeChild(arrView)
            removeChild(calView)
            removeChild(temperatureView)
        }
        else if sender.tag == 5 { // temperature
            bpmImage.tintColor = UIColor.lightGray
            arrImage.tintColor = UIColor.lightGray
            calorieImage.tintColor = UIColor.lightGray
            stepImage.tintColor = UIColor.lightGray
            temperatureImage.tintColor = UIColor.white
            
            addChild(temperatureView, in: self.view)
            removeChild(bpmView)
            removeChild(arrView)
            removeChild(calView)
            removeChild(stepView)
        }
    }
        
    // MARK: - SummaryView
    var bpmView = bpmGraphVC()
    let arrView = arrGraphVC()
    let calView = calorieGraphVC()
    let stepView = stepAndDistanceGraphVC()
    let temperatureView = temperatureGraphVC()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // navi, view, constraints 설정
        setNavigation()
        setup()
        Constraints()
        
    }
    
    // 자식 뷰 컨트롤러 추가
    func addChild(_ child: UIViewController, in containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: calorieButton.bottomAnchor),
            child.view.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
        ])
        
        child.didMove(toParent: self)
    }

    // 자식 뷰 컨트롤러 제거
    func removeChild(_ child: UIViewController) {
//        print("제거 : \(child)")
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    func setup(){
        view.backgroundColor = .white
        addViews()
        setSafeAreaView()
    }
    
    func test(){
        removeChild(bpmView)
    }
    
    // MARK: - addViews
    func addViews(){
        let childViewCheck = defaults.integer(forKey: "ChildView")
        
        view.addSubview(safeAreaView)
        
        // battery progress를 navigationbar에 추가
        customView.addSubview(batProgress)
        customView.addSubview(batteryLabel)
        let barItem = UIBarButtonItem(customView: customView)
        navigationItem.rightBarButtonItem = barItem
        
        // button set
        // bpm
        bpmButton.tag = 1
        view.addSubview(bpmButton)
        view.addSubview(bpmImage)
        
        // arr
        arrButton.tag = 2
        view.addSubview(arrButton)
        view.addSubview(arrImage)
        
        // cal
        calorieButton.tag = 3
        view.addSubview(calorieButton)
        view.addSubview(calorieImage)
        
        // step
        stepButton.tag = 4
        view.addSubview(stepButton)
        view.addSubview(stepImage)
        
        // temperature
        temperatureButton.tag = 5
        view.addSubview(temperatureButton)
        view.addSubview(temperatureImage)
        
        if childViewCheck == 1 {
            addChild(calView)
            view.addSubview(calView.view)
            calView.didMove(toParent: self)
            ButtonEvent(calorieButton)
            calView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                calView.view.topAnchor.constraint(equalTo: calorieButton.bottomAnchor),
                calView.view.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
                calView.view.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
                calView.view.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            ])
        }
        else if childViewCheck == 2 {
            addChild(stepView)
            view.addSubview(stepView.view)
            stepView.didMove(toParent: self)
            ButtonEvent(stepButton)
            stepView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stepView.view.topAnchor.constraint(equalTo: calorieButton.bottomAnchor),
                stepView.view.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
                stepView.view.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
                stepView.view.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            ])
        }
        else if childViewCheck == 3 {
            addChild(temperatureView)
            view.addSubview(temperatureView.view)
            temperatureView.didMove(toParent: self)
            ButtonEvent(temperatureButton)
            stepView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                temperatureView.view.topAnchor.constraint(equalTo: calorieButton.bottomAnchor),
                temperatureView.view.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
                temperatureView.view.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
                temperatureView.view.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            ])
        }
        else if childViewCheck == 4 {
            addChild(stepView)
            view.addSubview(stepView.view)
            stepView.didMove(toParent: self)
            ButtonEvent(stepButton)
            stepView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stepView.view.topAnchor.constraint(equalTo: calorieButton.bottomAnchor),
                stepView.view.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
                stepView.view.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
                stepView.view.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            ])
        }
        else {
            addChild(bpmView)
            view.addSubview(bpmView.view)
            bpmView.didMove(toParent: self)
            ButtonEvent(bpmButton)
            bpmView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bpmView.view.topAnchor.constraint(equalTo: calorieButton.bottomAnchor),
                bpmView.view.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
                bpmView.view.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
                bpmView.view.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            ])
        }
        
        defaults.set(0, forKey: "ChildView")
        defaults.set(false, forKey: "SummaryButtonCheck")
    }
    // 현재 뷰를 벗어남
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // 현재 뷰로 이동함
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let check = defaults.bool(forKey: "SummaryButtonCheck")
        // 홈 뷰에서 버튼이 클릭된 상태에서만 다시 뷰 로드
        if check == true {
            viewDidLoad()
        }
    }
    
    // MARK: - Constraints
    func Constraints(){
        let buttonWidth = (self.view.frame.size.width - 60) / 5
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // button set
        // bpm
        bpmButton.translatesAutoresizingMaskIntoConstraints = false
        bpmImage.translatesAutoresizingMaskIntoConstraints = false
        
        // arr
        arrButton.translatesAutoresizingMaskIntoConstraints = false
        arrImage.translatesAutoresizingMaskIntoConstraints = false
        
        // cal
        calorieButton.translatesAutoresizingMaskIntoConstraints = false
        calorieImage.translatesAutoresizingMaskIntoConstraints = false
        
        // step
        stepButton.translatesAutoresizingMaskIntoConstraints = false
        stepImage.translatesAutoresizingMaskIntoConstraints = false
        
        // temperature
        temperatureButton.translatesAutoresizingMaskIntoConstraints = false
        temperatureImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 배터리 프로그래스 바
            batProgress.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            batProgress.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: 0),
            batteryLabel.centerYAnchor.constraint(equalTo: batProgress.centerYAnchor),
            batteryLabel.trailingAnchor.constraint(equalTo: batProgress.leadingAnchor, constant: -10),

            // 상단 버튼
            // bpm
            bpmButton.topAnchor.constraint(equalTo: safeAreaView.topAnchor ),
            bpmButton.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 10),
            bpmButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            bpmButton.heightAnchor.constraint(equalToConstant: 50),
            
            bpmImage.topAnchor.constraint(equalTo: bpmButton.topAnchor, constant: 5),
            bpmImage.centerXAnchor.constraint(equalTo: bpmButton.centerXAnchor),
            
            // arr
            arrButton.topAnchor.constraint(equalTo: bpmButton.topAnchor),
            arrButton.leadingAnchor.constraint(equalTo: bpmButton.trailingAnchor, constant: 10),
            arrButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            arrButton.heightAnchor.constraint(equalToConstant: 50),
            
            arrImage.topAnchor.constraint(equalTo: arrButton.topAnchor, constant: 5),
            arrImage.centerXAnchor.constraint(equalTo: arrButton.centerXAnchor),
            
            // calorie
            calorieButton.topAnchor.constraint(equalTo: bpmButton.topAnchor),
            calorieButton.leadingAnchor.constraint(equalTo: arrButton.trailingAnchor, constant: 10),
            calorieButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            calorieButton.heightAnchor.constraint(equalToConstant: 50),
            
            calorieImage.topAnchor.constraint(equalTo: calorieButton.topAnchor, constant: 5),
            calorieImage.centerXAnchor.constraint(equalTo: calorieButton.centerXAnchor),
            
            // step
            stepButton.topAnchor.constraint(equalTo: bpmButton.topAnchor),
            stepButton.leadingAnchor.constraint(equalTo: calorieButton.trailingAnchor, constant: 10),
            stepButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            stepButton.heightAnchor.constraint(equalToConstant: 50),
            
            stepImage.topAnchor.constraint(equalTo: stepButton.topAnchor, constant: 5),
            stepImage.centerXAnchor.constraint(equalTo: stepButton.centerXAnchor),
            
            // temperature
            temperatureButton.topAnchor.constraint(equalTo: bpmButton.topAnchor),
            temperatureButton.leadingAnchor.constraint(equalTo: stepButton.trailingAnchor, constant: 10),
            temperatureButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            temperatureButton.heightAnchor.constraint(equalToConstant: 50),
            
            temperatureImage.topAnchor.constraint(equalTo: temperatureButton.topAnchor, constant: 5),
            temperatureImage.centerXAnchor.constraint(equalTo: temperatureButton.centerXAnchor),

        ])
    }
    
    // MARK: -
    // navigation 설정
    func setNavigation() {
        // Navigationbar Title 왼쪽 정렬
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)

        // keybord dismiss by touching anywhere in the view
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: -
    // safeAreaView 설정
    func setSafeAreaView(){
        
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                safeAreaView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: safeAreaView.bottomAnchor, multiplier: 1.0),
                safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                safeAreaView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: standardSpacing),
                safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}
