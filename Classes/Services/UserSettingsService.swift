//
//  UserSettingsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol UserSettingsServiceProtocol {
    func tipOfTheDayShown()
    func setTipOfTheDayNotShown()
    func isTipOfTheDayShown() -> Bool
    func saveDraft(text: String)
    func getDraft() -> String
    func clearDraft()
    func getNotificationSettings() -> NotificationSettings
    func saveNotificationSettings(_ settings: NotificationSettings)
    func getDifficultyLevel() -> DifficultyLevel
    func setDifficultyLevel(_ level: DifficultyLevel)
}

class UserSettingsService: UserSettingsServiceProtocol {
    
    private var days: Int = {
        Date().diffInDaysSince1970()
    }()
    
    private enum Constants {
        enum Key {
            static let tipOfTheDayShown = "tipOfTheDayShown"
            static let draft = "draft"
            static let tipPush = "tipPush"
            static let postPush = "postPush"
            static let difficultyLevel = "difficultyLevel"
        }
    }
    
    func tipOfTheDayShown() {
        UserDefaults.standard.set(days, forKey: Constants.Key.tipOfTheDayShown)
    }
    
    func setTipOfTheDayNotShown() {
        UserDefaults.standard.set(-1, forKey: Constants.Key.tipOfTheDayShown)
    }
    
    func isTipOfTheDayShown() -> Bool {
        return UserDefaults.standard.value(forKey: Constants.Key.tipOfTheDayShown) as? Int == days
    }
    
    func saveDraft(text: String) {
        UserDefaults.standard.setValue(text, forKey: Constants.Key.draft)
    }
    
    func getDraft() -> String {
        guard let text = UserDefaults.standard.value(forKey: Constants.Key.draft) as? String else { return "" }
        return text
    }
    
    func clearDraft() {
        UserDefaults.standard.setValue(nil, forKey: Constants.Key.draft)
    }
    
    func getNotificationSettings() -> NotificationSettings {
        let tipRawValue = UserDefaults.standard.value(forKey: Constants.Key.tipPush) as? String ?? ""
        let tipTopic = TipTopic(tipRawValue)
        
        let postRawValue = UserDefaults.standard.value(forKey: Constants.Key.postPush) as? String ?? ""
        let postTopic = PostTopic(postRawValue)
        
        return NotificationSettings(tip: tipTopic, post: postTopic)
    }
    
    func saveNotificationSettings(_ settings: NotificationSettings) {
        UserDefaults.standard.setValue(settings.tip.rawValue, forKey: Constants.Key.tipPush)
        UserDefaults.standard.setValue(settings.post.rawValue, forKey: Constants.Key.postPush)
    }
    
    func getDifficultyLevel() -> DifficultyLevel {
        let levelRawValue = UserDefaults.standard.value(forKey: Constants.Key.difficultyLevel) as? String ?? ""
        return DifficultyLevel(rawValue: levelRawValue) ?? .easy
    }
    
    func setDifficultyLevel(_ level: DifficultyLevel) {
        UserDefaults.standard.setValue(level.rawValue, forKey: Constants.Key.difficultyLevel)
    }
    
}
