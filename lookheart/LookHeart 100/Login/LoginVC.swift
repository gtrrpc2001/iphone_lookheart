//
//  LoginViewController.swift
//  LOOKHEART 100
//
//  Created by KHJ on 2024/04/09.
//

import Foundation
import UIKit
import LookheartPackage

class LoginVC : TitleViewController, DataPassingDelegate {
    private let emailTag = 1
    private let passwordTag = 2
    private var autoLogin = false
    
    private var viewModel = LoginVM()
    private var keyboardHandler: KeyboardEventHandling?
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupBindings()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler?.stopObserving()
    }
    
    
    
    // MARK: - Event
    private func setupBindings() {
        viewModel.setValidationHandlers(
            onSuccess: { [weak self] in
                DispatchQueue.main.async {
                    LoadingIndicator.shared.hide()
                    
                    self?.view.window?.rootViewController = TabBarController()
                    self?.view.window?.makeKeyAndVisible()
                }
            },
            onFailure: { [weak self] message in
                DispatchQueue.main.async {
                    LoadingIndicator.shared.hide()
                    
                    propAlert.basicAlert(
                        title: "loginFailed".localized(),
                        message: message,
                        ok: "ok".localized(),
                        viewController: self!)
                }
            })
    }
    
    @objc func autoLoginEvent(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle") {
            sender.setImage(UIImage(named: "check"), for: .normal)
            autoLogin = true
        } else {
            sender.setImage(UIImage(named: "circle"), for: .normal)
            autoLogin = false
        }
    }
    
    @objc func loginEvent(_ sender: UIButton) {
        LoadingIndicator.shared.show(in: self.view)
        
        viewModel.validateLogin(autoLogin: autoLogin)
    }
    
    @objc func signupEvent(_ sender: UIButton) {
        self.navigationController?.pushViewController(AgreeBasicTermsVC(), animated: true)
    }

    @objc func findEvent(_ sender: UIButton) {
        self.navigationController?.pushViewController(FindEmailVC(), animated: true)
    }
    
    func passData(email: String) {
        
    }
    
    @objc func textChanged(_ textField: UITextField) {
        switch textField.tag {
        case emailTag:
            viewModel.updateEmail(textField.text ?? "")
        case passwordTag:
            viewModel.updatePassword(textField.text ?? "")
        default:
            break
        }
    }
    
    
    
    // MARK: - Create
    private func createLabel(
        _ text: String,
        _ size: CGFloat,
        _ weight: UIFont.Weight,
        _ color: UIColor
    ) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = UIFont.systemFont(ofSize: size, weight: weight)
            $0.textColor = color
        }
    }
    
    
    private func createButton(
        _ text: String,
        _ size: CGFloat,
        _ weight: UIFont.Weight,
        _ color: UIColor,
        _ state: UIControl.State
    ) -> UIButton {
        return UIButton().then {
            $0.setTitle(text, for: state)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
            $0.setTitleColor(color, for: state)
        }
    }
    
    
    private func createTextField(
        _ text: String,
        _ tag: Int
    ) -> UITextField {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            .font: UIFont.systemFont(ofSize: 12)]
        
        return UITextField().then {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .darkGray
            $0.tintColor = .darkGray
            $0.backgroundColor = UIColor.PROFILE_BACKGROUND
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
            $0.leftViewMode = .always
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.tag = tag
            $0.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    
    private func setGesture(
        _ scrollView: UIScrollView,
        _ containerView: UIView
    ) {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        let heightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
    }
    
    
    // MARK: - Setup
    private func addViews() {
        let scrollView = UIScrollView()
        let containerView = UIView()
        
        // ScrollView, ContainerView
        setupScrollViewAndContainer(sv: scrollView, cv: containerView)
    
        // Login Help Text Label
        let loginUI = setupLoginLabels(in: containerView)
        
        // TextField
        let emailUI = setupEmailTextField(below: loginUI, in: containerView)
        let passwordUI = setupPasswordTextField(below: emailUI, in: containerView)
        
        // Auto Login Button
        let autoLoginUI = setupAutoLoginButton(below: passwordUI, in: containerView)

        // Find Email, Password Button
        let findUI = setupFindButton(below: passwordUI, in: containerView)
        
        // Login Button
        let loginButtonUI = setupLoginButton(below: findUI, leftRight: passwordUI, in: containerView, autoLoginUI)
        
        // HelpText Label
        let helpTextUI = setupHelpText(below: loginButtonUI, in: containerView)
        
        // Signup Button
        setupSignupButton(below: helpTextUI, leftRight: loginButtonUI, in: containerView)
    }
    
    
    
    // ScrollView, ContainerView
    private func setupScrollViewAndContainer(
        sv: UIScrollView,
        cv: UIView
    ) {
        view.addSubview(sv)
        sv.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(safeAreaView)
        }
        
        sv.addSubview(cv)
        cv.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(sv)
            make.width.equalTo(sv)
        }
        
        // Set ScrollView Event
        setGesture(sv, cv)
        keyboardHandler = KeyboardEventHandling(scrollView: sv)
        keyboardHandler?.startObserving()
    }
    
    
    
    // Login, Help Text
    private func setupLoginLabels(in containerView: UIView) -> UILabel {
        let loginLabel = createLabel("loginLabel".localized(), 18, .heavy, .black)
        let loginTextLabel = createLabel("loginText".localized(), 12, .semibold, .lightGray).then {
            $0.numberOfLines = 2
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
        
        return loginTextLabel
    }
    
    
    
    // EmailTextField
    private func setupEmailTextField(
        below loginLabel: UILabel,
        in containerView: UIView
    ) -> UITextField {
        let idTitleLabel = createLabel("email_Label".localized(), 12, .medium, .black)
        let emailTextField = createTextField("email_Hint".localized(), emailTag).then {
            $0.keyboardType = .emailAddress
            $0.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        }
        
        containerView.addSubview(idTitleLabel)
        idTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.left.equalTo(containerView.snp.left).offset(40)
        }
        
        containerView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(idTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(idTitleLabel.snp.left)
            make.right.equalTo(containerView.snp.right).offset(-40)
            make.height.equalTo(40)
        }
        
        return emailTextField
    }
    
    
    
    // PassWordTextField
    private func setupPasswordTextField(
        below emailTextField: UITextField,
        in containerView: UIView
    ) -> UITextField {
        let pwTitleLabel = createLabel("password_Label".localized(), 12, .medium, .black)
        let passWordTextField = createTextField("password_Hint".localized(), passwordTag).then {
            $0.isSecureTextEntry = true
            $0.clearsOnBeginEditing = false
            $0.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        }
        
        containerView.addSubview(pwTitleLabel)
        pwTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalTo(emailTextField)
        }
        
        containerView.addSubview(passWordTextField)
        passWordTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTitleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(40)
        }
        
        return passWordTextField
    }
    
    
    
    // Auto Login Button
    private func setupAutoLoginButton(
        below passWordTextField: UITextField,
        in containerView: UIView
    ) -> UIButton {
        let autoLoginButton = createButton("autoLogin".localized(), 12, .bold, .darkGray, .normal).then {
            let img = UIImage(named: "circle")
            $0.setImage(img, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.imageEdgeInsets = .init(top: 11, left: -15, bottom: 11, right: 0)
            $0.addTarget(self, action: #selector(autoLoginEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(autoLoginButton)
        autoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(5)
            make.left.equalTo(passWordTextField.snp.left).offset(-5)
        }
        return autoLoginButton
    }
    
    
    
    // Find ID, Password Button
    private func setupFindButton(
        below passWordTextField: UITextField,
        in containerView: UIView
    ) -> UIButton {
        let findButton = createButton("findEmailPassword".localized(), 12, .bold, .lightGray, .normal).then {
            $0.addTarget(self, action: #selector(findEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(findButton)
        findButton.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(10)
            make.right.equalTo(passWordTextField.snp.right).offset(10)
        }
        
        return findButton
    }
    
    
    // Login Button
    private func setupLoginButton(
        below findButton: UIButton,
        leftRight passWordTextField: UITextField,
        in containerView: UIView,
        _ autoLogin: UIButton
        
    ) -> UIButton {
        let loginButton = createButton("loginLabel".localized(), 14, .heavy, .white, .normal).then {
            $0.backgroundColor = UIColor.LOGIN_BUTTON
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(loginEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(findButton.snp.bottom).offset(15)
            make.left.right.equalTo(passWordTextField)
            make.height.equalTo(40)
        }
        
        return loginButton
    }
    
    
    // Hepl Text Label
    private func setupHelpText(
        below loginButton: UIButton,
        in containerView: UIView
    ) -> UILabel {
        let helpText = createLabel("signupHelpText".localized(), 14, .medium, UIColor.HELP_TEXT)
        
        containerView.addSubview(helpText)
        helpText.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.centerX.equalTo(safeAreaView.snp.centerX)
        }
        
        return helpText
    }
    
    
    // Signup Button
    private func setupSignupButton(
        below helpText: UILabel,
        leftRight loginButton: UIButton,
        in containerView: UIView
    ) {
        let signupButton = createButton("signupButton".localized(), 14, .heavy, .lightGray, .normal).then {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.addTarget(self, action: #selector(signupEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(signupButton)
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(helpText.snp.bottom).offset(20)
            make.left.right.equalTo(loginButton)
            make.height.equalTo(40)
        }
    }
}
