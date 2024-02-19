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
                                    
        if propProfil.isLogin {
            
            // Send Log
            NetworkManager.shared.sendLog(id: propEmail, userType: .User, action: .Shutdown)
            
            let prevHour = defaults.string(forKey: "\(propEmail)prevHour")!
            
            // Send Data
            if connectionFlag && HourlyDataManager.shared.calorie != 0 {
                BluetoothManager.shared.sendTenSecondData()
                BluetoothManager.shared.sendHourlyData(hour: prevHour)
            }
            
            // Set Default Data
            HealthDataManager.shared.setUserDefaultData()
            HourlyDataManager.shared.setUserDefaultData()
            
            defaults.set(propCurrentDate, forKey: "\(propEmail)\(PrevDateKey)")
            defaults.set(propCurrentHour, forKey: "\(propEmail)\(PrevHourKey)")
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
