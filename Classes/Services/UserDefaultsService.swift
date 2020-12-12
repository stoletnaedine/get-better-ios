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
}

class UserDefaultsServiceDefault: UserDefaultsService {
    
    let days = Date().diffInDaysSince1970()
    
    private enum Constants {
        static let tipOfTheDay = "tipOfTheDay"
    }
    
    func tipOfTheDayShown() {
        UserDefaults.standard.set(days, forKey: Constants.tipOfTheDay)
    }
    
    func setTipOfTheDayNotShown() {
        UserDefaults.standard.set(-1, forKey: Constants.tipOfTheDay)
    }
    
    func isTipOfTheDayShown() -> Bool {
        return UserDefaults.standard.value(forKey: Constants.tipOfTheDay) as? Int == days
    }
}
