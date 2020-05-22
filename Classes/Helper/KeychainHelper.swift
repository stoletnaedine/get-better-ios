//
//  KeychainHelper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 17.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainHelper {
    
    static func saveCredentials(email: String) -> Bool {
        return KeychainWrapper.standard.set(email, forKey: Constants.Keychain.emailKey)
    }
    
    static func getUserEmail() -> String? {
        return KeychainWrapper.standard.string(forKey: Constants.Keychain.emailKey)
    }
    
    static func deleteCredentials() {
        KeychainWrapper.standard.removeObject(forKey: Constants.Keychain.emailKey)
    }
}
