import Foundation
import UIKit
import LookheartPackage

class ChangePwVC : TitleViewController, UITextFieldDelegate {
    
    weak var delegate: DataPassingDelegate?
    
    private let PASSWORD_TAG = 0
    private let RE_PASSWORD_TAG = 1
    
    var id: String?
    private var password = String()
    private var rePassword = String()
    
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private lazy var passwordTextField = createTextField("password_Hint".localized(), PASSWORD_TAG)
    private lazy var rePasswordTextField = createTextField("rpw_Label_hint".localized(), RE_PASSWORD_TAG)
    
    // MARK: - textField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case PASSWORD_TAG:
            password = textField.text ?? "Empty"
        case RE_PASSWORD_TAG:
            rePassword = textField.text ?? "Empty"
        default:
            break
        }
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return passwordRegex!.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) != nil
    }
    
    // MARK: - button Evnet
    @objc func backButtonEvent(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeButtonEvent(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkPasswordValid(password) && password == rePassword {
            updatePassword()
        } else if password != rePassword {
            showAlert("reEnterPasswordHelp".localized())
        } else {
            showAlert("reconfirmPW".localized())
        }
    }
    
    private func updatePassword() {
        Task {
            let response = await ProfileService.shared.postUpdatePassword(id: id!, password: password)
            
            switch response {
            case .success:
                updatePasswordAlert()
            case .failer:
                showAlert("failSaveData".localized())
            default:
                showAlert("serverErr".localized())
            }
        }
    }
    
    private func updatePasswordAlert() {
        let alert = UIAlertController(title: "noti".localized(), message: "passwordComp".localized(), preferredStyle: UIAlertController.Style.alert)
        let complite = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default){ [self] _ in
            delegate?.passData(email: id!)
            navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(complite)
        present(alert, animated: false, completion: {})
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "noti".localized(), message: message, preferredStyle: UIAlertController.Style.alert)
        let complite = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default)
        alert.addAction(complite)
        self.present(alert, animated: false, completion: {})
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootVC = navigationController?.viewControllers.first as? LoginVC {
            delegate = rootVC
        }
        
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
    
    // MARK: -
    private func createLabel(_ text: String, _ font: UIFont, _ color: UIColor) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.font = font
            $0.textColor = color
            $0.numberOfLines = 2
        }
        return label
    }
    
    private func createTextField(_ placeholder: String, _ tag: Int) -> UITextField {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 12)]
        let textField = UITextField().then {
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
            $0.tag = tag
            $0.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        return textField
    }
    
    // MARK: -
    private func addViews() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(safeAreaView)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        // Change PW
        let changePwLabel = createLabel("findPW".localized(), UIFont.systemFont(ofSize: 18, weight: .heavy), .darkGray)
        containerView.addSubview(changePwLabel)
        changePwLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.left.equalTo(containerView.snp.left).offset(15)
        }
        
        // Help Text
        let helpTextLabel = createLabel("newPwInfo".localized(), UIFont.systemFont(ofSize: 16, weight: .medium), .lightGray)
        containerView.addSubview(helpTextLabel)
        helpTextLabel.snp.makeConstraints { make in
            make.top.equalTo(changePwLabel.snp.bottom).offset(20)
            make.left.equalTo(changePwLabel)
        }
        
        // ----------------------------- Password Start -----------------------------
        
        // Label
        let passwordLabel = createLabel("pw_Label".localized(), UIFont.systemFont(ofSize: 16, weight: .heavy), .darkGray)
        containerView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(helpTextLabel.snp.bottom).offset(20)
            make.left.equalTo(helpTextLabel)
        }
        
        // Text Field
        containerView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.left.equalTo(passwordLabel)
            make.right.equalTo(safeAreaView).offset(-10)
            make.height.equalTo(40)
        }
        
        // Password Help
        let passwordHelpLabel = createLabel("passwordHelp2".localized(), UIFont.systemFont(ofSize: 10, weight: .heavy), UIColor.MY_RED)
        containerView.addSubview(passwordHelpLabel)
        passwordHelpLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.left.equalTo(helpTextLabel).offset(5)
        }
        
        // ----------------------------- Password End -----------------------------
        
        
        
        
        // ----------------------------- Re_Password Start -----------------------------
        
        // Label
        let rePasswordLabel = createLabel("rpw_Label".localized(), UIFont.systemFont(ofSize: 16, weight: .heavy), .darkGray)
        containerView.addSubview(rePasswordLabel)
        rePasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordHelpLabel.snp.bottom).offset(20)
            make.left.equalTo(helpTextLabel)
        }
        
        // Text Field
        containerView.addSubview(rePasswordTextField)
        rePasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(rePasswordLabel.snp.bottom).offset(10)
            make.left.right.height.equalTo(passwordTextField)
        }
        
        // ----------------------------- Re_Password End -----------------------------
        
        
        
        
        
        // ----------------------------- Button Start -----------------------------
        
        // Change Button
        let changeButton = UIButton().then {
            $0.setTitle("ChangePw".localized(), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor.LOGIN_BUTTON
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(changeButtonEvent(_:)), for: .touchUpInside)
        }
        containerView.addSubview(changeButton)
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(rePasswordTextField.snp.bottom).offset(40)
            make.left.right.height.equalTo(passwordTextField)
        }
        
        
        // Back Button
        let backButton = UIButton().then {
            $0.setTitle("back".localized(), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.addTarget(self, action: #selector(backButtonEvent(_:)), for: .touchUpInside)
        }
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(changeButton.snp.bottom).offset(10)
            make.left.right.height.equalTo(passwordTextField)
        }
        
        // ----------------------------- Button End -----------------------------
    }
    
}
