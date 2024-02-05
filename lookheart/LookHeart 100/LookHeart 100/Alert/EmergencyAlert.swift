import UIKit
import AVFAudio
import AudioToolbox
import LookheartPackage

class EmergencyAlert: UIViewController {
    
    var countdown: Int = 10
    var countdownTimer: Timer?
    var emergencyFlag = false
    var audioPlayer: AVAudioPlayer?
    
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
        label.text = "profile3_emergency".localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.MY_RED
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "emergencyTxt".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = UIColor.MY_RED
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\("ok".localized())(10)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = UIColor.MY_RED
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapActionButton() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        audioPlayer?.stop()
        dismiss(animated: true)
    }
    
    init(emergencyCheck: Bool) {
        super.init(nibName: nil, bundle: nil)
        emergencyFlag = emergencyCheck
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        startCountdown()
    }
    
    func startCountdown() {
        if emergencyFlag {
            setupEmergencyAudioPlayer("heartAttackSound")
            audioPlayer?.play()
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        } else {
            actionButton.setTitle("ok".localized(), for: .normal)
        }
    }
    
    func setupEmergencyAudioPlayer(_ soundFile: String) {
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 무한 반복 재생
            audioPlayer?.prepareToPlay()
        } catch {
            print("오디오 파일을 로드할 수 없습니다: \(error)")
        }
    }
    
    @objc func updateCountdown() {
        if countdown > 0 {
            countdown -= 1
            actionButton.setTitle("\("ok".localized())(\(countdown))", for: .normal)
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            emergency()
        }
    }
    
    func updateArrAlert(arrTitle: String, arrMessage: String){
        titleLabel.text = arrTitle
        messageLabel.text = arrMessage
    }
    
    private func emergency() {
        // 위치 업데이트
        sendEmergency()
        actionButton.setTitle("sendEmergencyAlert".localized(), for: .normal)
    }
    
    private func sendEmergency() {
        let location = LocationManager.shared.getLocation()
        if let myLat = location?.lat, let myLong = location?.long {
            LocationManager.shared.addressInfo(lat: myLat, long: myLong) { [self] address in
                if let address = address {
                    print("주소: \(address)")
                    emergencyServerTask(address: address)
                } else {
                    print("주소를 찾을 수 없습니다.")
                }
            }
        }
    }
    
    private func emergencyServerTask(address: String) {
        NetworkManager.shared.sendEmergencyData(propEmail, address)
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(messageLabel)
        backgroundView.addSubview(actionButton)
        
        setupConstraint()
        
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    private func setupConstraint(){
        let screenWidth = UIScreen.main.bounds.width // Screen width
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: screenWidth / 1.2),
            backgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            actionButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            actionButton.widthAnchor.constraint(equalToConstant: 150),
            actionButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
