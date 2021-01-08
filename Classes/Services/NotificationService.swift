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
    
    func subscribe(to settings: NotificationSettings) {
        // TODO: удалить когда все перейдут на версию 1.11
        Messaging.messaging().unsubscribe(fromTopic: "tipOfTheDay")
        Messaging.messaging().unsubscribe(fromTopic: "daily")
        
        TipTopic.allCases.forEach({ topic in
            Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
        })
        if settings.tip != .none {
            Messaging.messaging().subscribe(toTopic: settings.tip.rawValue) { [weak self] error in
                if let error = error {
                    self?.alertService.showErrorMessage(desc: error.localizedDescription)
                    return
                }
            }
        }
            
        PostTopic.allCases.forEach({ topic in
            Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
        })
        if settings.post != .none {
            Messaging.messaging().subscribe(toTopic: settings.post.rawValue) { [weak self] error in
                if let error = error {
                    self?.alertService.showErrorMessage(desc: error.localizedDescription)
                    return
                }
            }
        }
        
        self.alertService.showSuccessMessage(
            desc: R.string.localizable.settingsPushSaved()
        )
    }
}
