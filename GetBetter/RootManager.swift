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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout),
                                               name: .logout, object: nil)
        
        setupNavigationBar()
        configToaster()
        
        if Auth.auth().currentUser == nil {
            showAuthController()
        } else {
            showTabBarController()
        }
    }
    
    @objc func logout() {
        try! Auth.auth().signOut()
        KeychainHelper.deleteCredentials()
        showAuthController()
    }
    
    func showTabBarController() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
    }
    
    func showAuthController() {
        let authViewController = AuthViewController()
        authViewController.completion = { [weak self] in
            self?.showTabBarController()
        }
        window?.rootViewController = UINavigationController(rootViewController: authViewController)
    }
    
    func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = .sky
        UINavigationBar.appearance().tintColor = .white
        let navigationBarFont = UIFont(name: Properties.Font.OfficinaSansExtraBoldC, size: 21)
            ?? UIFont(name: Properties.Font.OfficinaSansExtraBoldSCC, size: 21)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font: navigationBarFont as Any]
    }
    
    func configToaster() {
        ToastView.appearance().backgroundColor = .sky
        ToastView.appearance().bottomOffsetPortrait = CGFloat(90)
    }
}
