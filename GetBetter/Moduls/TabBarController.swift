//
//  TabBarController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 07.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var setupSphereCompletion: () -> () = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
        selectedIndex = 0
        UITabBar.appearance().tintColor = .black
    }
    
    func initViewControllers() {
        let circleVC = LifeCircleController()
        circleVC.setupSphereCompletion = { [weak self] in
            self?.setupSphereCompletion()
        }
        let circleViewController = UINavigationController(rootViewController: circleVC)
        circleViewController.tabBarItem.image = UIImage(named: "circle")
        circleViewController.tabBarItem.title = Constants.TabBar.lifeCircleTitle
        
        let journalViewController = UINavigationController(rootViewController: JournalViewController())
        journalViewController.tabBarItem.image = UIImage(named: "journal")
        journalViewController.tabBarItem.title = Constants.TabBar.journalTitle

        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        settingsViewController.tabBarItem.image = UIImage(named: "settings")
        settingsViewController.tabBarItem.title = Constants.TabBar.settingsTitle
        
        viewControllers = [circleViewController, journalViewController, settingsViewController]
    }
}
