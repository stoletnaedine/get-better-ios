//
//  RootManager.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Firebase
import UIKit

class RootManager {
    
    private var window: UIWindow?
    private let connectionHelper = ConnectionHelper()
    private lazy var alertService: AlertService = AlertServiceDefault()
    private lazy var database: GBDatabase = FirebaseDatabase()
    
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
        tabBarController.showOnboardingCompletion = { [weak self] in
            self?.showOnboardingPageViewController()
        }
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
