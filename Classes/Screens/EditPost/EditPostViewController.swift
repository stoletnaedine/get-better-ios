//
//  EditPostViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Kingfisher

class EditPostViewController: AddPostViewController {
    
    var post: Post?
    var editPostCompletion: ((_ postToSave: Post) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postType = .edit
        titleLabel.text = R.string.localizable.postEditTitle()
        placeholderLabel.isHidden = true
        selectSphereButton.isEnabled = false

        guard let post = post else { return }
        selectSphereButton.setTitle(post.sphere?.name, for: .normal)
        selectSphereButton.setImage(nil, for: .normal)
        selectSphereButton.tintColor = .violet
        sphereView.layer.borderColor = UIColor.grey.cgColor
        saveButtonView.backgroundColor = .violet
        
        selectedSphere = post.sphere
        postTextView.text = post.text
        if let textCount = post.text?.count {
            symbolsCountLabel.text = "\(textCount)/\(Constants.maxSymbolsCount)"
        }
        dateLabel.text = Date.convertToDateWithWeekday(from: post.timestamp ?? 0)
        if let photosCount = post.photos?.count, photosCount > 1 {
            photoCounterLabel.text = "+\(photosCount - 1)"
        }
        
        if let urlString = post.previewUrl,
           let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
            setupImageView(.fill)
        } else {
            setupImageView(.empty)
        }

        isNotAddSphereValue = post.notAddSphereValue
        notAddSphereValueSwitch.isOn = post.notAddSphereValue
    }
    
    override func setupSelectSphereButtonTapHandler() {
        // disabled
    }

    override func configurePost(completion: @escaping (Post) -> Void) {
        guard let text = postTextView.text, !text.isEmpty else {
            alertService.showErrorMessage(R.string.localizable.postEmptyText())
            return
        }
        guard let sphere = selectedSphere else {
            alertService.showErrorMessage(R.string.localizable.postEmptySphere())
            return
        }
        guard self.postType == .edit,
              let post = self.post,
              let postId = post.id else { return }

        if !imagesToUpload.isEmpty {
            showLoadingAnimation(on: self.view)
            selectSphereButton.isEnabled = false
            saveButton.isEnabled = false
            isModalInPresentation = true
            deletePhotos(for: post)

            storage.uploadPhotos(imagesToUpload, needFirstPhotoPreview: true) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(postPhotos):
                    let post = Post(
                        id: postId,
                        text: text,
                        sphere: sphere,
                        timestamp: post.timestamp,
                        previewUrl: postPhotos.preview?.url,
                        previewName: postPhotos.preview?.name,
                        photos: postPhotos.photos,
                        notAddSphereValue: self.isNotAddSphereValue)
                    completion(post)
                case let .failure(error):
                    DispatchQueue.main.async {
                        self.stopAnimation()
                        self.selectSphereButton.isEnabled = true
                        self.saveButton.isEnabled = true
                    }
                    self.alertService.showErrorMessage(error.localizedDescription)
                }
            }
        } else {
            if super.isClearedPhotos {
                deletePhotos(for: post)
            }
            let post = Post(
                id: postId,
                text: text,
                sphere: sphere,
                timestamp: post.timestamp,
                photoUrl: super.isClearedPhotos ? nil : post.photoUrl,
                photoName: super.isClearedPhotos ? nil : post.photoName,
                previewUrl: super.isClearedPhotos ? nil : post.previewUrl,
                previewName: super.isClearedPhotos ? nil : post.previewName,
                photos: super.isClearedPhotos ? nil : post.photos,
                notAddSphereValue: self.isNotAddSphereValue)
            completion(post)
        }
    }

    override func savePost(_ post: Post) {
        database.savePost(post) { [weak self] in
            guard let self = self else { return }
            self.stopAnimation()
            self.editPostCompletion?(post)
            self.alertService.showSuccessMessage(R.string.localizable.postEditSuccess())
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func deletePhotos(for post: Post) {
        var photoNamesForDelete = [String]()
        let photoNames = post.photos?.compactMap { $0.name } ?? []
        photoNamesForDelete.append(contentsOf: photoNames)
        if let mainPhotoName = post.photoName {
            photoNamesForDelete.append(mainPhotoName)
        }
        photoNamesForDelete.forEach { storage.deletePhoto(name: $0) }

        if let previewName = post.previewName {
            storage.deletePreview(name: previewName)
        }
    }
    
}
