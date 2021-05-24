//
//  FormValidator.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class FormValidator {

    static func isFormValid(email: String, password: String) -> Bool {

        let alertService: AlertServiceProtocol = AlertService()

        switch true {
        case email.isEmpty:
            alertService.showErrorMessage(R.string.localizable.emailIsEmpty())
            return false
        case !email.contains("@"):
            alertService.showErrorMessage(R.string.localizable.emailIsNotValid())
            return false
        case password.isEmpty:
            alertService.showErrorMessage(R.string.localizable.passwordIsEmpty())
            return false
        default:
            return true
        }
    }
}
