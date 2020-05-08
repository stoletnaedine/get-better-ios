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
    let avatarFileName = "avatar"
    let photosPath = "photos"
    let previewsPath = "previews"
    let usersPath = "users"
    let uuidString: String = UUID().uuidString
    let photoQuality: CGFloat = 0.5
    let resizeWidthPhoto: CGFloat = 750
    let resizeWidthPreview: CGFloat = 200
    let resizeWidthAvatar: CGFloat = 300
    
    func currentUserPath() -> StorageReference? {
        
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        
        return Storage.storage().reference()
            .child(usersPath)
            .child(userId)
    }
    
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void) {
        
        guard let currentUserRef = currentUserPath() else { return }
        guard let resizeImage = photo.resized(toWidth: resizeWidthAvatar) else { return }
        guard let imageData = resizeImage.jpegData(compressionQuality: photoQuality) else { return }
        metadata.contentType = contentType
        
        let avatarRef = currentUserRef.child(avatarFileName)
        
        avatarRef
            .putData(imageData, metadata: metadata, completion: { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(AppError(error: error)!))
                return
            }
            avatarRef.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(AppError(error: error)!))
                    return
                }
                completion(.success(url))
            })
        })
    }
    
    func uploadPhotoAndPreview(photo: UIImage, completion: @escaping (Result<Photo, AppError>) -> Void) {
        
        var photoName: String?
        var photoUrl: String?
        var previewName: String?
        var previewUrl: String?
        
        guard let photoRef = currentUserPath() else { return }
        guard let resizePhoto = photo.resized(toWidth: resizeWidthPhoto) else { return }
        guard let photoData = resizePhoto.jpegData(compressionQuality: photoQuality) else { return }
        metadata.contentType = contentType
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        photoRef
            .child(photosPath)
            .child(uuidString)
            .putData(photoData, metadata: metadata, completion: { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(AppError(error: error)!))
                dispatchGroup.leave()
                return
            }
            photoRef.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(AppError(error: error)!))
                    dispatchGroup.leave()
                    return
                }
                photoUrl = "\(url)"
                photoName = photoRef.name
                dispatchGroup.leave()
            })
        })
        
        guard let previewRef = currentUserPath() else { return }
        guard let resizePreview = photo.resized(toWidth: resizeWidthPreview) else { return }
        guard let previewData = resizePreview.jpegData(compressionQuality: photoQuality) else { return }
        
        dispatchGroup.enter()
        previewRef
            .child(previewsPath)
            .child(uuidString)
            .putData(previewData, metadata: metadata, completion: { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(AppError(error: error)!))
                dispatchGroup.leave()
                return
            }
            previewRef.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(AppError(error: error)!))
                    dispatchGroup.leave()
                    return
                }
                previewUrl = "\(url)"
                previewName = previewRef.name
                dispatchGroup.leave()
            })
        })
        
        dispatchGroup.notify(queue: .global(), execute: {
            completion(.success(Photo(photoUrl: photoUrl, photoName: photoName, previewUrl: previewUrl, previewName: previewName)))
        })
    }
    
    func deletePreview(name: String) {
        
        guard let ref = currentUserPath() else { return }
        
        delete(imageName: name, imagePath: previewsPath, reference: ref)
    }
    
    func deletePhoto(name: String) {
        
        guard let ref = currentUserPath() else { return }
        
        delete(imageName: name, imagePath: photosPath, reference: ref)
    }
    
    private func delete(imageName: String, imagePath: String, reference: StorageReference) {
        
        reference
            .child(imagePath)
            .child(imageName)
            .delete { error in
                if let error = error {
                    print("Error delete file = \(imageName): \(error.localizedDescription)")
                } else {
                    print("File = \(imageName) successfully deleted")
                }
        }
    }
}
