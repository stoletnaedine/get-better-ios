//
//  TabBarController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 07.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
        selectedIndex = 1
        UITabBar.appearance().tintColor = .black
    }
    
    func initViewControllers() {
        let circleViewController = UINavigationController(rootViewController: LifeCircleController())
        circleViewController.tabBarItem.image = UIImage(named: "circle")
        circleViewController.tabBarItem.title = Properties.TabBar.lifeCircleTitle
        
        let journalViewController = UINavigationController(rootViewController: JournalViewController())
        journalViewController.tabBarItem.image = UIImage(named: "journal")
        journalViewController.tabBarItem.title = Properties.TabBar.journalTitle
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        profileViewController.tabBarItem.image = UIImage(named: "profile")
        profileViewController.tabBarItem.title = Properties.TabBar.profileTitle
        
        viewControllers = [circleViewController, journalViewController, profileViewController]
    }
}
