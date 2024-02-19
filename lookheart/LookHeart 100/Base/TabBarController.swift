//
//  TabBarController.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/05.
//

import UIKit
import Foundation
import LookheartPackage

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.MY_RED
        self.tabBar.unselectedItemTintColor = .gray
        
        let homeVC = UINavigationController(rootViewController: MainViewController())
        homeVC.tabBarItem.title = "bottomHome".localized()
        homeVC.tabBarItem.image = UIImage(named: "tabBar_home")!
        homeVC.tabBarItem.selectedImage = UIImage(named: "tabBar_home_fill")!
        
        let SummaryVC = UINavigationController(rootViewController: SummaryVC())
        SummaryVC.view.backgroundColor = .white
        SummaryVC.tabBarItem.title = "bottomSummary".localized()
        SummaryVC.tabBarItem.image = UIImage(named: "tabBar_summary")!
        SummaryVC.tabBarItem.selectedImage = UIImage(named: "tabBar_summary_fill")!
        
        let arrVC = UINavigationController(rootViewController: ArrVC())
        arrVC.view.backgroundColor = .white
        arrVC.tabBarItem.title = "bottomArr".localized()
        arrVC.tabBarItem.image = UIImage(named: "tabBar_arr")!
        arrVC.tabBarItem.selectedImage = UIImage(named: "tabBar_arr_fill")!
        
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        profileVC.view.backgroundColor = .white
        profileVC.tabBarItem.title = "bottomProfile".localized()
        profileVC.tabBarItem.image = UIImage(named: "tabBar_profile")!
        profileVC.tabBarItem.selectedImage = UIImage(named: "tabBar_profile_fill")!
                
        viewControllers = [homeVC, SummaryVC, arrVC, profileVC]
    }

}
