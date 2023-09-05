//
//  TabBarController.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/05.
//

import UIKit
import Foundation


class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .magenta
        self.tabBar.unselectedItemTintColor = .gray
        
        let HomeVC = UINavigationController(rootViewController: MainViewController())
        HomeVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "homekit@2x.png")
//        HomeVC.tabBarItem.title = "Home"
        HomeVC.tabBarItem.title = "홈"
        HomeVC.tabBarItem.image = #imageLiteral(resourceName: "homekit@2x.png")
        
        

        let profileVC =  UINavigationController(rootViewController: ProfileVC())
        profileVC.view.backgroundColor = .white
        profileVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "person.crop.circle@2x.png")
//        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.title = "프로필"
        profileVC.tabBarItem.image = #imageLiteral(resourceName: "person.crop.circle@2x.png")
        
        let bpmVC = UINavigationController(rootViewController: SummaryVC())
        bpmVC.view.backgroundColor = .white
//        bpmVC.tabBarItem.title = "Summary"
        bpmVC.tabBarItem.title = "활동"
        bpmVC.tabBarItem.image = #imageLiteral(resourceName: "chart.xyaxis.line@2x.png")
    
        
       let arrVC = UINavigationController(rootViewController:arrVC())
        
        arrVC.view.backgroundColor = .white
//        arrVC.tabBarItem.title = "Arr"
        arrVC.tabBarItem.title = "비정상맥박"
        arrVC.tabBarItem.image = #imageLiteral(resourceName: "bolt.heart@2x.png")
        
        let ExerciseVC = UINavigationController(rootViewController:ExerciseList())
        ExerciseVC.view.backgroundColor = .white
//        ExerciseVC.tabBarItem.title = "Workout"
        ExerciseVC.tabBarItem.title = "운동"
        ExerciseVC.tabBarItem.image = #imageLiteral(resourceName: "figure.walk@2x.png")
        
        viewControllers = [HomeVC, bpmVC,arrVC, ExerciseVC, profileVC]
        
    }

    // 탭바 변경 시 호출되는 메서드
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
