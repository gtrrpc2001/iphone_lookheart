import UIKit

class LoginView : UIViewController, UITextFieldDelegate{
    
    private let safeAreaView = UIView()
    
    private var idInput: String = ""
    private var pwInput: String = ""
    
    // Navigation title Label
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "LOOKHEART"
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy) // 크기, 굵음 정도 설정
        label.textColor = .black
        
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        
        label.text = "로그인"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        
        return label
    }()
    
    let loginTextLabel: UILabel = {
        let label = UILabel()
        label.text = "LOOKHEART 서비스 이용을 환영합니다.\n가입하신 이메일과 비밀번호를 입력하세요."
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
   
    // 아이디 제목
    private var idTitleLabel: UILabel = {
        var label = UILabel()
        
        label.text = "아이디"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()

    
    // 이메일 입력 필드
    private var emailTextField: UITextField! = {
        let textField = UITextField()
        
        textField.frame.size.height = 40 // TextField의 높이 설정
        textField.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        textField.textColor = .darkGray // 입력 Text Color
        //textField.tintColor = .blue // 입력 시 변하는 TextField 색 설정
        textField.autocapitalizationType = .none // 자동으로 입력값의 첫 번째 문자를 대문자로 변경
        textField.autocorrectionType = .no // 틀린 글자 체크 no
        textField.spellCheckingType = .no // 스펠링 체크 기능 no
        textField.keyboardType = .emailAddress // 키보드 타입 email type
        
        // 테두리
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        
        // 크기
        textField.font = UIFont.systemFont(ofSize: 16)
        
        // 왼쪽 여백
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
       
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 12)]

        textField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요", attributes: attributes)
        
        return textField
    }()
    
    // 비밀번호 제목
    private var pwTitleLabel: UILabel = {
        var label = UILabel()
        
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()
    
    // 비밀번호 입력 필드
    private lazy var passWordTextField: UITextField = {
        let textField = UITextField()
        
        textField.frame.size.height = 40 // TextField의 높이 설정
        textField.backgroundColor = UIColor(red: 0xef/255, green: 0xf0/255, blue: 0xf2/255, alpha: 1.0)
        textField.textColor = .darkGray // 입력 Text Color
        //textField.tintColor = .blue // 입력 시 변하는 TextField 색 설정
        textField.autocapitalizationType = .none // 자동으로 입력값의 첫 번째 문자를 대문자로 변경
        textField.autocorrectionType = .no // 틀린 글자 체크 no
        textField.spellCheckingType = .no // 스펠링 체크 기능 no
        textField.isSecureTextEntry = true // 비밀번호 가리는 기능
        textField.clearsOnBeginEditing = false // 텍스트 필드 터치 시 내용 삭제
        
        // 테두리
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        
        // 크기
        textField.font = UIFont.systemFont(ofSize: 16)
        
        // 왼쪽 여백
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        
        // placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          .font: UIFont.systemFont(ofSize: 12)]
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: attributes)
        
        return textField
    }()
    
    // 자동 로그인 버튼
    lazy var autoLoginButton: UIButton = {
        let button = UIButton()
        var img = UIImage(named: "circle")
        
        if(UserDefaults.standard.bool(forKey: "autoLogin")){
            img = UIImage(named: "check")
        }
        else{
            img = UIImage(named: "circle")
        }
        
        button.setTitle("자동로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.setImage(img, for: .normal)
        
        //button.backgroundColor = .blue // 버튼 터치 범위 확인
        
        // button img size
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = .init(top: 11, left: -15, bottom: 11, right: 0)
        
        // 터치 이벤트
        button.addTarget(self, action: #selector(autoLoginTapped(_:)), for: .touchUpInside)

       return button
    }()

    // 아이디 비밀번호 찾기
    lazy var findIdPw: UIButton = {
        let button = UIButton()
        
        button.setTitle("이메일/비밀번호 찾기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.setTitleColor(.lightGray, for: .normal)
        
        //button.backgroundColor = .blue // 버튼 터치 범위 확인
        return button
    }()
    
    // 자동로그인 버튼 터치 이벤트
    @objc func autoLoginTapped(_ sender: UIButton) {
        if(UserDefaults.standard.bool(forKey: "autoLogin")){
            UserDefaults.standard.set(false, forKey: "autoLogin")
            sender.setImage(UIImage(named: "circle"), for: .normal)
        }
        else {
            UserDefaults.standard.set(true, forKey: "autoLogin")
            sender.setImage(UIImage(named: "check"), for: .normal)
        }
    }
    
    // 로그인 버튼
    lazy var loginButton: UIButton = {
        var button = UIButton(type: .custom)
        
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal) // 활성화 .normal / 비활성화 .disabled
        //button.layer.borderWidth = 1   // 버튼의 테두리 두께 설정
        button.backgroundColor = UIColor(red: 0x33/255, green: 0x47/255, blue: 0x71/255, alpha: 1.0)
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(loginButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // 로그인 버튼 터치 이벤트
    @objc func loginButtonEvent(_ sender: UIButton) {
        //print(UserDefaults.standard.string(forKey: "email")!)
        //print(UserDefaults.standard.string(forKey: "password")!)
        if(idInput == UserDefaults.standard.string(forKey: "Id") && pwInput == UserDefaults.standard.string(forKey: "Password")){
            // 자동 로그인 플래그
            if(UserDefaults.standard.bool(forKey: "autoLogin")){
                UserDefaults.standard.set(true, forKey: "autoLoginFlag")
            }
            else{UserDefaults.standard.set(false, forKey: "autoLoginFlag")}
            
            self.view.window?.rootViewController = TabBarController()
            self.view.window?.makeKeyAndVisible()
        }
        //MARK: - 관리자
        else if idInput == "admin@msl.co.kr" && pwInput == "Admin1234!"{
            if(UserDefaults.standard.bool(forKey: "autoLogin")){
                UserDefaults.standard.set(true, forKey: "autoLoginFlag")
            }
            else{UserDefaults.standard.set(false, forKey: "autoLoginFlag")}
            
            let currentTime = Date()
            
            UserDefaults.standard.set("admin@msl.co.kr", forKey: "Id")
            UserDefaults.standard.set("1", forKey: "Sex")
            UserDefaults.standard.set("룩하트", forKey: "name")
            UserDefaults.standard.set("177", forKey: "Height")
            UserDefaults.standard.set("77", forKey: "Weight")
            
            UserDefaults.standard.set("45", forKey: "Age")
            UserDefaults.standard.set("01012345678", forKey: "PhoneNumber")
            UserDefaults.standard.set("01012345678", forKey: "guardianTel1")
            UserDefaults.standard.set("01012345678", forKey: "guardianTel2")
            UserDefaults.standard.set(currentTime,forKey: "SignupDate")
            UserDefaults.standard.set("2023년 01월 01일", forKey: "Birthday")
            UserDefaults.standard.set(90, forKey: "eCalBpm")
            UserDefaults.standard.set(2000, forKey: "TargetStep")
            UserDefaults.standard.set(5, forKey: "TargetDistance")
            UserDefaults.standard.set(500, forKey: "TargeteCal")
            UserDefaults.standard.set(3000, forKey: "TargettCal")
            UserDefaults.standard.set("23", forKey: "SleepTime")
            UserDefaults.standard.set("7", forKey: "WakeupTime")
            UserDefaults.standard.set("1", forKey: "guardianAlert")
            
            UserDefaults.standard.set(true, forKey: "HeartAttackFlag")
            UserDefaults.standard.set(true, forKey: "NoncontactFlag")
            
            UserDefaults.standard.set(false, forKey: "MyoFlag")
            UserDefaults.standard.set(false, forKey: "ArrFlag")
            UserDefaults.standard.set(false, forKey: "TarchycardiaFlag")
            UserDefaults.standard.set(false, forKey: "BradycardiaFlag")
            UserDefaults.standard.set(false, forKey: "AtrialFibrillaionFlag")
            
            self.view.window?.rootViewController = TabBarController()
            self.view.window?.makeKeyAndVisible()
        }
        else{
            let alert = UIAlertController(title: "로그인 실패", message: "아이디 또는 비밀번호를 잘못 입력했습니다.", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: false)
        }
    }
    
    // 비밀번호 제목
    private var helpText: UILabel = {
        var label = UILabel()
        
        label.text = "LOOKHEART 이용이 처음이신가요?"
        label.font = UIFont.systemFont(ofSize: 14)
        // 0xff8f95a0
        label.textColor = UIColor(red: 0x8f/255, green: 0x95/255, blue: 0xa0/255, alpha: 1.0)
        
        return label
    }()

    // 회원가입 버튼
    lazy var signupButton: UIButton = {
        var button = UIButton(type: .custom)
        
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.lightGray, for: .normal) // 활성화 .normal / 비활성화 .disabled
        button.layer.borderWidth = 1   // 버튼의 테두리 두께 설정
        button.layer.borderColor = UIColor.lightGray.cgColor
        //button.isEnabled = false       // 버튼의 동작 설정 (처음에는 동작 off)
        
        // 터치 이벤트
        button.addTarget(self, action: #selector(signupButtonEvent(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // 회원가입 버튼 터치 이벤트
    @objc func signupButtonEvent(_ sender: UIButton) {
        
        let signupView1 = SignupView1()
        self.navigationController?.pushViewController(signupView1, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        Constraints()
        
        // safeAreaView 설정
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
        
        // Navigationbar Title 왼쪽 정렬
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        // keybord dismiss by touching anywhere in the view
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        let heightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
        
    } // viewDidLoad
    
    // MARK: textField event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            emailTextField.placeholder = ""
        }
        else if textField.tag == 2 {
            passWordTextField.placeholder = ""
        }
    }
    
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if emailTextField.placeholder == "" {
                emailTextField.placeholder = "아이디를 입력하세요"
            }
        }
        else if textField.tag == 2 {
            if passWordTextField.placeholder == "" {
                passWordTextField.placeholder = "비밀번호를 입력하세요"
            }
        }
    }
    
    // Called when the line feed button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
//        let txt = textField.text ?? "Empty"
        
        if textField.tag == 1 { idInput = textField.text ?? "Empty" } // email
        else if textField.tag == 2 { pwInput = textField.text ?? "Empty" } // password
    }
    
    func setup(){
        view.backgroundColor = .white
        addViews()
    }
    
    func addViews(){
        
        view.addSubview(safeAreaView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(loginLabel)
        containerView.addSubview(loginTextLabel)
        
        emailTextField.delegate = self
        emailTextField.tag = 1
        containerView.addSubview(idTitleLabel)
        containerView.addSubview(emailTextField)

        passWordTextField.delegate = self
        passWordTextField.tag = 2
        containerView.addSubview(pwTitleLabel)
        containerView.addSubview(passWordTextField)

        containerView.addSubview(autoLoginButton)
        containerView.addSubview(findIdPw)
        containerView.addSubview(loginButton)
        containerView.addSubview(helpText)
        containerView.addSubview(signupButton)

    }
    
    
    //MARK: layout
    // 오토 레이아웃 설정
    func Constraints(){
        
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // stackView
        idTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        pwTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passWordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        autoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        findIdPw.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        helpText.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // safeAreaView
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            loginLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            loginTextLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            loginTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 15),
            
            idTitleLabel.topAnchor.constraint(equalTo: loginTextLabel.bottomAnchor, constant: 20),
            idTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: idTitleLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            pwTitleLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            pwTitleLabel.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            
            passWordTextField.topAnchor.constraint(equalTo: pwTitleLabel.bottomAnchor, constant: 10),
            passWordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passWordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passWordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            autoLoginButton.topAnchor.constraint(equalTo: passWordTextField.bottomAnchor, constant: 5),
            autoLoginButton.leadingAnchor.constraint(equalTo: passWordTextField.leadingAnchor, constant: -5),
            
            findIdPw.topAnchor.constraint(equalTo: passWordTextField.bottomAnchor, constant: 10),
            findIdPw.trailingAnchor.constraint(equalTo: passWordTextField.trailingAnchor, constant: 10),
            
            loginButton.topAnchor.constraint(equalTo: findIdPw.bottomAnchor, constant: 15),
            loginButton.leadingAnchor.constraint(equalTo: passWordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passWordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            helpText.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            helpText.centerXAnchor.constraint(equalTo: safeAreaView.centerXAnchor),
            
            signupButton.topAnchor.constraint(equalTo: helpText.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
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
}

