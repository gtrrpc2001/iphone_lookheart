import UIKit
import Foundation
import LookheartPackage
import Alamofire

class LaunchScreenVC: UIViewController {
    struct Version: Codable {
        var versioncode: Int
        var apkkey: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startApp()
    }
    
    private func startApp(retryCount: Int = 0) {
        guard let window = view.window else { return }
        
        LoadingIndicator.shared.show(in: self.view)
        
        Task {
            switch(await checkVersion()) {
            case .success:
                let checkAppKey = await checkAppKey()
                let checkAutoLogin = defaults.bool(forKey: authLoginKey)
            
                print("appKey: \(checkAppKey), autoLogin: \(checkAutoLogin)")
                
                if checkAppKey && checkAutoLogin {
                    moveToMainVC(using: window)
                } else {
                    moveToLoginVC(using: window)
                }
                
            case .failer:
                updateAppAlert()
            case .notConnected, .invalidResponse:
                shutdownApp()
            case .session:
                if retryCount < 3 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    startApp(retryCount: retryCount + 1)
                } else {
                    shutdownApp()
                }
            default:
                return
            }
            
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
    }
    
    
    
    private func checkVersion() async -> NetworkResponse {
        let parameters: [String: Any] = [
            "app": "lookheart",
            "gubun": "IOS",
        ]
        
        do {
            let version: Version = try await AlamofireController.shared.alamofireControllerAsync(
                parameters: parameters,
                endPoint: .getVersion,
                method: .get
            )
            
            if let appVersion = getAppVersion?.split(separator: ".").last {
                print("version: \(version), appVersion: \(appVersion)")
                if Int(appVersion) == version.versioncode || 1610 == version.versioncode {
                    return .success
                } else {
                    return .failer
                }
            } else {
                return .invalidResponse
            }
        } catch {
            return AlamofireController.shared.handleError(error)
        }
    }
    
    
    
    
    private func checkAppKey() async -> Bool {
        if let appKey = defaults.string(forKey: appKey) {
            if let email = defaults.string(forKey: userEmailKey) {
                let params: [String: Any] = ["empid": email]
                
                do {
                    let getAppKey = try await AlamofireController.shared.alamofireControllerForString(
                        parameters: params,
                        endPoint: .getAppKey,
                        method: .get)
//                    print("appKey: \(appKey), getAppKey: \(getAppKey)")
                    return appKey.contains(getAppKey)
                } catch {
                    print("Error checkAppKey string data: \(error)")
                    return false
                }
            } else { return false }
        } else { return false }
    }
    

    
    
    
    private func moveToLoginVC(using window: UIWindow){
        let navController = UINavigationController(rootViewController: LoginVC())
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    private func moveToMainVC(using window: UIWindow) {
        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
    
    
    
    
    
    
    private func updateAppAlert() {
        DispatchQueue.main.async {
            propAlert.basicActionAlert(title: "noti".localized(), message: "updateApp".localized(), ok: "ok".localized(), viewController: self) {
                guard let url = URL(string: "https://itunes.apple.com/app/id6450522486") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func shutdownApp() {
        DispatchQueue.main.async {
            propAlert.basicActionAlert(
                title: "noti".localized(),
                message: "serverError".localized(),
                ok: "ok".localized(),
                viewController: self
            ) {
                self.shutdown()
            }
        }
    }
    
    private func shutdown() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            exit(0)
        }
    }
    
    private func addView() {
        let launchScreen = UIImageView(frame: self.view.bounds).then {
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage(named: "launchScreen")
        }
        
        view.addSubview(launchScreen)
        launchScreen.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}
