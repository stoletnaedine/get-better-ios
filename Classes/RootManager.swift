//
//  RootManager.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import CoreData
import Toaster
import Firebase

class RootManager {
    
    var window: UIWindow?
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logout, object: nil)
        
        setupNavigationBar()
        configToaster()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        if Auth.auth().currentUser == nil {
            showAuthController()
        } else {
            checkUserHasSetupSphere(completion: { [weak self] userHasSetupSphere in
                switch userHasSetupSphere {
                case true:
                    self?.showTabBarController()
                default:
                    self?.showSetupSpherePageViewController()
                }
            })
        }
    }
    
    func checkUserHasSetupSphere(completion: @escaping (Bool) -> Void) {
        FirebaseDatabaseService().getSphereMetrics(from: GlobalDefiitions.SphereMetrics.start, completion: { result in
            switch result {
            case .failure(_):
                completion(false)
            case .success(_):
                completion(true)
            }
        })
    }
    
    @objc func logout() {
        try! Auth.auth().signOut()
        showAuthController()
    }
    
    @objc func showTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.setupSphereCompletion = { [weak self] in
            self?.showSetupSpherePageViewController()
        }
        window?.rootViewController = tabBarController
    }
    
    @objc func showSetupSpherePageViewController() {
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
            self?.showSetupSpherePageViewController()
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
