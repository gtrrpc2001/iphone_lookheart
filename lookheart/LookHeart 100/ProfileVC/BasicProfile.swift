import UIKit
import LookheartPackage

class BasicProfile: UIView, UITextFieldDelegate {
    
    private let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
    private lazy var birthdayImage =  UIImage(
        systemName: "calendar",
        withConfiguration: symbolConfiguration)?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
    
    private let attributes = [NSAttributedString.Key
        .foregroundColor: UIColor.darkGray,
        .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    
    private let datePicker = UIDatePicker()
    private let datePickerTitle = "\n\n\n\n\n\n\n\n\n\n\n\n"
    private var datePickerDate = ""
    
    private let firstNameTag = 1, lastNameTag = 2, phoneTag = 3, heightTag = 4, weightTag = 5, sleepTag = 6, wakeupTag = 7
    
    private var firstName = ""
    private var lastName = ""
    private var phoneNumber = ""
    private var height = ""
    private var weight = ""
    private var gender = ""
    private var sleep = ""
    private var wakeup = ""
        
    private lazy var textFieldMapping: [String: UITextField] = [
        "FirstName": firstNameTextField,
        "LastName": lastNameTextField,
        "PhoneNumber": phoneTextField,
        "Height": heightTextField,
        "Weight": weightTextField,
        "SleepTime": sleepTextField,
        "WakeupTime": wakeupTextField
    ]
    
    private lazy var textFields: [UITextField] = [firstNameTextField, lastNameTextField, phoneTextField, heightTextField, weightTextField]
    
    // MARK: -
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    private let privacyInfo = UILabel().then {
        $0.text = "\("profile_HelpInfo1".localized())\n\("profile_HelpInfo2".localized())"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .lightGray
        $0.numberOfLines = 2
    }
    
    private let firstNameLabel = UILabel().then {
        $0.text = "firstname".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let lastNameLabel = UILabel().then {
        $0.text = "lastname".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let phoneLabel = UILabel().then {
        $0.text = "profile_phone".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let birthdayLabel = UILabel().then {
        $0.text = "birthday_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let birthday = UILabel().then {
        $0.text = UserProfileManager.shared.birthDate
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }

    private let ageLabel = UILabel().then {
        $0.text = "age".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }

    private let age = UILabel().then {
        $0.text = UserProfileManager.shared.age
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "gender".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }

    private let heightLabel = UILabel().then {
        $0.text = "height".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }

    private let weightLabel = UILabel().then {
        $0.text = "weight".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let sleepLabel = UILabel().then {
        $0.text = "profile_sleep".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let wakeupLabel = UILabel().then {
        $0.text = "profile_wakeup".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    /*------------------------- Background ------------------------*/
    private let firstNameBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let lastNameBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let phoneBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
        
    private let birthdayBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private let ageBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let genderBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let heightBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let weightBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let sleepBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let wakeupBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    /*------------------------- TextField ------------------------*/
    private lazy var firstNameTextField = UITextField().then {
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.tag = firstNameTag
        $0.delegate = self
        $0.attributedPlaceholder = NSAttributedString(string: UserProfileManager.shared.name, attributes: attributes)
    }

    private lazy var lastNameTextField = UITextField().then {
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.tag = lastNameTag
        $0.delegate = self
        $0.attributedPlaceholder = NSAttributedString(string: UserProfileManager.shared.name, attributes: attributes)
    }
    
    private lazy var phoneTextField = UITextField().then {
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.clearsOnBeginEditing = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.tag = phoneTag
        $0.delegate = self
        $0.keyboardType = .numberPad
        $0.attributedPlaceholder = NSAttributedString(string: UserProfileManager.shared.phone, attributes: attributes)
    }
    
    private lazy var heightTextField = UITextField().then {
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.tag = heightTag
        $0.delegate = self
        $0.keyboardType = .numberPad
        $0.attributedPlaceholder = NSAttributedString(string: UserProfileManager.shared.height, attributes: attributes)
    }
    
    private lazy var weightTextField = UITextField().then {
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.tag = weightTag
        $0.delegate = self
        $0.keyboardType = .numberPad
        $0.attributedPlaceholder = NSAttributedString(string: UserProfileManager.shared.weight, attributes: attributes)
    }
    
    private lazy var sleepTextField = UITextField().then {
        let bedTime = String(UserProfileManager.shared.bedTime)
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.tag = sleepTag
        $0.delegate = self
        $0.keyboardType = .numberPad
        $0.attributedPlaceholder = NSAttributedString(string: bedTime, attributes: attributes)
    }
    
    private lazy var wakeupTextField = UITextField().then {
        let wakeupTime = String(UserProfileManager.shared.wakeUpTime)
        $0.textColor = .darkGray
        $0.tintColor = .darkGray
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.tag = wakeupTag
        $0.delegate = self
        $0.keyboardType = .numberPad
        $0.attributedPlaceholder = NSAttributedString(string: wakeupTime, attributes: attributes)
    }
    
    /*------------------------- UIStackView ------------------------*/
    private lazy var labelSV = UIStackView(arrangedSubviews: [genderLabel, heightLabel, weightLabel]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private lazy var backgroundSV = UIStackView(arrangedSubviews: [genderBackground, heightBackground, weightBackground]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    /*------------------------- Button ------------------------*/
    private lazy var birthdayDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale.autoupdatingCurrent // 현재 로케일에 맞게 설정
        $0.timeZone = .autoupdatingCurrent

        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
        
        $0.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
    }
    
    private lazy var birthdayButton = UIButton(type: .custom).then {
        $0.setImage(birthdayImage, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 230)
        $0.addTarget(self, action: #selector(birthdayButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var genderButton = UIButton(type: .custom).then {
        $0.setTitle("Empty", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(genderButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var basicInfoSaveButton = UIButton(type: .custom).then {
        $0.setTitle("profile_save".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.LOGIN_BUTTON
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(saveProfile(_:)), for: .touchUpInside)
    }
    
    
    // MARK: UIButton Event
    @objc func saveProfile(_ sender: UIButton) {
        
        let userDefaultsUpdates: [String: String] = [
            "FirstName": firstName,
            "LastName": lastName,
            "Birthday": String(birthday.text!),
            "Age": String(age.text!),
            "PhoneNumber": phoneNumber,
            "Gender": gender,
            "Height": height,
            "Weight": weight,
            "SleepTime": sleep,
            "WakeupTime": wakeup
        ]
        
        for (key, value) in userDefaultsUpdates {
            if !value.isEmpty {
                
                setProfile(key, value)
                
                if let textField = textFieldMapping[key] { // 업데이트
                    textField.text = value
                    textField.placeholder = value
                }
            }
        }
        
        saveUserData()
        keyboardDown()
    }

    func setProfile(_ key: String, _ value: String){
//         print("key : \(key), value : \(value)")
        switch(key){
        case "FirstName":
            propProfil.name = "\(firstName) \(lastName)"
        case "LasttName":
            propProfil.name = "\(firstName) \(lastName)"
        case "Birthday":
            UserProfileManager.shared.birthDate = value
        case "Age":
            UserProfileManager.shared.age = value
        case "PhoneNumber":
            UserProfileManager.shared.phone = value
        case "Gender":
            UserProfileManager.shared.gender = value
        case "Height":
            UserProfileManager.shared.height = value
        case "Weight":
            UserProfileManager.shared.weight = value
        case "SleepTime":
            UserProfileManager.shared.bedTime = Int(value) ?? 23
        case "WakeupTime":
            UserProfileManager.shared.wakeUpTime = Int(value) ?? 7
        default:
            break
        }
    }
    
    func saveUserData(){

        let userData: [String: Any] = [
            "kind": "setProfile",
            "eq": propEmail,
            "eqname": propProfil.name,
            "email": propEmail,
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
            "alarm_sms": "0",
            "differtime": "1"
        ]
        
        Task {
            let response = await ProfileService.shared.postSignup(params: userData)
            
            switch response {
            case .success:
                alert(title: "saveData".localized(), message: nil)
            default:
                alert(title: "failSaveData".localized(), message: nil)
            }
        }
    }
    
    @objc func genderButtonEvent(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "gender".localized(),
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        
        let male = UIAlertAction(
            title: "male_Label".localized(),
            style: UIAlertAction.Style.default) { [self] _ in
                
                genderButton.setTitle("male_Label".localized(), for: .normal)
                gender = "남자"
        }
        
        let female = UIAlertAction(
            title: "female_Label".localized(),
            style: UIAlertAction.Style.default) { [self]_ in
                
                genderButton.setTitle("female_Label".localized(), for: .normal)
                gender = "여자"
            }
        
        alert.addAction(male)
        alert.addAction(female)
        
        parentViewController?.present(alert, animated: false)
    }
    
    @objc func birthdayButtonEvent(_ sender: UIButton) {
        
        let dateAlert = UIAlertController(title: datePickerTitle, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        
        dateAlert.view.addSubview(birthdayDatePicker)
        birthdayDatePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dateAlert.view.snp.top).offset(8)
            make.width.equalTo(dateAlert.view.snp.width)
            make.height.equalTo(200)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("reject", comment: ""), style: .cancel, handler: nil)
        let completeAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { [weak self] _ in
            self?.updateBirthday()
        }

        dateAlert.addAction(cancelAction)
        dateAlert.addAction(completeAction)

        parentViewController?.present(dateAlert, animated: true, completion: nil)
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.autoupdatingCurrent // 현재 로케일에 맞게 설정
        datePickerDate = dateFormatter.string(from: sender.date)
    }
    
    func updateBirthday() {
        birthday.text = datePickerDate
        age.text = calculateAge(from: birthdayDatePicker.date)
    }

    func calculateAge(from birthDate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        let age = ageComponents.year!
        return String(age)
    }
    
    private func alert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        parentViewController?.present(alert, animated: false)
    }
    
    private func keyboardDown(){
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        
        updateProfile()
        
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func updateProfile() {
        
        let name = propProfil.name.split(separator: " ")
        
        if name.count > 1 {
            firstNameTextField.attributedPlaceholder = setAttributed(text: String(name[0]))
            lastNameTextField.attributedPlaceholder = setAttributed(text: String(name[1]))
        } else {
            firstNameTextField.attributedPlaceholder = setAttributed(text: String(name[0]))
            lastNameTextField.attributedPlaceholder = setAttributed(text: lastName)
        }
        
        let gender = propProfil.gender == "남자" ? "male_Label".localized() : "female_Label".localized()
        
        let bedTime = String(propProfil.bedTime)
        let wakeupTime = String(propProfil.wakeUpTime)
        
        let phone = propProfil.phone
        let phoneText = phone == "01012345678" ? "phoneHintText2".localized() : phone
        
        age.text = propProfil.age
        birthday.text = propProfil.birthDate
        genderButton.setTitle(gender, for: .normal)
        
        phoneTextField.attributedPlaceholder = setAttributed(text: phoneText)
        heightTextField.attributedPlaceholder = setAttributed(text: propProfil.height)
        weightTextField.attributedPlaceholder = setAttributed(text: propProfil.weight)
        sleepTextField.attributedPlaceholder = setAttributed(text: bedTime)
        wakeupTextField.attributedPlaceholder = setAttributed(text: wakeupTime)
    }
    
    private func setAttributed(text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    // MARK: UITextField Event
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? "EMPTY"
        let tag = textField.tag
        
        var regexCheck:Bool = true
        scrollView.isScrollEnabled = true
        
        switch tag {
        case firstNameTag, lastNameTag:
            regexCheck = checkRegex(nameRegex!, txt)
        case phoneTag:
            regexCheck = checkRegex(phoneNumberRegex!, txt)
        case heightTag, weightTag:
            regexCheck = checkRegex(heightAndWeightRegex!, txt)
        case sleepTag, wakeupTag:
            regexCheck = checkRegex(bedTimeRegex!, txt)
        default:
            break
        }

        if !regexCheck && txt.count > 0 {
            showRegexAlert(type: tag)
            initText(type: tag)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = textField.text ?? "EMPTY"
        let tag = textField.tag
        
        switch tag {
        case firstNameTag:
            firstName = txt
        case lastNameTag:
            lastName = txt
        case phoneTag:
            phoneNumber = txt
        case heightTag:
            height = txt
        case weightTag:
            weight = txt
        case sleepTag:
            sleep = txt
        case wakeupTag:
            wakeup = txt
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
    
    private func initText(type: Int) {
        switch type {
        case firstNameTag:
            firstName = ""
            firstNameTextField.text = firstName
        case lastNameTag:
            lastName = ""
            lastNameTextField.text = lastName
        case phoneTag:
            phoneNumber = ""
            phoneTextField.text = phoneNumber
        case heightTag:
            height = ""
            heightTextField.text = height
        case weightTag:
            weight = ""
            weightTextField.text = weight
        case sleepTag:
            sleep = ""
            sleepTextField.text = sleep
        case wakeupTag:
            wakeup = ""
            wakeupTextField.text = wakeup
        default:
            break
        }
    }
    
    private func showRegexAlert(type: Int) {
        var helpText = ""
        switch type {
        case firstNameTag, lastNameTag:
            helpText = "nameHelp".localized()
        case phoneTag:
            helpText = "phoneHintText".localized()
        case heightTag, weightTag, sleepTag, wakeupTag:
            helpText = "numberHintText".localized()
        default:
            break
        }
        
        showAlert(helpText)
        
    }
    
    private func showAlert(_ helpText: String) {
        let alert = UIAlertController(title: "noti".localized(), message: helpText, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        
        parentViewController?.present(alert, animated: true, completion: nil)
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
        
        containerView.addSubview(privacyInfo)
        privacyInfo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        
        
        containerView.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyInfo.snp.bottom).offset(10)
            make.left.equalTo(privacyInfo)
        }
        
        containerView.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel)
            make.left.equalTo(scrollView.snp.centerX).offset(10)
        }
        
        
        containerView.addSubview(firstNameBackground)
        firstNameBackground.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(scrollView.snp.centerX).offset(-10)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(lastNameBackground)
        lastNameBackground.snp.makeConstraints { make in
            make.top.height.equalTo(firstNameBackground)
            make.left.equalTo(scrollView.snp.centerX).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { make in
            make.left.equalTo(firstNameBackground).offset(5)
            make.top.right.bottom.equalTo(firstNameBackground)
        }
        
        containerView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { make in
            make.left.equalTo(lastNameBackground).offset(5)
            make.top.right.bottom.equalTo(lastNameBackground)
        }
        
        
        containerView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(10)
            make.left.equalTo(firstNameLabel)
        }
        
        containerView.addSubview(phoneBackground)
        phoneBackground.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
            make.left.equalTo(firstNameBackground)
            make.right.height.equalTo(lastNameBackground)
        }
        
        containerView.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.left.equalTo(phoneBackground).offset(5)
            make.top.right.bottom.equalTo(phoneBackground)
        }
        
        
        
        
        containerView.addSubview(labelSV)
        labelSV.snp.makeConstraints { make in
            make.top.equalTo(phoneBackground.snp.bottom).offset(10)
            make.left.right.equalTo(phoneBackground)
        }
        
        containerView.addSubview(backgroundSV)
        backgroundSV.snp.makeConstraints { make in
            make.top.equalTo(labelSV.snp.bottom).offset(5)
            make.left.right.equalTo(phoneBackground)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(heightTextField)
        heightTextField.snp.makeConstraints { make in
            make.left.equalTo(heightBackground).offset(5)
            make.top.right.bottom.equalTo(heightBackground)
        }
        
        containerView.addSubview(genderButton)
        genderButton.snp.makeConstraints { make in
            make.left.equalTo(genderBackground).offset(5)
            make.top.bottom.equalTo(genderBackground)
        }

        containerView.addSubview(weightTextField)
        weightTextField.snp.makeConstraints { make in
            make.left.equalTo(weightBackground).offset(5)
            make.top.right.bottom.equalTo(weightBackground)
        }
        
        
        
        
        
        containerView.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundSV.snp.bottom).offset(10)
            make.left.equalTo(firstNameLabel)
        }
        
        containerView.addSubview(birthdayBackground)
        birthdayBackground.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(5)
            make.left.equalTo(birthdayLabel)
            make.right.equalTo(heightBackground)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(birthdayButton)
        birthdayButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(birthdayBackground)
            make.left.equalTo(birthdayBackground).offset(5)
        }
        
        containerView.addSubview(birthday)
        birthday.snp.makeConstraints { make in
            make.top.bottom.equalTo(birthdayBackground)
            make.left.equalTo(birthdayLabel.snp.right)
        }
        
        
        
        containerView.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel)
            make.left.equalTo(weightBackground)
        }
        
        containerView.addSubview(ageBackground)
        ageBackground.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(5)
            make.left.right.equalTo(weightBackground)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(age)
        age.snp.makeConstraints { make in
            make.left.equalTo(ageBackground).offset(5)
            make.top.right.bottom.equalTo(ageBackground)
        }
        
        
        
        containerView.addSubview(sleepLabel)
        sleepLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayBackground.snp.bottom).offset(10)
            make.left.equalTo(genderLabel.snp.left)
        }
        
        containerView.addSubview(sleepBackground)
        sleepBackground.snp.makeConstraints { make in
            make.top.equalTo(sleepLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(heightBackground.snp.centerX)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(sleepTextField)
        sleepTextField.snp.makeConstraints { make in
            make.left.equalTo(sleepBackground).offset(5)
            make.top.right.bottom.equalTo(sleepBackground)
        }
        
        
        
        
        
        containerView.addSubview(wakeupLabel)
        wakeupLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayBackground.snp.bottom).offset(10)
            make.left.equalTo(heightBackground.snp.centerX).offset(5)
        }
        
        containerView.addSubview(wakeupBackground)
        wakeupBackground.snp.makeConstraints { make in
            make.top.equalTo(wakeupLabel.snp.bottom).offset(5)
            make.left.equalTo(heightBackground.snp.centerX).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(wakeupTextField)
        wakeupTextField.snp.makeConstraints { make in
            make.left.equalTo(wakeupBackground).offset(5)
            make.top.right.bottom.equalTo(wakeupBackground)
        }
        
        
        

        
        containerView.addSubview(basicInfoSaveButton)
        basicInfoSaveButton.snp.makeConstraints { make in
            make.top.equalTo(wakeupTextField.snp.bottom).offset(30)
            make.left.right.equalTo(phoneBackground)
            make.height.equalTo(40)
        }
    }
}
