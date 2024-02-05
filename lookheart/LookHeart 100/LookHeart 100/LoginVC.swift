import UIKit
import LookheartPackage

class LoginVC : TitleViewController, UITextFieldDelegate, DataPassingDelegate {

    private let EMAIL_TAG = 1
    private let PASSWORD_TAG = 2
    
    private var idInput: String = ""
    private var pwInput: String = ""
    
    private let attributes = [
        NSAttributedString.Key.foregroundColor: UIColor.darkGray,
        .font: UIFont.systemFont(ofSize: 12)]
    
    private var img = UIImage(named: "circle")
    
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private let loginLabel = UILabel().then {
        $0.text = "loginLabel".localized()
        $0.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.textColor = .black
    }
    
    private let loginTextLabel = UILabel().then {
        $0.text = "loginText".localized()
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .lightGray
    }
    
    private let idTitleLabel = UILabel().then {
        $0.text = "email_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    private var pwTitleLabel = UILabel().then {
        $0.text = "password_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    private lazy var emailTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        $0.leftViewMode = .always
        $0.keyboardType = .emailAddress
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.delegate = self
        $0.tag = EMAIL_TAG
        $0.attributedPlaceholder = NSAttributedString(string: "email_Hint".localized(), attributes: attributes)
    }
    
    private lazy var passWordTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        $0.leftViewMode = .always
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isSecureTextEntry = true // 비밀번호 가리는 기능
        $0.clearsOnBeginEditing = false // 텍스트 필드 터치 시 내용 삭제
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.delegate = self
        $0.tag = PASSWORD_TAG
        $0.attributedPlaceholder = NSAttributedString(string: "password_Hint".localized(), attributes: attributes)
    }
    
    private lazy var autoLoginButton = UIButton().then {
        if UserDefaults.standard.bool(forKey: "autoLogin") {
            img = UIImage(named: "check")
        } else {
            img = UIImage(named: "circle")
        }
        $0.setTitle("autoLogin".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.setImage(img, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = .init(top: 11, left: -15, bottom: 11, right: 0)
        $0.addTarget(self, action: #selector(autoLoginTapped(_:)), for: .touchUpInside)
    }
    
    private lazy var findIdPw = UIButton().then {
        $0.setTitle("findEmailPassword".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.addTarget(self, action: #selector(findIdPw(_:)), for: .touchUpInside)
    }
    
    private lazy var loginButton = UIButton().then {
        $0.setTitle("loginLabel".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.LOGIN_BUTTON
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(loginButtonEvent(_:)), for: .touchUpInside)
    }
    
    private var helpText = UILabel().then {
        $0.text = "signupHelpText".localized()
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.HELP_TEXT
    }
    
    private lazy var signupButton = UIButton().then {
        $0.setTitle("signupButton".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.addTarget(self, action: #selector(signupButtonEvent(_:)), for: .touchUpInside)
    }
    
    // MARK: - Button Event
    @objc func autoLoginTapped(_ sender: UIButton) {
        if(UserDefaults.standard.bool(forKey: "autoLogin")){
            UserDefaults.standard.set(false, forKey: "autoLogin")
            sender.setImage(UIImage(named: "circle"), for: .normal)
        } else {
            UserDefaults.standard.set(true, forKey: "autoLogin")
            sender.setImage(UIImage(named: "check"), for: .normal)
        }
    }
    
    @objc func loginButtonEvent(_ sender: UIButton) {
        loginServerTask(idInput, pwInput) { success in
            if success {
                DispatchQueue.main.async {
                    // 자동 로그인 플래그
                    if(UserDefaults.standard.bool(forKey: "autoLogin")){
                        UserDefaults.standard.set(true, forKey: "autoLoginFlag")
                    } else {
                        UserDefaults.standard.set(false, forKey: "autoLoginFlag")
                    }
                                        
                    if !Keychain.shared.setString(self.idInput, forKey: "email") {
                        print("Failed to save data to the keychain")
                    }
                    
                    self.view.window?.rootViewController = TabBarController()
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                // 로그인 실패 처리
                let alert = UIAlertController(title: "loginFailed".localized(), message: "incorrectlyLogin".localized(), preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: false)
            }
        }
    }
    
    // 회원가입 버튼 터치 이벤트
    @objc func signupButtonEvent(_ sender: UIButton) {
        self.navigationController?.pushViewController(AgreeBasicTermsVC(), animated: true)
    }

    // id, pw 찾기
    @objc func findIdPw(_ sender: UIButton) {
        self.navigationController?.pushViewController(FindEmailVC(), animated: true)
    }
    
    func passData(email: String) {
        emailTextField.text = email
        idInput = email
    }
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setGesture()
    }
    
    private func setGesture() {
        // keybord dismiss by touching anywhere in the view
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        let heightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
    }
    
    // MARK: TEXTFIELD
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case EMAIL_TAG:
            emailTextField.placeholder = ""
        case PASSWORD_TAG:
            passWordTextField.placeholder = ""
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case EMAIL_TAG:
            if emailTextField.placeholder == "" {
                emailTextField.placeholder = "email_Hint".localized()
            }
        case PASSWORD_TAG:
            if passWordTextField.placeholder == "" {
                passWordTextField.placeholder = "password_Hint".localized()
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case EMAIL_TAG:
            idInput = textField.text ?? "Empty"
        case PASSWORD_TAG:
            pwInput = textField.text ?? "Empty"
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
    
    
    func loginServerTask(_ id: String, _ pw: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.checkLoginToServer(id: id, pw: pw, destroy: false) { result in
            switch result {
            case .success(let isAvailable):
                completion(isAvailable)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    //MARK: set Layout
    func addViews(){
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(safeAreaView)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        containerView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.left.equalTo(containerView.snp.left).offset(15)
        }
        
        containerView.addSubview(loginTextLabel)
        loginTextLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.left.equalTo(loginLabel.snp.left)
        }
        
        containerView.addSubview(idTitleLabel)
        idTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(loginTextLabel.snp.bottom).offset(20)
            make.left.equalTo(containerView.snp.left).offset(40)
        }
        
        containerView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(idTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(idTitleLabel.snp.left)
            make.right.equalTo(containerView.snp.right).offset(-40)
            make.height.equalTo(40)
        }
        
        containerView.addSubview(pwTitleLabel)
        pwTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalTo(idTitleLabel.snp.left)
        }
        
        containerView.addSubview(passWordTextField)
        passWordTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTitleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(40)
        }

        containerView.addSubview(autoLoginButton)
        autoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(5)
            make.left.equalTo(passWordTextField.snp.left).offset(-5)
        }
        
        containerView.addSubview(findIdPw)
        findIdPw.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(10)
            make.right.equalTo(passWordTextField.snp.right).offset(10)
        }
        
        containerView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(findIdPw.snp.bottom).offset(15)
            make.left.right.equalTo(passWordTextField)
            make.height.equalTo(40)
        }
        
        containerView.addSubview(helpText)
        helpText.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.centerX.equalTo(safeAreaView.snp.centerX)
        }
        
        containerView.addSubview(signupButton)
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(helpText.snp.bottom).offset(20)
            make.left.right.equalTo(loginButton)
            make.height.equalTo(40)
        }
    }
}

