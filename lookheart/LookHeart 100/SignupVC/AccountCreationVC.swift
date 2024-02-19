import UIKit
import LookheartPackage

class AccountCreationVC : TitleViewController, UITextFieldDelegate {
    
    private let EMAIL_TEXTFIELD_TAG = 1
    private let PASSWORD_TEXTFIELD_TAG = 2
    private let RE_PASSWORD_TEXTFIELD_TAG = 3
    
    private var idInput: String = ""
    private var pwInput: String = ""
    private var rePwInput: String = ""
    // 입력 확인
    private var dataCheck : [String : Bool] = ["email":false, "password":false, "rePassword":false]
    private lazy var textFields: [UITextField] = [emailTextField, passwordTextField, reEnterPasswordTextField]
    
    // MARK: -
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private let signupText = UILabel().then {
        $0.text = "signup3".localized()
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .darkGray
    }
    
    private let progressView = UIProgressView().then {
        $0.trackTintColor = UIColor.PROGRESS_BAR
        $0.progressTintColor = UIColor.PROGRESS_BAR_FILL
        $0.progress = 0.666
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "id_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "pw_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    private let reEnterPasswordLabel = UILabel().then {
        $0.text = "rpw_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    private var emailCheckLabel = UILabel().then {
        $0.text = "emailHelp".localized()
        $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private var passwordCheckLabel = UILabel().then {
        $0.text = "passwordHelp".localized()
        $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private var reEnterPasswordCheckLabel = UILabel().then {
        $0.text = "reEnterPasswordHelp".localized()
        $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private lazy var emailTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.keyboardType = .emailAddress
        $0.tag = EMAIL_TEXTFIELD_TAG
        $0.delegate = self
        
        $0.placeholderString = "email_Hint".localized()
        $0.placeholderColor = .lightGray
    }
    
    private lazy var passwordTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.textContentType = .oneTimeCode
        $0.isSecureTextEntry = true
        $0.clearsOnBeginEditing = false
        $0.tag = PASSWORD_TEXTFIELD_TAG
        $0.delegate = self
        
        $0.placeholderString = "password_Hint".localized()
        $0.placeholderColor = .lightGray
    }
    
    private lazy var reEnterPasswordTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.textContentType = .oneTimeCode
        $0.isSecureTextEntry = true
        $0.clearsOnBeginEditing = false
        $0.tag = RE_PASSWORD_TEXTFIELD_TAG
        $0.delegate = self
        
        $0.placeholderString = "rpw_Label_hint".localized()
        $0.placeholderColor = .lightGray
    }
    
    
    private lazy var backButton = UIButton().then {
        $0.setTitle("back".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.addTarget(self, action: #selector(backButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("next".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.addTarget(self, action: #selector(nextButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var buttonView = UIStackView(arrangedSubviews: [backButton, nextButton]).then {
        $0.spacing = 40
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
     
    // MARK: - Button Event
    @objc private func backButtonEvent(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonEvent(_ sender: UIButton) {
        
        for textField in textFields {
            textField.resignFirstResponder()    // 키보드가 열려 있을 경우 키보드 사라짐
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            if checkInput() {
                checkID()
            } else {
                alert(title: "noti".localized(), message: "incorrectlyLogin".localized())
            }
        }
    }
        
    private func checkID() {
        NetworkManager.shared.checkIDToServer(id: idInput){ [self] result in
            switch result {
            case .success(let isAvailable):
                if isAvailable {
                    
                    setKeyChain(key: "email", value: idInput)
                    setKeyChain(key: "password", value: pwInput)
                
                    self.navigationController?.pushViewController(HealthProfileSetupVC(), animated: true)
                    
                } else {
                    alert(title: "noti".localized(), message: "dupID".localized())
                }
            case .failure(_):
                alert(title: "noti".localized(), message: "serverErr".localized())
            }
        }
    }
    
    private func checkInput() -> Bool {
        // 입력 확인
        for(_, value) in dataCheck{
            if(value == false){
                return false
            }
        }
        return true
    }
    
    // MARK: - addViews
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(safeAreaView)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        containerView.addSubview(signupText)
        signupText.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(signupText.snp.bottom).offset(10)
            make.left.equalTo(containerView.snp.left).offset(40)
            make.right.equalTo(containerView.snp.right).offset(-40)
            make.centerX.equalTo(containerView.snp.centerX)
            make.height.equalTo(20)
        }
        
        containerView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(60)
            make.left.equalTo(containerView.snp.left).offset(43)
        }
                
        containerView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(5)
            make.left.equalTo(containerView.snp.left).offset(40)
            make.right.equalTo(progressView)
        }

        containerView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.left.equalTo(emailLabel.snp.left)
        }
        
        containerView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.left.right.equalTo(progressView)
        }
        
        containerView.addSubview(reEnterPasswordLabel)
        reEnterPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.equalTo(passwordLabel.snp.left)
        }
        
        containerView.addSubview(reEnterPasswordTextField)
        reEnterPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(reEnterPasswordLabel.snp.bottom).offset(5)
            make.left.right.equalTo(progressView)
        }
        
        containerView.addSubview(emailCheckLabel)
        emailCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(3)
            make.left.equalTo(progressView.snp.left)
        }
        
        containerView.addSubview(passwordCheckLabel)
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(3)
            make.left.equalTo(progressView.snp.left)
        }
        
        containerView.addSubview(reEnterPasswordCheckLabel)
        reEnterPasswordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(reEnterPasswordTextField.snp.bottom).offset(3)
            make.left.equalTo(progressView.snp.left)
        }
        
        containerView.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(reEnterPasswordTextField.snp.bottom).offset(30)
            make.left.equalTo(containerView.snp.left).offset(20)
            make.right.equalTo(containerView.snp.right).offset(-20)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setTapGesture()
        
    }
        
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: false)
    }
    
        
    private func setKeyChain(key: String, value: String) {
        if Keychain.shared.setString(value, forKey: key) {
            print("Keychain : set \(key)")
        } else {
            print("Keychain : set \(key) Err")
        }
    }
    
    // MARK: textField event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Called just before UITextField is edited
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Called when the line feed button is pressed
        textField.resignFirstResponder()    // return 버튼 눌렀을 때 키보드 사라지도록 설정
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        let tag = textField.tag
        var regexCheck:Bool
        
        // 정규식 체크
        switch tag {
        case EMAIL_TEXTFIELD_TAG:
            regexCheck = checkRegex(emailRegex!, txt)
            
            if !regexCheck { emailTextField.setError() }

            hintIsHidden(label: &emailCheckLabel,
                         key: "email",
                         hidden: regexCheck)
            
        case PASSWORD_TEXTFIELD_TAG:
            regexCheck = checkRegex(passwordRegex!, txt)
            
            if !regexCheck { passwordTextField.setError() }
            
            hintIsHidden(label: &passwordCheckLabel,
                         key: "password",
                         hidden: regexCheck)
            
        case RE_PASSWORD_TEXTFIELD_TAG:
            regexCheck = pwInput == txt
            
            print(regexCheck)
            if !regexCheck { reEnterPasswordTextField.setError() }
            
            hintIsHidden(label: &reEnterPasswordCheckLabel,
                         key: "rePassword",
                         hidden: regexCheck)
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        let tag = textField.tag
        
        // 실시간 입력 반응
        switch tag {
        case EMAIL_TEXTFIELD_TAG:
            inputTextFieldString(&idInput, txt)
        case PASSWORD_TEXTFIELD_TAG:
            inputTextFieldString(&pwInput, txt)
        case RE_PASSWORD_TEXTFIELD_TAG:
            inputTextFieldString(&rePwInput, txt)
        default:
            break
        }
    }
    
    private func inputTextFieldString(_ variable: inout String,_ text: String) {
        variable = text
    }
    
    private func checkRegex(_ regex: NSRegularExpression, _ text: String) -> Bool {
        return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) != nil
    }
    
    private func hintIsHidden(label: inout UILabel, key: String, hidden: Bool) {
        label.isHidden = hidden
        dataCheck[key] = hidden
    }
    
    // MARK: - keybord event
    private func setTapGesture() {
        // keybord dismiss by touching anywhere in the view
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        let heightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
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
        // 키보드 입력 시 키보드 사이즈를 알아내어 스크롤 뷰로 보여줌
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
