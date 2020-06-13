//
//  AppDelegate.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04/02/2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let rootManager = RootManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Auth.auth().languageCode = "ru"
        IQKeyboardManager.shared.enable = true
        rootManager.start()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
    }
}
