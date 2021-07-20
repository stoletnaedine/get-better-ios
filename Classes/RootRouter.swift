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
    private var userSettingsService: UserSettingsServiceProtocol = UserSettingsService()

    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = SplashScreenViewController()
        addObservers()
    }
    
    func startApp(completion: ((TabBarController) -> Void)? = nil) {
        var deadline: TimeInterval = .zero
        if window?.rootViewController is SplashScreenViewController {
            deadline = 2
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + deadline, execute: { [weak self] in
            guard let self = self else { return }
            self.startAuthFlow(completion: completion)
        })
    }

    private func startAuthFlow(completion: ((TabBarController) -> Void)?) {
        if Auth.auth().currentUser == nil {
            showAuthController()
        } else {
            checkUserHasSetupSphere { [weak self] userHasSetupSphere in
                if userHasSetupSphere {
                    self?.showTabBarController(completion)
                } else {
                    self?.showOnboardingPageViewController()
                }
            }
        }
    }

    func showAddPost() {
        if let tabBarController = window?.rootViewController as? TabBarController {
            tabBarController.showAddPost()
        } else {
            startApp(completion: { tabBarController in
                tabBarController.showAddPost()
            })
        }
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
        window?.rootViewController = authViewController
    }
    
    @objc private func showTabBarController(_ completion: ((TabBarController) -> Void)? = nil) {
        let tabBarController = TabBarController()
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
            case let .failure(error):
                completion(false)
                if error.code != .notFound {
                    self?.alertService.showErrorMessage(error.localizedDescription)
                }
            case .success:
                completion(true)
            }
        }
    }
    
}
