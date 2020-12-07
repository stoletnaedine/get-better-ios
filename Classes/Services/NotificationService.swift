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
    func configure(cell: NotificationCell, by item: SettingsCell)
}

class NotificationServiceDefault: NotificationService {

    private let database: GBDatabase = FirebaseDatabase()
    private let alertService: AlertService = AlertServiceDefault()
    private var settings: NotificationSettings?

    func configure(cell: NotificationCell, by item: SettingsCell) {
        cell.configure(
            model: NotificationCellViewModel(
                title: item.title,
                description: item.subTitle
            )
        )
        
        database.getNotificationSettings { [weak self] settings in
            guard let self = self,
                  let topic = item.topic else { return }
            self.settings = settings
            
            switch topic {
            case .tipOfTheDay:
                cell.setSwitchOn(settings.tipOfTheDay)
                cell.switchClosure = { isOn in
                    self.set(subscribe: isOn, topic: topic)
                }
            case .daily:
                cell.setSwitchOn(settings.daily)
                cell.switchClosure = { isOn in
                    self.set(subscribe: isOn, topic: topic)
                }
            }
        }
    }
    
    private func set(subscribe: Bool, topic: NotificationTopic) {
        guard var newSettings = self.settings else { return }
        if subscribe {
            Messaging.messaging()
                .subscribe(toTopic: topic.rawValue) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.alertService.showErrorMessage(desc: error.localizedDescription)
                } else {
                    switch topic {
                    case .daily:
                        newSettings.daily.toggle()
                    case .tipOfTheDay:
                        newSettings.tipOfTheDay.toggle()
                    }
                    self.settings = newSettings
                    self.database.saveNotificationSettings(newSettings)
                    self.alertService.showSuccessMessage(
                        desc: R.string.localizable.settingsNotificationSubscribe()
                    )
                }
            }
        } else {
            Messaging.messaging()
                .unsubscribe(fromTopic: topic.rawValue) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.alertService.showErrorMessage(desc: error.localizedDescription)
                } else {
                    switch topic {
                    case .daily:
                        newSettings.daily.toggle()
                    case .tipOfTheDay:
                        newSettings.tipOfTheDay.toggle()
                    }
                    self.settings = newSettings
                    self.database.saveNotificationSettings(newSettings)
                    self.alertService.showSuccessMessage(
                        desc: R.string.localizable.settingsNotificationUnsubscribe()
                    )
                }
            }
        }
    }
}
