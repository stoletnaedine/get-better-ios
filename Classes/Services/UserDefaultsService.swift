//
//  UserDefaultsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol UserDefaultsService {
    func tipOfTheDayShown()
    func setTipOfTheDayNotShown()
    func isTipOfTheDayShown() -> Bool
    func saveDraft(text: String)
    func getDraft() -> String
    func clearDraft()
}

class UserDefaultsServiceImpl: UserDefaultsService {
    
    var days: Int = {
        Date().diffInDaysSince1970()
    }()
    
    private enum Constants {
        enum Key {
            static let tipOfTheDay = "tipOfTheDay"
            static let draft = "draft"
        }
    }
    
    func tipOfTheDayShown() {
        UserDefaults.standard.set(days, forKey: Constants.Key.tipOfTheDay)
    }
    
    func setTipOfTheDayNotShown() {
        UserDefaults.standard.set(-1, forKey: Constants.Key.tipOfTheDay)
    }
    
    func isTipOfTheDayShown() -> Bool {
        return UserDefaults.standard.value(forKey: Constants.Key.tipOfTheDay) as? Int == days
    }
    
    func saveDraft(text: String) {
        UserDefaults.standard.setValue(text, forKey: Constants.Key.draft)
    }
    
    func getDraft() -> String {
        guard let text = UserDefaults.standard.value(forKey: Constants.Key.draft) as? String else { return "" }
        return text
    }
    
    func clearDraft() {
        UserDefaults.standard.setValue("", forKey: Constants.Key.draft)
    }
}
