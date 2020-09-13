//
//  SettingsViewModel.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

protocol SettingsPresenter {
    func loadProfileInfo(completion: @escaping (_ profile: Profile) -> Void)
    func fillArticles() -> [CommonSettingsCell]
    func createAppHistoryVersions() -> UIViewController
    func createDailyPushNotificationsCell() -> UITableViewCell
}

class SettingsPresenterDefault: SettingsPresenter {
    
    let databaseService: DatabaseService = FirebaseDatabaseService()
    let alertService: AlertService = AlertServiceDefault()
    var isDailySubscribe: Bool?
    
    struct Constansts {
        static let userDefaultsDailyKey = "dailyNotifications"
    }
    
    func loadProfileInfo(completion: @escaping (_ profile: Profile) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        DispatchQueue.global().async {
            var name = R.string.localizable.settingsDefaultName()
            var email = R.string.localizable.settingsDefaultEmail()
            var avatarURL: URL?
            
            if let userName = user.displayName {
                name = userName
            }
            if let userEmail = user.email {
                email = userEmail
            }
            if let userAvatarURL = user.photoURL {
                avatarURL = userAvatarURL
            }
            DispatchQueue.main.async {
                completion(Profile(avatarURL: avatarURL,
                                   name: name,
                                   email: email)
                )
            }
        }
    }
    
    func fillArticles() -> [CommonSettingsCell] {
        let aboutCircleViewController = ArticleViewController()
        aboutCircleViewController.article = Article(title: R.string.localizable.aboutCircleTitle(),
                                                    titleView: nil,
                                                    text: R.string.localizable.aboutCircleDescription(),
                                                    image: R.image.lifeCircleExample())
        
        let aboutJournalViewController = ArticleViewController()
        aboutJournalViewController.article = Article(title: R.string.localizable.aboutJournalTitle(),
                                                     titleView: nil,
                                                     text: R.string.localizable.aboutJournalDescription(),
                                                     image: R.image.aboutEvents())
        
        let aboutAppViewController = ArticleViewController()
        aboutAppViewController.article = Article(title: R.string.localizable.aboutAppTitle(),
                                                 titleView: UIImageView(image: R.image.titleViewLogo()),
                                                 text: R.string.localizable.aboutAppDescription(),
                                                 image: R.image.aboutTeam())
        
        return [CommonSettingsCell(title: R.string.localizable.aboutCircleTableTitle(),
                                   viewController: aboutCircleViewController),
                CommonSettingsCell(title: R.string.localizable.aboutJournalTableTitle(),
                                   viewController: aboutJournalViewController),
                CommonSettingsCell(title: R.string.localizable.aboutAppTableTitle(),
                                   viewController: aboutAppViewController)]
    }
    
    func createAppHistoryVersions() -> UIViewController {
        let vc = TextViewViewController()
        vc.text = R.string.localizable.appVersions()
        return vc
    }
    
    func createDailyPushNotificationsCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = R.string.localizable.settingsNotificationTitle()
        
        let screenWidth = UIScreen.main.bounds.width
        let switchWidth: CGFloat = 49
        let switchHeight: CGFloat = 31
        let switcher = UISwitch(frame: CGRect(x: screenWidth - switchWidth - 10,
                                              y: 6,
                                              width: switchWidth,
                                              height: switchHeight))
        
        databaseService.getNotificationSettings(topic: .daily, completion: { [weak self] isSubscribe in
            guard let self = self else { return }
            
            if let isSubscribe = isSubscribe {
                self.isDailySubscribe = isSubscribe
                switcher.setOn(isSubscribe, animated: false)
            } else {
                let isSubscribeUserDefaults = UserDefaults.standard.bool(forKey: Constansts.userDefaultsDailyKey)
                self.isDailySubscribe = isSubscribeUserDefaults
                self.databaseService.saveNotificationSetting(topic: .daily, subscribe: isSubscribeUserDefaults)
                switcher.setOn(isSubscribeUserDefaults, animated: false)
            }
        })
        
        switcher.addTarget(self, action: #selector(changeSubscribeDailyTopic), for: .valueChanged)
        cell.addSubview(switcher)
        
        return cell
    }
    
    @objc private func changeSubscribeDailyTopic() {
        guard let isDailySubscribe = self.isDailySubscribe else { return }
        
        if isDailySubscribe {
            Messaging.messaging()
                .unsubscribe(fromTopic: NotificationTopic.daily.rawValue) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    AlertServiceDefault().showErrorMessage(desc: error.localizedDescription)
                } else {
                    self.databaseService.saveNotificationSetting(topic: .daily, subscribe: false)
                    self.isDailySubscribe = false
                    self.alertService.showSuccessMessage(
                        desc: R.string.localizable.settingsNotificationUnsubscribe()
                    )
                }
            }
        } else {
            Messaging.messaging()
                .subscribe(toTopic: NotificationTopic.daily.rawValue) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    AlertServiceDefault().showErrorMessage(desc: error.localizedDescription)
                } else {
                    self.databaseService.saveNotificationSetting(topic: .daily, subscribe: true)
                    self.isDailySubscribe = true
                    self.alertService.showSuccessMessage(
                        desc: R.string.localizable.settingsNotificationSubscribe()
                    )
                }
            }
        }
        
    }
}
