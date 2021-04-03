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

protocol FileStorageProtocol {
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void)
    func uploadPhotos(_ photos: [UIImage], needFirstPhotoPreview: Bool, completion: @escaping (Result<[Photo], AppError>) -> Void)
    func deletePreview(name: String?)
    func deletePhoto(name: String?)
}

class FirebaseStorage: FileStorageProtocol {
    
    private enum Constants {
        static let contentType = "image/jpeg"
        static let avatarFileName = "avatar"
        static let photosPath = "photos"
        static let previewsPath = "previews"
        static let usersPath = "users"
        static let photoQuality: CGFloat = 0.8
        static let resizeWidthPreview: CGFloat = 300
        static let resizeWidthAvatar: CGFloat = 400
    }

    private let connectionHelper = ConnectionHelper()
    private let alertService: AlertServiceProtocol = AlertService()
    
    func uploadAvatar(photo: UIImage,
                      completion: @escaping (Result<URL, AppError>) -> Void) {
        guard let currentUserRef = currentUserPath() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        guard let resizeImage = photo.resized(toWidth: Constants.resizeWidthAvatar) else { return }
        guard let imageData = resizeImage.jpegData(compressionQuality: Constants.photoQuality) else { return }
        
        let avatarRef = currentUserRef.child(Constants.avatarFileName)
        let metadata = StorageMetadata()
        metadata.contentType = Constants.contentType

        avatarRef.putData(imageData, metadata: metadata, completion: { (metadata, error) in
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

    func uploadPhotos(_ photos: [UIImage],
                      needFirstPhotoPreview: Bool,
                      completion: @escaping (Result<[Photo], AppError>) -> Void) {
        guard let currentUserRef = currentUserPath() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }

        let group = DispatchGroup()
        var photoResult: [Photo] = []
        var firstPhotoPreviewNameUrl: PhotoNameURL? = nil

        photos.enumerated().forEach { index, photo in
            let photoId = UUID().uuidString

            // First photo preview
            if needFirstPhotoPreview && index == 0,
               let resizedPreview = photo.resized(toWidth: Constants.resizeWidthPreview),
               let previewData = resizedPreview.jpegData(compressionQuality: Constants.photoQuality) {
                group.enter()
                let previewRef = currentUserRef
                    .child(Constants.previewsPath)
                    .child(photoId)
                self.uploadPhoto(ref: previewRef, data: previewData) { result in
                    switch result {
                    case let .success(photoNameURL):
                        firstPhotoPreviewNameUrl = photoNameURL
                        group.leave()
                    case .failure:
                        group.leave()
                    }
                }
            }

            if let photoData = photo.jpegData(compressionQuality: Constants.photoQuality) {
                group.enter()
                let photoRef = currentUserRef
                    .child(Constants.photosPath)
                    .child(photoId)

                self.uploadPhoto(ref: photoRef, data: photoData) { result in
                    switch result {
                    case let .success(photoNameUrl):
                        let photo = Photo(
                            main: photoNameUrl,
                            preview: nil)
                        photoResult.append(photo)
                        group.leave()
                    case .failure:
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .global(), execute: {
            if let firstPhotoPreview = firstPhotoPreviewNameUrl,
               let previewPhotoIndex = photoResult.firstIndex(where: { $0.main.name == firstPhotoPreview.name }) {
                photoResult[previewPhotoIndex].preview = firstPhotoPreview
            }
            photoResult.sort(by: { $0.preview != nil && $1.preview == nil })
            completion(.success(photoResult))
        })
    }
    
    func deletePreview(name: String?) {
        guard let ref = currentUserPath(),
              let name = name, !name.isEmpty else { return }
        delete(imageName: name, imagePath: Constants.previewsPath, reference: ref)
    }
    
    func deletePhoto(name: String?) {
        guard let ref = currentUserPath(),
              let name = name, !name.isEmpty else { return }
        delete(imageName: name, imagePath: Constants.photosPath, reference: ref)
    }

    // MARK: — Private methods
    
    private func uploadPhoto(ref: StorageReference,
                             data: Data,
                             completion: @escaping (Result<PhotoNameURL, AppError>) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = Constants.contentType
        ref.putData(data, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(.init(errorCode: .serverError)))
                return
            }
            ref.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(.init(errorCode: .serverError)))
                    return
                }
                let result = PhotoNameURL(name: ref.name, url: "\(downloadURL)")
                completion(.success(result))
            }
        }
    }
    
    private func delete(imageName: String, imagePath: String, reference: StorageReference) {
        reference
            .child(imagePath)
            .child(imageName)
            .delete { [weak self] error in
                if let error = error {
                    self?.alertService.showErrorMessage(error.localizedDescription)
                }
            }
    }
    
    private func currentUserPath() -> StorageReference? {
        guard connectionHelper.isConnect(),
              let userId = Auth.auth().currentUser?.uid else { return nil }
        
        return Storage.storage().reference()
            .child(Constants.usersPath)
            .child(userId)
    }
}
