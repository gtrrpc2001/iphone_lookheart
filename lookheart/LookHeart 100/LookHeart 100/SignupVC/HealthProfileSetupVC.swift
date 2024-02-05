import UIKit
import LookheartPackage

class HealthProfileSetupVC : TitleViewController, UITextFieldDelegate {
    
    private let image =  UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light))?.withTintColor(.black, renderingMode: .alwaysOriginal)
    private let checkImage =  UIImage(systemName: "record.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light))?.withTintColor(.black, renderingMode: .alwaysOriginal)
    
    private let FIRSTNAME_TAG = 1
    private let LASTNAME_TAG = 2
    private let HEIGHT_TAG = 3
    private let WEIGHT_TAG = 4
    
    private let MALE_TAG = 1
    private let FEMALE_TAG = 2
    
    private var firstName: String = ""
    private var lastName: String = ""
    private var height: String = ""
    private var weight: String = ""
    private var gender: String = ""
    private var birthday:String = ""
    
    private let calendar = Calendar.current
    private var dateComponents = DateComponents()
    private var buttonFlag = false  // 버튼 중복 이벤트 방지
    
    private var dataCheck : [String : Bool] = ["name":false, "height":false, "weight":false, "gender":false, "birthday":false]
    
    private lazy var textFields: [UITextField] = [firstNameTextField, lastNameTextField, heightTextField, weightTextField]
    
    // MARK: -
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private let signupText = UILabel().then {
        $0.text = "signup4".localized()
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .darkGray
    }
    
    private let progressView = UIProgressView().then {
        $0.trackTintColor = UIColor.PROGRESS_BAR
        $0.progressTintColor = UIColor.PROGRESS_BAR_FILL
        $0.progress = 1.0
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let firstNameLabel = UILabel().then {
        $0.text = "firstname".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    private let lastNameLabel = UILabel().then {
        $0.text = "lastname".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    private let heightLabel = UILabel().then {
        $0.text = "height_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    private let weightLabel = UILabel().then {
        $0.text = "weight_Label".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    private var nameCheckLabel = UILabel().then {
        $0.text = "nameHelp".localized()
        $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private var heightCheckLabel = UILabel().then {
        $0.text = "heightHelp".localized()
        $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private var weightCheckLabel = UILabel().then {
        $0.text = "weightHelp".localized()
        $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private lazy var firstNameTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.tag = FIRSTNAME_TAG
        $0.delegate = self
        
        $0.placeholderString = "nameHintText".localized()
        $0.placeholderColor = .lightGray
    }
    
    private lazy var lastNameTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.tag = LASTNAME_TAG
        $0.delegate = self
        
        $0.placeholderString = "nameHintText".localized()
        $0.placeholderColor = .lightGray
    }
    
    private lazy var heightTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.keyboardType = .numberPad
        $0.tag = HEIGHT_TAG
        $0.delegate = self
        
        $0.placeholderString = "heightHintText".localized()
        $0.placeholderColor = .lightGray
    }
    
    
    private lazy var weightTextField = UnderLineTextField().then {
        $0.textColor = .darkGray
        $0.tintColor = UIColor.MY_BLUE
        $0.keyboardType = .numberPad
        $0.tag = WEIGHT_TAG
        $0.delegate = self
        
        $0.placeholderString = "weightHintText".localized()
        $0.placeholderColor = .lightGray
    }
    
    private lazy var maleLabel = UILabel().then {
        $0.text =  "♂"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }
    
    private lazy var femaleLabel = UILabel().then {
        $0.text = "♀"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }
    
    private lazy var maleButton = UIButton().then {
        $0.setTitle("male_Label".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.setTitleColor(.black, for: .normal)
        $0.tag = MALE_TAG
        $0.contentEdgeInsets = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 50)
        $0.addTarget(self, action: #selector(genderButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var femaleButton = UIButton().then {
        $0.setTitle("female_Label".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.setTitleColor(.black, for: .normal)
        $0.tag = FEMALE_TAG
        $0.contentEdgeInsets = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 50)
        $0.addTarget(self, action: #selector(genderButtonEvent(_:)), for: .touchUpInside)
    }
        
    private lazy var maleCheckImage = UIImageView().then { $0.image = image }
    
    private lazy var femaleCheckImage =  UIImageView().then { $0.image = image }
    
    private lazy var maleView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 30
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
    
        $0.addSubview(maleLabel)
        $0.addSubview(maleButton)
        $0.addSubview(maleCheckImage)
    }
    
    private lazy var femaleView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 30
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
    
        $0.addSubview(femaleLabel)
        $0.addSubview(femaleButton)
        $0.addSubview(femaleCheckImage)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [maleView, femaleView]).then {
        $0.spacing = 20
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private lazy var birthdayDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale.current
        $0.calendar = calendar
        $0.timeZone = .autoupdatingCurrent
        
        dateComponents.year = 1968
        dateComponents.month = 1
        dateComponents.day = 1
        
        if let date = calendar.date(from: dateComponents){ $0.date = date }

        if #available(iOS 13.4, *) { $0.preferredDatePickerStyle = .wheels }
        else { alert(title: "noti".localized(), message: "update".localized()) }
        
        $0.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
    }
    
    private lazy var birthdayButton = UIButton().then {
        $0.setTitle("birthday_Label".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.addTarget(self, action: #selector(birthdayButtonEvent(_:)), for: .touchUpInside)
    }
            
    private let birthdayUnderLine = UIView().then { $0.backgroundColor = .lightGray }
    
    private let birthdayLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .darkGray
    }
    
    private lazy var backButton = UIButton().then {
        $0.setTitle("back".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.addTarget(self, action: #selector(backButtonEvent(_:)), for: .touchUpInside)
    }
            
    private lazy var completeButton = UIButton().then {
        $0.setTitle("signup_complete".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.addTarget(self, action: #selector(completeButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var buttonView = UIStackView(arrangedSubviews: [backButton, completeButton]).then {
        $0.spacing = 40
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    // MARK: - Button Event
    @objc func genderButtonEvent(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case MALE_TAG:
            maleCheckImage.image = checkImage
            femaleCheckImage.image = image
            gender = "남자"
        case FEMALE_TAG:
            femaleCheckImage.image = checkImage
            maleCheckImage.image = image
            gender = "여자"
        default:
            break
        }
        
        dataCheck["gender"] = true
    }
                
    @objc func onDidChangeDate(sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
                
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myBirthday = dateFormatter.string(from: sender.date)
        
        birthday = myBirthday
    }
    
    @objc func birthdayButtonEvent(_ sender: UIButton) {
        var dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if (UIDevice.current.userInterfaceIdiom == .pad){
            dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
            birthdayDatePicker.translatesAutoresizingMaskIntoConstraints = true
        }
        else{
            birthdayDatePicker.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: dateAlert.view.bounds.size.width - margin * 4.0, height: 200)
        let customView = UIView(frame: rect)
        
        dateAlert.setBackgroundColor(color: .white)
        
        // 키보드가 열려 있을 경우 키보드 사라짐
        for textField in textFields {
            textField.resignFirstResponder()
        }
        
        dateAlert.view.addSubview(customView)
        dateAlert.view.addSubview(birthdayDatePicker)
        
        birthdayDatePicker.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        birthdayDatePicker.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        
        let cancel = UIAlertAction(title: "reject".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        let complite = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default){ [self]_ in
            birthdayLabel.text = birthday
            dataCheck["birthday"] = true
        }
        
        dateAlert.addAction(cancel)
        dateAlert.addAction(complite)
        
        self.present(dateAlert, animated: false, completion: {})
    }
    
    @objc func backButtonEvent(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func completeButtonEvent(_ sender: UIButton) {
        if buttonFlag { return }
        buttonFlag = true
        
        for textField in textFields {
            textField.resignFirstResponder()    // 키보드가 열려 있을 경우 키보드 사라짐
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            if checkInput() {
                signupServerTask(setParam())
            } else {
                alert(title: "noti".localized(), message: "physicalenterAgain".localized())
                buttonFlag = false
            }
        }
    }
    
    private func signupServerTask(_ parameters: [String: Any]){
        
        NetworkManager.shared.signupToServer(parameters: parameters) { [self] result in
            switch result {
            case .success(let isAvailable):
                if isAvailable {
                    setNoti()
                    signupAlert()
                }
            case .failure(let error):
                alert(title: "noti".localized(), message: "serverErr".localized())
                buttonFlag = false
                
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setParam() -> [String : Any] {
        return [
            "kind": "checkReg",
            "eq": Keychain.shared.getString(forKey: "email")!,
            "password": Keychain.shared.getString(forKey: "password")!,
            "email": Keychain.shared.getString(forKey: "email")!,
            "eqname": setName(),
            "phone": Keychain.shared.getString(forKey: "phone")!,
            "sex": gender,
            "height": height,
            "weight": weight,
            "age": setAge(),
            "birth": birthday,
            "sleeptime": "23",
            "uptime": "7",
            "bpm": "90",
            "step": "3000",
            "distanceKM": "5",
            "calexe": "500",
            "cal": "3000",
            "alarm_sms": "0",
            "differtime": "0"
        ]
    }
    
    private func setNoti() {
        UserDefaults.standard.set(true, forKey: "HeartAttackFlag")
        UserDefaults.standard.set(false, forKey: "NoncontactFlag")
        UserDefaults.standard.set(false, forKey: "ArrFlag")
        
        UserDefaults.standard.set(false, forKey: "MyoFlag")
        UserDefaults.standard.set(false, forKey: "TarchycardiaFlag")
        UserDefaults.standard.set(false, forKey: "BradycardiaFlag")
        UserDefaults.standard.set(false, forKey: "AtrialFibrillaionFlag")
    }
    
    private func signupAlert() {
        let alert = UIAlertController(title: "signup_complete".localized(), message: "returnLogin".localized(), preferredStyle: UIAlertController.Style.alert)
        
        let complite = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default){ _ in
            
            Keychain.shared.clear() // 저장된 민감 정보 삭제
            
            self.navigationController?.popToRootViewController(animated: true) // rootView
        }
        
        alert.addAction(complite)
        self.present(alert, animated: false, completion: {})
    }
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: false)
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
    
    private func setAge() -> Int {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 문자열을 Date 객체로 변환
        guard let birthdate = dateFormatter.date(from: birthday) else {
            fatalError("Invalid birthdate format")
        }
        
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: currentDate)
        
        if let age = ageComponents.year {
            return age
        } else {
            return 60
        }
    }
    
    private func setName() -> String {
        if firstName.isEmpty {
            return lastName
        } else {
            return "\(firstName) \(lastName)"
        }
    }
    
    // MARK: -
    func addViews(){
        
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
                
        containerView.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(30)
            make.left.equalTo(progressView.snp.left).offset(3)
        }
        
        containerView.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel)
            make.left.equalTo(progressView.snp.centerX)
        }
        
        containerView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(5)
            make.left.equalTo(progressView)
            make.right.equalTo(progressView.snp.centerX).offset(-10)
        }
        
        containerView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField)
            make.left.equalTo(progressView.snp.centerX)
            make.right.equalTo(progressView)
        }
        
        containerView.addSubview(heightLabel)
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(30)
            make.left.equalTo(firstNameLabel.snp.left)
        }
        
        containerView.addSubview(heightTextField)
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(5)
            make.left.right.equalTo(progressView)
        }
        
        containerView.addSubview(weightLabel)
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(30)
            make.left.equalTo(firstNameLabel)
        }
        
        containerView.addSubview(weightTextField)
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(5)
            make.left.right.equalTo(progressView)
        }
        
        containerView.addSubview(nameCheckLabel)
        nameCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(3)
            make.left.equalTo(progressView.snp.left)
        }
                
        containerView.addSubview(heightCheckLabel)
        heightCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(3)
            make.left.equalTo(progressView.snp.left)
        }
        
        containerView.addSubview(weightCheckLabel)
        weightCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(3)
            make.left.equalTo(progressView.snp.left)
        }
        
        maleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(maleView.snp.centerY).offset(-3)
            make.left.equalTo(maleView.snp.left).offset(15)
        }
        
        maleButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(maleView)
        }
        
        maleCheckImage.snp.makeConstraints { make in
            make.centerY.equalTo(maleView.snp.centerY)
            make.right.equalTo(maleView.snp.right).offset(-15)
        }
        
        femaleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(femaleView.snp.centerY).offset(-3)
            make.left.equalTo(femaleView.snp.left).offset(15)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(femaleView)
        }
        
        femaleCheckImage.snp.makeConstraints { make in
            make.centerY.equalTo(femaleView.snp.centerY)
            make.right.equalTo(femaleView.snp.right).offset(-15)
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(40)
            make.left.equalTo(containerView.snp.left).offset(20)
            make.right.equalTo(containerView.snp.right).offset(-20)
            make.height.equalTo(60)
        }
        
        containerView.addSubview(birthdayButton)
        birthdayButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(50)
            make.left.equalTo(progressView.snp.left)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        containerView.addSubview(birthdayUnderLine)
        birthdayUnderLine.snp.makeConstraints { make in
            make.top.equalTo(birthdayButton.snp.bottom).offset(5)
            make.left.right.equalTo(progressView)
            make.height.equalTo(1)
        }
        
        containerView.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(birthdayUnderLine.snp.top).offset(-5)
            make.left.equalTo(birthdayButton.snp.right).offset(10)
        }
        
        containerView.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(birthdayUnderLine.snp.bottom).offset(30)
            make.left.right.equalTo(stackView)
            make.height.equalTo(60)
        }
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setTapGesture()
        
    }
    
    // MARK: - TextField event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Called just before UITextField is edited
    }
    
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        let tag = textField.tag
        var regexCheck:Bool
        
        switch tag {
        case FIRSTNAME_TAG:
            regexCheck = checkRegex(nameRegex!, txt)
            if !regexCheck {
                if !firstName.isEmpty {
                    firstNameTextField.setError()
                    hintIsHidden(label: &nameCheckLabel,
                                 key: "name",
                                 hidden: regexCheck)
                } else {    nameCheckLabel.isHidden = true  }
            }
        case LASTNAME_TAG:
            regexCheck = checkRegex(nameRegex!, txt)
            if !regexCheck { lastNameTextField.setError() }
            hintIsHidden(label: &nameCheckLabel,
                         key: "name",
                         hidden: regexCheck)
        case HEIGHT_TAG:
            regexCheck = checkRegex(heightAndWeightRegex!, txt)
            if !regexCheck { heightTextField.setError() }
            hintIsHidden(label: &heightCheckLabel,
                         key: "height",
                         hidden: regexCheck)
        case WEIGHT_TAG:
            regexCheck = checkRegex(heightAndWeightRegex!, txt)
            if !regexCheck { weightTextField.setError() }
            hintIsHidden(label: &weightCheckLabel,
                         key: "weight",
                         hidden: regexCheck)
        default:
            break
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Called when the line feed button is pressed
        textField.resignFirstResponder()
        return true
    }
    
    // 실시간 입력 반응
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = textField.text ?? "Empty"
        let tag = textField.tag
        
        // 실시간 입력 반응
        switch tag {
        case FIRSTNAME_TAG:
            inputTextFieldString(&firstName, txt)
        case LASTNAME_TAG:
            inputTextFieldString(&lastName, txt)
        case HEIGHT_TAG:
            inputTextFieldString(&height, txt)
        case WEIGHT_TAG:
            inputTextFieldString(&weight, txt)
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
        // 키보드 사라질 시 화면 복구
        self.view.transform = .identity
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

    }
}
