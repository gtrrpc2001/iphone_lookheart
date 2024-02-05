//
//  AppDelegate.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/04.
//

import UIKit
import UserNotifications
import LookheartPackage
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        requestNotificationAuthorization()
         
        configureFirebase()
        
        return true
        
    }
    
    
    // 알림 권한 요청
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification permission granted: \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    // FireBase 초기화
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("\(type(of: self)): \(#function)")
        
        NotificationManager.shared.setNotiUserDefault()
                
        let lastHour = MyDateTime.shared.getSplitDateTime(.TIME)[0]
        let lastDate = MyDateTime.shared.getCurrentDateTime(.DATE)
        
        defaults.set(lastDate, forKey: "prevHour")
        defaults.set(lastHour, forKey: "prevDate")
        
        HealthDataManager.shared.setUserDefaultData()
        HourlyDataManager.shared.setUserDefaultData()
        
        // 종료 전에 필요한 작업 수행
        if connectionFlag {
            BluetoothManager.shared.sendTenSecondData()
            BluetoothManager.shared.sendHourlyData(hour: lastHour)
        }

        // Send Log
        if UserProfileManager.shared.isLogin {
            NetworkManager.shared.sendLog(id: propEmail, userType: .User, action: .Shutdown)
        }
        
        sleep(2)
        
        print("💣💣💣")
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
        completionHandler()
    }
}
