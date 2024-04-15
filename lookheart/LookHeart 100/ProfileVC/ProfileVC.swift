import Foundation
import UIKit
import LookheartPackage

class ProfileVC: BaseViewController, UITextFieldDelegate, AuthDelegate, settingDelegate {

    private var authPhoneNumber = AuthPhoneNumber().then {
        $0.isHidden = true
        $0.alpha = 0
    }
    
    private let BASICINFO_TAG = 1
    private let TARGET_TAG = 2
    private let GUARDIAN_TAG = 3
    private let SETTING_TAG = 4
    
    private lazy var buttonList = [basicInfoButton, goalButton, guardianButton, settingButton]
    
    private var basicProfile = BasicProfile()
    private var targetProfile = TargetProfile().then {
        $0.isHidden = true
    }
    private var guardianProfile = GuardianProfile().then {
        $0.isHidden = true
    }
    private var settingProfile = SettingProfile().then {
        $0.isHidden = true
    }
    
    private var accountDeletion = AccountDeletion()
    
    private lazy var viewList = [basicProfile, targetProfile, guardianProfile, settingProfile]
    
    // MARK: -
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    private var underlineView = UIView()
    private var viewBackground = UIView()
    
    private let nameLabel = UILabel().then {
        $0.text = propProfil.name
        $0.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        $0.textColor = .darkGray
    }
    
    private let sirLabel = UILabel().then {
        $0.text = "sir".localized()
        $0.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.textColor = .lightGray
    }
    
    private let emailTitle = UILabel().then {
        $0.text = "email_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .darkGray
    }
    
    private let emailLabel = UILabel().then {
        $0.text = propEmail
        $0.font = UIFont.systemFont(ofSize: 15, weight: .light)
        $0.textColor = .black
    }
    
    private let joinDateTitle = UILabel().then {
        $0.text = "joinDate".localized()
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .darkGray
    }
    
    private let joinDateLabel = UILabel().then {
        $0.text = "isEmpty"
        $0.font = UIFont.systemFont(ofSize: 15, weight: .light)
        $0.textColor = .black
    }
    
    private let topBackground = UIView().then {
        $0.backgroundColor = UIColor.MY_LIGHT_GRAY
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.layer.borderWidth = 1
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var basicInfoButton = UIButton().then {
        $0.setTitle("basic".localized(), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.backgroundColor = .clear
        $0.tag = BASICINFO_TAG
    }
    
    private lazy var goalButton = UIButton().then {
        $0.setTitle("target".localized(), for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.backgroundColor = .clear
        $0.tag = TARGET_TAG
    }
    
    private lazy var guardianButton = UIButton().then {
        $0.setTitle("guardian".localized(), for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.backgroundColor = .clear
        $0.tag = GUARDIAN_TAG
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setTitle("setting".localized(), for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.backgroundColor = .clear
        $0.tag = SETTING_TAG
    }
    
    // MARK: - Auth PhoneNumber delegate
    func auth() {
        isHidden(true)
    }
    
    func complete(result: String) {
        
        isHidden(false)
        
        let changePasswordVC = ChangePwVC()
        changePasswordVC.id = propEmail
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
        
    }
    
    func cancle() {
        isHidden(false)
    }
    
    private func isHidden(_ flag: Bool) {
        if flag {
            authPhoneNumber.isHidden = false
            underlineView.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.authPhoneNumber.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.authPhoneNumber.alpha = 0
                self.underlineView.isHidden = false
            }) { _ in
                self.authPhoneNumber.isHidden = true
            }
        }
    }
    
    // MARK: - Account deletion
    func deletion() {
        propAlert.basicPasswordAlert(viewController: self) { password in
            self.checkAccount(password: password)
        }
    }
    
    private func checkAccount(password: String) {
        let id = propEmail
        
        Task {
            let response = await LoginService.shared.loginTask(id, password, true)
            
            switch response {
            case .success:
                self.accountDeletion.password = password
                self.navigationController?.pushViewController(self.accountDeletion, animated: true)
            case .failer:
                propAlert.basicAlert(title: "noti".localized(), message: "reconfirmPW".localized(), ok: "ok".localized(), viewController: self)
            default:
                propAlert.basicAlert(title: "noti".localized(), message: "serverInternetError".localized(), ok: "ok".localized(), viewController: self)
            }
        }
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingProfile.settingDelegate = self
        authPhoneNumber.delegate = self
        
        addView()
        addTarget()
        
        setKeyboardObserver()
        setGesture()
        
        updateProfile()
        setButtonColor(basicInfoButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        basicProfile.updateProfile()
        targetProfile.updateProfile()
        guardianProfile.updateProfile()
        settingProfile.updateProfile()
    }
    
    private func updateProfile() {
        let name = propProfil.name.split(separator: " ")
        
        nameLabel.text = String(name[0])        
        emailLabel.text = "◦ \(propEmail)"
        joinDateLabel.text = "◦ \(propProfil.joinDate)"
    }
    
    private func setUnderline(_ button: UIButton) {
        underlineView = UIView()
        underlineView.backgroundColor = .black
        
        containerView.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.left.right.equalTo(button)
            make.height.equalTo(2)
        }
    }
    
    private func setButtonColor(_ sender: UIButton) {
        for button in buttonList {
            if button == sender {
                button.setTitleColor(.black, for: .normal)
                setUnderline(button)
            } else {
                button.setTitleColor(.lightGray, for: .normal)
            }
        }
    }
    
    private func viewIsHidden(_ selectView: UIView) {
        for view in viewList {
            if view == selectView {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        let tag = sender.tag

        switch tag {
        case BASICINFO_TAG:
            viewIsHidden(basicProfile)
        case TARGET_TAG:
            viewIsHidden(targetProfile)
        case GUARDIAN_TAG:
            viewIsHidden(guardianProfile)
        case SETTING_TAG:
            viewIsHidden(settingProfile)
        default:
            break
        }
        
        underlineView.isHidden = true
        setButtonColor(sender)
        
    }
    
    // MARK: - keyboard
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    func setGesture() {
        // keybord dismiss by touching anywhere in the view
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -
    private func addTarget() {
        for button in buttonList {
            button.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
        }
    }

    private func addView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(safeAreaView)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(scrollView)
            make.height.width.equalTo(scrollView)
        }
        
        containerView.addSubview(topBackground)
        
        topBackground.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(topBackground).offset(10)
            make.left.equalTo(topBackground).offset(20)
        }
        
        topBackground.addSubview(sirLabel)
        sirLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel).offset(-2)
            make.left.equalTo(nameLabel.snp.right).offset(3)
        }
        
        topBackground.addSubview(emailTitle)
        emailTitle.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(nameLabel)
        }
        
        topBackground.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTitle.snp.bottom).offset(5)
            make.left.equalTo(emailTitle)
        }
        
        topBackground.addSubview(joinDateTitle)
        joinDateTitle.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.left.equalTo(emailLabel)
        }
        
        topBackground.addSubview(joinDateLabel)
        joinDateLabel.snp.makeConstraints { make in
            make.top.equalTo(joinDateTitle.snp.bottom).offset(5)
            make.left.equalTo(joinDateTitle)
        }
        
        topBackground.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
            make.bottom.equalTo(joinDateLabel).offset(10)
        }
        
        // -------------------- Button --------------------
        containerView.addSubview(basicInfoButton)
        basicInfoButton.snp.makeConstraints { make in
            make.top.equalTo(topBackground.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
        }
        
        containerView.addSubview(goalButton)
        goalButton.snp.makeConstraints { make in
            make.top.equalTo(basicInfoButton)
            make.left.equalTo(basicInfoButton.snp.right).offset(10)
        }
        
        containerView.addSubview(guardianButton)
        guardianButton.snp.makeConstraints { make in
            make.top.equalTo(basicInfoButton)
            make.left.equalTo(goalButton.snp.right).offset(10)
        }
        
        containerView.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(basicInfoButton)
            make.left.equalTo(guardianButton.snp.right).offset(10)
        }
        
        // -------------------- VIEW --------------------
        for view in viewList {
            containerView.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.equalTo(basicInfoButton.snp.bottom).offset(5)
                make.left.right.bottom.equalTo(containerView)
            }
        }
        
        containerView.addSubview(authPhoneNumber)
        authPhoneNumber.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(30)
        }
        
    }
}
