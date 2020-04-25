//
//  StorageService.swift
//  GetBetter
//
//  Created by Исламгулова Лариса on 25.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class StorageService {
    
    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let ref = Storage.storage().reference()
            .child(Properties.Profile.avatarsDirectory)
            .child(currentUserId)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = photo.jpegData(compressionQuality: 0.1) else { return }
        
//        guard let imageData = avatarImageView.image?.jpegData(compressionQuality: 0.1) else {
//            return
//        }
        
        ref.putData(imageData, metadata: metadata, completion: { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            })
        })
    }
}
