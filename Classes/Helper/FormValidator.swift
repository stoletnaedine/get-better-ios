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

        let alertService: AppAlert = AlertService()

        switch true {
        case email.isEmpty:
            alertService.showNotificationMessage(
                    title: R.string.localizable.error(),
                    desc: R.string.localizable.emailIsEmpty(),
                    textColor: .white,
                    imageName: nil
            )
            return false
        case !email.contains("@"):
            alertService.showNotificationMessage(
                    title: R.string.localizable.error(),
                    desc: R.string.localizable.emailIsNotValid(),
                    textColor: .white,
                    imageName: nil
            )
            return false
        case password.isEmpty:
            alertService.showNotificationMessage(
                    title: R.string.localizable.error(),
                    desc: R.string.localizable.passwordIsEmpty(),
                    textColor: .white,
                    imageName: nil
            )
            return false
        default:
            return true
        }
    }
}
