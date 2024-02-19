import Foundation
import UIKit

class BatteryProgress: UIView {
    
    static let shared = BatteryProgress()
    private var battery = 0
    
    var batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold) // 크기, 굵음 정도 설정
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var batProgress: UIProgressView = {
        let battery = UIProgressView()

        let batteryLevel: Float = 0.0 // 프로그래스 바 값 설정
        battery.setProgress(batteryLevel, animated: false)
        battery.progressViewStyle = .default
        battery.progressTintColor = UIColor.red
        battery.trackTintColor = UIColor.lightGray
        battery.layer.cornerRadius = 5
        battery.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        battery.clipsToBounds = true
        // height 높이 설정
        battery.transform = battery.transform.scaledBy(x: 1, y: 3)
        battery.translatesAutoresizingMaskIntoConstraints = false
        return battery
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(batProgress)
        addSubview(batteryLabel)
        
        NSLayoutConstraint.activate([
            
            batProgress.centerYAnchor.constraint(equalTo: centerYAnchor),
            batProgress.topAnchor.constraint(equalTo: topAnchor),
            batProgress.bottomAnchor.constraint(equalTo: bottomAnchor),
            batProgress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            batProgress.widthAnchor.constraint(equalToConstant: 50),
            batProgress.heightAnchor.constraint(equalToConstant: 5),
            
            batteryLabel.centerYAnchor.constraint(equalTo: batProgress.centerYAnchor),
            batteryLabel.centerXAnchor.constraint(equalTo: batProgress.centerXAnchor),
        ])
    }
    
    func setProgress(_ progress: Float, _ battery: Int, animated: Bool) {
        self.battery = battery
        batProgress.setProgress(progress, animated: animated)
        batteryLabel.text = String(battery)
    }
    
    func getBattery() -> Int {
        return battery
    }
}
