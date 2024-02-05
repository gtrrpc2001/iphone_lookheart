import Foundation
import UIKit
import LookheartPackage

protocol settingDelegate: AnyObject {
    func auth() // SettingProfile -> Profile AuthPhoneNumber
    func deletion()
}

class SettingProfile: UIView {
        
    /*------------------------- Button TAG ------------------------*/
    // region
    private let ENABLE_NOTI = true, DISABLE_NOTI = false
    private let EMERGENCY_ENABLE = 0, EMERGENCY_DISABLE = 1
    private let ARR_ENABLE = 2, ARR_DISABLE = 3
    private let FAST_ENABLE = 4, FAST_DISABLE = 5
    private let SLOW_ENABLE = 6, SLOW_DISABLE = 7
    private let HEAVY_ENABLE = 8, HEAVY_DISABLE = 9
    private let MYO_ENABLE = 10, MYO_DISABLE = 11
    private let NONCONTACT_ENABLE = 12, NONCONTACT_DISABLE = 13
    private let HOURLY_ARR_ENABLE = 14, HOURLY_ARR_DISABLE = 15
    private let TOTAL_ARR_ENABLE = 16, TOTAL_ARR_DISABLE = 17
    // endregion
    
    
    /*------------------------- UI Var ------------------------*/
    // region
    weak var settingDelegate: settingDelegate?
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    // endregion

    
    /*------------------------- Dictionary ------------------------*/
    // region
    private lazy var backgroundMapping: [NotiType : UILabel] = [:]
    private lazy var buttonMapping: [Int : UIButton] = [:]
    
    private var notiFlagMapping: [NotiType : Bool] = [
        NotiType.emergency : NotificationManager.shared.getFlag(.emergency),
        NotiType.arr : NotificationManager.shared.getFlag(.arr),
        NotiType.fast : NotificationManager.shared.getFlag(.fast),
        NotiType.slow : NotificationManager.shared.getFlag(.slow),
        NotiType.heavy : NotificationManager.shared.getFlag(.heavy),
        NotiType.myo : NotificationManager.shared.getFlag(.myo),
        NotiType.noncontact : NotificationManager.shared.getFlag(.noncontact),
        NotiType.hourly : NotificationManager.shared.getFlag(.hourly),
        NotiType.total : NotificationManager.shared.getFlag(.total)
    ]
    // endregion
        
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addView()
        setButton()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - auth, logout, deletion
    @objc private func changePwButtonEvent(_ sender: UIButton) {
        settingDelegate?.auth()
    }
    
    @objc private func deletionButtonEvent(_ sender: UIButton) {
        settingDelegate?.deletion()
    }
    
    func deletionComplete() {
        logoutEvent()
    }
    
    @objc private func logoutButtonEvent(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "noti".localized(), message: "logoutHelp".localized(), preferredStyle: UIAlertController.Style.alert)
        
        let cancle = UIAlertAction(title: "reject".localized(), style: .cancel, handler: nil)
        let complite = UIAlertAction(title: "logout".localized(), style: UIAlertAction.Style.default){ [self] _ in
            
            logoutEvent()

            window?.rootViewController = LoginVC()
            window?.rootViewController?.dismiss(animated: true)
            
        }
        
        alert.addAction(cancle)
        alert.addAction(complite)
        window?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
    private func logoutEvent() {
        
        // BLE Disconnect
        BluetoothManager.shared.disconnectBLEDevice()
        
        // Login Flag
        UserProfileManager.shared.isLogin = false
        
        // AutoLogin Flag
        defaults.set(false, forKey: "autoLoginFlag")
        
        // Send Logout Log
        NetworkManager.shared.sendLog(id: propEmail, userType: .User, action: .Logout)
        NetworkManager.shared.updateLogoutFlag()
        
        // Send Data
        if HourlyDataManager.shared.calorie != 0.0 {
            let prevDate = defaults.string(forKey: "\(propEmail)prevDate")!.split(separator: "-")
            let prevHour = defaults.string(forKey: "\(propEmail)prevHour")!
            HourlyDataManager.shared.sendHourlyData(String(prevDate[0]), String(prevDate[1]), String(prevDate[2]), prevHour)
            TenSecondDataManager.shared.sendTenSecondData(MyDateTime.shared.getCurrentDateTime(.DATETIME))
        }
        
    
    }
    
    
    // MARK: -
    public func setButton() {
        for type in backgroundMapping {
            if type.key != .null {
                createButtons(type: type.key, background: type.value)
            }
        }
    }
    
    // MARK: -
    private func createButtons(type: NotiType, background: UILabel) {
        let enabledButton = createButton(type: type, enableFlag: ENABLE_NOTI)
        let disabledButton = createButton(type: type, enableFlag: DISABLE_NOTI)
        
        let buttonStackView = UIStackView(arrangedSubviews: [disabledButton, enabledButton]).then {
            $0.spacing = 10
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
          
        containerView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(background)
            make.left.equalTo(background).offset(10)
            make.right.equalTo(background).offset(-10)
        }
    }
    
    
    private func createButton(type: NotiType, enableFlag: Bool) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(enableFlag ? "profile3_on".localized(): "profile3_off".localized(), for: .normal )
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.tag = setButtonTag(type, enableFlag)
            $0.setTitleColor(setButtonTextColor(notiFlagMapping[type]!, enableFlag), for: .normal)
            $0.backgroundColor = setButtonColor(notiFlagMapping[type]!, enableFlag)
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
        }
        
        buttonMapping[button.tag] = button
        
        return button
    }
    
    @objc private func buttonEvent(_ sender: UIButton) {
        let notificationManager = NotificationManager.shared
        let tag = sender.tag
        var enable = false
        
        switch tag {
        case EMERGENCY_ENABLE:
            fallthrough
        case EMERGENCY_DISABLE:
            enable = tag == EMERGENCY_ENABLE ? true : false
            notificationManager.setFlag(.emergency, enable)
            setOnOffButtonColor(EMERGENCY_ENABLE, EMERGENCY_DISABLE, enable)
            
        case ARR_ENABLE:
            fallthrough
        case ARR_DISABLE:
            enable = tag == ARR_ENABLE ? true : false
            notificationManager.setFlag(.arr, enable)
            setOnOffButtonColor(ARR_ENABLE, ARR_DISABLE, enable)
            
        case FAST_ENABLE:
            fallthrough
        case FAST_DISABLE:
            enable = tag == FAST_ENABLE ? true : false
            notificationManager.setFlag(.fast, enable)
            setOnOffButtonColor(FAST_ENABLE, FAST_DISABLE, enable)
            
        case SLOW_ENABLE:
            fallthrough
        case SLOW_DISABLE:
            enable = tag == SLOW_ENABLE ? true : false
            notificationManager.setFlag(.slow, enable)
            setOnOffButtonColor(SLOW_ENABLE, SLOW_DISABLE, enable)
            
        case HEAVY_ENABLE:
            fallthrough
        case HEAVY_DISABLE:
            enable = tag == HEAVY_ENABLE ? true : false
            notificationManager.setFlag(.heavy, enable)
            setOnOffButtonColor(HEAVY_ENABLE, HEAVY_DISABLE, enable)
            
        case MYO_ENABLE:
            fallthrough
        case MYO_DISABLE:
            enable = tag == MYO_ENABLE ? true : false
            notificationManager.setFlag(.myo, enable)
            setOnOffButtonColor(MYO_ENABLE, MYO_DISABLE, enable)
            
        case NONCONTACT_ENABLE:
            fallthrough
        case NONCONTACT_DISABLE:
            enable = tag == NONCONTACT_ENABLE ? true : false
            notificationManager.setFlag(.noncontact, enable)
            setOnOffButtonColor(NONCONTACT_ENABLE, NONCONTACT_DISABLE, enable)
             
        case HOURLY_ARR_ENABLE:
            fallthrough
        case HOURLY_ARR_DISABLE:
            enable = tag == HOURLY_ARR_ENABLE ? true : false
            notificationManager.setFlag(.hourly, enable)
            setOnOffButtonColor(HOURLY_ARR_ENABLE, HOURLY_ARR_DISABLE, enable)
            
        case TOTAL_ARR_ENABLE:
            fallthrough
        case TOTAL_ARR_DISABLE:
            enable = tag == TOTAL_ARR_ENABLE ? true : false
            notificationManager.setFlag(.total, enable)
            setOnOffButtonColor(TOTAL_ARR_ENABLE, TOTAL_ARR_DISABLE, enable)
            
        default:
            break
        }
        
        notificationManager.setNotiUserDefault()
    }
    
    private func setButtonTag(_ type: NotiType, _ flag: Bool) -> Int {
        switch type {
        case .emergency:
            if flag { return EMERGENCY_ENABLE }
            else { return EMERGENCY_DISABLE }
        case .arr:
            if flag { return ARR_ENABLE }
            else { return ARR_DISABLE }
        case .fast:
            if flag { return FAST_ENABLE }
            else { return FAST_DISABLE }
        case .slow:
            if flag { return SLOW_ENABLE }
            else { return SLOW_DISABLE }
        case .heavy:
            if flag { return HEAVY_ENABLE }
            else { return HEAVY_DISABLE }
        case .myo:
            if flag { return MYO_ENABLE }
            else { return MYO_DISABLE }
        case .noncontact:
            if flag { return NONCONTACT_ENABLE }
            else { return NONCONTACT_DISABLE }
        case .hourly:
            if flag { return HOURLY_ARR_ENABLE }
            else { return HOURLY_ARR_DISABLE }
        case .total:
            if flag { return TOTAL_ARR_ENABLE }
            else { return TOTAL_ARR_DISABLE }
        case .null:
            return 1000
        }
    }
    
    private func setOnOffButtonColor(_ enableButtonTag: Int,_ disableButtonTag: Int, _ isOn: Bool) {
        let onFlag = isOn == true ? true : false
        let offFlag = isOn == false ? true : false
        
        if  let enableButton = buttonMapping[enableButtonTag],
            let disableButton = buttonMapping[disableButtonTag] {
            
            enableButton.setTitleColor(setButtonTextColor(onFlag, true), for: .normal)
            enableButton.backgroundColor = setButtonColor(onFlag, true)
            
            disableButton.setTitleColor(setButtonTextColor(offFlag, true), for: .normal)
            disableButton.backgroundColor = setButtonColor(offFlag, true)
        }
    }
    
    private func setButtonColor(_ notiFlag: Bool, _ enableFlag: Bool) -> UIColor {
        let flag = notiFlag == enableFlag
        return flag ? UIColor.PROFILE_BUTTON_SELECT : .clear
    }
    
    private func setButtonTextColor(_ notiFlag: Bool, _ enableFlag: Bool) -> UIColor {
        let flag = notiFlag == enableFlag
        return flag ? .white : UIColor.PROFILE_BUTTON_TEXT
    }
    
    // MARK: -
    private func createBackgroundLabel(type: NotiType) -> UILabel {
        let backgroundColor = type != .null ? UIColor.PROFILE_BACKGROUND : .white
        let label = UILabel().then {
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        backgroundMapping[type] = label
        
        return label
    }
    
    // MARK: -
    private func createLabel(type: NotiType) -> UILabel {
        let label = UILabel().then {
            $0.text = setLabelText(type: type)
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .darkGray
        }
        
        return label
    }
    
    private func setLabelText(type: NotiType) -> String {
        switch type {
        case .emergency:
            return "profile3_emergency".localized()
        case .arr:
            return "arr".localized()
        case .fast:
            return "typeFastArr".localized()
        case .slow:
            return "typeSlowArr".localized()
        case .heavy:
            return "typeHeavyArr".localized()
        case .myo:
            return "profile3_myo".localized()
        case .noncontact:
            return "profile3_nonContact".localized()
        case .hourly:
            return "hourlyArr".localized()
        case .total:
            return "totalArr".localized()
        default:
            return ""
        }
    }
    
    // MARK: -
    private func addView() {
        
        let stackViewSpacing = 20
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        
        // Text Label
        let notiLabel = UILabel().then {
            $0.text = "profile3_title".localized()
            $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            $0.textColor = .black
        }
        
        containerView.addSubview(notiLabel)
        notiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        
        // ----------------------------- Emergency, Arr Start -----------------------------
        // Text Label
        let emergencyAndArrLabelSV = UIStackView().then {
            $0.addArrangedSubview(createLabel(type: .emergency))
            $0.addArrangedSubview(createLabel(type: .arr))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(emergencyAndArrLabelSV)
        emergencyAndArrLabelSV.snp.makeConstraints { make in
            make.top.equalTo(notiLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        // Background Label
        let emergencyAndArrBackgroundSV = UIStackView().then {
            $0.addArrangedSubview(createBackgroundLabel(type: .emergency))
            $0.addArrangedSubview(createBackgroundLabel(type: .arr))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(emergencyAndArrBackgroundSV)
        emergencyAndArrBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(emergencyAndArrLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
            make.height.equalTo(40)
        }
        
        // ----------------------------- Emergency, Arr End -----------------------------
        
        
        
        
        
        // ----------------------------- Hourly, Total Arr Start -----------------------------
        // Text Label
        let hourlyAndTotalLabelSV = UIStackView().then {
            $0.addArrangedSubview(createLabel(type: .hourly))
            $0.addArrangedSubview(createLabel(type: .total))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(hourlyAndTotalLabelSV)
        hourlyAndTotalLabelSV.snp.makeConstraints { make in
            make.top.equalTo(emergencyAndArrBackgroundSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
        }
        
        
        // Background Label
        let hourlyAndTotalBackgroundSV = UIStackView().then {
            $0.addArrangedSubview(createBackgroundLabel(type: .hourly))
            $0.addArrangedSubview(createBackgroundLabel(type: .total))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(hourlyAndTotalBackgroundSV)
        hourlyAndTotalBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(hourlyAndTotalLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
            make.height.equalTo(40)
        }
        
        // ----------------------------- Hourly, Total Arr End -----------------------------
        
        

        
        
        // ----------------------------- Myo, Noncontact Start -----------------------------
        // Text Label
        let myoAndNoncontactLabelSV = UIStackView().then {
            $0.addArrangedSubview(createLabel(type: .myo))
            $0.addArrangedSubview(createLabel(type: .noncontact))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(myoAndNoncontactLabelSV)
        myoAndNoncontactLabelSV.snp.makeConstraints { make in
            make.top.equalTo(hourlyAndTotalBackgroundSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
        }
        
        
        // Background Label
        let myoAndNoncontactBackgroundSV = UIStackView().then {
            $0.addArrangedSubview(createBackgroundLabel(type: .myo))
            $0.addArrangedSubview(createBackgroundLabel(type: .noncontact))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(myoAndNoncontactBackgroundSV)
        myoAndNoncontactBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(myoAndNoncontactLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
            make.height.equalTo(40)
        }
        
        // ----------------------------- Myo, Noncontact End -----------------------------
        

        
        
        
        // ----------------------------- Fast, Slow Arr Start -----------------------------
        // Text Label
        let fastArrAndSlowArrLabelSV = UIStackView().then {
            $0.addArrangedSubview(createLabel(type: .fast))
            $0.addArrangedSubview(createLabel(type: .slow))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(fastArrAndSlowArrLabelSV)
        fastArrAndSlowArrLabelSV.snp.makeConstraints { make in
            make.top.equalTo(myoAndNoncontactBackgroundSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
        }
        
        
        // Background Label
        let fastArrAndSlowArrBackgroundSV = UIStackView().then {
            $0.addArrangedSubview(createBackgroundLabel(type: .fast))
            $0.addArrangedSubview(createBackgroundLabel(type: .slow))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(fastArrAndSlowArrBackgroundSV)
        fastArrAndSlowArrBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(fastArrAndSlowArrLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
            make.height.equalTo(40)
        }
        
        // ----------------------------- Fast, Slow Arr End -----------------------------
        
        
        
        
        
        // ----------------------------- Heavy Arr, nil Start -----------------------------
        // Text Label
        let heavyLabelSV = UIStackView().then {
            $0.addArrangedSubview(createLabel(type: .heavy))
            $0.addArrangedSubview(createLabel(type: .null))  // null
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(heavyLabelSV)
        heavyLabelSV.snp.makeConstraints { make in
            make.top.equalTo(fastArrAndSlowArrBackgroundSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
        }
        
        // Background Label
        let heavyBackgroundSV = UIStackView().then {
            $0.addArrangedSubview(createBackgroundLabel(type: .heavy))
            $0.addArrangedSubview(createBackgroundLabel(type: .null))
            $0.spacing = CGFloat(stackViewSpacing)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        containerView.addSubview(heavyBackgroundSV)
        heavyBackgroundSV.snp.makeConstraints { make in
            make.top.equalTo(heavyLabelSV.snp.bottom).offset(10)
            make.left.right.equalTo(emergencyAndArrLabelSV)
            make.height.equalTo(40)
        }
        
        // ----------------------------- Heavy Arr, nil End -----------------------------
        
        
        
        
        
        // ----------------------------- Button Start -----------------------------
        
        // Change Password
        let changePwButton = UIButton().then {
            $0.setTitle("ChangePw".localized(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.backgroundColor = UIColor.PROFILE_BUTTON_SELECT
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(changePwButtonEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(changePwButton)
        changePwButton.snp.makeConstraints { make in
            make.top.equalTo(heavyBackgroundSV.snp.bottom).offset(40)
            make.left.right.height.equalTo(emergencyAndArrBackgroundSV)
        }
        
        
        
        // Logout
        let logoutButton = UIButton().then {
            $0.setTitle("logout".localized(), for: .normal)
            $0.setTitleColor(.darkGray, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.backgroundColor = UIColor.PROFILE_BACKGROUND
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(logoutButtonEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(changePwButton.snp.bottom).offset(10)
            make.left.right.height.equalTo(emergencyAndArrBackgroundSV)
        }
        
        
        
        // AccountDeletion
        let deletionButton = UIButton().then {
            $0.setTitle("AccountDeletion".localized(), for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.PROFILE_BACKGROUND.cgColor
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(deletionButtonEvent(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(deletionButton)
        deletionButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(10)
            make.left.right.height.equalTo(emergencyAndArrBackgroundSV)
            make.bottom.equalToSuperview().offset(-20) // 여기 추가
        }
        
        // ----------------------------- Button End -----------------------------
        
    }
}
