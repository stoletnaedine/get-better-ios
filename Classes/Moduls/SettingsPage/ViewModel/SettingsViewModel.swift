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
            var email = "Email не указан"
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
}
