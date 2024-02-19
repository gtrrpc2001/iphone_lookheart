import Foundation
import UIKit
import LookheartPackage

class GuardianAlert: UIViewController {
    
    private static let FIRST_GUARDIAN_TAG = 1
    private static let SECOND_GUARDIAN_TAG = 2
    
    private var firstTextField:String = ""
    private var secondTextField:String = ""
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "setupGuardian".localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.MY_BLUE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let firstGuardianTitle: UILabel = {
        let label = UILabel()
        label.text = "profile3_guardianNumber1".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondGuardianTitle: UILabel = {
        let label = UILabel()
        label.text = "profile3_guardianNumber2".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstGuardianTextField: UnderLineTextField = {
        var textField = UnderLineTextField()
        textField.textColor = .darkGray
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor.MY_BLUE
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholderString = "setupGuardianTxt".localized()
        textField.placeholderColor = UIColor.MY_BLUE
        textField.tag = FIRST_GUARDIAN_TAG
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let secondGuardianTextField: UnderLineTextField = {
        var textField = UnderLineTextField()
        textField.textColor = .darkGray // 입력 Text Color
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor.MY_BLUE
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholderString = "setupGuardianTxt".localized()
        textField.placeholderColor = UIColor.MY_BLUE
        textField.tag = SECOND_GUARDIAN_TAG
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("nextGuardianPhone".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = UIColor.MY_BLUE
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func isPhoneValid(_ phoneNumber: String) -> Bool {
        return phoneNumberRegex?.firstMatch(in: phoneNumber, options: [], range: NSRange(location: 0, length: phoneNumber.count)) != nil
    }
    
    @objc func didTapActionButton() {
        let phoneNumbers = [firstTextField, secondTextField].filter { !$0.isEmpty }
        let areAllNumbersValid = phoneNumbers.allSatisfy(isPhoneValid)

        if actionButton.title(for: .normal) == "nextGuardianPhone".localized() {
            dismiss(animated: true)
        } else if areAllNumbersValid {
            setGuardian(phoneNumbers)
        } else {
            ToastHelper.shared.showToast(view, "setupGuardianTxt".localized(), withDuration: 1.0, delay: 1.0, bottomPosition: false)
        }
        
        NotificationManager.shared.setNotificationEnabled(type: .guardian, flag: true)
    }
    
    private func setGuardian(_ guardian: [String]){
        
        
        NetworkManager.shared.setGuardianToServer(phone: guardian) { [self] result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    ToastHelper.shared.showToast(
                        view, "setGuardianComp".localized(),
                        withDuration: 0.5, delay: 0.5, bottomPosition: false)
                } else {
                    ToastHelper.shared.showToast(
                        view, "setGuardianFail".localized(),
                        withDuration: 0.5, delay: 0.5, bottomPosition: false)
                    
                }
                alertDismiss()
            case .failure(let error):
                ToastHelper.shared.showToast(
                    view, "setGuardianFail".localized(),
                    withDuration: 0.5, delay: 0.5, bottomPosition: false)
                alertDismiss()
                print("setGuardian 네트워크 요청 실패했습니다: \(error)")
            }
        }
    }
    
    private func alertDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setKeyboardUpDown()
    }
    
    private func setKeyboardUpDown() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        switch (textField.tag) {
        case GuardianAlert.FIRST_GUARDIAN_TAG:
            firstTextField = txt
        case GuardianAlert.SECOND_GUARDIAN_TAG:
            secondTextField = txt
        default:
            break
        }
        
        if firstTextField.count > 0 || secondTextField.count > 0 {
            setButtonTitle("ok".localized())
        } else {
            setButtonTitle("nextGuardianPhone".localized())
        }
        
    }
    
    private func setButtonTitle(_ title: String) {
        actionButton.setTitle(title, for: .normal)
    }
            
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 200
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    deinit {
        // 알림 해제
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setAction(){
        firstGuardianTextField.addTarget(self,
                            action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        secondGuardianTextField.addTarget(self,
                            action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(firstGuardianTitle)
        backgroundView.addSubview(firstGuardianTextField)
        backgroundView.addSubview(secondGuardianTitle)
        backgroundView.addSubview(secondGuardianTextField)
        backgroundView.addSubview(actionButton)
        
        setupConstraint()
        setAction()
    }
    
    private func setupConstraint(){
        let screenWidth = UIScreen.main.bounds.width // Screen width
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: screenWidth / 1.2),
            backgroundView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            firstGuardianTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            firstGuardianTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            
            firstGuardianTextField.topAnchor.constraint(equalTo: firstGuardianTitle.bottomAnchor, constant: 10),
            firstGuardianTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            firstGuardianTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            
            secondGuardianTitle.topAnchor.constraint(equalTo: firstGuardianTextField.bottomAnchor, constant: 20),
            secondGuardianTitle.leadingAnchor.constraint(equalTo: firstGuardianTitle.leadingAnchor),
            
            secondGuardianTextField.topAnchor.constraint(equalTo: secondGuardianTitle.bottomAnchor, constant: 10),
            secondGuardianTextField.leadingAnchor.constraint(equalTo: firstGuardianTextField.leadingAnchor),
            secondGuardianTextField.trailingAnchor.constraint(equalTo: firstGuardianTextField.trailingAnchor),
            
            actionButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            actionButton.widthAnchor.constraint(equalToConstant: 150),
            actionButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
