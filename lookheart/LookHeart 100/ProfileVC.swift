import UIKit
import CoreBluetooth

class ProfileVC: UIViewController, UITextFieldDelegate {
    
    private let safeAreaView = UIView()
    
    // CBCentralManager 인스턴스 생성
    var centralManager: CBCentralManager?
    var connectedPeripheral: CBPeripheral?
    
    // basicInfo var
    private var myName = ""
    private var myPhoneNumber = ""
    private var myHeight = ""
    private var myWeight = ""
    private var date = ""
    private var myGender = ""
    private var mySleep = ""
    private var myWakeup = ""
    
    // target var
    private var myBpm = ""
    private var myStep = ""
    private var myDistance = ""
    private var myACal = ""
    private var myTCal = ""
    
    // set var
    private var guardianTel = ""
    private var guardianTel2 = ""
    
    var heightAnchor: NSLayoutConstraint?
    
    var dateComponents = DateComponents() // 날짜값 저장을 위한 변수
    var MykeyboadrdSize:CGFloat = 0.0 // 키보드 사이즈 저장 변수
    
    // image set
    let birthdayImage =  UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
    let plusImage =  UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    let minusImage =  UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
//    let logoutImage =  UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)

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
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    /*-------------------- 상단 View 설정 --------------------*/
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = UserDefaults.standard.string(forKey: "name") ?? "isEmpty"
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy) // 크기, 굵음 정도 설정
        label.textColor = .black
        
        return label
    }()
    
    let sirLabel: UILabel = {
        let label = UILabel()
        
        label.text = "님"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .lightGray
        
        return label
    }()
    
    // 이벤트, 이미지 추가 필요
     lazy var logoutButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 1
        
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 30)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
         
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        //button.bringSubviewToFront(view)
        
        // image 지정 및 정렬
//        button.setImage(logoutImage, for: .normal)
//        button.semanticContentAttribute = .forceRightToLeft // 이미지 오른쪽 정렬
            
        button.addTarget(self, action: #selector(logoutButtonEvent(_:)), for: .touchUpInside)
         
        return button
    }()
    @objc func logoutButtonEvent(_ sender: UIButton) {
        let alert = UIAlertController(title: "로그아웃", message: "로그인 페이지로 돌아가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: .destructive, handler: { Action in
            UserDefaults.standard.set(false, forKey: "autoLoginFlag")
            let navigationController = UINavigationController(rootViewController: LoginView())
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
        })
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    lazy var logoutImage: UIImageView = {
        var imageView = UIImageView()
        // record.circle
        let image =  UIImage(named: "logout")!
        let redImg = image.imageWithColor(color: .lightGray)
        imageView.image = redImg
        
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "이메일"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        
        return label
    }()
    
    let emailData: UILabel = {
        let label = UILabel()
        
        label.text = UserDefaults.standard.string(forKey: "Id") ?? "isEmpty"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        
        return label
    }()
    
    let signupDateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "가입일"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        
        return label
    }()
    
    let signupDate: UILabel = {
        let label = UILabel()
        var signupDate = ""
        
        if let UserdefaultDate = UserDefaults.standard.object(forKey: "SignupDate") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let stringDate = dateFormatter.string(from: UserdefaultDate)
            signupDate = stringDate
        }
        else{
            signupDate = "isEmpty"
        }
        
        label.text = signupDate
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        
        return label
    }()
    
    let topView: UIView = {
        let view = UILabel()
        
        view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
        view.layer.borderColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1.0).cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    /*-------------------- 버튼 View 설정 --------------------*/
    
    lazy var basicInfoButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("기본정보", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .clear
        basiceUnderLine.isHidden = false
        
        button.addTarget(self, action: #selector(basicInfoButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func basicInfoButtonEvent(_ sender: UIButton) {
        goalButton.setTitleColor(.lightGray, for: .normal)
        basicInfoButton.setTitleColor(.black, for: .normal)
        setButton.setTitleColor(.lightGray, for: .normal)
        
        setButton.isEnabled = true
        
        goalUnderLine.isHidden = true
        basiceUnderLine.isHidden = false
        setUnderLine.isHidden = true
        
        goalView.isHidden = true
        basicInfoView.isHidden = false
        setView.isHidden = true
        
        heightAnchor?.isActive = false
        heightAnchor?.constant = scrollView.frame.height / 4
        heightAnchor?.isActive = true
        
    }
        
    lazy var goalButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("목표량", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .clear
        // 196108
        button.addTarget(self, action: #selector(goalButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func goalButtonEvent(_ sender: UIButton) {
        goalButton.setTitleColor(.black, for: .normal)
        basicInfoButton.setTitleColor(.lightGray, for: .normal)
        setButton.setTitleColor(.lightGray, for: .normal)
        
        setButton.isEnabled = true
        
        goalUnderLine.isHidden = false
        basiceUnderLine.isHidden = true
        setUnderLine.isHidden = true
        
        goalView.isHidden = false
        basicInfoView.isHidden = true
        setView.isHidden = true
        
        heightAnchor?.isActive = false
        heightAnchor?.constant = scrollView.frame.height / 4
        heightAnchor?.isActive = true
        
    }

    lazy var setButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("설정", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .clear
        // 196108
        button.addTarget(self, action: #selector(setButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func setButtonEvent(_ sender: UIButton) {
        goalButton.setTitleColor(.lightGray, for: .normal)
        basicInfoButton.setTitleColor(.lightGray, for: .normal)
        setButton.setTitleColor(.black, for: .normal)
        
        setButton.isEnabled = false
        
        goalUnderLine.isHidden = true
        basiceUnderLine.isHidden = true
        setUnderLine.isHidden = false
        
        goalView.isHidden = true
        basicInfoView.isHidden = true
        setView.isHidden = false
        
        heightAnchor?.isActive = false
        heightAnchor?.constant += 300
        heightAnchor?.isActive = true
    }
    
    lazy var basiceUnderLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        return label
    }()
    
    lazy var goalUnderLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.isHidden = true
        return label
    }()
    
    lazy var setUnderLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.isHidden = true
        return label
    }()
    
    let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.backgroundColor = .green
        return view
    }()
    
    /*-------------------- 기본정보 View 설정 --------------------*/
    
    /*------------------------- Label ------------------------*/
    let privacyInfo: UILabel = {
        let label = UILabel()
        label.text = "입력하신 개인정보는\n모두 암호화되어 안전하게 관리합니다."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        label.numberOfLines = 2
        
        return label
    }()
    
    let nameTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "성명"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let phoneNumberTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "휴대폰 번호("+"\"-\""+" 제외)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let birthdayTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let birthdayLabel:UILabel = {
        let label = UILabel()
        
        label.text = UserDefaults.standard.string(forKey: "Birthday") ?? "isEmpty"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()

    let ageTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "나이"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()

    // 나이
    let ageLabel:UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "Age") ?? "isEmpty"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    let genderTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()

    let heightTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "키"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()

    let weightTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "체중"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let sleepLabel: UILabel = {
        let label = UILabel()
        label.text = "취침시간"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let wakeupLabel: UILabel = {
        let label = UILabel()
        label.text = "기상시간"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    


    /*------------------------- Background ------------------------*/
    // 이름
    let nameTextFieldBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    // 휴대폰 번호
    let phoneNumberTextFieldBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // 생년월일
    let birthdayBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // 나이
    let ageBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    // 성별
    let genderBackground:UILabel = {
        let label = UILabel()
        
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    // 키
    let heightTextFieldBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // 체중
    let weightTextFieldBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    // 수면시간
    let sleepBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    // 기상시간
    let wakeupBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    /*------------------------- TextField ------------------------*/
    // 성명
    private var nameTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
       
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "name") ?? "isEmpty", attributes: attributes)
        
        return textField
    }()

    // 휴대폰 번호
    private var phoneNumberTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        //textField.backgroundColor = .green
        // 크기
        textField.font = UIFont.systemFont(ofSize: 14)
        // 비어 있는 경우 설정
        var attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        // 값이 있는 경우 설정
        if((UserDefaults.standard.string(forKey: "PhoneNumber")?.isEmpty) != nil){
            attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                              .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        }
        var hypenPhoneNumber = UserDefaults.standard.string(forKey: "PhoneNumber") ?? "01012345678"
        hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
        hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
        
        textField.attributedPlaceholder = NSAttributedString(string: hypenPhoneNumber, attributes: attributes)
        
        return textField
    }()
    
    // 키
    private var heightTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        //textField.backgroundColor = .green
        // 크기
        textField.font = UIFont.systemFont(ofSize: 16)
       
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "Height") ?? "isEmpty", attributes: attributes)
        
        return textField
    }()
    
    // 체중
    private var weightTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        //textField.backgroundColor = .green
        // 크기
        textField.font = UIFont.systemFont(ofSize: 16)
       
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "Weight") ?? "isEmpty", attributes: attributes)
        
        return textField
    }()
    
    // 수면시간
    private var sleepTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
       
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "SleepTime") ?? "isEmpty", attributes: attributes)
        
        return textField
    }()
    // 기상시간
    private var wakeupTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
       
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "WakeupTime") ?? "isEmpty", attributes: attributes)
        
        return textField
    }()
    
    /*------------------------- Button ------------------------*/
    
    // datapicker
    lazy var birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let calendar = Calendar.current
        
        datePicker.datePickerMode = .date
        
        dateComponents.year = 1968
        dateComponents.month = 1
        dateComponents.day = 1
        
        if let date = calendar.date(from: dateComponents){
            datePicker.date = date
        }
            
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.calendar.locale = Locale(identifier: "ko_KR")
        datePicker.timeZone = .autoupdatingCurrent

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
//             Fallback on earlier versions
            let alert = UIAlertController(title: "알림", message: "아이폰 버전 업데이트 필요(13.4)", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: false)
        }
        datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
        
       return datePicker
    }()
    
    // Called when DatePicker is selected.
    @objc func onDidChangeDate(sender: UIDatePicker){
        // Generate the format.
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let convertStr = dateFormatter.string(from: sender.date)
        
        date = convertStr
        //print(convertStr)
    }
    
    // 생년월일
    lazy var birthdayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(birthdayImage, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 230)
        button.addTarget(self, action: #selector(birthdayButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func birthdayButtonEvent(_ sender: UIButton) {
        // \n : Content 범위를 늘리기 위함
        var dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        // ipad일 경우
        if (UIDevice.current.userInterfaceIdiom == .pad){
            dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
            birthdayDatePicker.translatesAutoresizingMaskIntoConstraints = true
            
        }
        else{
            birthdayDatePicker.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: dateAlert.view.bounds.size.width - margin * 4.0, height: 200)
        let customView = UIView(frame: rect)
        
        dateAlert.setBackgroundColor(color: .white)
        //customView.backgroundColor = .green // 범위 확인
        
        dateAlert.view.addSubview(customView)
        dateAlert.view.addSubview(birthdayDatePicker)
        
        // datePicker 위치
        birthdayDatePicker.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        birthdayDatePicker.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        let complite = UIAlertAction(title: "완료", style: UIAlertAction.Style.default){ [self]_ in
            
            birthdayLabel.text = self.date
            
            // 현재 시간
            _ = Date()
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            let currentDay = Calendar.current.component(.day, from: Date())
            
            // 출생 년도
            let ageString = self.birthdayLabel.text
            let birthSplit = ageString!.components(separatedBy: " ")
            let birthYear = birthSplit[0].components(separatedBy: "년")
            let birthMonth = birthSplit[1].components(separatedBy: "월")
            let birthDay = birthSplit[2].components(separatedBy: "일")
                            
            var age = Int(currentYear) - Int(birthYear[0])!
        
            if(Int(currentMonth) < Int(birthMonth[0])! ||
               Int(currentMonth) == Int(birthMonth[0])! &&
               Int(currentDay) < Int(birthDay[0])!){
                age -= 1
            }
            
            ageLabel.text = String(age)
            
            //UserDefaults.standard.set(self.date, forKey: "birthday")
        }
        
        dateAlert.addAction(cancel)
        dateAlert.addAction(complite)
        
        self.present(dateAlert, animated: false, completion: {})
    }
    
        
        lazy var genderButton: UIButton = {
            var button = UIButton(type: .custom)
    
            if((UserDefaults.standard.string(forKey: "Sex")?.isEmpty) == nil){
                button.setTitle("선택", for: .normal)
            }
            else if(UserDefaults.standard.string(forKey: "Sex") == "1"){
                button.setTitle("남자", for: .normal)
            }
            else{
                button.setTitle("여자", for: .normal)
            }
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            button.setTitleColor(.darkGray, for: .normal)
            button.isEnabled = true
    
            button.addTarget(self, action: #selector(genderButtonEvent(_:)), for: .touchUpInside)
    
            return button
        }()
    
        @objc func genderButtonEvent(_ sender: UIButton) {
            let alert = UIAlertController(title: "성별", message: nil, preferredStyle: UIAlertController.Style.alert)
            let male = UIAlertAction(title: "남자", style: UIAlertAction.Style.default){_ in
                self.genderButton.setTitle("남자", for: .normal)
                self.myGender = "1"
            }
            let female = UIAlertAction(title: "여자", style: UIAlertAction.Style.default){_ in
                self.genderButton.setTitle("여자", for: .normal)
                self.myGender = "2"
            }
            
            alert.addAction(male)
            alert.addAction(female)
            
            self.present(alert, animated: false)
        }
    
    // 기본정보 저장 버튼
    lazy var basicInfoSaveButton: UIButton = {
        var button = UIButton(type: .custom)
        
        button.setTitle("저 장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal) // 활성화 .normal / 비활성화 .disabled
        button.backgroundColor = UIColor(red: 0x33/255, green: 0x47/255, blue: 0x71/255, alpha: 1.0)
        button.isEnabled = true       // 버튼의 동작 설정 (처음에는 동작 off)
        
        button.addTarget(self, action: #selector(basicInfoSaveButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func basicInfoSaveButtonEvent(_ sender: UIButton) {
        // 열려 있는 텍스트 필드 확인용 배열
        let textFields: [UITextField] = [nameTextField, phoneNumberTextField, heightTextField, weightTextField]
        
        _ = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 16, weight: .medium)]

        // 변경된 내용이 있을 경우에만 값 수정
        if(!myName.isEmpty){
            UserDefaults.standard.set(myName, forKey: "name")
            nameLabel.text = UserDefaults.standard.string(forKey: "name")
            nameTextField.text = myName
            nameTextField.placeholder = myName
        }
        if(!myPhoneNumber.isEmpty){
            UserDefaults.standard.set(myPhoneNumber, forKey: "PhoneNumber")
            
            var hypenPhoneNumber = UserDefaults.standard.string(forKey: "PhoneNumber")!
            hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
            hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
            
            phoneNumberTextField.text = hypenPhoneNumber
            phoneNumberTextField.placeholder = hypenPhoneNumber
        }
        if(!myGender.isEmpty){
            UserDefaults.standard.set(myGender, forKey: "Sex")
        }
        if(!myHeight.isEmpty){
            UserDefaults.standard.set(myHeight, forKey: "Height")
            heightTextField.placeholder = myHeight
        }
        if(!myWeight.isEmpty){
            UserDefaults.standard.set(myWeight, forKey: "Weight")
            weightTextField.placeholder = myWeight
        }
        if(!mySleep.isEmpty){
            UserDefaults.standard.set(mySleep, forKey: "SleepTime")
            sleepTextField.placeholder = mySleep
        }
        if(!myWakeup.isEmpty){
            UserDefaults.standard.set(myWakeup, forKey: "WakeupTime")
            wakeupTextField.placeholder = myWakeup
        }
        
        UserDefaults.standard.set(birthdayLabel.text, forKey: "Birthday")
        UserDefaults.standard.set(ageLabel.text, forKey: "Age")
        
        basicInfoView.setNeedsLayout()
        basicInfoView.layoutIfNeeded()
        
        // 키보드가 열려 있을 경우 키보드 사라짐
        for textField in textFields {
            textField.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "저장되었습니다", message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: false)
    }
    
    let basicInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    /*-------------------- 목표량 View 설정 --------------------*/
    
    /*-------------------- Label --------------------*/
    
    let targetInfo: UILabel = {
        let label = UILabel()
        label.text = "나에게 맞는 기준을 설정하고,\n매일의 건강 목표를 달성해보세요."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        label.numberOfLines = 2
        
        return label
    }()
    
    let bpmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 기준 bpm"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let bpmInfo: UILabel = {
        let label = UILabel()
        label.text = "성인 평균 활동 기준 bpm은 90입니다."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()

    let dailyTargetStepLabel: UILabel = {
        let label = UILabel()
        label.text = "일일 목표 걸음수"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let dailyTargetDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "일일 목표 걸음거리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let activityCalLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 칼로리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let dailyTargetCalLabel: UILabel = {
        let label = UILabel()
        label.text = "일일 목표 소비칼로리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    
    let bpmLabel:UILabel = {
        let label = UILabel()
        label.text = "bpm"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    let stepLabel:UILabel = {
        let label = UILabel()
        label.text = "걸음"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    let distanceLabel:UILabel = {
        let label = UILabel()
        label.text = "km"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    let aCalLabel:UILabel = {
        let label = UILabel()
        label.text = "kcal"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    let tCalLabel:UILabel = {
        let label = UILabel()
        label.text = "kcal"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    /*-------------------- BackGround --------------------*/
    
    // bpm
    let bpmBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // dailyStep
    let dailyTargetStepBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // dailyDistance
    let dailyTargetDistanceBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // activityCal
    let activityCalBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // dailyTCal
    let dailyTargetCalBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    /*-------------------- TextField --------------------*/
    
    
    private var bpmTextField: CustomTextField! = {
        let textField = CustomTextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
//        textField.backgroundColor = .green
        textField.textAlignment = .right
        textField.clearsOnBeginEditing = true
        
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "eCalBpm") ?? "0", attributes: attributes)
        
        return textField
    }()
    
    private var stepTextField: CustomTextField! = {
        let textField = CustomTextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .right
        textField.clearsOnBeginEditing = true
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "TargetStep") ?? "0", attributes: attributes)
        
        return textField
    }()
    
    private var distanceTextField: CustomTextField! = {
        let textField = CustomTextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .right
        textField.clearsOnBeginEditing = true
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "TargetDistance") ?? "0", attributes: attributes)
        
        return textField
    }()
    
    private var aCalTextField: CustomTextField! = {
        let textField = CustomTextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .right
        textField.clearsOnBeginEditing = true
        
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "TargeteCal") ?? "0", attributes: attributes)
        
        return textField
    }()
    
    private var tCalTextField: CustomTextField! = {
        let textField = CustomTextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 14)
//        textField.becomeFirstResponder()
        textField.textAlignment = .right
        textField.clearsOnBeginEditing = true
        
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "TargettCal") ?? "0", attributes: attributes)
        
        return textField
    }()
    
    /*-------------------- Button --------------------*/
    
    lazy var bpmPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var bpmMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var stepMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var stepPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    lazy var distanceMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    lazy var distancePlusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var aCalMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var aCalPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tCalMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tCalPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func ButtonTapped(_ sender: UIButton) {
        
        // 초기값
        if(myBpm.isEmpty){
            myBpm = UserDefaults.standard.string(forKey: "eCalBpm") ?? "0"
        }
        else if(myStep.isEmpty){
            myStep = UserDefaults.standard.string(forKey: "TargetStep") ?? "0"
        }
        else if(myDistance.isEmpty){
            myDistance = UserDefaults.standard.string(forKey: "TargetDistance") ?? "0"
        }
        else if(myACal.isEmpty){
            myACal = UserDefaults.standard.string(forKey: "TargeteCal") ?? "0"
        }
        else if(myTCal.isEmpty){
            myTCal = UserDefaults.standard.string(forKey: "TargettCal") ?? "0"
        }
        
        // button touch event
        if(sender.tag == 1) {
            if var intBpm = Int(myBpm) {
                intBpm += 1
                myBpm = String(intBpm)
                bpmTextField.text = myBpm
            }
        }
        else if(sender.tag == 2){
            if var intBpm = Int(myBpm) {
                intBpm -= 1
                myBpm = String(intBpm)
                bpmTextField.text = myBpm
            }
        }
        else if(sender.tag == 3){
            if var intStep = Int(myStep) {
                intStep += 1
                myStep = String(intStep)
                stepTextField.text = myStep
            }
        }
        else if(sender.tag == 4){
            if var intStep = Int(myStep) {
                intStep -= 1
                myStep = String(intStep)
                stepTextField.text = myStep
            }
        }
        else if(sender.tag == 5){
            if var intDistance = Int(myDistance) {
                intDistance += 1
                myDistance = String(intDistance)
                distanceTextField.text = myDistance
            }
        }
        else if(sender.tag == 6){
            if var intDistance = Int(myDistance) {
                intDistance -= 1
                myDistance = String(intDistance)
                distanceTextField.text = myDistance
            }
        }
        else if(sender.tag == 7){
            if var intACal = Int(myACal) {
                intACal += 1
                myACal = String(intACal)
                aCalTextField.text = myACal
            }
        }
        else if(sender.tag == 8){
            if var intACal = Int(myACal) {
                intACal -= 1
                myACal = String(intACal)
                aCalTextField.text = myACal
            }
        }
        else if(sender.tag == 9){
            if var intTCal = Int(myTCal) {
                intTCal += 1
                myTCal = String(intTCal)
                tCalTextField.text = myTCal
            }
        }
        else if(sender.tag == 10){
            if var intTCal = Int(myTCal) {
                intTCal -= 1
                myTCal = String(intTCal)
                tCalTextField.text = myTCal
            }
        }
        else if(sender.tag == 27){
            let alert = UserDefaults.standard.string(forKey: "guardianAlert")!
            let intAlert = Int(alert)! + 1
            UserDefaults.standard.set(String(intAlert), forKey: "guardianAlert")
            alertTextField.text = UserDefaults.standard.string(forKey: "guardianAlert")!
        }
        else if(sender.tag == 28){
            let alert = UserDefaults.standard.string(forKey: "guardianAlert")!
            if Int(alert)! > 0 {
                let intAlert = Int(alert)! - 1
                UserDefaults.standard.set(String(intAlert), forKey: "guardianAlert")
                alertTextField.text = UserDefaults.standard.string(forKey: "guardianAlert")!
            }
        }
        
    }
    
    // 목표량 저장 버튼
    lazy var goalSaveButton: UIButton = {
        var button = UIButton(type: .custom)
        
        button.setTitle("저 장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal) // 활성화 .normal / 비활성화 .disabled
        button.backgroundColor = UIColor(red: 0x33/255, green: 0x47/255, blue: 0x71/255, alpha: 1.0)
        button.isEnabled = true       // 버튼의 동작 설정 (처음에는 동작 off)
        
        button.addTarget(self, action: #selector(goalSaveButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func goalSaveButtonEvent(_ sender: UIButton) {
        
        // 열려 있는 텍스트 필드 확인용 배열
        let textFields: [UITextField] = [bpmTextField, stepTextField, distanceTextField, aCalTextField, tCalTextField]
        
        // 변경된 내용이 있을 경우에만 값 수정
        if(!myBpm.isEmpty){ UserDefaults.standard.set(myBpm, forKey: "eCalBpm") }
        if(!myStep.isEmpty){ UserDefaults.standard.set(myStep, forKey: "TargetStep") }
        if(!myDistance.isEmpty){ UserDefaults.standard.set(myDistance, forKey: "TargetDistance") }
        if(!myACal.isEmpty){ UserDefaults.standard.set(myACal, forKey: "TargeteCal") }
        if(!myTCal.isEmpty){ UserDefaults.standard.set(myTCal, forKey: "TargettCal") }
        
        basicInfoView.setNeedsLayout()
        basicInfoView.layoutIfNeeded()
        
        // 키보드가 열려 있을 경우 키보드 사라짐
        for textField in textFields {
            textField.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "저장되었습니다", message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: false)
    }
    
    let goalView: UIView = {
        let view = UIView()
        //view.backgroundColor = .green
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    /*-------------------- setView --------------------*/
    
    
    /*-------------------- Label --------------------*/
    let setHelpLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 푸쉬 알림"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let heartAttackLabel: UILabel = {
        let label = UILabel()
        label.text = "응급상황"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let arrLabel: UILabel = {
        let label = UILabel()
        label.text = "비정상맥박"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let myoLabel: UILabel = {
        let label = UILabel()
        label.text = "근전도"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let noncontactLabel: UILabel = {
        let label = UILabel()
        label.text = "전극떨어짐"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let tarchycardiaLabel: UILabel = {
        let label = UILabel()
        label.text = "빠른 맥박"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let bradycardiaLabel: UILabel = {
        let label = UILabel()
        label.text = "느린 맥박"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let atrialFibrillaionLabel: UILabel = {
        let label = UILabel()
        label.text = "불규칙 맥박"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    // MARK: - work22
    let guardianLabel: UILabel = {
        let label = UILabel()
        label.text = "보호자 SMS 알림"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    let guardianInfo: UILabel = {
        let label = UILabel()
        label.text = "비정상맥박이 기준 횟수 이상 발생 시\n보호자에게 sms 알림문자를 전송합니다."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        label.numberOfLines = 2
        
        return label
    }()
    
    let guardianAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "보호자 알림 기능"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "알림발생 기준 횟수"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    let alertTimeLabel:UILabel = {
        let label = UILabel()
        label.text = "회"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    let guardianTelLabel: UILabel = {
        let label = UILabel()
        label.text = "보호자 연락처 1("+"\"-\""+" 제외)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()

    let guardianTel2Label: UILabel = {
        let label = UILabel()
        label.text = "보호자 연락처 2("+"\"-\""+" 제외)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    /*-------------------- baground --------------------*/
    
    let heartAttackBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let arrBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let noncontactBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let myoBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let tarchycardiaBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let bradycardiaBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let atrialFibrillaionBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - WORK3333
    let guardianAlertBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let alertBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let alertTextField: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "guardianAlert") ?? "0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    
    // 휴대폰 번호
    private var guardianTelTextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        //textField.backgroundColor = .green
        // 크기
        textField.font = UIFont.systemFont(ofSize: 14)
        // 비어 있는 경우 설정
        var attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        // 값이 있는 경우 설정
        if((UserDefaults.standard.string(forKey: "guardianTel1")?.isEmpty) != nil){
            attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                              .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        }
        var hypenPhoneNumber = UserDefaults.standard.string(forKey: "guardianTel1") ?? "01012345678"
        hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
        hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
        
        textField.attributedPlaceholder = NSAttributedString(string: hypenPhoneNumber, attributes: attributes)
        
        return textField
    }()
    
    private var guardianTel2TextField: UITextField! = {
        let textField = UITextField()
        
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        //textField.backgroundColor = .green
        // 크기
        textField.font = UIFont.systemFont(ofSize: 14)
        // 비어 있는 경우 설정
        var attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        // 값이 있는 경우 설정
        if((UserDefaults.standard.string(forKey: "guardianTel2")?.isEmpty) != nil){
            attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                              .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        }
        var hypenPhoneNumber = UserDefaults.standard.string(forKey: "guardianTel2") ?? "01012345678"
        hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
        hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
        
        textField.attributedPlaceholder = NSAttributedString(string: hypenPhoneNumber, attributes: attributes)
        
        return textField
    }()
    
    lazy var alertPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var alertMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var guardianAlertOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
               
        if(UserDefaults.standard.bool(forKey: "guardianAlertFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
   
   lazy var guardianAlertOnButton: UIButton = {
      let button = UIButton()
      
       button.setTitle("사용", for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
       button.layer.cornerRadius = 10
       button.clipsToBounds = true
       
       if(UserDefaults.standard.bool(forKey: "guardianAlertFlag")){
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
       }
       else{
           button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
           button.backgroundColor = .clear
       }
  
       button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
       
      return button
  }()
    
    let guardianTelBackground:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let guardianTel2Background:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    /*-------------------- button --------------------*/
    
    lazy var heartAttackFlagOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        if(UserDefaults.standard.bool(forKey: "HeartAttackFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
        
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
   
   lazy var heartAttackFlagOnButton: UIButton = {
      let button = UIButton()
      
       button.setTitle("사용", for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
       button.layer.cornerRadius = 10
       button.clipsToBounds = true
       
       if(UserDefaults.standard.bool(forKey: "HeartAttackFlag")){
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
       }
       else{
           button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
           button.backgroundColor = .clear
       }
  
       button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
       
      return button
  }()
    
     lazy var arrFlagOffButton: UIButton = {
        let button = UIButton()
        
         button.setTitle("해제", for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
         button.layer.cornerRadius = 10
         button.clipsToBounds = true
                
         if(UserDefaults.standard.bool(forKey: "ArrFlag")){
             button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
             button.backgroundColor = .clear
         }
         else{
             button.setTitleColor(.white, for: .normal)
             button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
         }
    
         button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
         
        return button
    }()
    
    lazy var arrFlagOnButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("사용", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        if(UserDefaults.standard.bool(forKey: "ArrFlag")){
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
        else{
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
  
    lazy var myoFlagOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        if(UserDefaults.standard.bool(forKey: "MyoFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
   
   lazy var myoFlagOnButton: UIButton = {
      let button = UIButton()
      
       button.setTitle("사용", for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
       button.layer.cornerRadius = 10
       button.clipsToBounds = true
       
       if(UserDefaults.standard.bool(forKey: "MyoFlag")){
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
       }
       else{
           button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
           button.backgroundColor = .clear
       }
  
       button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
       
      return button
  }()
    
    lazy var noncontactFlagOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        if(UserDefaults.standard.bool(forKey: "NoncontactFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
   
   lazy var noncontactFlagOnButton: UIButton = {
      let button = UIButton()
      
       button.setTitle("사용", for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
       button.layer.cornerRadius = 10
       button.clipsToBounds = true
       
       if(UserDefaults.standard.bool(forKey: "NoncontactFlag")){
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
       }
       else{
           button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
           button.backgroundColor = .clear
       }
       
       button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
       
      return button
  }()
    
    lazy var tarchycardiaFlagOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        if(UserDefaults.standard.bool(forKey: "TarchycardiaFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var tarchycardiaFlagOnButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("사용", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        if(UserDefaults.standard.bool(forKey: "TarchycardiaFlag")){
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
        else{
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var bradycardiaFlagOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        if(UserDefaults.standard.bool(forKey: "BradycardiaFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var bradycardiaFlagOnButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("사용", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        if(UserDefaults.standard.bool(forKey: "BradycardiaFlag")){
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
        else{
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var atrialFibrillaionFlagOffButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        if(UserDefaults.standard.bool(forKey: "AtrialFibrillaionFlag")){
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        else{
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
   
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    lazy var atrialFibrillaionFlagOnButton: UIButton = {
       let button = UIButton()
       
        button.setTitle("사용", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        if(UserDefaults.standard.bool(forKey: "AtrialFibrillaionFlag")){
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
        }
        else{
            button.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            button.backgroundColor = .clear
        }
        
        button.addTarget(self, action: #selector(flagButtonEvent(_:)), for: .touchUpInside)
        
       return button
   }()
    
    @objc func flagButtonEvent(_ sender: UIButton) {
        // button touch event
        if(sender.tag == 11) { // on
            heartAttackFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            heartAttackFlagOnButton.setTitleColor(.white, for: .normal)
            
            heartAttackFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            heartAttackFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "HeartAttackFlag")
        }
        else if(sender.tag == 12){ // off
            heartAttackFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            heartAttackFlagOffButton.setTitleColor(.white, for: .normal)
            
            heartAttackFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            heartAttackFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "HeartAttackFlag")
        }
        
        else if(sender.tag == 13){ // on
            arrFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            arrFlagOnButton.setTitleColor(.white, for: .normal)
            
            arrFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            arrFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "ArrFlag")
        }
        else if(sender.tag == 14){ // off
            arrFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            arrFlagOffButton.setTitleColor(.white, for: .normal)
            
            arrFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            arrFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "ArrFlag")
        }
        
        else if(sender.tag == 15){ // on
            myoFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            myoFlagOnButton.setTitleColor(.white, for: .normal)
            
            myoFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            myoFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "MyoFlag")
        }
        else if(sender.tag == 16){ // off
            myoFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            myoFlagOffButton.setTitleColor(.white, for: .normal)
            
            myoFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            myoFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "MyoFlag")
        }
        
        else if(sender.tag == 17){ // on
            noncontactFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            noncontactFlagOnButton.setTitleColor(.white, for: .normal)
            
            noncontactFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            noncontactFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "NoncontactFlag")
        }
        else if(sender.tag == 18){ // off
            noncontactFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            noncontactFlagOffButton.setTitleColor(.white, for: .normal)
            
            noncontactFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            noncontactFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "NoncontactFlag")
        }
        
        
        else if(sender.tag == 19){ // on
            tarchycardiaFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            tarchycardiaFlagOnButton.setTitleColor(.white, for: .normal)
            
            tarchycardiaFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            tarchycardiaFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "TarchycardiaFlag")
        }
        else if(sender.tag == 20){ // off
            tarchycardiaFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            tarchycardiaFlagOffButton.setTitleColor(.white, for: .normal)
            
            tarchycardiaFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            tarchycardiaFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "TarchycardiaFlag")
        }
        
        
        else if(sender.tag == 21){ // on
            bradycardiaFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            bradycardiaFlagOnButton.setTitleColor(.white, for: .normal)
            
            bradycardiaFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            bradycardiaFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "BradycardiaFlag")
        }
        else if(sender.tag == 22){ // off
            bradycardiaFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            bradycardiaFlagOffButton.setTitleColor(.white, for: .normal)
            
            bradycardiaFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            bradycardiaFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "BradycardiaFlag")
        }
        
        else if(sender.tag == 23){ // on
            atrialFibrillaionFlagOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            atrialFibrillaionFlagOnButton.setTitleColor(.white, for: .normal)
            
            atrialFibrillaionFlagOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            atrialFibrillaionFlagOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "AtrialFibrillaionFlag")
        }
        else if(sender.tag == 24){ // off
            atrialFibrillaionFlagOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            atrialFibrillaionFlagOffButton.setTitleColor(.white, for: .normal)
            
            atrialFibrillaionFlagOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            atrialFibrillaionFlagOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "AtrialFibrillaionFlag")
        }
        
        else if(sender.tag == 25){ // on
            guardianAlertOnButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            guardianAlertOnButton.setTitleColor(.white, for: .normal)
            
            guardianAlertOffButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            guardianAlertOffButton.backgroundColor = .clear
            
            UserDefaults.standard.set(true, forKey: "guardianAlertFlag")
        }
        else if(sender.tag == 26){ // off
            guardianAlertOffButton.backgroundColor = UIColor(red: 56/255, green: 70/255, blue: 110/255, alpha: 1.0)
            guardianAlertOffButton.setTitleColor(.white, for: .normal)
            
            guardianAlertOnButton.setTitleColor(UIColor(red: 151/255, green: 154/255, blue: 164/255, alpha: 1.0), for: .normal)
            guardianAlertOnButton.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: "guardianAlertFlag")
        }
        
    }
    
    let setView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    /*-------------------- ViewDidLoad --------------------*/
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setup()
        Constraints()
        
    } // viewDidLoad
    
    func setup(){
        view.backgroundColor = .white
        addViews()
        setSafeAreaView()
        
        // scroll View 설정
        heightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 100)
        heightAnchor!.priority = .defaultHigh
        heightAnchor!.isActive = true
    }
    
    func addViews(){
        view.addSubview(safeAreaView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // battery progress를 navigationbar에 추가
        customView.addSubview(batProgress)
        customView.addSubview(batteryLabel)
        let barItem = UIBarButtonItem(customView: customView)
        navigationItem.rightBarButtonItem = barItem
        
        // topView
        containerView.addSubview(topView)
        containerView.addSubview(logoutButton)
        containerView.addSubview(logoutImage)
        topView.addSubview(nameLabel)
        topView.addSubview(sirLabel)
        topView.addSubview(emailLabel)
        topView.addSubview(emailData)
        topView.addSubview(signupDateLabel)
        topView.addSubview(signupDate)
        
        // buttonView
        containerView.addSubview(buttonView)
        buttonView.addSubview(basicInfoButton)
        buttonView.addSubview(basiceUnderLine)
        buttonView.addSubview(goalButton)
        buttonView.addSubview(goalUnderLine)
        buttonView.addSubview(setButton)
        buttonView.addSubview(setUnderLine)
        
        // basicInfoView
        containerView.addSubview(basicInfoView)
        basicInfoView.addSubview(privacyInfo)
        
        nameTextField.delegate = self
        nameTextField.tag = 1
        basicInfoView.addSubview(nameTitleLabel)
        basicInfoView.addSubview(nameTextFieldBackground)
        basicInfoView.addSubview(nameTextField)

        phoneNumberTextField.delegate = self
        phoneNumberTextField.tag = 2
        basicInfoView.addSubview(phoneNumberTitleLabel)
        basicInfoView.addSubview(phoneNumberTextFieldBackground)
        basicInfoView.addSubview(phoneNumberTextField)

        basicInfoView.addSubview(birthdayTitleLabel)
        basicInfoView.addSubview(birthdayBackground)
        basicInfoView.addSubview(birthdayButton)
        basicInfoView.addSubview(birthdayLabel)

        basicInfoView.addSubview(ageTitleLabel)
        basicInfoView.addSubview(ageBackground)
        basicInfoView.addSubview(ageLabel)


        basicInfoView.addSubview(genderTitleLabel)
        basicInfoView.addSubview(genderBackground)
        basicInfoView.addSubview(genderButton)

        heightTextField.delegate = self
        heightTextField.tag = 3
        basicInfoView.addSubview(heightTitleLabel)
        basicInfoView.addSubview(heightTextFieldBackground)
        basicInfoView.addSubview(heightTextField)

        weightTextField.delegate = self
        weightTextField.tag = 4
        basicInfoView.addSubview(weightTitleLabel)
        basicInfoView.addSubview(weightTextFieldBackground)
        basicInfoView.addSubview(weightTextField)

        sleepTextField.delegate = self
        sleepTextField.tag = 111
        basicInfoView.addSubview(sleepLabel)
        basicInfoView.addSubview(sleepBackground)
        basicInfoView.addSubview(sleepTextField)
        
        wakeupTextField.delegate = self
        wakeupTextField.tag = 222
        basicInfoView.addSubview(wakeupLabel)
        basicInfoView.addSubview(wakeupBackground)
        basicInfoView.addSubview(wakeupTextField)
        
        basicInfoView.addSubview(basicInfoSaveButton)

        // goalView
        containerView.addSubview(goalView)
        goalView.addSubview(targetInfo)

        bpmTextField.delegate = self
        bpmPlusButton.tag = 1
        bpmMinusButton.tag = 2
        bpmTextField.tag = 5
        goalView.addSubview(bpmTitleLabel)
        goalView.addSubview(bpmInfo)
        goalView.addSubview(bpmBackground)
        goalView.addSubview(bpmPlusButton)
        goalView.addSubview(bpmMinusButton)
        goalView.addSubview(bpmLabel)
        goalView.addSubview(bpmTextField)

        stepTextField.delegate = self
        stepPlusButton.tag = 3
        stepMinusButton.tag = 4
        stepTextField.tag = 6
        goalView.addSubview(dailyTargetStepLabel)
        goalView.addSubview(dailyTargetStepBackground)
        goalView.addSubview(stepMinusButton)
        goalView.addSubview(stepPlusButton)
        goalView.addSubview(stepLabel)
        goalView.addSubview(stepTextField)

        distanceTextField.delegate = self
        distancePlusButton.tag = 5
        distanceMinusButton.tag = 6
        distanceTextField.tag = 7
        goalView.addSubview(dailyTargetDistanceLabel)
        goalView.addSubview(dailyTargetDistanceBackground)
        goalView.addSubview(distancePlusButton)
        goalView.addSubview(distanceMinusButton)
        goalView.addSubview(distanceLabel)
        goalView.addSubview(distanceTextField)

        aCalTextField.delegate = self
        aCalPlusButton.tag = 7
        aCalMinusButton.tag = 8
        aCalTextField.tag = 8
        goalView.addSubview(activityCalLabel)
        goalView.addSubview(activityCalBackground)
        goalView.addSubview(aCalPlusButton)
        goalView.addSubview(aCalMinusButton)
        goalView.addSubview(aCalLabel)
        goalView.addSubview(aCalTextField)

        tCalTextField.delegate = self
        tCalPlusButton.tag = 9
        tCalMinusButton.tag = 10
        tCalTextField.tag = 9
        goalView.addSubview(dailyTargetCalLabel)
        goalView.addSubview(dailyTargetCalBackground)
        goalView.addSubview(tCalPlusButton)
        goalView.addSubview(tCalMinusButton)
        goalView.addSubview(tCalLabel)
        goalView.addSubview(tCalTextField)

        goalView.addSubview(goalSaveButton)
        
        // setView
        containerView.addSubview(setView)
        setView.addSubview(setHelpLabel)
        
        heartAttackFlagOnButton.tag = 11
        heartAttackFlagOffButton.tag = 12
        setView.addSubview(heartAttackBackground)
        setView.addSubview(heartAttackLabel)
        setView.addSubview(heartAttackFlagOnButton)
        setView.addSubview(heartAttackFlagOffButton)
        
        arrFlagOnButton.tag = 13
        arrFlagOffButton.tag = 14
        setView.addSubview(arrBackground)
        setView.addSubview(arrLabel)
        setView.addSubview(arrFlagOnButton)
        setView.addSubview(arrFlagOffButton)
        
        myoFlagOnButton.tag = 15
        myoFlagOffButton.tag = 16
        setView.addSubview(myoBackground)
        setView.addSubview(myoLabel)
        setView.addSubview(myoFlagOnButton)
        setView.addSubview(myoFlagOffButton)
        
        noncontactFlagOnButton.tag = 17
        noncontactFlagOffButton.tag = 18
        setView.addSubview(noncontactBackground)
        setView.addSubview(noncontactLabel)
        setView.addSubview(noncontactFlagOnButton)
        setView.addSubview(noncontactFlagOffButton)
        
        tarchycardiaFlagOnButton.tag = 19
        tarchycardiaFlagOffButton.tag = 20
        setView.addSubview(tarchycardiaLabel)
        setView.addSubview(tarchycardiaBackground)
        setView.addSubview(tarchycardiaFlagOnButton)
        setView.addSubview(tarchycardiaFlagOffButton)
        
        bradycardiaFlagOnButton.tag = 21
        bradycardiaFlagOffButton.tag = 22
        setView.addSubview(bradycardiaLabel)
        setView.addSubview(bradycardiaBackground)
        setView.addSubview(bradycardiaFlagOnButton)
        setView.addSubview(bradycardiaFlagOffButton)
        
        atrialFibrillaionFlagOnButton.tag = 23
        atrialFibrillaionFlagOffButton.tag = 24
        setView.addSubview(atrialFibrillaionLabel)
        setView.addSubview(atrialFibrillaionBackground)
        setView.addSubview(atrialFibrillaionFlagOnButton)
        setView.addSubview(atrialFibrillaionFlagOffButton)
        
        
        // alert
        setView.addSubview(guardianLabel)
        setView.addSubview(guardianInfo)
        
        guardianAlertOnButton.tag = 25
        guardianAlertOffButton.tag = 26
        setView.addSubview(guardianAlertLabel)
        setView.addSubview(guardianAlertBackground)
        setView.addSubview(guardianAlertOnButton)
        setView.addSubview(guardianAlertOffButton)
        
        alertPlusButton.tag = 27
        alertMinusButton.tag = 28
        setView.addSubview(alertLabel)
        setView.addSubview(alertBackground)
        setView.addSubview(alertTextField)
        setView.addSubview(alertTimeLabel)
        setView.addSubview(alertPlusButton)
        setView.addSubview(alertMinusButton)
        setView.addSubview(alertTextField)
        
        guardianTelTextField.delegate = self
        guardianTelTextField.tag = 33
        setView.addSubview(guardianTelLabel)
        setView.addSubview(guardianTelBackground)
        setView.addSubview(guardianTelTextField)
        
        guardianTel2TextField.delegate = self
        guardianTel2TextField.tag = 44
        setView.addSubview(guardianTel2Label)
        setView.addSubview(guardianTel2Background)
        setView.addSubview(guardianTel2TextField)
    }
    
    //MARK: layout
    // 오토 레이아웃 설정
    func Constraints(){
        
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // topView content
        topView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        sirLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutImage.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailData.translatesAutoresizingMaskIntoConstraints = false
        signupDateLabel.translatesAutoresizingMaskIntoConstraints = false
        signupDate.translatesAutoresizingMaskIntoConstraints = false

        // buttonView content
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        basicInfoButton.translatesAutoresizingMaskIntoConstraints = false
        basiceUnderLine.translatesAutoresizingMaskIntoConstraints = false
        goalButton.translatesAutoresizingMaskIntoConstraints = false
        goalUnderLine.translatesAutoresizingMaskIntoConstraints = false
        setButton.translatesAutoresizingMaskIntoConstraints = false
        setUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        // basicInfoView
        basicInfoView.translatesAutoresizingMaskIntoConstraints = false // 개인정보 View
        privacyInfo.translatesAutoresizingMaskIntoConstraints = false // 개인정보 설명 변수

        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 이름 타이틀
        nameTextFieldBackground.translatesAutoresizingMaskIntoConstraints = false // 이름 배경
        nameTextField.translatesAutoresizingMaskIntoConstraints = false // 이틈 입력 필드

        phoneNumberTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 휴대폰 타이틀
        phoneNumberTextFieldBackground.translatesAutoresizingMaskIntoConstraints = false // 휴대폰 배경
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false // 핸드폰 번호 입력 필드

        birthdayTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 생년월일 타이틀
        birthdayBackground.translatesAutoresizingMaskIntoConstraints = false // 생년월일 배경
        birthdayButton.translatesAutoresizingMaskIntoConstraints = false // 생년월일 버튼
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false // 생년월일

        ageTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 나이 타이틀
        ageBackground.translatesAutoresizingMaskIntoConstraints = false // 나이 배경
        ageLabel.translatesAutoresizingMaskIntoConstraints = false // 나이 입력 필드

        genderTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 성별 타이틀
        genderBackground.translatesAutoresizingMaskIntoConstraints = false // 성별 배경
        genderButton.translatesAutoresizingMaskIntoConstraints = false // 성별 버튼


        heightTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 키 타이틀
        heightTextFieldBackground.translatesAutoresizingMaskIntoConstraints = false // 키 배경
        heightTextField.translatesAutoresizingMaskIntoConstraints = false // 키 입력 필드

        weightTitleLabel.translatesAutoresizingMaskIntoConstraints = false // 체중 타이틀
        weightTextFieldBackground.translatesAutoresizingMaskIntoConstraints = false // 체중 배경
        weightTextField.translatesAutoresizingMaskIntoConstraints = false // 체중 입력 필드

        sleepLabel.translatesAutoresizingMaskIntoConstraints = false // 수면 타이틀
        sleepBackground.translatesAutoresizingMaskIntoConstraints = false // 수면 배경
        sleepTextField.translatesAutoresizingMaskIntoConstraints = false // 수면 입력 필드
        
        wakeupLabel.translatesAutoresizingMaskIntoConstraints = false // 기상 타이틀
        wakeupBackground.translatesAutoresizingMaskIntoConstraints = false // 기상 배경
        wakeupTextField.translatesAutoresizingMaskIntoConstraints = false // 기상 입력 필드
        
        basicInfoSaveButton.translatesAutoresizingMaskIntoConstraints = false // 기본정보 저장 버튼

        // goalView
        goalView.translatesAutoresizingMaskIntoConstraints = false // 목표량 View
        targetInfo.translatesAutoresizingMaskIntoConstraints = false // 목표량 정보

        bpmTitleLabel.translatesAutoresizingMaskIntoConstraints = false // bpm title
        bpmInfo.translatesAutoresizingMaskIntoConstraints = false // bpm 정보
        bpmBackground.translatesAutoresizingMaskIntoConstraints = false // bpm 배경
        bpmPlusButton.translatesAutoresizingMaskIntoConstraints = false // bpm plus 버튼
        bpmMinusButton.translatesAutoresizingMaskIntoConstraints = false // bpm minus 버튼
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false  // bpm 단위
        bpmTextField.translatesAutoresizingMaskIntoConstraints = false  // bpm 입력 필드

        dailyTargetStepLabel.translatesAutoresizingMaskIntoConstraints = false  // step label
        dailyTargetStepBackground.translatesAutoresizingMaskIntoConstraints = false // step 배경
        stepPlusButton.translatesAutoresizingMaskIntoConstraints = false    // step plus 버튼
        stepMinusButton.translatesAutoresizingMaskIntoConstraints = false   // step minus 버튼
        stepLabel.translatesAutoresizingMaskIntoConstraints = false     // step 단위
        stepTextField.translatesAutoresizingMaskIntoConstraints = false // step 입력 필드

        dailyTargetDistanceLabel.translatesAutoresizingMaskIntoConstraints = false  // distance label
        dailyTargetDistanceBackground.translatesAutoresizingMaskIntoConstraints = false // distance 배경
        distancePlusButton.translatesAutoresizingMaskIntoConstraints = false    // distance plus 버튼
        distanceMinusButton.translatesAutoresizingMaskIntoConstraints = false   // distance minus 버튼
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false     // distance 단위
        distanceTextField.translatesAutoresizingMaskIntoConstraints = false // distance 입력 필드

        activityCalLabel.translatesAutoresizingMaskIntoConstraints = false  // aCal label
        activityCalBackground.translatesAutoresizingMaskIntoConstraints = false     // aCal 배경
        aCalPlusButton.translatesAutoresizingMaskIntoConstraints = false    // aCal plus 버튼
        aCalMinusButton.translatesAutoresizingMaskIntoConstraints = false   // aCal minus 버튼
        aCalLabel.translatesAutoresizingMaskIntoConstraints = false     // aCal 단위
        aCalTextField.translatesAutoresizingMaskIntoConstraints = false // aCal 입력 필드

        dailyTargetCalLabel.translatesAutoresizingMaskIntoConstraints = false   // tCal label
        dailyTargetCalBackground.translatesAutoresizingMaskIntoConstraints = false  // tCal 배경
        tCalPlusButton.translatesAutoresizingMaskIntoConstraints = false    // tCal plus 버튼
        tCalMinusButton.translatesAutoresizingMaskIntoConstraints = false   // tCal minus 버튼
        tCalLabel.translatesAutoresizingMaskIntoConstraints = false     // tCal 단위
        tCalTextField.translatesAutoresizingMaskIntoConstraints = false // tCal 입력 필드
        
        goalSaveButton.translatesAutoresizingMaskIntoConstraints = false // 목표량 저장 버튼
        
        
        // setView
        setView.translatesAutoresizingMaskIntoConstraints = false
        setHelpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heartAttackBackground.translatesAutoresizingMaskIntoConstraints = false
        heartAttackLabel.translatesAutoresizingMaskIntoConstraints = false
        heartAttackFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        heartAttackFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        myoBackground.translatesAutoresizingMaskIntoConstraints = false
        myoLabel.translatesAutoresizingMaskIntoConstraints = false
        myoFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        myoFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        noncontactBackground.translatesAutoresizingMaskIntoConstraints = false
        noncontactLabel.translatesAutoresizingMaskIntoConstraints = false
        noncontactFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        noncontactFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        arrBackground.translatesAutoresizingMaskIntoConstraints = false
        arrLabel.translatesAutoresizingMaskIntoConstraints = false
        arrFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        arrFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        tarchycardiaLabel.translatesAutoresizingMaskIntoConstraints = false
        tarchycardiaBackground.translatesAutoresizingMaskIntoConstraints = false
        tarchycardiaFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        tarchycardiaFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        bradycardiaLabel.translatesAutoresizingMaskIntoConstraints = false
        bradycardiaBackground.translatesAutoresizingMaskIntoConstraints = false
        bradycardiaFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        bradycardiaFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        atrialFibrillaionLabel.translatesAutoresizingMaskIntoConstraints = false
        atrialFibrillaionBackground.translatesAutoresizingMaskIntoConstraints = false
        atrialFibrillaionFlagOnButton.translatesAutoresizingMaskIntoConstraints = false
        atrialFibrillaionFlagOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        // guardianLabel
        guardianLabel.translatesAutoresizingMaskIntoConstraints = false
        guardianInfo.translatesAutoresizingMaskIntoConstraints = false
                
        guardianAlertLabel.translatesAutoresizingMaskIntoConstraints = false
        guardianAlertBackground.translatesAutoresizingMaskIntoConstraints = false
        guardianAlertOnButton.translatesAutoresizingMaskIntoConstraints = false
        guardianAlertOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertBackground.translatesAutoresizingMaskIntoConstraints = false
        alertTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        alertPlusButton.translatesAutoresizingMaskIntoConstraints = false
        alertMinusButton.translatesAutoresizingMaskIntoConstraints = false
        alertTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guardianTelLabel.translatesAutoresizingMaskIntoConstraints = false
        guardianTelBackground.translatesAutoresizingMaskIntoConstraints = false
        guardianTelTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guardianTel2Label.translatesAutoresizingMaskIntoConstraints = false
        guardianTel2Background.translatesAutoresizingMaskIntoConstraints = false
        guardianTel2TextField.translatesAutoresizingMaskIntoConstraints = false
                        
        NSLayoutConstraint.activate([
            
            // safeAreaView
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            batProgress.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            batProgress.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: 0),
            batteryLabel.centerYAnchor.constraint(equalTo: batProgress.centerYAnchor),
            batteryLabel.trailingAnchor.constraint(equalTo: batProgress.leadingAnchor, constant: -10),
            
            scrollView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            /*-------------------- 상단 View 설정 --------------------*/

            topView.topAnchor.constraint(equalTo: containerView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            topView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            topView.heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),

            sirLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            sirLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 3),

            logoutButton.centerYAnchor.constraint(equalTo: sirLabel.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            
            logoutImage.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor, constant: -3.5),
            logoutImage.leadingAnchor.constraint(equalTo: logoutButton.trailingAnchor, constant: -25),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            emailData.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailData.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 10),

            signupDateLabel.topAnchor.constraint(equalTo: emailData.bottomAnchor, constant: 10),
            signupDateLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),

            signupDate.centerYAnchor.constraint(equalTo: signupDateLabel.centerYAnchor),
            signupDate.leadingAnchor.constraint(equalTo: signupDateLabel.trailingAnchor, constant: 10),

            /*-------------------- 버튼 View 설정 --------------------*/

            buttonView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            buttonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 60),

            // 기본정보 버튼
            basicInfoButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10),
            basicInfoButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            // 목표량
            goalButton.topAnchor.constraint(equalTo: basicInfoButton.topAnchor),
            goalButton.leadingAnchor.constraint(equalTo: basicInfoButton.trailingAnchor, constant: 10),
            
            // 설정
            setButton.topAnchor.constraint(equalTo: basicInfoButton.topAnchor),
            setButton.leadingAnchor.constraint(equalTo: goalButton.trailingAnchor, constant: 10),

            // 기본정보 언더 라인
            basiceUnderLine.topAnchor.constraint(equalTo: basicInfoButton.bottomAnchor, constant: 3),
            basiceUnderLine.leadingAnchor.constraint(equalTo: basicInfoButton.leadingAnchor),
            basiceUnderLine.trailingAnchor.constraint(equalTo: basicInfoButton.trailingAnchor),
            basiceUnderLine.heightAnchor.constraint(equalToConstant: 2),

            // 목표량 언더 라인
            goalUnderLine.topAnchor.constraint(equalTo: goalButton.bottomAnchor, constant: 3),
            goalUnderLine.leadingAnchor.constraint(equalTo: goalButton.leadingAnchor),
            goalUnderLine.trailingAnchor.constraint(equalTo: goalButton.trailingAnchor),
            goalUnderLine.heightAnchor.constraint(equalToConstant: 2),

            // 설정 언더 라인
            setUnderLine.topAnchor.constraint(equalTo: setButton.bottomAnchor, constant: 3),
            setUnderLine.leadingAnchor.constraint(equalTo: setButton.leadingAnchor),
            setUnderLine.trailingAnchor.constraint(equalTo: setButton.trailingAnchor),
            setUnderLine.heightAnchor.constraint(equalToConstant: 2),
            
            /*-------------------- 기본 정보 View --------------------*/
            basicInfoView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            basicInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            basicInfoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            basicInfoView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // 개인정보 안내
            privacyInfo.topAnchor.constraint(equalTo: basicInfoView.topAnchor),
            privacyInfo.leadingAnchor.constraint(equalTo: basicInfoButton.leadingAnchor),

            // 성명
            nameTitleLabel.topAnchor.constraint(equalTo: privacyInfo.bottomAnchor, constant: 10),
            nameTitleLabel.leadingAnchor.constraint(equalTo: privacyInfo.leadingAnchor),

            // 이름 입력 배경
            nameTextFieldBackground.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 5),
            nameTextFieldBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameTextFieldBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            nameTextFieldBackground.heightAnchor.constraint(equalToConstant: 35),

            // 이름 입력 필드
            nameTextField.topAnchor.constraint(equalTo: nameTextFieldBackground.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameTextFieldBackground.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: nameTextFieldBackground.trailingAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameTextFieldBackground.bottomAnchor),

            // 휴대폰 번호
            phoneNumberTitleLabel.topAnchor.constraint(equalTo: nameTextFieldBackground.bottomAnchor, constant: 10),
            phoneNumberTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),

            // 휴대폰 번호 입력 배경
            phoneNumberTextFieldBackground.topAnchor.constraint(equalTo: phoneNumberTitleLabel.bottomAnchor, constant: 5),
            phoneNumberTextFieldBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            phoneNumberTextFieldBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            phoneNumberTextFieldBackground.heightAnchor.constraint(equalToConstant: 35),

            // 휴대폰 번호 입력 필드
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberTextFieldBackground.topAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: phoneNumberTextFieldBackground.leadingAnchor, constant: 8),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: phoneNumberTextFieldBackground.trailingAnchor),
            phoneNumberTextField.bottomAnchor.constraint(equalTo: phoneNumberTextFieldBackground.bottomAnchor),

            // 생년 월일
            birthdayTitleLabel.topAnchor.constraint(equalTo: phoneNumberTextFieldBackground.bottomAnchor, constant: 10),
            birthdayTitleLabel.leadingAnchor.constraint(equalTo: phoneNumberTitleLabel.leadingAnchor),

            // 생년 월일 배경
            birthdayBackground.topAnchor.constraint(equalTo: birthdayTitleLabel.bottomAnchor, constant: 5),
            birthdayBackground.leadingAnchor.constraint(equalTo: birthdayTitleLabel.leadingAnchor),
            birthdayBackground.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor,constant: -10),
            birthdayBackground.heightAnchor.constraint(equalToConstant: 35),

            // 생년 월일 버튼
            birthdayButton.topAnchor.constraint(equalTo: birthdayBackground.topAnchor),
            birthdayButton.leadingAnchor.constraint(equalTo: birthdayBackground.leadingAnchor, constant: 8),
            birthdayButton.bottomAnchor.constraint(equalTo: birthdayBackground.bottomAnchor),

            // 생년 월일
            birthdayLabel.topAnchor.constraint(equalTo: birthdayBackground.topAnchor),
            birthdayLabel.leadingAnchor.constraint(equalTo: birthdayTitleLabel.trailingAnchor, constant: 8),
            birthdayLabel.bottomAnchor.constraint(equalTo: birthdayBackground.bottomAnchor),

            // 나이
            ageTitleLabel.topAnchor.constraint(equalTo: phoneNumberTextFieldBackground.bottomAnchor, constant: 10),
            ageTitleLabel.leadingAnchor.constraint(equalTo: birthdayBackground.trailingAnchor, constant: 10),

            // 나이 배경
            ageBackground.topAnchor.constraint(equalTo: ageTitleLabel.bottomAnchor, constant: 5),
            ageBackground.leadingAnchor.constraint(equalTo: ageTitleLabel.leadingAnchor),
            ageBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            ageBackground.heightAnchor.constraint(equalToConstant: 35),

            // 나이 입력 필드
            ageLabel.topAnchor.constraint(equalTo: ageBackground.topAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: ageBackground.leadingAnchor, constant: 8),
            ageLabel.trailingAnchor.constraint(equalTo: ageBackground.trailingAnchor),
            ageLabel.bottomAnchor.constraint(equalTo: ageBackground.bottomAnchor),

            // 키
            heightTitleLabel.topAnchor.constraint(equalTo: birthdayBackground.bottomAnchor, constant: 10),
            heightTitleLabel.leadingAnchor.constraint(equalTo: heightTextFieldBackground.leadingAnchor),

            // 키 배경
            heightTextFieldBackground.topAnchor.constraint(equalTo: heightTitleLabel.bottomAnchor, constant: 5),
            heightTextFieldBackground.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightTextFieldBackground.heightAnchor.constraint(equalToConstant: 35),
            // view 정중앙 값에서 왼쪽 너비 값 20 오른쪽 너비 값 20 을 빼고 3개의 content가 들어가므로 각 content 사이의 값 20(10+10)을 빼고 3을 나누어 주었음
            // 3개의 컨텐츠를 균등하게 배분하기 위함(stackview써도 됨)
            heightTextFieldBackground.widthAnchor.constraint(equalToConstant: (view.frame.width-60)/3),

            // 키 입력 필드
            heightTextField.topAnchor.constraint(equalTo: heightTextFieldBackground.topAnchor),
            heightTextField.leadingAnchor.constraint(equalTo: heightTextFieldBackground.leadingAnchor, constant: 8),
            heightTextField.trailingAnchor.constraint(equalTo: heightTextFieldBackground.trailingAnchor),
            heightTextField.bottomAnchor.constraint(equalTo: heightTextFieldBackground.bottomAnchor),

            // 성별
            genderTitleLabel.topAnchor.constraint(equalTo: birthdayBackground.bottomAnchor, constant: 10),
            genderTitleLabel.leadingAnchor.constraint(equalTo: birthdayTitleLabel.leadingAnchor),

            // 성별 배경
            genderBackground.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 5),
            genderBackground.trailingAnchor.constraint(equalTo: heightTextFieldBackground.leadingAnchor, constant: -10),
            genderBackground.heightAnchor.constraint(equalToConstant: 35),
            genderBackground.widthAnchor.constraint(equalToConstant: (view.frame.width-60)/3),

            // 성별 버튼
            genderButton.topAnchor.constraint(equalTo: genderBackground.topAnchor),
            genderButton.leadingAnchor.constraint(equalTo: genderBackground.leadingAnchor, constant: 8),
            genderButton.bottomAnchor.constraint(equalTo: genderBackground.bottomAnchor),

            // 체중
            weightTitleLabel.topAnchor.constraint(equalTo: birthdayBackground.bottomAnchor, constant: 10),
            weightTitleLabel.leadingAnchor.constraint(equalTo: heightTextFieldBackground.trailingAnchor, constant: 10),

            // 체중 배경
            weightTextFieldBackground.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor, constant: 5),
            weightTextFieldBackground.leadingAnchor.constraint(equalTo: heightTextFieldBackground.trailingAnchor, constant: 10),
            weightTextFieldBackground.heightAnchor.constraint(equalToConstant: 35),
            weightTextFieldBackground.widthAnchor.constraint(equalToConstant: (view.frame.width-60)/3),

            // 체중 입력 필드
            weightTextField.topAnchor.constraint(equalTo: weightTextFieldBackground.topAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: weightTextFieldBackground.leadingAnchor, constant: 8),
            weightTextField.trailingAnchor.constraint(equalTo: weightTextFieldBackground.trailingAnchor),
            weightTextField.bottomAnchor.constraint(equalTo: weightTextFieldBackground.bottomAnchor),
            
            // 수면 시간
            sleepLabel.topAnchor.constraint(equalTo: genderBackground.bottomAnchor, constant: 10),
            sleepLabel.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            
            // 수면 배경
            sleepBackground.topAnchor.constraint(equalTo: sleepLabel.bottomAnchor, constant: 5),
            sleepBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            sleepBackground.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -5),
            sleepBackground.heightAnchor.constraint(equalToConstant: 35),
            
            // 수면 입력 필드
            sleepTextField.topAnchor.constraint(equalTo: sleepBackground.topAnchor),
            sleepTextField.leadingAnchor.constraint(equalTo: sleepBackground.leadingAnchor, constant: 8),
            sleepTextField.trailingAnchor.constraint(equalTo: sleepBackground.trailingAnchor),
            sleepTextField.bottomAnchor.constraint(equalTo: sleepBackground.bottomAnchor),

            // 기상 시간
            wakeupLabel.topAnchor.constraint(equalTo: genderBackground.bottomAnchor, constant: 10),
            wakeupLabel.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 5),
            
            // 기상 배경
            wakeupBackground.topAnchor.constraint(equalTo: wakeupLabel.bottomAnchor, constant: 5),
            wakeupBackground.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 5),
            wakeupBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            wakeupBackground.heightAnchor.constraint(equalToConstant: 35),
            
            // 기상 입력 필드
            wakeupTextField.topAnchor.constraint(equalTo: wakeupBackground.topAnchor),
            wakeupTextField.leadingAnchor.constraint(equalTo: wakeupBackground.leadingAnchor, constant: 8),
            wakeupTextField.trailingAnchor.constraint(equalTo: wakeupBackground.trailingAnchor),
            wakeupTextField.bottomAnchor.constraint(equalTo: wakeupBackground.bottomAnchor),
            
            // 기본정보 저장 버튼
            basicInfoSaveButton.topAnchor.constraint(equalTo: sleepBackground.bottomAnchor, constant: 20),
//            basicInfoSaveButton.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor,constant: -10),
            basicInfoSaveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            basicInfoSaveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            basicInfoSaveButton.heightAnchor.constraint(equalToConstant: 40),

            /*-------------------- 목표 량 View --------------------*/
            goalView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            goalView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            goalView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            goalView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // 목표량 정보
            targetInfo.topAnchor.constraint(equalTo: goalView.topAnchor, constant: 0),
            targetInfo.leadingAnchor.constraint(equalTo: goalView.leadingAnchor, constant: 20),

            // bpm Title
            bpmTitleLabel.topAnchor.constraint(equalTo: targetInfo.bottomAnchor, constant: 10),
            bpmTitleLabel.leadingAnchor.constraint(equalTo: targetInfo.leadingAnchor),

            // bpm info
            bpmInfo.topAnchor.constraint(equalTo: bpmTitleLabel.bottomAnchor),
            bpmInfo.leadingAnchor.constraint(equalTo: bpmTitleLabel.leadingAnchor),

            // bpm 배경
            bpmBackground.topAnchor.constraint(equalTo: bpmInfo.bottomAnchor,constant: 10),
            bpmBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            bpmBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            bpmBackground.heightAnchor.constraint(equalToConstant: 40),

            // bpm plus button
            bpmPlusButton.topAnchor.constraint(equalTo: bpmBackground.topAnchor),
            bpmPlusButton.trailingAnchor.constraint(equalTo: bpmBackground.trailingAnchor, constant: -15),
            bpmPlusButton.bottomAnchor.constraint(equalTo: bpmBackground.bottomAnchor),

            // bpm Minus button
            bpmMinusButton.topAnchor.constraint(equalTo: bpmBackground.topAnchor),
            bpmMinusButton.leadingAnchor.constraint(equalTo: bpmBackground.leadingAnchor, constant: 15),
            bpmMinusButton.bottomAnchor.constraint(equalTo: bpmBackground.bottomAnchor),

            // bpm label
            bpmLabel.centerYAnchor.constraint(equalTo: bpmBackground.centerYAnchor),
            bpmLabel.trailingAnchor.constraint(equalTo: bpmPlusButton.leadingAnchor, constant: -5),

            // bpm Textfield
            bpmTextField.centerXAnchor.constraint(equalTo: bpmBackground.centerXAnchor),
            bpmTextField.centerYAnchor.constraint(equalTo: bpmBackground.centerYAnchor),

            // 일일 목표 걸음수 라벨
            dailyTargetStepLabel.topAnchor.constraint(equalTo: bpmBackground.bottomAnchor, constant: 10),
            dailyTargetStepLabel.leadingAnchor.constraint(equalTo: bpmBackground.leadingAnchor),

            // 일일 목표 걸음수 배경
            dailyTargetStepBackground.topAnchor.constraint(equalTo: dailyTargetStepLabel.bottomAnchor, constant: 10),
            dailyTargetStepBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dailyTargetStepBackground.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -5),
            dailyTargetStepBackground.heightAnchor.constraint(equalToConstant: 40),

            // step plus button
            stepPlusButton.topAnchor.constraint(equalTo: dailyTargetStepBackground.topAnchor),
            stepPlusButton.trailingAnchor.constraint(equalTo: dailyTargetStepBackground.trailingAnchor, constant: -15),
            stepPlusButton.bottomAnchor.constraint(equalTo: dailyTargetStepBackground.bottomAnchor),

            // step Minus button
            stepMinusButton.topAnchor.constraint(equalTo: dailyTargetStepBackground.topAnchor),
            stepMinusButton.leadingAnchor.constraint(equalTo: dailyTargetStepBackground.leadingAnchor, constant: 15),
            stepMinusButton.bottomAnchor.constraint(equalTo: dailyTargetStepBackground.bottomAnchor),

            // step Label
            stepLabel.centerYAnchor.constraint(equalTo: dailyTargetStepBackground.centerYAnchor),
            stepLabel.trailingAnchor.constraint(equalTo: stepPlusButton.leadingAnchor, constant: -5),

            // step Textfield
            stepTextField.trailingAnchor.constraint(equalTo: stepLabel.leadingAnchor, constant: -5),
            stepTextField.centerYAnchor.constraint(equalTo: dailyTargetStepBackground.centerYAnchor),

            // 일일 목표 걸음거리 라벨
            dailyTargetDistanceLabel.topAnchor.constraint(equalTo: bpmBackground.bottomAnchor, constant: 10),
            dailyTargetDistanceLabel.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 5),

            // 일일 목표 걸음거리 배경
            dailyTargetDistanceBackground.topAnchor.constraint(equalTo: dailyTargetDistanceLabel.bottomAnchor, constant: 10),
            dailyTargetDistanceBackground.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 5),
            dailyTargetDistanceBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dailyTargetDistanceBackground.heightAnchor.constraint(equalToConstant: 40),

            // distance plus button
            distancePlusButton.topAnchor.constraint(equalTo: dailyTargetDistanceBackground.topAnchor),
            distancePlusButton.trailingAnchor.constraint(equalTo: dailyTargetDistanceBackground.trailingAnchor, constant: -15),
            distancePlusButton.bottomAnchor.constraint(equalTo: dailyTargetDistanceBackground.bottomAnchor),

            // distance Minus button
            distanceMinusButton.topAnchor.constraint(equalTo: dailyTargetDistanceBackground.topAnchor),
            distanceMinusButton.leadingAnchor.constraint(equalTo: dailyTargetDistanceBackground.leadingAnchor, constant: 15),
            distanceMinusButton.bottomAnchor.constraint(equalTo: dailyTargetDistanceBackground.bottomAnchor),

            // distance label
            distanceLabel.centerYAnchor.constraint(equalTo: dailyTargetDistanceBackground.centerYAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: distancePlusButton.leadingAnchor, constant: -10),

            // distance Textfield
            distanceTextField.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -5),
            distanceTextField.centerYAnchor.constraint(equalTo: dailyTargetDistanceBackground.centerYAnchor),

            // 활동 칼로리 라벨
            activityCalLabel.topAnchor.constraint(equalTo: dailyTargetStepBackground.bottomAnchor, constant: 10),
            activityCalLabel.leadingAnchor.constraint(equalTo: dailyTargetStepBackground.leadingAnchor),

            // 활동 칼로리 배경
            activityCalBackground.topAnchor.constraint(equalTo: activityCalLabel.bottomAnchor, constant: 10),
            activityCalBackground.leadingAnchor.constraint(equalTo: dailyTargetStepBackground.leadingAnchor),
            activityCalBackground.trailingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: -5),
            activityCalBackground.heightAnchor.constraint(equalToConstant: 40),

            // aCal plus button
            aCalPlusButton.topAnchor.constraint(equalTo: activityCalBackground.topAnchor),
            aCalPlusButton.trailingAnchor.constraint(equalTo: activityCalBackground.trailingAnchor, constant: -15),
            aCalPlusButton.bottomAnchor.constraint(equalTo: activityCalBackground.bottomAnchor),

            // aCal Minus button
            aCalMinusButton.topAnchor.constraint(equalTo: activityCalBackground.topAnchor),
            aCalMinusButton.leadingAnchor.constraint(equalTo: activityCalBackground.leadingAnchor, constant: 15),
            aCalMinusButton.bottomAnchor.constraint(equalTo: activityCalBackground.bottomAnchor),

            // aCal label
            aCalLabel.centerYAnchor.constraint(equalTo: activityCalBackground.centerYAnchor),
            aCalLabel.trailingAnchor.constraint(equalTo: aCalPlusButton.leadingAnchor, constant: -5),

            // aCal Textfield
            aCalTextField.trailingAnchor.constraint(equalTo: aCalLabel.leadingAnchor, constant: -5),
            aCalTextField.centerYAnchor.constraint(equalTo: activityCalBackground.centerYAnchor),

            // 일일 목표 소비칼로리 라벨
            dailyTargetCalLabel.topAnchor.constraint(equalTo: dailyTargetStepBackground.bottomAnchor, constant: 10),
            dailyTargetCalLabel.leadingAnchor.constraint(equalTo: dailyTargetDistanceBackground.leadingAnchor),

            // 일일 목표 소비칼로리 배경
            dailyTargetCalBackground.topAnchor.constraint(equalTo: dailyTargetCalLabel.bottomAnchor, constant: 10),
            dailyTargetCalBackground.leadingAnchor.constraint(equalTo: dailyTargetCalLabel.leadingAnchor),
            dailyTargetCalBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dailyTargetCalBackground.heightAnchor.constraint(equalToConstant: 40),

            // tCal plus button
            tCalPlusButton.topAnchor.constraint(equalTo: dailyTargetCalBackground.topAnchor),
            tCalPlusButton.trailingAnchor.constraint(equalTo: dailyTargetCalBackground.trailingAnchor, constant: -15),
            tCalPlusButton.bottomAnchor.constraint(equalTo: dailyTargetCalBackground.bottomAnchor),

            // tCal Minus button
            tCalMinusButton.topAnchor.constraint(equalTo: dailyTargetCalBackground.topAnchor),
            tCalMinusButton.leadingAnchor.constraint(equalTo: dailyTargetCalBackground.leadingAnchor, constant: 15),
            tCalMinusButton.bottomAnchor.constraint(equalTo: dailyTargetCalBackground.bottomAnchor),

            // tcal label
            tCalLabel.centerYAnchor.constraint(equalTo: dailyTargetCalBackground.centerYAnchor),
            tCalLabel.trailingAnchor.constraint(equalTo: tCalPlusButton.leadingAnchor, constant: -5),

            // tcal TextField
            tCalTextField.trailingAnchor.constraint(equalTo: tCalLabel.leadingAnchor, constant: -5),
            tCalTextField.centerYAnchor.constraint(equalTo: dailyTargetCalBackground.centerYAnchor),

            // 목표량 저장 버튼
            goalSaveButton.topAnchor.constraint(equalTo: activityCalBackground.bottomAnchor, constant: 20),
//            goalSaveButton.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: -10),
            goalSaveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            goalSaveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            goalSaveButton.heightAnchor.constraint(equalToConstant: 40),
            
            /*-------------------- 설정 View --------------------*/
            setView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            setView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            setView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            setView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // 도움말
            setHelpLabel.topAnchor.constraint(equalTo: setView.topAnchor, constant: 0),
            setHelpLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 20),
            
            // 응급상황
            heartAttackLabel.topAnchor.constraint(equalTo: setHelpLabel.bottomAnchor, constant: 20),
            heartAttackLabel.leadingAnchor.constraint(equalTo: setHelpLabel.leadingAnchor, constant: 0),
            
            heartAttackBackground.topAnchor.constraint(equalTo: heartAttackLabel.bottomAnchor, constant: 10),
            heartAttackBackground.leadingAnchor.constraint(equalTo: heartAttackLabel.leadingAnchor),
            heartAttackBackground.trailingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: -10),
            heartAttackBackground.heightAnchor.constraint(equalToConstant: 40),
            
            heartAttackFlagOnButton.centerYAnchor.constraint(equalTo: heartAttackBackground.centerYAnchor),
            heartAttackFlagOnButton.centerXAnchor.constraint(equalTo: heartAttackBackground.centerXAnchor, constant: 30),
            heartAttackFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            heartAttackFlagOffButton.centerYAnchor.constraint(equalTo: heartAttackBackground.centerYAnchor),
            heartAttackFlagOffButton.centerXAnchor.constraint(equalTo: heartAttackBackground.centerXAnchor, constant: -30),
            heartAttackFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 비정상맥박
            arrLabel.topAnchor.constraint(equalTo: setHelpLabel.bottomAnchor, constant: 20),
            arrLabel.leadingAnchor.constraint(equalTo: arrBackground.leadingAnchor, constant: 0),
            
            arrBackground.topAnchor.constraint(equalTo: arrLabel.bottomAnchor, constant: 10),
            arrBackground.leadingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: 10),
            arrBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            arrBackground.heightAnchor.constraint(equalToConstant: 40),
          
            arrFlagOnButton.centerYAnchor.constraint(equalTo: arrBackground.centerYAnchor),
            arrFlagOnButton.centerXAnchor.constraint(equalTo: arrBackground.centerXAnchor, constant: 30),
            arrFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            arrFlagOffButton.centerYAnchor.constraint(equalTo: arrBackground.centerYAnchor),
            arrFlagOffButton.centerXAnchor.constraint(equalTo: arrBackground.centerXAnchor, constant: -30),
            arrFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 근전도
            myoLabel.topAnchor.constraint(equalTo: heartAttackBackground.bottomAnchor, constant: 10),
            myoLabel.leadingAnchor.constraint(equalTo: heartAttackBackground.leadingAnchor, constant: 0),
            
            myoBackground.topAnchor.constraint(equalTo: myoLabel.bottomAnchor, constant: 10),
            myoBackground.leadingAnchor.constraint(equalTo: myoLabel.leadingAnchor),
            myoBackground.trailingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: -10),
            myoBackground.heightAnchor.constraint(equalToConstant: 40),
            
            myoFlagOnButton.centerYAnchor.constraint(equalTo: myoBackground.centerYAnchor),
            myoFlagOnButton.centerXAnchor.constraint(equalTo: myoBackground.centerXAnchor, constant: 30),
            myoFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            myoFlagOffButton.centerYAnchor.constraint(equalTo: myoBackground.centerYAnchor),
            myoFlagOffButton.centerXAnchor.constraint(equalTo: myoBackground.centerXAnchor, constant: -30),
            myoFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 전극 떨어짐
            noncontactLabel.topAnchor.constraint(equalTo: arrBackground.bottomAnchor, constant: 10),
            noncontactLabel.leadingAnchor.constraint(equalTo: arrBackground.leadingAnchor, constant: 0),
            
            noncontactBackground.topAnchor.constraint(equalTo: noncontactLabel.bottomAnchor, constant: 10),
            noncontactBackground.leadingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: 10),
            noncontactBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            noncontactBackground.heightAnchor.constraint(equalToConstant: 40),
            
            noncontactFlagOnButton.centerYAnchor.constraint(equalTo: noncontactBackground.centerYAnchor),
            noncontactFlagOnButton.centerXAnchor.constraint(equalTo: noncontactBackground.centerXAnchor, constant: 30),
            noncontactFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            noncontactFlagOffButton.centerYAnchor.constraint(equalTo: noncontactBackground.centerYAnchor),
            noncontactFlagOffButton.centerXAnchor.constraint(equalTo: noncontactBackground.centerXAnchor, constant: -30),
            noncontactFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 빈맥
            tarchycardiaLabel.topAnchor.constraint(equalTo: myoBackground.bottomAnchor, constant: 10),
            tarchycardiaLabel.leadingAnchor.constraint(equalTo: myoBackground.leadingAnchor, constant: 0),
            
            tarchycardiaBackground.topAnchor.constraint(equalTo: tarchycardiaLabel.bottomAnchor, constant: 10),
            tarchycardiaBackground.leadingAnchor.constraint(equalTo: myoBackground.leadingAnchor),
            tarchycardiaBackground.trailingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: -10),
            tarchycardiaBackground.heightAnchor.constraint(equalToConstant: 40),
            
            tarchycardiaFlagOnButton.centerYAnchor.constraint(equalTo: tarchycardiaBackground.centerYAnchor),
            tarchycardiaFlagOnButton.centerXAnchor.constraint(equalTo: tarchycardiaBackground.centerXAnchor, constant: 30),
            tarchycardiaFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            tarchycardiaFlagOffButton.centerYAnchor.constraint(equalTo: tarchycardiaBackground.centerYAnchor),
            tarchycardiaFlagOffButton.centerXAnchor.constraint(equalTo: tarchycardiaBackground.centerXAnchor, constant: -30),
            tarchycardiaFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 서맥
            bradycardiaLabel.topAnchor.constraint(equalTo: noncontactBackground.bottomAnchor, constant: 10),
            bradycardiaLabel.leadingAnchor.constraint(equalTo: noncontactBackground.leadingAnchor, constant: 0),
            
            bradycardiaBackground.topAnchor.constraint(equalTo: bradycardiaLabel.bottomAnchor, constant: 10),
            bradycardiaBackground.leadingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: 10),
            bradycardiaBackground.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -20),
            bradycardiaBackground.heightAnchor.constraint(equalToConstant: 40),
            
            bradycardiaFlagOnButton.centerYAnchor.constraint(equalTo: bradycardiaBackground.centerYAnchor),
            bradycardiaFlagOnButton.centerXAnchor.constraint(equalTo: bradycardiaBackground.centerXAnchor, constant: 30),
            bradycardiaFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            bradycardiaFlagOffButton.centerYAnchor.constraint(equalTo: bradycardiaBackground.centerYAnchor),
            bradycardiaFlagOffButton.centerXAnchor.constraint(equalTo: bradycardiaBackground.centerXAnchor, constant: -30),
            bradycardiaFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 심박세동
            atrialFibrillaionLabel.topAnchor.constraint(equalTo: tarchycardiaBackground.bottomAnchor, constant: 10),
            atrialFibrillaionLabel.leadingAnchor.constraint(equalTo: tarchycardiaBackground.leadingAnchor, constant: 0),
            
            atrialFibrillaionBackground.topAnchor.constraint(equalTo: atrialFibrillaionLabel.bottomAnchor, constant: 10),
            atrialFibrillaionBackground.leadingAnchor.constraint(equalTo: tarchycardiaBackground.leadingAnchor),
            atrialFibrillaionBackground.trailingAnchor.constraint(equalTo: safeAreaView.centerXAnchor, constant: -10),
            atrialFibrillaionBackground.heightAnchor.constraint(equalToConstant: 40),
            
            atrialFibrillaionFlagOnButton.centerYAnchor.constraint(equalTo: atrialFibrillaionBackground.centerYAnchor),
            atrialFibrillaionFlagOnButton.centerXAnchor.constraint(equalTo: atrialFibrillaionBackground.centerXAnchor, constant: 30),
            atrialFibrillaionFlagOnButton.heightAnchor.constraint(equalToConstant: 30),
            
            atrialFibrillaionFlagOffButton.centerYAnchor.constraint(equalTo: atrialFibrillaionBackground.centerYAnchor),
            atrialFibrillaionFlagOffButton.centerXAnchor.constraint(equalTo: atrialFibrillaionBackground.centerXAnchor, constant: -30),
            atrialFibrillaionFlagOffButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            /*-------------------- 알림 View --------------------*/
            
            // 보호자 SMS 알림 / Info
            guardianLabel.topAnchor.constraint(equalTo: atrialFibrillaionBackground.bottomAnchor, constant: 20),
            guardianLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 20),
            
            guardianInfo.topAnchor.constraint(equalTo: guardianLabel.bottomAnchor, constant: 20),
            guardianInfo.leadingAnchor.constraint(equalTo: guardianLabel.leadingAnchor),
            
            // 보호자 알림 기능
            guardianAlertLabel.topAnchor.constraint(equalTo: guardianInfo.bottomAnchor, constant: 20),
            guardianAlertLabel.leadingAnchor.constraint(equalTo: guardianInfo.leadingAnchor),
            
            guardianAlertBackground.topAnchor.constraint(equalTo: guardianAlertLabel.bottomAnchor, constant: 10),
            guardianAlertBackground.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 20),
            guardianAlertBackground.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -20),
            guardianAlertBackground.heightAnchor.constraint(equalToConstant: 40),
            
            guardianAlertOnButton.topAnchor.constraint(equalTo: guardianAlertBackground.topAnchor, constant: 5),
            guardianAlertOnButton.leadingAnchor.constraint(equalTo: guardianAlertBackground.centerXAnchor, constant: 30),
            guardianAlertOnButton.trailingAnchor.constraint(equalTo: guardianAlertBackground.trailingAnchor, constant: -30),
            guardianAlertOnButton.bottomAnchor.constraint(equalTo: guardianAlertBackground.bottomAnchor, constant: -5),
            
            
            guardianAlertOffButton.topAnchor.constraint(equalTo: guardianAlertBackground.topAnchor, constant: 5),
            guardianAlertOffButton.leadingAnchor.constraint(equalTo: guardianAlertBackground.leadingAnchor, constant: 30),
            guardianAlertOffButton.trailingAnchor.constraint(equalTo: guardianAlertBackground.centerXAnchor, constant: -30),
            guardianAlertOffButton.bottomAnchor.constraint(equalTo: guardianAlertBackground.bottomAnchor, constant: -5),
            
            // 알림발생 기준 횟수
            alertLabel.topAnchor.constraint(equalTo: guardianAlertBackground.bottomAnchor, constant: 10),
            alertLabel.leadingAnchor.constraint(equalTo: guardianAlertLabel.leadingAnchor),
            
            alertBackground.topAnchor.constraint(equalTo: alertLabel.bottomAnchor, constant: 10),
            alertBackground.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 20),
            alertBackground.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -20),
            alertBackground.heightAnchor.constraint(equalToConstant: 40),
            
            
            alertPlusButton.topAnchor.constraint(equalTo: alertBackground.topAnchor),
            alertPlusButton.trailingAnchor.constraint(equalTo: alertBackground.trailingAnchor, constant: -15),
            alertPlusButton.bottomAnchor.constraint(equalTo: alertBackground.bottomAnchor),
            
            alertMinusButton.topAnchor.constraint(equalTo: alertBackground.topAnchor),
            alertMinusButton.leadingAnchor.constraint(equalTo: alertBackground.leadingAnchor, constant: 15),
            alertMinusButton.bottomAnchor.constraint(equalTo: alertBackground.bottomAnchor),
            
            alertTimeLabel.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
            alertTimeLabel.trailingAnchor.constraint(equalTo: alertPlusButton.leadingAnchor, constant: -5),
            
            alertTextField.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor),
            alertTextField.centerYAnchor.constraint(equalTo: alertBackground.centerYAnchor),
            
            // 보호자 연락처 1
            guardianTelLabel.topAnchor.constraint(equalTo: alertBackground.bottomAnchor, constant: 10),
            guardianTelLabel.leadingAnchor.constraint(equalTo: guardianAlertLabel.leadingAnchor),
            
            guardianTelBackground.topAnchor.constraint(equalTo: guardianTelLabel.bottomAnchor, constant: 10),
            guardianTelBackground.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 20),
            guardianTelBackground.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -20),
            guardianTelBackground.heightAnchor.constraint(equalToConstant: 40),
            
            guardianTelTextField.topAnchor.constraint(equalTo: guardianTelBackground.topAnchor),
            guardianTelTextField.leadingAnchor.constraint(equalTo: guardianTelBackground.leadingAnchor, constant: 8),
            guardianTelTextField.trailingAnchor.constraint(equalTo: guardianTelBackground.trailingAnchor),
            guardianTelTextField.bottomAnchor.constraint(equalTo: guardianTelBackground.bottomAnchor),
            
            // 보호자 연락처 2
            guardianTel2Label.topAnchor.constraint(equalTo: guardianTelBackground.bottomAnchor, constant: 10),
            guardianTel2Label.leadingAnchor.constraint(equalTo: guardianAlertLabel.leadingAnchor),
            
            guardianTel2Background.topAnchor.constraint(equalTo: guardianTel2Label.bottomAnchor, constant: 10),
            guardianTel2Background.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 20),
            guardianTel2Background.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -20),
            guardianTel2Background.heightAnchor.constraint(equalToConstant: 40),
            
            guardianTel2TextField.topAnchor.constraint(equalTo: guardianTel2Background.topAnchor),
            guardianTel2TextField.leadingAnchor.constraint(equalTo: guardianTel2Background.leadingAnchor, constant: 8),
            guardianTel2TextField.trailingAnchor.constraint(equalTo: guardianTelBackground.trailingAnchor),
            guardianTel2TextField.bottomAnchor.constraint(equalTo: guardianTel2Background.bottomAnchor),
        ])
    }
    
    // MARK: textField event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // name
        if textField.tag == 1 {
            nameTextField.placeholder = ""
        }
        // phoneNumber
        else if textField.tag == 2 {
            phoneNumberTextField.placeholder = ""
        }
        // height
        else if textField.tag == 3 {
            heightTextField.placeholder = ""
        }
        // weight
        else if textField.tag == 4 {
            weightTextField.placeholder = ""
        }
        // Bpm
        else if textField.tag == 5 {
            bpmTextField.placeholder = ""
        }
        // Step
        else if textField.tag == 6 {
            stepTextField.placeholder = ""
        }
        // Distance
        else if textField.tag == 7 {
            distanceTextField.placeholder = ""
        }
        // ACal
        else if textField.tag == 8 {
            aCalTextField.placeholder = ""
        }
        // TCal
        else if textField.tag == 9 {
            tCalTextField.placeholder = ""
        }
        // guardianTel
        else if textField.tag == 33 {
            guardianTelTextField.placeholder = ""
        }
        // guardianTel2
        else if textField.tag == 44 {
            guardianTel2TextField.placeholder = ""
        }
        // sleep
        else if textField.tag == 111 {
            sleepTextField.placeholder = ""
        }
        // wakeup
        else if textField.tag == 222 {
            wakeupTextField.placeholder = ""
        }
    }
    
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        // name
        if textField.tag == 1 {
            
            if(txt.count > 0){
                if let _ = nameRegex?.firstMatch(in: myName, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    nameTextField.text = ""
                    myName = "LOOKHEART"
                    showRegexViolationAlert(type: "name")
                }
            }
            
            if(nameTextField.placeholder == ""){
                nameTextField.placeholder = UserDefaults.standard.string(forKey: "name") ?? "이름을 입력해주세요"
            }
        }
        // phoneNumber
        else if textField.tag == 2 {
            
            if(txt.count > 0){
                if let _ = phoneNumberRegex?.firstMatch(in: myPhoneNumber, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    phoneNumberTextField.text = ""
                    myPhoneNumber = "01012345678"
                    showRegexViolationAlert(type: "phoneNumber")
                }
            }
            
            if(phoneNumberTextField.placeholder == ""){
                
                var hypenPhoneNumber = UserDefaults.standard.string(forKey: "PhoneNumber")!
                hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
                hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
                
                phoneNumberTextField.placeholder = hypenPhoneNumber
            }
        }
        // height
        else if textField.tag == 3 {
            
            if(txt.count > 0){
                if let _ = heightAndWeightRegex?.firstMatch(in: myHeight, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    heightTextField.text = ""
                    myHeight = "170"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(heightTextField.placeholder == ""){
                heightTextField.placeholder = UserDefaults.standard.string(forKey: "Height") ?? "키 입력"
            }
        }
        // weight
        else if textField.tag == 4 {
            
            if(txt.count > 0){
                if let _ = heightAndWeightRegex?.firstMatch(in: myWeight, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    weightTextField.text = ""
                    myWeight = "77"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(weightTextField.placeholder == ""){
                weightTextField.placeholder = UserDefaults.standard.string(forKey: "Weight") ?? "체중 입력"
            }
        }
        // Bpm
        else if textField.tag == 5 {
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: myBpm, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    bpmTextField.text = ""
                    myBpm = "90"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(bpmTextField.placeholder == ""){
                bpmTextField.placeholder = UserDefaults.standard.string(forKey: "eCalBpm") ?? "bpm 입력"
            }
        }

        // Step
        else if textField.tag == 6 {
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: myStep, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    stepTextField.text = ""
                    myStep = "2000"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(stepTextField.placeholder == ""){
                stepTextField.placeholder = UserDefaults.standard.string(forKey: "TargetStep") ?? "걸음수 입력"
            }
        }
        // Distance
        else if textField.tag == 7 {
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: myDistance, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    distanceTextField.text = ""
                    myDistance = "5"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(distanceTextField.placeholder == ""){
                distanceTextField.placeholder = UserDefaults.standard.string(forKey: "TargetDistance") ?? "거리 입력"
            }
        }
        // ACal
        else if textField.tag == 8 {
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: myACal, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    aCalTextField.text = ""
                    myACal = "500"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(aCalTextField.placeholder == ""){
                aCalTextField.placeholder = UserDefaults.standard.string(forKey: "TargeteCal") ?? "칼로리 입력"
            }
        }
        // TCal
        else if textField.tag == 9 {
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: myTCal, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    tCalTextField.text = ""
                    myTCal = "3000"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(tCalTextField.placeholder == ""){
                tCalTextField.placeholder = UserDefaults.standard.string(forKey: "TargettCal") ?? "칼로리 입력"
            }
        }
        // guardianTel
        else if textField.tag == 33 {
            print(guardianTelTextField.text!)
            if(txt.count > 0){
                if let _ = phoneNumberRegex?.firstMatch(in: guardianTel, options: [], range: NSRange(location: 0, length: txt.count)){
                    UserDefaults.standard.set(guardianTel, forKey: "guardianTel1")
                    var hypenPhoneNumber = UserDefaults.standard.string(forKey: "guardianTel1")!
                    hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
                    hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
                    guardianTelTextField.text = hypenPhoneNumber
                }
                else{
                    guardianTelTextField.text = ""
                    guardianTel = "01012345678"
                    showRegexViolationAlert(type: "phoneNumber")
                }
            }
            
            if(guardianTelTextField.placeholder == ""){
                
                var hypenPhoneNumber = UserDefaults.standard.string(forKey: "guardianTel1")!
                hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
                hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
                
                guardianTelTextField.placeholder = hypenPhoneNumber
                guardianTelTextField.text = hypenPhoneNumber
            }
        }
        // guardianTel2
        else if textField.tag == 44 {
            if(txt.count > 0){
                if let _ = phoneNumberRegex?.firstMatch(in: guardianTel2, options: [], range: NSRange(location: 0, length: txt.count)){
                    UserDefaults.standard.set(guardianTel2, forKey: "guardianTel2")
                    
                    var hypenPhoneNumber = UserDefaults.standard.string(forKey: "guardianTel2")!
                    hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
                    hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
                    guardianTel2TextField.text = hypenPhoneNumber
                }
                else{
                    guardianTel2TextField.text = ""
                    guardianTel2 = "01012345678"
                    showRegexViolationAlert(type: "phoneNumber")
                }
            }
            
            if(guardianTel2TextField.placeholder == ""){
                
                var hypenPhoneNumber = UserDefaults.standard.string(forKey: "guardianTel2")!
                hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.startIndex, offsetBy: 3))
                hypenPhoneNumber.insert("-", at: hypenPhoneNumber.index(hypenPhoneNumber.endIndex, offsetBy: -4))
                
                guardianTel2TextField.placeholder = hypenPhoneNumber
            }
        }
        // sleep
        else if textField.tag == 111{
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: mySleep, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    sleepTextField.text = ""
                    myStep = "23"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(sleepTextField.placeholder == ""){
                sleepTextField.placeholder = UserDefaults.standard.string(forKey: "SleepTime") ?? "취침시간 입력"
            }
        }
        // wakeup
        else if textField.tag == 222{
            
            if(txt.count > 0){
                if let _ = targetNumberRegex?.firstMatch(in: myWakeup, options: [], range: NSRange(location: 0, length: txt.count)){
                }
                else{
                    wakeupTextField.text = ""
                    myWakeup = "7"
                    showRegexViolationAlert(type: "number")
                }
            }
            
            if(wakeupTextField.placeholder == ""){
                wakeupTextField.placeholder = UserDefaults.standard.string(forKey: "WakeupTime") ?? "기상시간 입력"
            }
        }
    }
    
    // Called when the line feed button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // code...
        textField.resignFirstResponder()
        return true
    }
    
    // 실시간 입력 반응
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        //let txt = textField.text?.trimmingCharacters(in: .whitespaces) ?? "Empty"
        if textField.tag == 1 { myName = txt} // name
        else if textField.tag == 2 { myPhoneNumber = txt } // phoneNumber
        else if textField.tag == 3 { myHeight = txt } // height
        else if textField.tag == 4 { myWeight = txt } // weight
        else if textField.tag == 5 { myBpm = txt } // bpm
        else if textField.tag == 6 { myStep = txt } // step
        else if textField.tag == 7 { myDistance = txt } // distance
        else if textField.tag == 8 { myACal = txt } // aCal
        else if textField.tag == 9 { myTCal = txt } // tCal
        else if textField.tag == 33 { guardianTel = txt } // guardianTel1
        else if textField.tag == 44 { guardianTel2 = txt } // guardianTel2
        else if textField.tag == 111 { mySleep = txt } // sleep
        else if textField.tag == 222 { myWakeup = txt } // sleep
    }
    
    func showRegexViolationAlert(type: String){
        var helpText = ""
        
        switch type {
        case "name":
            helpText = "올바른 이름을 입력해주세요"
            break
        case "phoneNumber":
            helpText = "올바른 휴대폰 번호를 입력해주세요"
            break
        case "number":
            fallthrough
        case "":
            helpText = "올바른 숫자를 입력해주세요"
            break
        default:
            helpText = "isEmpty"
            break
        }
        
        let alert = UIAlertController(title: "알림", message: helpText, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: false)
    }
    
    // keybord up, down event
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 입력 시 키보드 사이즈를 알아내어 스크롤 뷰로 보여줌
    @objc func keyboardUp(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
    }

    @objc func keyboardDown() {
        self.view.transform = .identity
        
        // 키보드 사라질 시 화면 복구
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

    }
    
    // textField 터치 범위 설정
    class CustomTextField: UITextField {
        // textField 터치 범위 설정
        private let touchAreaInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let hitTestRect = bounds.inset(by: touchAreaInsets)
            
            //self.backgroundColor = .green
            return hitTestRect.contains(point)
        }
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

// 이미지 크기 조정
extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: 12, height: 12))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
