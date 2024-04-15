import UIKit
import LookheartPackage

protocol DataPassingDelegate: AnyObject {
    func passData(email: String)
}

class FindEmailVC : TitleViewController, UITextFieldDelegate, AuthDelegate {
    
    weak var delegate: DataPassingDelegate?
    
    private let authPhoneNumber = AuthPhoneNumber()
    
    private let FIRST_NAME_TAG = 1
    private let LAST_NAME_TAG = 2
    
    private var firstName = String()
    private var lastName = String()
    private var phoneNumber = String()
    private var birthday = String()
    private var id = String()
    
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private lazy var firstNameTextField = createTextField("firstnameHelp".localized(), .default, FIRST_NAME_TAG)
    private lazy var lastNameTextField = createTextField("lastnameHelp".localized(), .default, LAST_NAME_TAG)
    private lazy var phoneNumberField = createTextField("phoneHintText3".localized(), .numberPad, 0).then{   $0.isEnabled = false    }
    private lazy var birthdayLabel = createLabel("birthdayHelp".localized(), UIFont.systemFont(ofSize: 14, weight: .medium), .darkGray)
    
    // MARK: - UIDatePicker
    private let birthdayDatePicker = UIDatePicker().then {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        $0.datePickerMode = .date
        $0.locale = Locale.current
        $0.calendar = calendar
        $0.timeZone = .autoupdatingCurrent
        
        dateComponents.year = 1968
        dateComponents.month = 1
        dateComponents.day = 1
        
        if let date = calendar.date(from: dateComponents){ $0.date = date }
        
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func birthdayButtonEvent(_ sender: UIButton) {
        // 데이터 피커 알림창
        let dateAlert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        dateAlert.view.addSubview(birthdayDatePicker)
        birthdayDatePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        let cancelAction = UIAlertAction(title: "reject".localized(), style: .cancel, handler: nil)
        let completeAction = UIAlertAction(title: "ok".localized(), style: .default) { [weak self] _ in
            self?.updateBirthday()
        }

        dateAlert.addAction(cancelAction)
        dateAlert.addAction(completeAction)

        self.view.endEditing(true)
        present(dateAlert, animated: true, completion: nil)
    }
    
    private func updateBirthday() {
        // 데이트 피커에서 선택된 날짜 처리
        let dateFormat = MyDateTime.shared.getDateFormat()
        dateFormat.dateFormat = MyDateTime.shared.getFormatter(.DATE)
        dateFormat.locale = Locale.autoupdatingCurrent // 현재 로케일에 맞게 설정
        
        birthday = dateFormat.string(from: birthdayDatePicker.date)
        birthdayLabel.text = birthday
    }
    
    // MARK: - textField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case FIRST_NAME_TAG:
            firstName = textField.text ?? "Empty"
        case LAST_NAME_TAG:
            lastName = textField.text ?? "Empty"
        default:
            break
        }
    }
    
    // MARK: - button Evnet
    @objc func backButtonEvent(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func searchButtonEvent(_ sender: UIButton) {
        searchID()
        self.view.endEditing(true)
    }
    
    private func searchID() {
        Task {
            let getFindID = await ProfileService.shared.getFindID(name: setName(), phoneNumber: phoneNumber, birthday: birthday)
            let id = getFindID.0
            let response = getFindID.1
            
            switch response {
            case .success:
                self.id = id!
                searchAlert(id!)
            default:
                showAlert("unableFindId".localized())
            }
        }
    }
    
    private func searchAlert(_ id: String) {
        let alert = UIAlertController(title: "noti".localized(), message: id, preferredStyle: UIAlertController.Style.alert)
        
        let complite = UIAlertAction(title: "ChangePw".localized(), style: UIAlertAction.Style.default){ _ in
            let changePasswordVC = ChangePwVC()
            changePasswordVC.id = id
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
        }
        
        let cancle = UIAlertAction(title: "back".localized(), style: UIAlertAction.Style.default){ [self] _ in
            delegate?.passData(email: id)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(cancle)
        alert.addAction(complite)
        self.present(alert, animated: false, completion: {})
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "noti".localized(), message: message, preferredStyle: UIAlertController.Style.alert)
        let complite = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default)        
        alert.addAction(complite)
        self.present(alert, animated: false, completion: {})
    }
    
    private func setName() -> String {
        if firstName.isEmpty {
            return lastName
        } else {
            return "\(firstName) \(lastName)"
        }
    }
    
    // MARK: - auth
    func complete(result: String) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.authPhoneNumber.alpha = 0
        }) { _ in
            self.authPhoneNumber.isHidden = true
        }
        
        self.phoneNumber = result
        phoneNumberField.text = result
    }
    
    func cancle() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 본인 인증 UIView delegate
        authPhoneNumber.delegate = self
        
        // set email delegate
        if let rootVC = self.navigationController?.viewControllers.first as? LoginVC {
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
        }
        return label
    }
    
    private func createTextField(_ placeholder: String, _ type: UIKeyboardType, _ tag: Int) -> UITextField {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 14)]
        
        let textField = UITextField().then {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .darkGray
            $0.tintColor = .darkGray
            $0.backgroundColor = UIColor.PROFILE_BACKGROUND
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
            $0.leftViewMode = .always
            $0.keyboardType = type
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.isEnabled = true
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
        
        // Find ID Label
        let findIdLabel = createLabel("findID".localized(), UIFont.systemFont(ofSize: 18, weight: .heavy), .darkGray)
        containerView.addSubview(findIdLabel)
        findIdLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.left.equalTo(containerView.snp.left).offset(15)
        }
        
        // Help Text
        let findIdHelpTextLabel = createLabel("findHelpText".localized(), UIFont.systemFont(ofSize: 16, weight: .medium), .lightGray)
        containerView.addSubview(findIdHelpTextLabel)
        findIdHelpTextLabel.snp.makeConstraints { make in
            make.top.equalTo(findIdLabel.snp.bottom).offset(20)
            make.left.equalTo(findIdLabel)
        }
        
        // ----------------------------- First Name Start -----------------------------
        
        // Label
        let firstNameLabel = createLabel("firstname".localized(), UIFont.systemFont(ofSize: 16, weight: .heavy), .darkGray)
        containerView.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(findIdHelpTextLabel.snp.bottom).offset(20)
            make.left.equalTo(findIdHelpTextLabel)
        }
        
        // Text Field
        containerView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(10)
            make.left.equalTo(firstNameLabel)
            make.right.equalTo(safeAreaView.snp.centerX).offset(-10)
            make.height.equalTo(40)
        }
        // ----------------------------- First Name End -----------------------------
        
        
        
        
        // ----------------------------- Last Name Start -----------------------------
        
        // Label
        let lastNameLabel = createLabel("lastname".localized(), UIFont.systemFont(ofSize: 16, weight: .heavy), .darkGray)
        containerView.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel)
            make.left.equalTo(safeAreaView.snp.centerX).offset(10)
        }
        
        // Text Field
        containerView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField)
            make.left.equalTo(lastNameLabel)
            make.right.equalTo(safeAreaView).offset(-10)
            make.height.equalTo(40)
        }
        // ----------------------------- Last Name End -----------------------------
        
        
        
        // ----------------------------- PhoneNumber Start -----------------------------
        
        // Label
        let phoneNumberLabel = createLabel("phoneHintText3".localized(), UIFont.systemFont(ofSize: 16, weight: .heavy), .darkGray)
        containerView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        // TextField
        containerView.addSubview(phoneNumberField)
        phoneNumberField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(10)
            make.left.equalTo(firstNameTextField)
            make.right.equalTo(lastNameTextField)
            make.height.equalTo(40)
        }
        // ----------------------------- PhoneNumber End -----------------------------
        
        
        
        
        // ----------------------------- Birthday Start -----------------------------
        
        // Title Label
        let birthdayTitle = createLabel("birthday_Label".localized(), UIFont.systemFont(ofSize: 16, weight: .heavy), .darkGray)
        containerView.addSubview(birthdayTitle)
        birthdayTitle.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberField.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        // Background Label
        let birthdayBackground = UILabel().then {
            $0.backgroundColor = UIColor.PROFILE_BACKGROUND
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        containerView.addSubview(birthdayBackground)
        birthdayBackground.snp.makeConstraints { make in
            make.top.equalTo(birthdayTitle.snp.bottom).offset(10)
            make.left.equalTo(firstNameTextField)
            make.right.equalTo(lastNameTextField)
            make.height.equalTo(40)
        }
        
        // Button
        let birthdayButton = UIButton(type: .custom).then {
            let image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
            $0.setImage(image, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 300)
            $0.addTarget(self, action: #selector(birthdayButtonEvent(_:)), for: .touchUpInside)
        }
        containerView.addSubview(birthdayButton)
        birthdayButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(birthdayBackground)
            make.left.equalTo(birthdayBackground).offset(5)
        }
        
        // Value Label
        containerView.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(birthdayBackground)
            make.left.equalTo(birthdayTitle.snp.right).offset(-10)
        }
        // ----------------------------- Birthday End -----------------------------
        
        
        
        
        // ----------------------------- Button Start -----------------------------
        
        // SearchButton
        let searchButton = UIButton().then {
            $0.setTitle("search".localized(), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor.LOGIN_BUTTON
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(searchButtonEvent(_:)), for: .touchUpInside)
        }
        containerView.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(birthdayBackground.snp.bottom).offset(40)
            make.left.height.equalTo(firstNameTextField)
            make.right.equalTo(lastNameTextField)
        }
        
        
        // BackButton
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
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.left.height.equalTo(firstNameTextField)
            make.right.equalTo(lastNameTextField)
        }
        
        // ----------------------------- Button End -----------------------------
        
        
        // Auth
        view.addSubview(authPhoneNumber)
        authPhoneNumber.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaView)
            make.bottom.equalTo(safeAreaView).offset(30)
        }
    }
}
