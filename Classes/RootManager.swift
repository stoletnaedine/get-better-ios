//
//  RootManager.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Toaster
import Firebase
import UIKit

class RootManager {
    
    var window: UIWindow?
    let connectionHelper = ConnectionHelper()
    
    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = R.storyboard.launchScreen().instantiateInitialViewController()
        
        addObservers()
        setupNavigationBar()
        configToaster()
        
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
                default:
                    self?.showOnboardingPageViewController()
                }
            })
        }
    }
    
    func checkUserHasSetupSphere(completion: @escaping (Bool) -> Void) {
        FirebaseDatabaseService().getSphereMetrics(from: GlobalDefiitions.SphereMetrics.start, completion: { result in
            switch result {
            case .failure:
                completion(false)
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
        tabBarController.setupSphereCompletion = { [weak self] in
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
            self?.showTabBarController()
        }
        authViewController.registerCompletion = { [weak self] in
            self?.showOnboardingPageViewController()
        }
        window?.rootViewController = UINavigationController(rootViewController: authViewController)
    }
    
    func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = .violet
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
    }
    
    func configToaster() {
        ToastView.appearance().backgroundColor = .darkGray
        ToastView.appearance().font = UIFont.systemFont(ofSize: 16)
        let screenHeight = UIScreen.main.bounds.height
        ToastView.appearance().bottomOffsetPortrait = CGFloat(screenHeight / 2)
    }
}
