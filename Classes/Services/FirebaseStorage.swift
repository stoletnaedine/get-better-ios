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

protocol GBStorage {
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void)
    func uploadPhoto(photo: UIImage, completion: @escaping (Result<Photo, AppError>) -> Void)
    func deletePreview(name: String)
    func deletePhoto(name: String)
}

class FirebaseStorage: GBStorage {
    
    private enum Constants {
        static let contentType = "image/jpeg"
        static let avatarFileName = "avatar"
        static let photosPath = "photos"
        static let previewsPath = "previews"
        static let usersPath = "users"
        static let photoQuality: CGFloat = 0.8
        static let resizeWidthPhoto: CGFloat = 1000
        static let resizeWidthPreview: CGFloat = 200
        static let resizeWidthAvatar: CGFloat = 400
    }
    
    private let uuidString: String = UUID().uuidString
    private let metadata = StorageMetadata()
    private let connectionHelper = ConnectionHelper()
    private let alertService: AlertService = AlertServiceDefault()
    
    func uploadAvatar(photo: UIImage,
                      completion: @escaping (Result<URL, AppError>) -> Void) {
        guard let currentUserRef = currentUserPath() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        guard let resizeImage = photo.resized(toWidth: Constants.resizeWidthAvatar) else { return }
        guard let imageData = resizeImage.jpegData(compressionQuality: Constants.photoQuality) else { return }
        metadata.contentType = Constants.contentType
        
        let avatarRef = currentUserRef.child(Constants.avatarFileName)
        
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
        
        guard let currentUserRef = currentUserPath() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        guard let resizePhoto = photo.resized(toWidth: Constants.resizeWidthPhoto) else { return }
        guard let photoData = resizePhoto.jpegData(compressionQuality: Constants.photoQuality) else { return }
        metadata.contentType = Constants.contentType
        
        let photoRef = currentUserRef
            .child(Constants.photosPath)
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
        
        guard let resizePreview = photo.resized(toWidth: Constants.resizeWidthPreview) else { return }
        guard let previewData = resizePreview.jpegData(compressionQuality: Constants.photoQuality) else { return }
        
        let previewRef = currentUserRef
            .child(Constants.previewsPath)
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
        delete(imageName: name, imagePath: Constants.previewsPath, reference: ref)
    }
    
    func deletePhoto(name: String) {
        guard let ref = currentUserPath() else { return }
        delete(imageName: name, imagePath: Constants.photosPath, reference: ref)
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
                    dispatchGroup.leave()
                })
            })
    }
    
    private func delete(imageName: String, imagePath: String, reference: StorageReference) {
        reference
            .child(imagePath)
            .child(imageName)
            .delete { [weak self] error in
                if let error = error {
                    self?.alertService.showErrorMessage(desc: error.localizedDescription)
                }
        }
    }
    
    private func currentUserPath() -> StorageReference? {
        guard connectionHelper.connectionAvailable() else { return nil }
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        
        return Storage.storage().reference()
            .child(Constants.usersPath)
            .child(userId)
    }
}
