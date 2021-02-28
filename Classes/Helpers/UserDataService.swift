//
//  UserDataService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 17.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import SwiftKeychainWrapper

protocol UserDataServiceProtocol {
    var email: String? { get set }
    func deleteCredentials()
}

class UserDataService: UserDataServiceProtocol {

    var email: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.email)
        }
        set {
            guard let email = newValue else { return }
            let result = KeychainWrapper.standard.set(email, forKey: Keys.email)
            print(result)
        }
    }

    func deleteCredentials() {
        KeychainWrapper.standard.removeObject(forKey: Keys.email)
    }
}

// MARK: — Keys

extension UserDataService {
    private enum Keys {
        static let email = "com.stoletnaedine.GetBetter.UserEmail"
    }
}
