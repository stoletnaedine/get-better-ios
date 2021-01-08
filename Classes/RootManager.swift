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
    func showPushAlert()
}

class RootManager: RootManagerProtocol {
    
    private var window: UIWindow?
    private let connectionHelper = ConnectionHelper()
    private lazy var alertService: AlertService = AlertServiceDefault()
    private lazy var database: GBDatabase = FirebaseDatabase()
    private var tabBarController: TabBarController?
    private let userDefaultsService: UserDefaultsService = UserDefaultsServiceImpl()
    
    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = R.storyboard.launchScreen().instantiateInitialViewController()
        addObservers()
        enterApp()
    }
    
    func showAddPost() {
        if let tabBarController = self.tabBarController {
            tabBarController.showAddPost()
            return
        }
        
        enterApp(completion: { tabBarController in
            tabBarController.showAddPost()
        })
    }
    
    func showTip() {
        userDefaultsService.setTipOfTheDayNotShown()
        enterApp()
    }
    
    func showPushAlert() {
        let alert = UIAlertController(title: "Теперь можно указать время для пушей 👍",
                                      message: "Обновите push-уведомления в разделе Настройки",
                                      preferredStyle: .alert)
        
        if let tabBarController = self.tabBarController {
            tabBarController.present(alert, animated: true, completion: nil)
            return
        }
        enterApp(completion: { tabBarController in
            tabBarController.present(alert, animated: true, completion: nil)
        })
    }
    
    @objc
    private func enterApp(completion: ((TabBarController) -> Void)? = nil) {
        guard connectionHelper.connectionAvailable() else {
            showNoInternetViewController()
            return
        }
        guard Auth.auth().currentUser != nil else {
            showAuthController()
            return
        }
        checkUserHasSetupSphere { [weak self] userHasSetupSphere in
            switch userHasSetupSphere {
            case true:
                self?.showTabBarController(completion)
            case false:
                self?.showOnboardingPageViewController()
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
    
    @objc
    private func showTabBarController(_ completion: ((TabBarController) -> Void)? = nil) {
        let tabBarController = TabBarController()
        self.tabBarController = tabBarController
        window?.rootViewController = tabBarController
        completion?(tabBarController)
    }
    
    @objc
    private func logout() {
        try! Auth.auth().signOut()
        showAuthController()
    }
    
    @objc
    private func showNoInternetViewController() {
        let noInternetViewController = NoInternetViewController()
        window?.rootViewController = noInternetViewController
    }
    
    @objc
    private func showOnboardingPageViewController() {
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
