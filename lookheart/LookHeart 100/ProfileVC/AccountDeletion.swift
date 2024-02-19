import Foundation
import UIKit
import LookheartPackage

class AccountDeletion : TitleViewController, AuthDelegate {
    
    var password: String = ""
    private var phone: String = ""
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    private var authPhoneNumber = AuthPhoneNumber().then {
        $0.isHidden = true
        $0.alpha = 0
    }
    
    // MARK: -
    @objc private func agreeButtonEvent(_ sender: UIButton) {
        isHidden(true, false)
    }
    
    @objc private func backButtonEvent(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: -
    func complete(phoneNumber: String) {
        
        phone = phoneNumber
        
        isHidden(false, true)
        
    }
    
    func cancle() {
        isHidden(false, false)
    }
    
    
    private func isHidden(_ flag: Bool, _ checkResult: Bool) {
        if flag {
            
            authPhoneNumber.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.authPhoneNumber.alpha = 1
            }
            
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.authPhoneNumber.alpha = 0}) { [self] _ in
                
                authPhoneNumber.isHidden = true
                
                if checkResult {
                    matchPhoneNumber()
                }
                    
            }
        }
        
    }
    
    private func matchPhoneNumber() {
        if UserProfileManager.shared.phone == phone {
            accountDeletionAlert()
        } else {
            showAlert("mismatchesPhoneNumber".localized())
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "noti".localized(), message: message, preferredStyle: UIAlertController.Style.alert)
        let complite = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default)
        alert.addAction(complite)
        self.present(alert, animated: true, completion: {})
    }
    
    private func accountDeletionAlert() {
        let alert = UIAlertController(title: "noti".localized(), message: "accountDeletionText".localized(), preferredStyle: UIAlertController.Style.alert)
        let complite = UIAlertAction(title: "AccountDeletion".localized(), style: UIAlertAction.Style.default){ [self] _ in
            deleteAccount()
        }
        
        let cancel = UIAlertAction(title: "reject".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(complite)
        present(alert, animated: true, completion: {})
    }
    
    private func deleteAccount() {
        NetworkManager.shared.accountDeletion(parameters: setUserParam()) { result in
            switch result {
            case .success(let deletion):
                if deletion {
                    self.completeDeletionAccount()
                }
            case .failure(let error):
                print("deleteAccount : \(error)")
                propAlert.basicAlert(title: "noti".localized(), message: "serverError".localized(), ok: "ok".localized(), viewController: self)
            }
        }
    }
    
        
    private func completeDeletionAccount() {
        
        // BLE Disconnect
        BluetoothManager.shared.disconnectBLEDevice()
        
        // Login Flag
        UserProfileManager.shared.isLogin = false
        
        // AutoLogin Flag
        defaults.set(false, forKey: "autoLoginFlag")
        
        // Send Logout Log
        NetworkManager.shared.sendLog(id: propEmail, userType: .User, action: .AccountDeletion)
        NetworkManager.shared.updateLogoutFlag()
        
        view.window?.rootViewController = LoginVC()
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
        
    private func setUserParam() -> [String : Any] {
        return [
            "kind": "deleteUser",
            "eq": propProfil.email,
            "password": password,
            "email": propProfil.email,
            "eqname": propProfil.name,
            "phone": propProfil.phone,
            "sex": propProfil.gender,
            "height": propProfil.height,
            "weight": propProfil.weight,
            "age": propProfil.age,
            "birth": propProfil.birthDate,
            "sleeptime": propProfil.bedTime,
            "uptime": propProfil.wakeUpTime,
            "bpm": propProfil.targetBpm,
            "step": propProfil.targetStep,
            "distanceKM": propProfil.targetDistance,
            "calexe": propProfil.targetActivityCalorie,
            "cal": propProfil.targetCalorie,
            "alarm_sms": propProfil.conversionFlag == true ? 0 : 1,
            "differtime": "1"
        ]
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authPhoneNumber.delegate = self
        
        addViews()
        
    }
    
    // MARK: -
    private func createLabel(_ text: String, _ line: Int?, _ color: UIColor, fontSize: CGFloat, weight: UIFont.Weight, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.numberOfLines = line ?? 1
            $0.textColor = color
            $0.textAlignment = alignment
            $0.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        return label
    }
    
    private func createBackground() -> UILabel {
        let background = UILabel().then {
            $0.backgroundColor = UIColor.PROFILE_BACKGROUND
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        return background
    }
    
    // MARK: -
    private func addViews(){
        
        safeAreaView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(safeAreaView)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        // --------------------- deletion Start ---------------------
        let deletionLabel = createLabel("AccountDeletion".localized(), nil, .black, fontSize: 20, weight: .heavy, alignment: .center)
        
        let deletionText = createLabel("DeletionText".localized(), 2, .lightGray, fontSize: 16, weight: .heavy, alignment: .center)
        
        //
        containerView.addSubview(deletionLabel)
        containerView.addSubview(deletionText)
        
        //
        deletionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaView).offset(20)
            make.centerX.equalTo(safeAreaView)
        }
                
        deletionText.snp.makeConstraints { make in
            make.top.equalTo(deletionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(safeAreaView)
        }
        // --------------------- deletion End ---------------------
        
        
        
        // --------------------- Privacy Start ---------------------
        let privacyText = createLabel("privacyText".localized(), 2, .darkGray, fontSize: 16, weight: .heavy, alignment: .center)
        let privacyHelpText = createLabel("privacyHelpText".localized(), 10, .lightGray, fontSize: 12, weight: .medium, alignment: .center)
        let privacyBackground = createBackground()
        
        //
        containerView.addSubview(privacyText)
        containerView.addSubview(privacyHelpText)
        containerView.addSubview(privacyBackground)
        containerView.sendSubviewToBack(privacyBackground)
        
        //
        privacyText.snp.makeConstraints { make in
            make.top.equalTo(deletionText.snp.bottom).offset(40)
            make.left.equalTo(safeAreaView).offset(20)
            make.right.equalTo(safeAreaView).offset(-20)
        }
        
        privacyHelpText.snp.makeConstraints { make in
            make.top.equalTo(privacyText.snp.bottom).offset(10)
            make.left.right.equalTo(privacyText)
        }

        privacyBackground.snp.makeConstraints { make in
            make.top.equalTo(privacyText).offset(-5)
            make.bottom.equalTo(privacyHelpText).offset(10)
            make.left.equalTo(safeAreaView).offset(10)
            make.right.equalTo(safeAreaView).offset(-10)
        }
        
        // --------------------- Privacy End ---------------------
        
        
        
        
        
        // --------------------- Service Start ---------------------
        let serviceLogText = createLabel("serviceLogText".localized(), nil, .darkGray, fontSize: 16, weight: .heavy, alignment: .center)
        let serviceLogHelpText = createLabel("serviceLogHelpText".localized(), 10, .lightGray, fontSize: 12, weight: .medium, alignment: .center    )
        let serviceBackground = createBackground()
        
        //
        containerView.addSubview(serviceLogText)
        containerView.addSubview(serviceLogHelpText)
        containerView.addSubview(serviceBackground)
        containerView.sendSubviewToBack(serviceBackground)
        
        //
        serviceLogText.snp.makeConstraints { make in
            make.top.equalTo(privacyBackground.snp.bottom).offset(20)
            make.left.right.equalTo(privacyText)
        }
        
        containerView.addSubview(serviceLogHelpText)
        serviceLogHelpText.snp.makeConstraints { make in
            make.top.equalTo(serviceLogText.snp.bottom).offset(10)
            make.left.right.equalTo(privacyText)
        }

        serviceBackground.snp.makeConstraints { make in
            make.top.equalTo(serviceLogText).offset(-5)
            make.bottom.equalTo(serviceLogHelpText).offset(10)
            make.left.equalTo(safeAreaView).offset(10)
            make.right.equalTo(safeAreaView).offset(-10)
        }
        // --------------------- Service End ---------------------
        
        
        
        
        
        // --------------------- Service Start ---------------------
        let reSignupText = createLabel("reSignupText".localized(), nil, .darkGray, fontSize: 16, weight: .heavy, alignment: .center)
        let reSignupHelpText = createLabel("reSignupHelpText".localized(), 10, .lightGray, fontSize: 12, weight: .medium, alignment: .center)
        let reSignupBackground = createBackground()
        
        //
        containerView.addSubview(reSignupText)
        containerView.addSubview(reSignupHelpText)
        containerView.addSubview(reSignupBackground)
        containerView.sendSubviewToBack(reSignupBackground)
    
        //
        reSignupText.snp.makeConstraints { make in
            make.top.equalTo(serviceBackground.snp.bottom).offset(20)
            make.left.right.equalTo(privacyText)
        }
    
        reSignupHelpText.snp.makeConstraints { make in
            make.top.equalTo(reSignupText.snp.bottom).offset(10)
            make.left.right.equalTo(privacyText)
        }

        reSignupBackground.snp.makeConstraints { make in
            make.top.equalTo(reSignupText).offset(-5)
            make.bottom.equalTo(reSignupHelpText).offset(10)
            make.left.equalTo(safeAreaView).offset(10)
            make.right.equalTo(safeAreaView).offset(-10)
        }
        // --------------------- Service End ---------------------
        
        
        // --------------------- Notes Start ---------------------
        let notesText = createLabel("notesText".localized(), 2, .lightGray, fontSize: 12, weight: .heavy, alignment: .center)
        
        //
        containerView.addSubview(notesText)
        
        //
        notesText.snp.makeConstraints { make in
            make.top.equalTo(reSignupBackground.snp.bottom).offset(60)
            make.left.right.equalTo(privacyText)
        }
        
        // --------------------- Notes End ---------------------
        
        
        
        
        // --------------------- Agree Start ---------------------
        let agreeText = createLabel("AccountDeletionAgreeText".localized(), 3, .darkGray, fontSize: 14, weight: .bold, alignment: .center)
        
        let agreeButton = UIButton().then {
            $0.setTitle("AccountDeletionAgree".localized(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.backgroundColor = UIColor.MY_BODY_STATE
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(agreeButtonEvent(_:)), for: .touchUpInside)
        }
        
        let backButton = UIButton().then {
            $0.setTitle("back".localized(), for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.backgroundColor = UIColor.white
            $0.layer.borderColor = UIColor.PROFILE_BACKGROUND.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(backButtonEvent(_:)), for: .touchUpInside)
        }
        
        //
        containerView.addSubview(agreeText)
        containerView.addSubview(agreeButton)
        containerView.addSubview(backButton)
        
        //
        agreeText.snp.makeConstraints { make in
            make.top.equalTo(notesText.snp.bottom).offset(60)
            make.left.right.equalTo(reSignupBackground)
        }
        
        agreeButton.snp.makeConstraints { make in
            make.top.equalTo(agreeText.snp.bottom).offset(20)
            make.left.equalTo(safeAreaView.snp.centerX).offset(20)
            make.right.equalTo(safeAreaView).offset(-20)
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.height.equalTo(agreeButton)
            make.right.equalTo(safeAreaView.snp.centerX).offset(-20)
            make.left.equalTo(safeAreaView).offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        // --------------------- Agree End ---------------------
        
        
        containerView.addSubview(authPhoneNumber)
        authPhoneNumber.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(30)
        }
    }
}
