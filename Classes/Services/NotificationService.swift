//
//  SettingsViewModel.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import FirebaseMessaging

protocol NotificationService {
    func subscribe(to settings: NotificationSettings)
}

class NotificationServiceDefault: NotificationService {

    private let alertService: AlertService = AlertServiceDefault()
    private var settings: NotificationSettings?
    
    func subscribe(to settings: NotificationSettings) {
        // TODO: удалить когда все перейдут на версию 1.11
        Messaging.messaging().unsubscribe(fromTopic: "tipOfTheDay")
        Messaging.messaging().unsubscribe(fromTopic: "daily")
        
        PostTopic.allCases.forEach({ topic in
            Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
        })
        Messaging.messaging().subscribe(toTopic: settings.post.rawValue) { [weak self] error in
            if let error = error {
                self?.alertService.showErrorMessage(desc: error.localizedDescription)
                return
            }
        }
        
        TipTopic.allCases.forEach({ topic in
            Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
        })
        Messaging.messaging().subscribe(toTopic: settings.tip.rawValue) { [weak self] error in
            if let error = error {
                self?.alertService.showErrorMessage(desc: error.localizedDescription)
                return
            }
        }
        
        self.alertService.showSuccessMessage(
            desc: R.string.localizable.settingsPushSaved()
        )
    }
}
