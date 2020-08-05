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

protocol StorageService {
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void)
    func uploadPhoto(photo: UIImage, completion: @escaping (Result<Photo, AppError>) -> Void)
    func deletePreview(name: String)
    func deletePhoto(name: String)
}

class FirebaseStorageService: StorageService {
    let metadata = StorageMetadata()
    let contentType = "image/jpeg"
    let avatarFileName = "avatar"
    let photosPath = "photos"
    let previewsPath = "previews"
    let usersPath = "users"
    let uuidString: String = UUID().uuidString
    let photoQuality: CGFloat = 0.75
    let resizeWidthPhoto: CGFloat = 900
    let resizeWidthPreview: CGFloat = 100
    let resizeWidthAvatar: CGFloat = 250
    
    func uploadAvatar(photo: UIImage,
                      completion: @escaping (Result<URL, AppError>) -> Void) {
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
    
    func uploadPhoto(photo: UIImage,
                     completion: @escaping (Result<Photo, AppError>) -> Void) {
        var photoName: String?
        var photoUrl: String?
        var previewName: String?
        var previewUrl: String?
        let dispatchGroup = DispatchGroup()
        
        guard let currentUserRef = currentUserPath() else { return }
        guard let resizePhoto = photo.resized(toWidth: resizeWidthPhoto) else { return }
        guard let photoData = resizePhoto.jpegData(compressionQuality: photoQuality) else { return }
        metadata.contentType = contentType
        
        let photoRef = currentUserRef
            .child(photosPath)
            .child(uuidString)
        
        dispatchGroup.enter()
        uploadPhoto(ref: photoRef,
                    data: photoData,
                    dispatchGroup: dispatchGroup,
                    completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let photo):
                photoName = photo.name
                photoUrl = photo.urlString
            }
        })
        
        guard let resizePreview = photo.resized(toWidth: resizeWidthPreview) else { return }
        guard let previewData = resizePreview.jpegData(compressionQuality: photoQuality) else { return }
        
        let previewRef = currentUserRef
            .child(previewsPath)
            .child(uuidString)
        
        dispatchGroup.enter()
        uploadPhoto(ref: previewRef,
                    data: previewData,
                    dispatchGroup: dispatchGroup,
                    completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let photo):
                previewName = photo.name
                previewUrl = photo.urlString
            }
        })
        
        dispatchGroup.notify(queue: .global(), execute: {
            let photo = Photo(photoUrl: photoUrl,
                              photoName: photoName,
                              previewUrl: previewUrl,
                              previewName: previewName)
            completion(.success(photo))
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
    
    private func uploadPhoto(ref: StorageReference,
                             data: Data,
                             dispatchGroup: DispatchGroup,
                             completion: @escaping (Result<(name: String, urlString: String), AppError>) -> Void) {
        ref
            .putData(data, metadata: metadata, completion: { (metadata, error) in
                guard let _ = metadata else {
                    completion(.failure(AppError(error: error)!))
                    dispatchGroup.leave()
                    return
                }
                ref.downloadURL(completion: { (url, error) in
                    guard let url = url else {
                        completion(.failure(AppError(error: error)!))
                        dispatchGroup.leave()
                        return
                    }
                    let name = ref.name
                    let urlString = "\(url)"
                    let result = (name: name, urlString: urlString)
                    completion(.success(result))
                    print("Firebase saved file \(String(describing: name))")
                    dispatchGroup.leave()
                })
            })
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
    
    private func currentUserPath() -> StorageReference? {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        
        return Storage.storage().reference()
            .child(usersPath)
            .child(userId)
    }
}
