import UIKit

class AgreeBasicTermsVC : TitleViewController {
    
    private let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light) // 이미지 크기, 굵기
    lazy var agreeImage = UIImage(systemName: "circle", withConfiguration: symbolConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
    
    @IBOutlet weak var textView: UITextView!
    private var agreeTxt = ""
    private var agreeFlag = false
    
    private let signupText = UILabel().then {
        $0.text = "signup1".localized()
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .darkGray
    }
    
    private let progressView = UIProgressView().then {
        $0.trackTintColor = UIColor.PROGRESS_BAR
        $0.progressTintColor = UIColor.PROGRESS_BAR_FILL
        $0.progress = 0.333
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let agreeLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let agreeTextView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 9)
        $0.backgroundColor = .white
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 )
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.isScrollEnabled = true
        $0.isEditable = false
    }
    
    private lazy var agreeButton = UIButton().then {
        $0.setTitle("agree".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.setImage(agreeImage, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -10)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        $0.addTarget(self, action: #selector(autoLoginTapped(_:)), for: .touchUpInside)
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
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("next".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.MY_LIGHT_GRAY_BORDER.cgColor
        $0.addTarget(self, action: #selector(nextButtonEvent(_:)), for: .touchUpInside)
    }
    
    private lazy var buttonView = UIStackView(arrangedSubviews: [backButton, nextButton]).then {
        $0.spacing = 40
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    // MARK: - Button Event
    @objc func autoLoginTapped(_ sender: UIButton) {
        agreeFlag = UserDefaults.standard.bool(forKey: "firstAgree")
        agreeFlag = !agreeFlag
        
        if agreeFlag {
            sender.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfiguration)?.withTintColor(.blue, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "circle", withConfiguration: symbolConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        }
        
        UserDefaults.standard.set(agreeFlag, forKey: "firstAgree")
    }
    
    @objc func backButtonEvent(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func nextButtonEvent(_ sender: UIButton) {
        if agreeFlag {
            self.navigationController?.pushViewController(AgreePersonalInfoVC(), animated: true)
        }
        else{
            let alert = UIAlertController(title: "noti".localized(), message: "notAgree".localized(), preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: false)
        }
    }
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        readTxtfile()
        
        agreeLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-100, height: 0)
        
        let attributedText = NSAttributedString(string: agreeTxt, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)])
        agreeLabel.attributedText = attributedText
        
        DispatchQueue.global().async { [self] in
            DispatchQueue.main.async { [self] in
                agreeTextView.text = agreeTxt
            }
        }
    }
        
    private func readTxtfile() {
        do {
            agreeTxt = try String(contentsOfFile: getFile()!, encoding: .utf8)
        } catch let error as NSError {
            print("catch :: ", error.localizedDescription)
            return
        }
    }
    
    private func getFile() -> String? {
        var paths = Bundle.main.path(forResource: "agree_en.txt", ofType: nil)
        switch FindLanguage.shared.getLanguge() {
        case "ko":
            paths = Bundle.main.path(forResource: "agree.txt", ofType: nil)
        case "zh":
            paths = Bundle.main.path(forResource: "agree_cn.txt", ofType: nil)
        default:
            break
        }
        return paths
    }
    
    // MARK: - add View
    private func addViews(){
        view.addSubview(signupText)
        signupText.snp.makeConstraints { make in
            make.top.equalTo(safeAreaView.snp.top).offset(20)
            make.centerX.equalTo(safeAreaView.snp.centerX)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(signupText.snp.bottom).offset(10)
            make.left.equalTo(safeAreaView.snp.left).offset(40)
            make.right.equalTo(safeAreaView.snp.right).offset(-40)
            make.height.equalTo(20)
        }
        
        view.addSubview(agreeTextView)
        agreeTextView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(40)
            make.left.equalTo(safeAreaView.snp.left).offset(40)
            make.right.equalTo(safeAreaView.snp.right).offset(-40)
            make.height.equalTo(300)
        }
        
        view.addSubview(agreeButton)
        agreeButton.snp.makeConstraints { make in
            make.top.equalTo(agreeTextView.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaView.snp.centerX)
        }
        
        view.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(60)
            make.left.equalTo(safeAreaView.snp.left).offset(20)
            make.right.equalTo(safeAreaView.snp.right).offset(-20)
            make.height.equalTo(60)
        }
    }
}
