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
            Toast(text: Properties.RegisterValidate.emailIsEmpty).show()
            return false
        case !email.contains("@"):
            Toast(text: Properties.RegisterValidate.emailIsNotValid).show()
            return false
        case password.isEmpty:
            Toast(text: Properties.RegisterValidate.passwordIsEmpty).show()
            return false
        default:
            return true
        }
    }
    
    static func isFormValid(email: String, password1: String, password2: String) -> Bool {
        
        switch true {
        case email.isEmpty:
            Toast(text: Properties.RegisterValidate.emailIsEmpty).show()
            return false
        case !email.contains("@"):
            Toast(text: Properties.RegisterValidate.emailIsNotValid).show()
            return false
        case password1.isEmpty || password2.isEmpty:
            Toast(text: Properties.RegisterValidate.passwordIsEmpty).show()
            return false
        case password1 != password2:
            Toast(text: Properties.RegisterValidate.passwordsNotEquals).show()
            return false
        default:
            return true
        }
    }
}
