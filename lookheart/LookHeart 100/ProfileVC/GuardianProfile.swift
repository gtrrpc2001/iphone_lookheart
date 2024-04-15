import UIKit
import LookheartPackage

class GuardianProfile: UIView, UITextFieldDelegate {
 
    private let FIRST_TAG = 0
    private let SECOND_TAG = 1
    
    private var firstGuardian = ""
    private var secondGuardian = ""

    private var textfieldTag = 0

    private var guardianNumbers:[String] = []
    private var guardianNumberList:[String] = []
    
    /*------------------------- Image, Attributes ------------------------*/
    // region
    let plusImage =  UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    let minusImage =  UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                      .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
    // endregion
    
    /*------------------------- Dictionary ------------------------*/
    // region
    private lazy var backgroundList: [UILabel] = [firstGuardianBackground, secondGuardianBackground]
    private lazy var textFieldList: [Int : UITextField] = [:]
    private lazy var guardianNumberCheck: [Int : String] = [:]
    // endregion
    
    // MARK: -
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    /*------------------------- UILabel ------------------------*/
    // region
    // Text Label
    private lazy var guardianLabel = createLabel("profile3_guardianTitle".localized(), 16, .bold, .black, 1)
    
    private lazy var guardianInfo = createLabel("\("profile3_arrInfo1".localized())\n\("profile3_arrInfo2".localized())", 14, .medium, .lightGray, 2)
    
    private lazy var guardianAlertLabel = createLabel("profile3_guardianNoti".localized(), 14, .medium, .darkGray, 1)

    private lazy var alertNumberLabel = createLabel("profile3_arrNumber".localized(), 14, .medium, .darkGray, 1)
    
    private lazy var firstGuardianLabel = createLabel("profile3_guardianNumber1".localized(), 14, .medium, .darkGray, 1)

    private lazy var secondGuardianLabel = createLabel("profile3_guardianNumber2".localized(), 14, .medium, .darkGray, 1)
    
    private lazy var arrCnt = createLabel("1", 14, .medium, .darkGray, 1)
    
    // Background Label
    private lazy var alertBackground = createBackgroundLabel()
    private lazy var alertNumberBackground = createBackgroundLabel()
    
    private lazy var firstGuardianBackground = createBackgroundLabel()
    private lazy var secondGuardianBackground = createBackgroundLabel()
    // endregion
    
    /*------------------------- UIButton ------------------------*/
    // region
    private lazy var plusButton = UIButton().then {
        $0.setImage(plusImage, for: .normal)
        $0.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var minusButton = UIButton().then {
        $0.setImage(minusImage, for: .normal)
        $0.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var guardianSaveButton = UIButton(type: .custom).then {
        $0.setTitle("profile_save".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.LOGIN_BUTTON
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(saveGuardian(_:)), for: .touchUpInside)
    }
    // endregion
    
    // MARK: - UIButton Event
    @objc func saveGuardian(_ sender: UIButton) {
        
        guardianNumbers.removeAll()
        
        if !isValidGuardianNumber(firstGuardian) || !isValidGuardianNumber(secondGuardian) {
            keyboardDown()
            return
        }
        
        addGuardianNumberIfExists(firstGuardian, tag: FIRST_TAG)
        addGuardianNumberIfExists(secondGuardian, tag: SECOND_TAG)
        
        guardianNumbers = Array(guardianNumberCheck.values) // Dictionary -> [String]
        
        UserProfileManager.shared.guardianPhoneNumber = guardianNumbers

    
        setGuardian()
        keyboardDown()
    }
    
    private func addGuardianNumberIfExists(_ number: String, tag: Int) {
        guard !number.isEmpty else { return }
        guardianNumberCheck[tag] = number
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        showToast("functionMessage".localized())
    }
    
    private func setGuardian() {
        let phoneNumber = UserProfileManager.shared.guardianPhoneNumber
        
        Task {
            let response = await ProfileService.shared.postGuardian(phone: phoneNumber)
            
            switch response {
            case .success:
                updateProfile()
                showToast("setGuardianComp".localized())
            default:
                showToast("setGuardianFail".localized())
            }
        }
    }
    
    private func isValidGuardianNumber(_ number: String) -> Bool {
        if number.isEmpty { return true }
        return !number.isEmpty && checkRegex(phoneNumberRegex!, number)
    }
    
    private func keyboardDown() {
        for textField in textFieldList {
            textField.value.resignFirstResponder()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        
        createButtons()
        
        addGuardianTextField()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateProfile() {
        let numbers = UserProfileManager.shared.guardianPhoneNumber
        guardianNumberList.removeAll()
        
        for number in numbers {
            guardianNumberList.append(number)
        }
        
        for textFiled in textFieldList {
            textFiled.value.attributedPlaceholder = setPlaceholder(textFiled.key)
        }
    }
    
    
    // MARK: -
    public func createButtons() {
        let enabledButton = createButton(enableFlag: true)
        let disabledButton = createButton(enableFlag: false)
        
        let buttonStackView = UIStackView(arrangedSubviews: [disabledButton, enabledButton]).then {
            $0.spacing = 10
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
          
        containerView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(alertBackground)
            make.left.equalTo(alertBackground).offset(10)
            make.right.equalTo(alertBackground).offset(-10)
        }
    }
    
    private func createButton(enableFlag: Bool) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(enableFlag ? "profile3_on".localized(): "profile3_off".localized(), for: .normal )
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.setTitleColor(enableFlag ? .white : UIColor.PROFILE_BUTTON_TEXT, for: .normal)
            $0.backgroundColor = enableFlag ? UIColor.PROFILE_BUTTON_SELECT : .clear
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
        }
        return button
    }
    
    private func createLabel(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor, _ number: Int) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.font = UIFont.systemFont(ofSize: size, weight: weight)
            $0.textColor = color
            $0.numberOfLines = number
        }
        return label
    }
    
    private func createBackgroundLabel() -> UILabel {
        let label = UILabel().then {
            $0.backgroundColor = UIColor.PROFILE_BACKGROUND
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        return label
    }
    
    
    // MARK: -
    private func addGuardianTextField() {
        for background in backgroundList {

            let textField = createTextField()
            
            containerView.addSubview(textField)
            
            textField.snp.makeConstraints { make in
                make.top.bottom.right.equalTo(background)
                make.left.equalTo(background).offset(5)
            }
        }
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField().then {
            $0.textColor = .darkGray
            $0.tintColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.keyboardType = .numberPad
            $0.textAlignment = .left
            $0.clearsOnBeginEditing = true
            $0.delegate = self
            $0.tag = textfieldTag
        }
        
        textFieldList[textfieldTag] = textField
        textfieldTag += 1
        
        return textField
    }
    
    func setPlaceholder(_ tag: Int) -> NSAttributedString {
        if tag >= guardianNumberList.count {
            return NSAttributedString(string: "phoneHintText2".localized(), attributes: attributes)
        } else {
            guardianNumberCheck[tag] = guardianNumberList[tag]
            return NSAttributedString(string: guardianNumberList[tag], attributes: attributes)
        }
    }
    
    
    // MARK: - UITextField Event
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? "EMPTY"
        let tag = textField.tag
        let regexCheck = checkRegex(phoneNumberRegex!, txt)
        
        scrollView.isScrollEnabled = true

        if !regexCheck && txt.count > 0 {
            showAlert(title: "noti".localized(), message: "numberHintText".localized())
            initText(tag: tag)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = textField.text ?? "EMPTY"
        let tag = textField.tag
        
        switch tag {
        case FIRST_TAG:
            firstGuardian = txt
        case SECOND_TAG:
            secondGuardian = txt
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func checkRegex(_ regex: NSRegularExpression, _ text: String) -> Bool {
        return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) != nil
    }
    
    private func initText(tag: Int) {
        
        textFieldList[tag]?.text = ""
        
        switch tag {
        case FIRST_TAG:
            firstGuardian = ""
        case SECOND_TAG:
            secondGuardian = ""
        default:
            break
        }
    }
    
    private func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        parentViewController?.present(alert, animated: false)
    }
    
    private func showToast(_ message: String) {
        ToastHelper.shared.showToast(self, message, withDuration: 1.0, delay: 1.0, bottomPosition: true)
    }
    
    // MARK: -
    private func addView() {
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(500)
        }
        
        
        
        // 보호자 알림
        containerView.addSubview(guardianLabel)
        guardianLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(guardianInfo)
        guardianInfo.snp.makeConstraints { make in
            make.top.equalTo(guardianLabel.snp.bottom).offset(20)
            make.left.equalTo(guardianLabel)
        }
        
        
        
        
        // 보호자 알림 기능
        containerView.addSubview(guardianAlertLabel)
        guardianAlertLabel.snp.makeConstraints { make in
            make.top.equalTo(guardianInfo.snp.bottom).offset(20)
            make.left.equalTo(guardianLabel)
        }
        
        containerView.addSubview(alertBackground)
        alertBackground.snp.makeConstraints { make in
            make.top.equalTo(guardianAlertLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        
        
        // 보호자 알림 기준 횟수
        containerView.addSubview(alertNumberLabel)
        alertNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(alertBackground.snp.bottom).offset(10)
            make.left.equalTo(guardianLabel)
        }
        
        containerView.addSubview(alertNumberBackground)
        alertNumberBackground.snp.makeConstraints { make in
            make.top.equalTo(alertNumberLabel.snp.bottom).offset(10)
            make.left.right.height.equalTo(alertBackground)
        }
        
        containerView.addSubview(arrCnt)
        arrCnt.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(alertNumberBackground)
        }
        
        containerView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(alertNumberBackground)
            make.right.equalTo(alertNumberBackground).offset(-10)
        }
        containerView.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(alertNumberBackground)
            make.left.equalTo(alertNumberBackground).offset(10)
        }
        
        
        
        // 보호자 연락처 1
        containerView.addSubview(firstGuardianLabel)
        firstGuardianLabel.snp.makeConstraints { make in
            make.top.equalTo(alertNumberBackground.snp.bottom).offset(10)
            make.left.equalTo(guardianLabel)
        }
        
        containerView.addSubview(firstGuardianBackground)
        firstGuardianBackground.snp.makeConstraints { make in
            make.top.equalTo(firstGuardianLabel.snp.bottom).offset(10)
            make.left.right.height.equalTo(alertBackground)
        }
        
        
        
        
        // 보호자 연락처 2
        containerView.addSubview(secondGuardianLabel)
        secondGuardianLabel.snp.makeConstraints { make in
            make.top.equalTo(firstGuardianBackground.snp.bottom).offset(10)
            make.left.equalTo(guardianLabel)
        }
        
        containerView.addSubview(secondGuardianBackground)
        secondGuardianBackground.snp.makeConstraints { make in
            make.top.equalTo(secondGuardianLabel.snp.bottom).offset(10)
            make.left.right.height.equalTo(alertBackground)
        }
        
        // save button
        containerView.addSubview(guardianSaveButton)
        guardianSaveButton.snp.makeConstraints { make in
            make.top.equalTo(secondGuardianBackground.snp.bottom).offset(30)
            make.left.right.height.equalTo(alertBackground)
        }
    }
}
