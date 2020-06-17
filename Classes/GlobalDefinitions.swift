//
//  Properties.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct GlobalDefinitions {
    
    struct Keychain {
        static let emailKey = "com.stoletnaedine.GetBetter.UserEmail"
        static let isShowedTutorialKey = "com.stoletnaedine.GetBetter.isShowedTutorialKey"
    }
    
    struct SphereMetrics {
        static let start = "start_sphere_level"
        static let current = "current_sphere_level"
    }
    
    static let notValidSphereValue = -1.0
    
    static let appVersion = 0.5
}
