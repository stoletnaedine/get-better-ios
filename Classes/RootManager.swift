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
    
    var window: UIWindow?
    let connectionHelper = ConnectionHelper()
    let alertService: AlertService = AlertServiceDefault()
    
    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = R.storyboard.launchScreen().instantiateInitialViewController()
        
        addObservers()
        
        if connectionHelper.isConnectionAvailable() {
            enterApp()
        } else {
            showNoInternetViewController()
        }
    }
    
    func addObservers() {
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
    
    @objc func enterApp() {
        if Auth.auth().currentUser == nil {
            showAuthController()
        } else {
            checkUserHasSetupSphere(completion: { [weak self] userHasSetupSphere in
                switch userHasSetupSphere {
                case true:
                    self?.showTabBarController()
                case false:
                    self?.showOnboardingPageViewController()
                }
            })
        }
    }
    
    func checkUserHasSetupSphere(completion: @escaping (Bool) -> Void) {
        FirebaseDatabase().getStartSphereMetrics(completion: { [weak self] result in
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
        })
    }
    
    @objc func logout() {
        try! Auth.auth().signOut()
        showAuthController()
    }
    
    @objc func showNoInternetViewController() {
        let noInternetViewController = NoInternetViewController()
        window?.rootViewController = noInternetViewController
    }
    
    @objc func showTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.showOnboardingCompletion = { [weak self] in
            self?.showOnboardingPageViewController()
        }
        window?.rootViewController = tabBarController
    }
    
    @objc func showOnboardingPageViewController() {
        let onboardingPageViewController = OnboardingPageViewController()
        onboardingPageViewController.completion = { [weak self] in
            self?.showTabBarController()
        }
        window?.rootViewController = UINavigationController(rootViewController: onboardingPageViewController)
    }
    
    func showAuthController() {
        let authViewController = AuthViewController()
        authViewController.signInCompletion = { [weak self] in
            self?.enterApp()
        }
        window?.rootViewController = UINavigationController(rootViewController: authViewController)
    }
}
