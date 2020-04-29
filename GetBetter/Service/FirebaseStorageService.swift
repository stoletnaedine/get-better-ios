//
//  StorageService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class FirebaseStorageService {
    
    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void) {
        
        let ref = Storage.storage().reference()
            .child(Constants.Profile.avatarsDirectory)
            .child(currentUserId)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = photo.jpegData(compressionQuality: 0.1) else { return }
        
        ref.putData(imageData, metadata: metadata, completion: { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(AppError(error: error)!))
                return
            }
            ref.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(AppError(error: error)!))
                    return
                }
                completion(.success(url))
            })
        })
    }
}
