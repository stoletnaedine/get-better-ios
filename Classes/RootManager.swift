//
//  RootManager.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Firebase
import UIKit

protocol RootManagerProtocol {
    func start()
    func showAddPost()
    func showTip()
}

class RootManager: RootManagerProtocol {
    
    private var window: UIWindow?
    private let connectionHelper = ConnectionHelper()
    private lazy var alertService: AlertService = AlertServiceDefault()
    private lazy var database: GBDatabase = FirebaseDatabase()
    private var tabBarController: TabBarController?
    
    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = R.storyboard.launchScreen().instantiateInitialViewController()
        
        addObservers()
        
        if connectionHelper.connectionAvailable() {
            enterApp()
        } else {
            showNoInternetViewController()
        }
    }
    
    func showAddPost() {
        guard connectionHelper.connectionAvailable() else { return }
        let addPostVC = AddPostViewController()
        let journalVCIndex: Int = 1
        if let tabBarController = self.tabBarController,
           let journalNC = tabBarController.viewControllers?[journalVCIndex] as? UINavigationController,
           let journalVC = journalNC.viewControllers.first as? JournalViewController {
            addPostVC.addedPostCompletion = {
                journalVC.updatePostsInTableView()
                tabBarController.selectedIndex = journalVCIndex
            }
            tabBarController.present(addPostVC, animated: true, completion: nil)
        }
    }
    
    func showTip() {
        guard connectionHelper.connectionAvailable() else { return }
        let lifeCircleVCIndex: Int = 0
        if let tabBarController = self.tabBarController,
           let lifeCircleNC = tabBarController.viewControllers?[lifeCircleVCIndex] as? UINavigationController,
           let lifeCircleVC = lifeCircleNC.viewControllers.first as? LifeCircleViewController {
            lifeCircleVC.showTip()
        }
    }
    
    @objc private func enterApp() {
        if Auth.auth().currentUser == nil {
            showAuthController()
        } else {
            checkUserHasSetupSphere { [weak self] userHasSetupSphere in
                switch userHasSetupSphere {
                case true:
                    self?.showTabBarController()
                case false:
                    self?.showOnboardingPageViewController()
                }
            }
        }
    }
    
    private func showAuthController() {
        let authViewController = AuthViewController()
        authViewController.signInCompletion = { [weak self] in
            self?.enterApp()
        }
        window?.rootViewController = UINavigationController(rootViewController: authViewController)
    }
    
    @objc private func logout() {
        try! Auth.auth().signOut()
        showAuthController()
    }
    
    @objc private func showNoInternetViewController() {
        let noInternetViewController = NoInternetViewController()
        window?.rootViewController = noInternetViewController
    }
    
    @objc private func showTabBarController() {
        let tabBarController = TabBarController()
        self.tabBarController = tabBarController
        window?.rootViewController = tabBarController
    }
    
    @objc private func showOnboardingPageViewController() {
        let onboardingPageViewController = OnboardingPageViewController()
        onboardingPageViewController.completion = { [weak self] in
            self?.showTabBarController()
        }
        window?.rootViewController = UINavigationController(rootViewController: onboardingPageViewController)
    }
}

// MARK: — Helpers

extension RootManager {
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logout),
                                               name: .logout,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showNoInternetViewController),
                                               name: .showNoInternetScreen,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterApp),
                                               name: .enterApp,
                                               object: nil)
    }
    
    private func checkUserHasSetupSphere(completion: @escaping (Bool) -> Void) {
        database.getStartSphereMetrics { [weak self] result in
            switch result {
            case .failure(let error):
                if error.name == AppErrorCode.notFound.rawValue {
                    completion(false)
                } else {
                    self?.alertService.showErrorMessage(desc: error.localizedDescription)
                }
            case .success:
                completion(true)
            }
        }
    }
    
}
