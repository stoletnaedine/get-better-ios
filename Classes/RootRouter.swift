//
//  RootRouter.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Firebase
import UIKit

protocol RootRouterProtocol {
    func startApp(completion: ((TabBarController) -> Void)?)
    func showAddPost()
    func showTip()
}

class RootRouter: RootRouterProtocol {
    
    private var window: UIWindow?
    private let connectionHelper = ConnectionHelper()
    private lazy var alertService: AlertServiceProtocol = AlertService()
    private lazy var database: DatabaseProtocol = FirebaseDatabase()
    private var tabBarController: TabBarController?
    private var userSettingsService: UserSettingsServiceProtocol = UserSettingsService()

    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        addObservers()
    }
    
    func startApp(completion: ((TabBarController) -> Void)? = nil) {
        guard Auth.auth().currentUser != nil else {
            showAuthController()
            return
        }
        checkUserHasSetupSphere { [weak self] userHasSetupSphere in
            if userHasSetupSphere {
                self?.showTabBarController(completion)
            } else {
                self?.showOnboardingPageViewController()
            }
        }
    }

    func showAddPost() {
        if let tabBarController = self.tabBarController {
            tabBarController.showAddPost()
            return
        }

        startApp(completion: { tabBarController in
            tabBarController.showAddPost()
        })
    }

    func showTip() {
        userSettingsService.tipOfTheDayHasShown = false
        startApp()
    }

    // MARK: — Private methods
    
    private func showAuthController() {
        let authViewController = AuthViewController()
        authViewController.signInCompletion = { [weak self] in
            self?.startApp()
        }
        window?.rootViewController = UINavigationController(rootViewController: authViewController)
    }
    
    @objc private func showTabBarController(_ completion: ((TabBarController) -> Void)? = nil) {
        let tabBarController = TabBarController()
        self.tabBarController = tabBarController
        window?.rootViewController = tabBarController
        completion?(tabBarController)
    }
    
    @objc private func logout() {
        try! Auth.auth().signOut()
        showAuthController()
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

extension RootRouter {
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logout),
            name: .logout,
            object: nil)
    }
    
    private func checkUserHasSetupSphere(completion: @escaping (Bool) -> Void) {
        database.getStartSphereMetrics { [weak self] result in
            switch result {
            case .failure(let error):
                if error.name == AppErrorCode.notFound.rawValue {
                    completion(false)
                } else {
                    self?.alertService.showErrorMessage(error.localizedDescription)
                }
            case .success:
                completion(true)
            }
        }
    }
    
}
