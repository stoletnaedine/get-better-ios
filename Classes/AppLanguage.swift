//
//  AppLanguage.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.05.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import Foundation

enum AppLanguage: String {
    case english = "en"
    case russian = "ru"

    init(languageCode: String) {
        switch languageCode {
        case AppLanguage.russian.rawValue:
            self = .russian
        default:
            self = .english
        }
    }
}
