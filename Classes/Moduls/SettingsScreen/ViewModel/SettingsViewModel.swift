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
            var name = "Анонимный пользователь"
            var email = "E-mail не указан"
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
        aboutCircleViewController.article = Article(title: GlobalDefiitions.AboutCircle.title,
                                                    titleView: nil,
                                                    text: GlobalDefiitions.AboutCircle.description,
                                                    image: R.image.aboutCircle())
        
        let aboutJournalViewController = ArticleViewController()
        aboutJournalViewController.article = Article(title: GlobalDefiitions.AboutJournal.title,
                                                     titleView: nil,
                                                     text: GlobalDefiitions.AboutJournal.description,
                                                     image: R.image.aboutEvents())
        
        let aboutAppViewController = ArticleViewController()
        aboutAppViewController.article = Article(title: GlobalDefiitions.AboutApp.title,
                                                 titleView: UIImageView(image: R.image.titleViewLogo()),
                                                 text: GlobalDefiitions.AboutApp.description,
                                                 image: R.image.aboutTeam())
        
        return [SettingsCell(title: "Колесо жизненного баланса", viewController: aboutCircleViewController),
                SettingsCell(title: "Правила игры (зачем нужен дневник)", viewController: aboutJournalViewController),
                SettingsCell(title: "О приложении", viewController: aboutAppViewController)]
    }
}
