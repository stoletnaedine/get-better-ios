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
    
    @discardableResult
    static func saveUserEmail(_ email: String) -> Bool {
        return KeychainWrapper.standard.set(email, forKey: GlobalDefinitions.Keychain.emailKey)
    }
    
    static func getUserEmail() -> String? {
        return KeychainWrapper.standard.string(forKey: GlobalDefinitions.Keychain.emailKey)
    }
    
    static func deleteCredentials() {
        KeychainWrapper.standard.removeObject(forKey: GlobalDefinitions.Keychain.emailKey)
    }
}
