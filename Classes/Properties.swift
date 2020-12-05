//
//  Properties.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

enum Properties {
    
    enum Keychain {
        static let emailKey = "com.stoletnaedine.GetBetter.UserEmail"
    }
    
    enum UserDefaults {
        static let tutorialHasShowed = "tutorialHasShowed"
    }
    
    static let notValidSphereValue = -1.0
    static let appVersion = "1.8.3"
    static let appStoreUrl = URL(string: "https://apps.apple.com/us/app/getbetter/id1522666671?uo=4")!
    static let maxSphereValue: Double = 10.0
}
