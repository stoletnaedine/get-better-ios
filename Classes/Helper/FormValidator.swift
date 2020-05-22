//
//  FormValidator.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import Toaster

class FormValidator {
    
    static func isFormValid(email: String, password: String) -> Bool {
        
        switch true {
        case email.isEmpty:
            Toast(text: Constants.RegisterValidate.emailIsEmpty).show()
            return false
        case !email.contains("@"):
            Toast(text: Constants.RegisterValidate.emailIsNotValid).show()
            return false
        case password.isEmpty:
            Toast(text: Constants.RegisterValidate.passwordIsEmpty).show()
            return false
        default:
            return true
        }
    }
}
