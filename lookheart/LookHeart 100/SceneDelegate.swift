//
//  SceneDelegate.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var isLogged: Bool = UserDefaults.standard.bool(forKey: "autoLoginFlag")
    //var isLogged: Bool = false // test
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        // navigationbar
        let navigationController = UINavigationController(rootViewController: LoginView())

        
//        window.rootViewController = ExerciseList()
        
        if isLogged == false {
            window.rootViewController = navigationController // 로그인 안된 상태
        }
        else {
            window.rootViewController = TabBarController() // 로그인 상태
        }

        window.makeKeyAndVisible()
        self.window = window
       
    }
}
