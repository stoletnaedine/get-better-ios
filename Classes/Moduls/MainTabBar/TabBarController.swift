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
        let lifeCircleVC = LifeCircleViewController()
        lifeCircleVC.setupSphereCompletion = { [weak self] in
            self?.setupSphereCompletion()
        }
        let lifeCircleNC = UINavigationController(rootViewController: lifeCircleVC)
        lifeCircleNC.tabBarItem.image = R.image.circle()
        lifeCircleNC.tabBarItem.title = GlobalDefiitions.TabBar.lifeCircleTitle
        
        let journalNC = UINavigationController(rootViewController: JournalViewController())
        journalNC.tabBarItem.image = R.image.journal()
        journalNC.tabBarItem.title = GlobalDefiitions.TabBar.journalTitle

        let settingsNC = UINavigationController(rootViewController: SettingsViewController())
        settingsNC.tabBarItem.image = R.image.settings()
        settingsNC.tabBarItem.title = GlobalDefiitions.TabBar.settingsTitle
        
        viewControllers = [lifeCircleNC, journalNC, settingsNC]
    }
}
