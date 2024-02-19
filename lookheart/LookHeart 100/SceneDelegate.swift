import UIKit
import LookheartPackage
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        FindLanguage.shared.findLanguage()
        
        sleep(1)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = LaunchScreenVC()
        window.makeKeyAndVisible()
        self.window = window
        
    }
    
    
}
