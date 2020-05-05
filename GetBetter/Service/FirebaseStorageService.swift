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
import FirebaseAuth

class FirebaseStorageService {
    
    let metadata = StorageMetadata()
    let contentType = "image/jpeg"
    let avatarsPath = "avatars"
    let picsPath = "pics"
    let uuidString: String = UUID().uuidString
    let photoQuality: CGFloat = 0.1
    
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Storage.storage().reference()
            .child(avatarsPath)
            .child(userId)
        
        metadata.contentType = contentType
        
        guard let imageData = photo.jpegData(compressionQuality: photoQuality) else { return }
        
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
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Storage.storage().reference()
            .child(picsPath)
            .child(userId)
            .child(uuidString)
        
        metadata.contentType = contentType
        
        guard let imageData = photo.jpegData(compressionQuality: photoQuality) else { return }
        
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
