//
//  StorageService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class FirebaseStorageService {
    
    let metadata = StorageMetadata()
    let contentType = "image/jpeg"
    let avatarsPath = "avatars"
    let picsPath = "photos"
    let uuidString: String = UUID().uuidString
    let photoQuality: CGFloat = 0.5
    let resizeWidthPhoto: CGFloat = 750
    let resizeWidthAvatar: CGFloat = 300
    
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Storage.storage().reference()
            .child(avatarsPath)
            .child(userId)
        
        metadata.contentType = contentType
        
        guard let resizeImage = photo.resized(toWidth: resizeWidthAvatar) else { return }
        guard let imageData = resizeImage.jpegData(compressionQuality: photoQuality) else { return }
        
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
    
    func upload(photo: UIImage, completion: @escaping (Result<Photo, AppError>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Storage.storage().reference()
            .child(picsPath)
            .child(userId)
            .child(uuidString)
        
        metadata.contentType = contentType
        
        guard let resizeImage = photo.resized(toWidth: resizeWidthPhoto) else { return }
        guard let imageData = resizeImage.jpegData(compressionQuality: photoQuality) else { return }
        
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
                let name = ref.name
                let urlString = "\(url)"
                completion(.success(Photo(name: name, url: urlString)))
            })
        })
    }
    
    func delete(photoName: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let photoRef = Storage.storage().reference()
            .child(picsPath)
            .child(userId)
            .child(photoName)
            
        photoRef.delete { error in
                if let error = error {
                    print("Error delete file = \(photoName): \(error.localizedDescription)")
                } else {
                    print("File = \(photoName) successfully deleted")
                }
        }
    }
}
