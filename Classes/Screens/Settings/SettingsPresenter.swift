////
////  SettingsViewModel.swift
////  GetBetter
////
////  Created by Artur Islamgulov on 22.05.2020.
////  Copyright © 2020 Artur Islamgulov. All rights reserved.
////
//
//import UIKit
//import FirebaseMessaging
//
//protocol SettingsPresenter {
//    func createPushNotifyCell(topic: NotificationTopic) -> NotificationTableViewCell
//    func
//}
//
//class SettingsPresenterDefault: SettingsPresenter {
//    
//    let database: GBDatabase = FirebaseDatabase()
//    let alertService: AlertService = AlertServiceDefault()
//    
//    var isDailySubscribe: Bool?
//    var isTipSubscribe: Bool?
//    
//    func createPushNotifyCell(topic: NotificationTopic) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.selectionStyle = .none
//        
//        var title: String
//        switch topic {
//        case .daily:
//            title = R.string.localizable.settingsPushDaily()
//        case .tipOfTheDay:
//            title = R.string.localizable.settingsPushTip()
//        }
//        cell.textLabel?.text = title
//        
//        let screenWidth = UIScreen.main.bounds.width
//        let switchWidth: CGFloat = 49
//        let switchHeight: CGFloat = 31
//        let switcher = UISwitch(frame: CGRect(x: screenWidth - switchWidth - 10, y: 6,
//                                              width: switchWidth, height: switchHeight))
//        
//        database.getNotificationSettings { [weak self] settings in
//            guard let self = self else { return }
//            var isLocalSubscribe: Bool
//            
//            if let isSubscribe = isSubscribe {
//                isLocalSubscribe = isSubscribe
//                switcher.setOn(isSubscribe, animated: true)
//            } else {
//                let isSubscribe = false
//                isLocalSubscribe = isSubscribe
//                self.database.saveNotification(_ notification: topic, subscribe: isSubscribe)
//                switcher.setOn(isSubscribe, animated: true)
//            }
//            
//            switch topic {
//            case .daily:
//                self.isDailySubscribe = isLocalSubscribe
//            case .tipOfTheDay:
//                self.isTipSubscribe = isLocalSubscribe
//            }
//        }
//        
//        switch topic {
//        case .daily:
//            switcher.addTarget(self, action: #selector(changeSubscribeDaily), for: .valueChanged)
//        case .tipOfTheDay:
//            switcher.addTarget(self, action: #selector(changeSubscribeTip), for: .valueChanged)
//        }
//        
//        cell.addSubview(switcher)
//        
//        return cell
//    }
//    
//    @objc private func changeSubscribeDaily() {
//        guard let isDailySubscribe = self.isDailySubscribe else { return }
//        
//        if isDailySubscribe {
//            Messaging.messaging()
//                .unsubscribe(fromTopic: NotificationTopic.daily.rawValue) { [weak self] error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    AlertServiceDefault().showErrorMessage(desc: error.localizedDescription)
//                } else {
//                    self.database.saveNotification(_ notification: .daily, subscribe: false)
//                    self.isDailySubscribe = false
//                    self.alertService.showSuccessMessage(
//                        desc: R.string.localizable.settingsNotificationUnsubscribe()
//                    )
//                }
//            }
//        } else {
//            Messaging.messaging()
//                .subscribe(toTopic: NotificationTopic.daily.rawValue) { [weak self] error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    AlertServiceDefault().showErrorMessage(desc: error.localizedDescription)
//                } else {
//                    self.database.saveNotification(_ notification: .daily, subscribe: true)
//                    self.isDailySubscribe = true
//                    self.alertService.showSuccessMessage(
//                        desc: R.string.localizable.settingsNotificationSubscribe()
//                    )
//                }
//            }
//        }
//    }
//    
//    @objc private func changeSubscribeTip() {
//        guard let isTipSubscribe = self.isTipSubscribe else { return }
//        
//        if isTipSubscribe {
//            Messaging.messaging()
//                .unsubscribe(fromTopic: NotificationTopic.tipOfTheDay.rawValue) { [weak self] error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    AlertServiceDefault().showErrorMessage(desc: error.localizedDescription)
//                } else {
//                    self.database.saveNotification(_ notification: .tipOfTheDay, subscribe: false)
//                    self.isTipSubscribe = false
//                    self.alertService.showSuccessMessage(
//                        desc: R.string.localizable.settingsNotificationUnsubscribe()
//                    )
//                }
//            }
//        } else {
//            Messaging.messaging()
//                .subscribe(toTopic: NotificationTopic.tipOfTheDay.rawValue) { [weak self] error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    AlertServiceDefault().showErrorMessage(desc: error.localizedDescription)
//                } else {
//                    self.database.saveNotification(_ notification: .tipOfTheDay, subscribe: true)
//                    self.isTipSubscribe = true
//                    self.alertService.showSuccessMessage(
//                        desc: R.string.localizable.settingsNotificationSubscribe()
//                    )
//                }
//            }
//        }
//    }
//}
