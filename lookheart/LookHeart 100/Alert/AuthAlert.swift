import UIKit

class AuthAlert: UIViewController {
    
    
    // MARK: -
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "AuthEmailTitle".localized()
        $0.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.PROGRESS_BAR_FILL
    }
    
    private let messageLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 // 줄 간격
        
        let text = "AuthEmailMessage".localized()
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        let targetText = "파란색 링크"
        if let range = text.range(of: targetText) {
            let nsRange = NSRange(range, in: text)
            
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .heavy), range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
        }

        $0.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        $0.textColor = UIColor.MY_BLUE
        $0.numberOfLines = 10
        $0.attributedText = attributedString
        $0.textAlignment = .center
    }
    
    private let actionButton = UIButton().then {
        $0.setTitle("resendEmail".localized(), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.backgroundColor = UIColor.PROGRESS_BAR_FILL
        $0.tintColor = .white
        $0.layer.cornerRadius = 15
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("nextGuardianPhone".localized(), for: .normal)
        $0.setTitleColor(UIColor.PROGRESS_BAR_FILL, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.PROGRESS_BAR_FILL.cgColor
    }
    
    @objc func didTapActionButton() {
        
    }
    
    @objc func didTapCancleButton() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        addTarget()
    }
    
    private func addTarget() {
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(didTapCancleButton), for: .touchUpInside)
    }
    
    private func addView() {
        let screenWidth = UIScreen.main.bounds.width // Screen width
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(screenWidth / 1.2)
            make.height.equalTo(260)
        }
        
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top)
            make.left.right.equalTo(backgroundView)
            make.height.equalTo(40)
        }
        
        backgroundView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(backgroundView)
        }
        
        backgroundView.addSubview(cancleButton)
        cancleButton.snp.makeConstraints { make in
            make.left.equalTo(backgroundView).offset(10)
            make.right.equalTo(backgroundView).offset(-10)
            make.bottom.equalTo(backgroundView).offset(-10)
            make.height.equalTo(40)
        }
        
        backgroundView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.left.right.equalTo(cancleButton)
            make.bottom.equalTo(cancleButton.snp.top).offset(-5)
            make.height.equalTo(40)
        }
    
    }
}
