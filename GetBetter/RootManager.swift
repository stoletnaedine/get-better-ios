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
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBarController), name: .showTabBarController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPageViewController), name: .showPageViewController, object: nil)
        
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
        showAuthController()
    }
    
    @objc func showTabBarController() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
    }
    
    @objc func showPageViewController() {
        window?.rootViewController = UINavigationController(rootViewController: PageViewController())
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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 21) as Any]
    }
    
    func configToaster() {
        ToastView.appearance().backgroundColor = .sky
        ToastView.appearance().font = UIFont(name: Constants.Font.SFUITextRegular, size: 14)
        let screenHeight = UIScreen.main.bounds.height
        ToastView.appearance().bottomOffsetPortrait = CGFloat(screenHeight / 2)
    }
}
