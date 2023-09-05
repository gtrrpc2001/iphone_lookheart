//
//  AppDelegate.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/04.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 13이상인 경우에는 SceneDelegate에서 이미 초기화 되었으니까 바로 return
        
        UNUserNotificationCenter.current().requestAuthorization(
           options: [.alert, .sound, .badge],
           completionHandler: { (granted, error) in
             print("granted notification, \(granted)")
           }
         )
         
         UNUserNotificationCenter.current().delegate = self
   
        if #available(iOS 13.0, *) {
            return true
            
        }
        sleep(1)
        // 13이전의 경우에는 SceneDelegate에서 해주었던 작업을 그대로 진행해주면 된다.
        window = UIWindow()
        //window?.rootViewController = Test()
        window?.rootViewController = MainViewController() // 초기 ViewController
        window?.makeKeyAndVisible()
 
        return true
    }
    
}

// 추가
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        // deep link처리 시 아래 url값 가지고 처리
//        let url = response.notification.request.content.userInfo

        completionHandler()
    }
}


// iOS 14 ~
//
//import UIKit
//import SwiftUI
//
//class AppDelegate: NSObject, UIApplicationDelegate{
//    func application(
//        _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//            return true
//        }
//
//    func application(
//      _ application: UIApplication,
//      configurationForConnecting connectingSceneSession: UISceneSession,
//      options: UIScene.ConnectionOptions
//    ) -> UISceneConfiguration {
//      let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//      sceneConfig.delegateClass = SceneDelegate.self
//      return sceneConfig
//    }
//}
