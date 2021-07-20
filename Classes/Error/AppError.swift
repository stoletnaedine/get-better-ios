//
//  HelpError.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 02.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import Firebase

class AppError: Error {
    
    var name: String?
    var code: AppErrorCode?
    
    init?(error: Error?) {
        if let error = error {
            self.name = error.localizedDescription
        } else {
            return nil
        }
    }
    
    init(errorCode: AppErrorCode) {
        self.code = errorCode
        switch errorCode {
        case .noInternet:
            self.name = R.string.localizable.errorNoInternet()
        case .notFound:
            self.name = R.string.localizable.errorNotFound()
        case .serverError:
            self.name = R.string.localizable.errorServerError()
        case .unexpected:
            self.name = R.string.localizable.errorUnexpected()
        }
    }
    
    init(firebaseError: Error) {
        if let errorCode = AuthErrorCode(rawValue: firebaseError._code) {
            switch errorCode {
            case .emailAlreadyInUse:
                self.name = R.string.localizable.errorEmailAlreadyInUse()
            case .wrongPassword:
                self.name = R.string.localizable.errorWrongPassword()
            case .weakPassword:
                self.name = R.string.localizable.errorWeakPassword()
            case .invalidEmail:
                self.name = R.string.localizable.errorInvalidEmail()
            case .tooManyRequests:
                self.name = R.string.localizable.errorTooManyRequests()
            case .userNotFound:
                self.name = R.string.localizable.errorUserNotFound()
            case .networkError:
                self.name = R.string.localizable.errorNetworkError()
            case .requiresRecentLogin:
                self.name = R.string.localizable.errorRequiresRecentLogin()
            default:
                self.name = firebaseError.localizedDescription
            }
        }
    }
}

enum AppErrorCode {
    case noInternet
    case serverError
    case notFound
    case unexpected
}
