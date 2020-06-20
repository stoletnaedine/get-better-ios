//
//  SettingsViewModel.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import Firebase

class SettingsViewModel {
    
    func loadProfileInfo(completion: @escaping (_ profile: Profile) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        DispatchQueue.global().async {
            var name = R.string.localizable.settingsDefaultName()
            var email = R.string.localizable.settingsDefaultEmail()
            var avatar: UIImage?
            
            if let userName = user.displayName {
                name = userName
            }
            if let userEmail = user.email {
                email = userEmail
            }
            if let photoURL = user.photoURL,
                let imageData = try? Data(contentsOf: photoURL),
                let loadedAvatar = UIImage(data: imageData) {
                avatar = loadedAvatar
            }
            DispatchQueue.main.async {
                completion(Profile(avatar: avatar, name: name, email: email))
            }
        }
    }
    
    func fillArticles() -> [SettingsCell] {
        
        let aboutCircleViewController = ArticleViewController()
        aboutCircleViewController.article = Article(title: R.string.localizable.aboutCircleTitle(),
                                                    titleView: nil,
                                                    text: R.string.localizable.aboutCircleDescription(),
                                                    image: R.image.aboutCircle())
        
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
        
        return [SettingsCell(title: R.string.localizable.aboutCircleTableTitle(), viewController: aboutCircleViewController),
                SettingsCell(title: R.string.localizable.aboutJournalTableTitle(), viewController: aboutJournalViewController),
                SettingsCell(title: R.string.localizable.aboutAppTableTitle(), viewController: aboutAppViewController)]
    }
}