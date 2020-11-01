//
//  TabBarController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 07.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var showOnboardingCompletion: VoidClosure?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
        selectedIndex = 0
        UITabBar.appearance().tintColor = .violet
        delegate = self
    }
    
    func initViewControllers() {
        let lifeCircleVC = LifeCircleViewController()
        lifeCircleVC.showOnboardingCompletion = { [weak self] in
            self?.showOnboardingCompletion?()
        }
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
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == R.string.localizable.tabBarAddPost() {
            let journalVCIndex: Int = 1
            let addPostVC = AddPostViewController()
            if let journalNC = tabBarController.viewControllers?[journalVCIndex] as? UINavigationController,
               let journalVC = journalNC.viewControllers.first as? JournalViewController {
                addPostVC.addedPostCompletion = { [weak self] in
                    journalVC.updatePostsInTableView()
                    self?.selectedIndex = journalVCIndex
                }
            }
            self.present(addPostVC, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}
