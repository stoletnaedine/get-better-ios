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
    
    static func saveCredentials(email: String, password: String) -> Bool {
        return KeychainWrapper.standard.set(email, forKey: Properties.Keychain.emailKey)
            && KeychainWrapper.standard.set(password, forKey: Properties.Keychain.passwordKey)
    }
    
    static func getUserEmail() -> String? {
        return KeychainWrapper.standard.string(forKey: Properties.Keychain.emailKey)
    }
    
    static func getUserPassword() -> String? {
        return KeychainWrapper.standard.string(forKey: Properties.Keychain.passwordKey)
    }
    
    static func deleteCredentials() {
        KeychainWrapper.standard.removeObject(forKey: Properties.Keychain.emailKey)
        KeychainWrapper.standard.removeObject(forKey: Properties.Keychain.passwordKey)
    }
}
