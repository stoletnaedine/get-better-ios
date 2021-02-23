//
//  UserSettingsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol UserSettingsServiceProtocol {
    func tutorialHasShown(_ shown: Bool)
    func isTutorialHasShown() -> Bool
    func lifeCircleTutorialHasShown(_ shown: Bool)
    func isLifeCircleTutorialHasShown() -> Bool
    func tipOfTheDayHasShown(_ shown: Bool)
    func isTipOfTheDayHasShown() -> Bool
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
            static let tutorialHasShowed = "tutorialHasShowed"
            static let lifeCircleTutorialHasShowed = "lifeCircleTutorialHasShowed"
        }
    }

    func tutorialHasShown(_ shown: Bool) {
        UserDefaults.standard.set(shown, forKey: Constants.Key.tutorialHasShowed)
    }

    func isTutorialHasShown() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.Key.tutorialHasShowed)
    }

    func lifeCircleTutorialHasShown(_ shown: Bool) {
        UserDefaults.standard.set(shown, forKey: Constants.Key.lifeCircleTutorialHasShowed)
    }

    func isLifeCircleTutorialHasShown() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.Key.lifeCircleTutorialHasShowed)
    }

    func tipOfTheDayHasShown(_ shown: Bool) {
        let value = shown ? self.days : -1
        UserDefaults.standard.set(value, forKey: Constants.Key.tipOfTheDayShown)
    }
    
    func isTipOfTheDayHasShown() -> Bool {
        return UserDefaults.standard.value(forKey: Constants.Key.tipOfTheDayShown) as? Int == self.days
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
