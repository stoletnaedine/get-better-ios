//
//  UserSettingsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserSettingsServiceProtocol {
    var tutorialHasShown: Bool { get set }
//    var lifeCircleTutorialHasShown: Bool { get set }
    var tipOfTheDayHasShown: Bool { get set }
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
            static let draft = "draft"
            static let tipPush = "tipPush"
            static let postPush = "postPush"
            static let difficultyLevel = "difficultyLevel"
            static let tutorialHasShown = "tutorialHasShown"
            static let lifeCircleTutorialHasShown = "lifeCircleTutorialHasShown"
            static let tipOfTheDayHasShown = "tipOfTheDayHasShown"
        }
    }

    var tutorialHasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: userIdKey(with: Constants.Key.tutorialHasShown))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey(with: Constants.Key.tutorialHasShown))
        }
    }

//    var lifeCircleTutorialHasShown: Bool {
//        get {
//            return UserDefaults.standard.bool(forKey: userIdKey(with: Constants.Key.lifeCircleTutorialHasShown))
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: userIdKey(with: Constants.Key.lifeCircleTutorialHasShown))
//        }
//    }

    var tipOfTheDayHasShown: Bool {
        get {
            return UserDefaults.standard.value(forKey: userIdKey(with: Constants.Key.tipOfTheDayHasShown)) as? Int == self.days
        }
        set {
            let value = newValue ? self.days : -1
            UserDefaults.standard.set(value, forKey: userIdKey(with: Constants.Key.tipOfTheDayHasShown))
        }
    }
    
    func saveDraft(text: String) {
        UserDefaults.standard.setValue(text, forKey: userIdKey(with: Constants.Key.draft))
    }
    
    func getDraft() -> String {
        return UserDefaults.standard.value(forKey: userIdKey(with: Constants.Key.draft)) as? String ?? ""
    }
    
    func clearDraft() {
        UserDefaults.standard.setValue(nil, forKey: userIdKey(with: Constants.Key.draft))
    }
    
    func getNotificationSettings() -> NotificationSettings {
        // Миграция для ранних пользователей
        if let oldTipRawValue = UserDefaults.standard.value(forKey: Constants.Key.tipPush) as? String,
            let oldPostRawValue = UserDefaults.standard.value(forKey: Constants.Key.postPush) as? String {
            let oldTipTopic = TipTopic(oldTipRawValue)
            let oldPostTopic = PostTopic(oldPostRawValue)
            let oldSettings = NotificationSettings(tip: oldTipTopic, post: oldPostTopic)
            self.saveNotificationSettings(oldSettings)
            UserDefaults.standard.removeObject(forKey: Constants.Key.tipPush)
            UserDefaults.standard.removeObject(forKey: Constants.Key.postPush)
            return oldSettings
        }

        let tipRawValue = UserDefaults.standard.value(forKey: userIdKey(with: Constants.Key.tipPush)) as? String ?? ""
        let tipTopic = TipTopic(tipRawValue)
        let postRawValue = UserDefaults.standard.value(forKey: userIdKey(with: Constants.Key.postPush)) as? String ?? ""
        let postTopic = PostTopic(postRawValue)

        return NotificationSettings(tip: tipTopic, post: postTopic)
    }
    
    func saveNotificationSettings(_ settings: NotificationSettings) {
        UserDefaults.standard.setValue(settings.tip.rawValue, forKey: userIdKey(with: Constants.Key.tipPush))
        UserDefaults.standard.setValue(settings.post.rawValue, forKey: userIdKey(with: Constants.Key.postPush))
    }
    
    func getDifficultyLevel() -> DifficultyLevel {
        // Миграция для ранних пользователей
        if let oldLevelRawValue = UserDefaults.standard.value(forKey: Constants.Key.difficultyLevel) as? String,
           let level = DifficultyLevel(rawValue: oldLevelRawValue) {
            self.setDifficultyLevel(level)
            UserDefaults.standard.removeObject(forKey: Constants.Key.difficultyLevel)
            return level
        }

        let levelRawValue = UserDefaults.standard.value(forKey: userIdKey(with: Constants.Key.difficultyLevel)) as? String ?? ""
        return DifficultyLevel(rawValue: levelRawValue) ?? .easy
    }
    
    func setDifficultyLevel(_ level: DifficultyLevel) {
        UserDefaults.standard.setValue(level.rawValue, forKey: userIdKey(with: Constants.Key.difficultyLevel))
    }

    // MARK: — Private methods

    private func userIdKey(with key: String) -> String {
        return "\(Auth.auth().currentUser?.uid ?? "")_\(key)"
    }
    
}
