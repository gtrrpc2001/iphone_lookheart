import UIKit
import AVFAudio
import AudioToolbox
import LookheartPackage

class EmergencyAlert: UIViewController {
    
    private var countdown: Int = 10
    private var countdownTimer: Timer?
    private var emergencyFlag = false
    private var audioPlayer: AVAudioPlayer?
    
    private var alertTitleLabel: UILabel?
    private var alertMessageLabel: UILabel?
    private var alertButton: UIButton?
            
    @objc func didTapActionButton() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        audioPlayer?.stop()
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmergencyAudioPlayer()
        
        setUserInterface()
        
        startCountdown()
        
    }
        
    private func setupEmergencyAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "heartAttackSound", withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 무한 반복 재생
            audioPlayer?.prepareToPlay()
        } catch {
            print("오디오 파일을 로드할 수 없습니다: \(error)")
        }
    }
    
    private func startCountdown() {
        
        audioPlayer?.play()
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
    }

    
    @objc func updateCountdown() {
        if countdown > 0 {
            countdown -= 1
            updateButton(text: "\("ok".localized())(\(countdown))")
        } else {
            
            countdownTimer?.invalidate()
            countdownTimer = nil
            
            getAddress()
        }
    }
    
    public func getAddress() {
        let location = LocationManager.shared.getLocation()
        
        if let myLat = location?.lat, let myLong = location?.long {
            LocationManager.shared.addressInfo(lat: myLat, long: myLong) { [self] address in
                if let address = address {
                    print("address: \(address)")
                    sendEmergency(address: address)
                } else {
                    print("주소를 찾을 수 없습니다.")
                }
            }
        }
    }
    
    private func sendEmergency(address: String) {
        NetworkManager.shared.sendEmergencyData(address, propCurrentDateTime) { result in
            switch result {
                
            case .success(let success):
                
                if success {
                    self.updateButton(text: "sendEmergencyAlert".localized())
                } else {
                    self.updateButton(text: "failureEmergency".localized())
                }
                
            case .failure(_):
                self.updateButton(text: "failureEmergency".localized())
            }
        }
    }
    
    
    func updateMessage(message: String){
        alertMessageLabel!.text = message
    }
    
    func updateButton(text: String){
        alertButton!.setTitle(text, for: .normal)
    }
    
    // MARK: - setUserInterface
    private func setUserInterface() {
                
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let screenWidth = UIScreen.main.bounds.width
        
        // create
        let alertBackground = propCreateUI.backgroundLabel(backgroundColor: .white, borderColor: UIColor.clear.cgColor, borderWidth: 0, cornerRadius: 10).then {
            $0.isUserInteractionEnabled = true
        }

        alertTitleLabel = propCreateUI.label(text: "profile3_emergency".localized(), color: .white, size: 18, weight: .heavy).then {
            $0.textAlignment = .center
            $0.backgroundColor = UIColor.MY_RED
        }
        
        alertMessageLabel = propCreateUI.label(text: "emergencyTxt".localized(), color: UIColor.MY_RED, size: 16, weight: .heavy).then {
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }
        
        alertButton = propCreateUI.button(title: "\("ok".localized())(10)", titleColor: .white, size: 14, weight: .bold, backgroundColor: UIColor.MY_RED, tag: 0).then {
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        }
        
        // addSubview
        view.addSubview(alertBackground)
        
        // makeConstraints
        alertBackground.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(screenWidth / 1.2)
            make.height.equalTo(200)
        }
        
        if let alertTitleLabel = alertTitleLabel, let alertMessageLabel = alertMessageLabel, let alertButton = alertButton {
            
            alertBackground.addSubview(alertTitleLabel)
            alertBackground.addSubview(alertMessageLabel)
            alertBackground.addSubview(alertButton)
            
            alertTitleLabel.snp.makeConstraints { make in
                make.top.left.right.equalTo(alertBackground)
                make.height.equalTo(40)
            }
            
            alertMessageLabel.snp.makeConstraints { make in
                make.top.equalTo(alertTitleLabel.snp.bottom).offset(10)
                make.left.right.equalTo(alertBackground)
            }
            
            alertButton.snp.makeConstraints { make in
                make.centerX.equalTo(alertBackground)
                make.bottom.equalTo(alertBackground).offset(-10)
                make.width.equalTo(100)
                make.height.equalTo(40)
            }
        }
    }
}
