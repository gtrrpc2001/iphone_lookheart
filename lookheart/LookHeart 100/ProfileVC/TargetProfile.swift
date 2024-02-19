import UIKit
import LookheartPackage

class TargetProfile: UIView, UITextFieldDelegate {
    
    /*------------------------- Enum ------------------------*/
    // region
    enum UIType {
        case bpm
        case step
        case distance
        case aCal
        case tCal
    }
    
    enum ButtonPlusMinus {
        case bpmPlus, bpmMinus, stepPlus, stepMinus, distancePlus, distanceMinus, aCalPlus, aCalMinus, tCalPlus, tCalMinus
        
        init(type: UIType, plusMinusFlag: Bool) {
            switch (type, plusMinusFlag) {
            case (.bpm, true): self = .bpmPlus
            case (.bpm, false): self = .bpmMinus
                
            case (.step, true): self = .stepPlus
            case (.step, false): self = .stepMinus
                
            case (.distance, true): self = .distancePlus
            case (.distance, false): self = .distanceMinus
                
            case (.aCal, true): self = .aCalPlus
            case (.aCal, false): self = .aCalMinus
                
            case (.tCal, true): self = .tCalPlus
            case (.tCal, false): self = .tCalMinus

            }
        }
    }
    // endregion
    
    /*------------------------- Image, Attributes ------------------------*/
    // region
    let plusImage =  UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    let minusImage =  UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                      .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
    // endregion
    
    /*------------------------- Button TAG ------------------------*/
    // region
    private let BUTTON_PLUS = true
    private let BUTTON_MINUS = false
    
    private let BPM_PLUS_TAG = 0
    private let BPM_MINUS_TAG = 1
    
    private let STEP_PLUS_TAG = 2
    private let STEP_MINUS_TAG = 3
    
    private let DISTANCE_PLUS_TAG = 4
    private let DISTANCE_MINUS_TAG = 5
    
    private let ACAL_PLUS_TAG = 6
    private let ACAL_MINUS_TAG = 7
    
    private let TCAL_PLUS_TAG = 8
    private let TCAL_MINUS_TAG = 9
    // endregion
    
    /*------------------------- TextField TAG ------------------------*/
    // region
    private let BPM_TAG = 0
    private let STEP_TAG = 1
    private let DISTANCE_TAG = 2
    private let ACAL_TAG = 3
    private let TCAL_TAG = 4
    // endregion
    
    /*------------------------- Target Var ------------------------*/
    // region
    private var targetBpm = 0
    private var targetStep = 0
    private var targetDistance = 0
    private var targetTCal = 0
    private var targetACal = 0
    // endregion
    
    /*------------------------- Dictionary ------------------------*/
    // region
    private var buttonListDictionary: [ButtonPlusMinus : UIButton] = [:]
    private var textFieldDictionary: [UIType : CustomTextField] = [:]
    private var textFieldMapping: [String : CustomTextField] = [:]
    
    private lazy var backgroundMapping: [UILabel : UIType] = [
        bpmBackground : UIType.bpm,
        stepBackground : UIType.step,
        distanceBackground : UIType.distance,
        aCalBackground : UIType.aCal,
        tCalBackground : UIType.tCal
    ]
    
    private var typeMapping: [UIType : String] = [
        UIType.bpm : "Bpm",
        UIType.step : "Step",
        UIType.distance : "Distance",
        UIType.tCal : "TCal",
        UIType.aCal : "ACal"
    ]
    
    private var textMapping: [UIType : String] = [
        UIType.bpm : "summaryBpm_low".localized(),
        UIType.step : "stepValue2".localized(),
        UIType.distance : "distanceValue2".localized(),
        UIType.tCal : "eCalValue2".localized(),
        UIType.aCal : "eCalValue2".localized()
    ]
    // endregion
    
    // MARK: -
    private var scrollView = UIScrollView()
    private var containerView = UIView()
        
    private let infoLabel = UILabel().then {
        $0.text = "\("profile2_HelpInfo1".localized())\n\("profile2_HelpInfo2".localized())"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .lightGray
        $0.numberOfLines = 2
    }
    
    /*------------------------- BPM ------------------------*/
    // region
    private let bpmLabel = UILabel().then {
        $0.text = "profile2_bpm".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let bpmInfoLabel = UILabel().then {
        $0.text = "profile2_bpmInfo".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .lightGray
    }
    
    private let bpmBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    // endregion
    
    /*------------------------- STEP ------------------------*/
    // region
    private let stepLabel = UILabel().then {
        $0.text = "profile2_steps".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let stepBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    // endregion
    
    /*------------------------- DISTANCE ------------------------*/
    // region
    private let distanceLabel = UILabel().then {
        $0.text = "profile2_distance".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let distanceBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    // endregion
    
    /*------------------------- Activity Calorie ------------------------*/
    // region
    private let aCalLabel = UILabel().then {
        $0.text = "profile2_aCal".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let aCalBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    // endregion
    
    /*------------------------- Total Calorie ------------------------*/
    // region
    private let tCalLabel = UILabel().then {
        $0.text = "profile2_tCal".localized()
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
    }
    
    private let tCalBackground = UILabel().then {
        $0.backgroundColor = UIColor.PROFILE_BACKGROUND
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    // endregion
    
    /*------------------------- Stack View ------------------------*/
    // region
    private lazy var stepAndDistanceLabelSV = UIStackView(arrangedSubviews: [stepLabel, distanceLabel]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private lazy var stepAndDistanceBackgroundSV = UIStackView(arrangedSubviews: [stepBackground, distanceBackground]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private lazy var calorieLabelSV = UIStackView(arrangedSubviews: [aCalLabel, tCalLabel]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private lazy var calorieBackgroundSV = UIStackView(arrangedSubviews: [aCalBackground, tCalBackground]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    // endregion
    
    /*------------------------- Button ------------------------*/
    // region
    private lazy var targetSaveButton = UIButton(type: .custom).then {
        $0.setTitle("profile_save".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.LOGIN_BUTTON
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(saveProfile(_:)), for: .touchUpInside)
    }
    // endregion
    
    // MARK: - UIButton Event
    @objc func saveProfile(_ sender: UIButton) {
        
        let targetUpdates: [String: String] = [
            "Bpm": String(targetBpm),
            "Step": String(targetStep),
            "Distance": String(targetDistance),
            "TCal": String(targetTCal),
            "ACal": String(targetACal)
        ]
        
        for (key, value) in targetUpdates {
            if !value.isEmpty {
                
                setProfile(key, Int(value)!)
                
                if let textField = textFieldMapping[key] { // 업데이트
                    textField.text = value
                    textField.placeholder = value
                }
            }
        }
        
        saveUserData()
        keyboardDown()
    }
    
    func setProfile(_ key: String, _ value: Int){
        // print("key : \(key), value : \(value)")
        switch(key){
        case "Bpm":
            UserProfileManager.shared.targetBpm = value
        case "Step":
            UserProfileManager.shared.targetStep = value
        case "Distance":
            UserProfileManager.shared.targetDistance = value
        case "TCal":
            UserProfileManager.shared.targetCalorie = value
        case "ACal":
            UserProfileManager.shared.targetActivityCalorie = value
        default:
            break
        }
    }
    
    func saveUserData(){

        let userData: [String: Any] = [
            "kind": "setProfile",
            "eq": propEmail,
            "eqname": UserProfileManager.shared.name,
            "email": propEmail,
            "phone": UserProfileManager.shared.phone,
            "sex": UserProfileManager.shared.gender,
            "height": UserProfileManager.shared.height,
            "weight": UserProfileManager.shared.weight,
            "age": UserProfileManager.shared.age,
            "birth": UserProfileManager.shared.birthDate,
            "sleeptime": UserProfileManager.shared.bedTime,
            "uptime": UserProfileManager.shared.wakeUpTime,
            "bpm": UserProfileManager.shared.targetBpm,
            "step": UserProfileManager.shared.targetStep,
            "distanceKM": UserProfileManager.shared.targetDistance,
            "calexe": UserProfileManager.shared.targetActivityCalorie,
            "cal": UserProfileManager.shared.targetCalorie,
            "alarm_sms": "0",
            "differtime": "1"
        ]
        
        NetworkManager.shared.signupToServer(parameters: userData) { [self] result in
            switch result {
            case .success(let isAvailable):
                if isAvailable {
                    showAlert(title: "saveData".localized(), message: nil)
                }
            case .failure(let error):
                showAlert(title: "failSaveData".localized(), message: nil)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func keyboardDown(){
        for textField in textFieldDictionary {
            textField.value.resignFirstResponder()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setUI()
        updateProfile()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func setUI() {
        for type in backgroundMapping {
            createUI(background: type.key, type: type.value)
        }
    }
    
    public func updateProfile() {
        
        targetBpm = UserProfileManager.shared.targetBpm
        targetStep = UserProfileManager.shared.targetStep
        targetDistance = UserProfileManager.shared.targetDistance
        targetTCal = UserProfileManager.shared.targetCalorie
        targetACal = UserProfileManager.shared.targetActivityCalorie
        
        for textFiled in textFieldDictionary {
            textFiled.value.attributedPlaceholder = setPlaceholder(textFiled.key)
        }
    }
    
    // MARK: - create UI
    func createUI(background: UILabel, type: UIType) {
        let plusButton = createButton(type: type, plusMinusFlag: BUTTON_PLUS)
        let minusButton = createButton(type: type, plusMinusFlag: BUTTON_MINUS)
        let unitLabel = createLabel(type: type)
        let textField = createTextField(type: type)
        
        containerView.addSubview(plusButton)
        containerView.addSubview(minusButton)
        containerView.addSubview(unitLabel)
        containerView.addSubview(textField)
        
        plusButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(background)
            make.right.equalTo(background).offset(-3)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(background)
            make.left.equalTo(background).offset(3)
        }
        
        unitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(background)
            make.right.equalTo(plusButton.snp.left).offset(-2)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(background)
        }
    }
    // MARK: -
    private func createButton(type: UIType, plusMinusFlag: Bool) -> UIButton {
        let button = UIButton().then {
            $0.setImage(plusMinusFlag ? plusImage : minusImage, for: .normal)
            $0.tag = setButtonTag(type, plusMinusFlag)
            $0.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
        }
        
        let buttonType = ButtonPlusMinus(type: type, plusMinusFlag: plusMinusFlag)
        buttonListDictionary[buttonType] = button
        
        return button
    }
    
    @objc private func buttonEvent(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case BPM_PLUS_TAG:
            fallthrough
        case BPM_MINUS_TAG:
            targetBpm = tag == BPM_PLUS_TAG ? targetBpm + 1 : targetBpm - 1
        case STEP_PLUS_TAG:
            fallthrough
        case STEP_MINUS_TAG:
            targetStep = tag == STEP_PLUS_TAG ? targetStep + 1 : targetStep - 1
        case DISTANCE_PLUS_TAG:
            fallthrough
        case DISTANCE_MINUS_TAG:
            targetDistance = tag == DISTANCE_PLUS_TAG ? targetDistance + 1 : targetDistance - 1
        case ACAL_PLUS_TAG:
            fallthrough
        case ACAL_MINUS_TAG:
            targetACal = tag == ACAL_PLUS_TAG ? targetACal + 1 : targetACal - 1
        case TCAL_PLUS_TAG:
            fallthrough
        case TCAL_MINUS_TAG:
            targetTCal = tag == TCAL_PLUS_TAG ? targetTCal + 1 : targetTCal - 1
        default:
            break
        }
        
        for textFiled in textFieldDictionary {
            textFiled.value.text = ""
            textFiled.value.attributedPlaceholder = setPlaceholder(textFiled.key)
        }
    }
    
    private func setButtonTag(_ type: UIType, _ flag: Bool) -> Int {
        switch type {
        case .bpm:
            if flag { return BPM_PLUS_TAG }
            else { return BPM_MINUS_TAG }
        case .step:
            if flag { return STEP_PLUS_TAG }
            else { return STEP_MINUS_TAG }
        case .distance:
            if flag { return DISTANCE_PLUS_TAG }
            else { return DISTANCE_MINUS_TAG }
        case .aCal:
            if flag { return ACAL_PLUS_TAG }
            else { return ACAL_MINUS_TAG }
        case .tCal:
            if flag { return TCAL_PLUS_TAG }
            else { return TCAL_MINUS_TAG }
        }
    }
    // MARK: -
    private func createLabel(type: UIType) -> UILabel {
        let textLabel = UILabel().then {
            $0.text = setUnitText(type: type)
            $0.font = UIFont.systemFont(ofSize: 11, weight: .medium)
            $0.textColor = .lightGray
        }
        return textLabel
    }
    
    private func setUnitText(type: UIType) -> String {
        switch type {
        case .bpm:
            return textMapping[.bpm]!
        case .step:
            return textMapping[.step]!
        case .distance:
            return textMapping[.distance]!
        case .aCal:
            return textMapping[.aCal]!
        case .tCal:
            return textMapping[.tCal]!
        }
    }
    // MARK: -
    private func createTextField(type: UIType) -> CustomTextField {
        let textField = CustomTextField().then {
            $0.textColor = .darkGray
            $0.tintColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.keyboardType = .numberPad
            $0.textAlignment = .right
            $0.clearsOnBeginEditing = true
            $0.delegate = self
            $0.tag = setTextFieldTag(type)
        }
        
        textFieldDictionary[type] = textField
        textFieldMapping[typeMapping[type]!] = textField
        
        return textField
    }
    
    func setPlaceholder(_ textFieldType: UIType) -> NSAttributedString {
        switch textFieldType {
        case .bpm:
            return NSAttributedString(string: String(targetBpm), attributes: attributes)
        case .step:
            return NSAttributedString(string: String(targetStep), attributes: attributes)
        case .distance:
            return NSAttributedString(string: String(targetDistance), attributes: attributes)
        case .aCal:
            return NSAttributedString(string: String(targetACal), attributes: attributes)
        case .tCal:
            return NSAttributedString(string: String(targetTCal), attributes: attributes)
        }
    }
    
    private func setTextFieldTag(_ type: UIType) -> Int {
        switch type {
        case .bpm:
            return BPM_TAG
        case .step:
            return STEP_TAG
        case .distance:
            return DISTANCE_TAG
        case .aCal:
            return ACAL_TAG
        case .tCal:
            return TCAL_TAG
        }
    }
    
    // MARK: - UITextField Event
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? "EMPTY"
        let tag = textField.tag
        let regexCheck = checkRegex(targetNumberRegex!, txt)
        
        scrollView.isScrollEnabled = true

        if !regexCheck && txt.count > 0 {
            showAlert(title: "noti".localized(), message: "numberHintText".localized())
            initText(type: tag)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = textField.text ?? "EMPTY"
        let tag = textField.tag
        
        switch tag {
        case BPM_TAG:
            targetBpm = Int(txt) ?? targetBpm
        case STEP_TAG:
            targetStep = Int(txt) ?? targetStep
        case DISTANCE_TAG:
            targetDistance = Int(txt) ?? targetDistance
        case ACAL_TAG:
            targetACal = Int(txt) ?? targetACal
        case TCAL_TAG:
            targetTCal = Int(txt) ?? targetTCal
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
        case BPM_TAG:
            targetBpm = UserProfileManager.shared.targetBpm
            initTextField(textField: textFieldDictionary[.bpm]!, type: .bpm, value: targetBpm)
        case STEP_TAG:
            targetStep = UserProfileManager.shared.targetStep
            initTextField(textField: textFieldDictionary[.step]!, type: .step, value: targetStep)
        case DISTANCE_TAG:
            targetDistance = UserProfileManager.shared.targetDistance
            initTextField(textField: textFieldDictionary[.distance]!, type: .distance, value: targetDistance)
        case ACAL_TAG:
            targetACal = UserProfileManager.shared.targetActivityCalorie
            initTextField(textField: textFieldDictionary[.aCal]!, type: .aCal, value: targetACal)
        case TCAL_TAG:
            targetTCal = UserProfileManager.shared.targetCalorie
            initTextField(textField: textFieldDictionary[.tCal]!, type: .tCal, value: targetTCal)
        default:
            break
        }
    }
    
    private func initTextField(textField: CustomTextField, type: UIType, value: Int) {
        textField.text = String(value)
        textField.attributedPlaceholder = setPlaceholder(type)
    }
    
    private func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        parentViewController?.present(alert, animated: false)
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
        
        containerView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(bpmLabel)
        bpmLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.left.equalTo(infoLabel)
        }
        
        containerView.addSubview(bpmInfoLabel)
        bpmInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(bpmLabel.snp.bottom)
            make.left.equalTo(bpmLabel)
        }
        
        containerView.addSubview(bpmBackground)
        bpmBackground.snp.makeConstraints { make in
            make.top.equalTo(bpmInfoLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(stepAndDistanceLabelSV)
        stepAndDistanceLabelSV.snp.makeConstraints { make in
            make.top.equalTo(bpmBackground.snp.bottom).offset(10)
            make.left.right.equalTo(bpmBackground)
        }
        
        containerView.addSubview(stepAndDistanceBackgroundSV)
        stepAndDistanceBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(stepAndDistanceLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(bpmBackground)
            make.height.equalTo(35)
        }
        
        containerView.addSubview(calorieLabelSV)
        calorieLabelSV.snp.makeConstraints { make in
            make.top.equalTo(stepAndDistanceBackgroundSV.snp.bottom).offset(10)
            make.left.right.equalTo(bpmBackground)
        }
        
        containerView.addSubview(calorieBackgroundSV)
        calorieBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(calorieLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(bpmBackground)
            make.height.equalTo(35)
        }
        
        
        containerView.addSubview(targetSaveButton)
        targetSaveButton.snp.makeConstraints { make in
            make.top.equalTo(calorieBackgroundSV.snp.bottom).offset(30)
            make.left.right.equalTo(bpmBackground)
            make.height.equalTo(40)
        }
    }
}
