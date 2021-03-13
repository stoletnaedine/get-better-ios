//
//  TabBarController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 07.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let connectionHelper = ConnectionHelper()
    
    private enum Constants {
        static let journalVCIndex: Int = 1
        static let addPostVCIndex: Int = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
        selectedIndex = 0
        UITabBar.appearance().tintColor = .violet
        delegate = self
    }
    
    func initViewControllers() {
        let lifeCircleVC = LifeCircleViewController()
        let lifeCircleNC = UINavigationController(rootViewController: lifeCircleVC)
        lifeCircleNC.tabBarItem.image = R.image.circle()
        lifeCircleNC.tabBarItem.title = R.string.localizable.tabBarLifeCircle()
        
        let journalNC = UINavigationController(rootViewController: JournalViewController())
        journalNC.tabBarItem.image = R.image.journal()
        journalNC.tabBarItem.title = R.string.localizable.tabBarJournal()
        
        let fakeAddPostVC = UIViewController()
        fakeAddPostVC.title = R.string.localizable.tabBarAddPost()
        fakeAddPostVC.tabBarItem.title = R.string.localizable.tabBarAddPost()
        fakeAddPostVC.tabBarItem.image = R.image.addPost()
        
        let achievementsNC = UINavigationController(rootViewController: AchievementsViewController())
        achievementsNC.tabBarItem.image = R.image.achievements()
        achievementsNC.tabBarItem.title = R.string.localizable.tabBarAchievements()

        let settingsNC = UINavigationController(rootViewController: SettingsViewController())
        settingsNC.tabBarItem.image = R.image.settings()
        settingsNC.tabBarItem.title = R.string.localizable.tabBarSettings()
        
        viewControllers = [lifeCircleNC, journalNC, fakeAddPostVC, achievementsNC, settingsNC]
    }
    
    func showAddPost() {
        guard connectionHelper.isConnect() else { return }
        let addPostVC = AddPostViewController()
        if let journalNC = self.viewControllers?[Constants.journalVCIndex] as? UINavigationController,
           let journalVC = journalNC.viewControllers.first as? JournalViewController {
            addPostVC.addedPostCompletion = { [weak self] in
                journalVC.updatePostsInTableView()
                self?.selectedIndex = Constants.journalVCIndex
            }
        }
        self.present(addPostVC, animated: true, completion: nil)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let addPostVC = viewControllers?[Constants.addPostVCIndex],
           viewController == addPostVC {
            showAddPost()
            return false
        }
        
        return true
    }
    
}
