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
        self.titleLabel.text = R.string.localizable.postEditTitle()

        guard let post = post else { return }
        
        loadImageButton.isHidden = false
        bigLoadImageButton.isHidden = false
        cancelLoadButton.isHidden = true
        placeholderLabel.isHidden = true
        
        selectSphereButton.isEnabled = false
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
        
        if let urlString = post.previewUrl,
           let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
            cancelLoadButton.isHidden = false
            loadImageButton.isHidden = true
            bigLoadImageButton.isHidden = true
        }
    }
    
    override func setupSelectSphereButtonTapHandler() {
        // disabled
    }

    // FIXME: logic for edit post
//    override func savePost(text: String, sphere: Sphere, photos: [Photo]) {
//        guard let post = self.post,
//              let postId = post.id else { return }
//
//        let photo: Photo = super.isOldPhoto
//            ? Photo(
//                photoUrl: post.photoUrl,
//                photoName: post.photoName,
//                previewUrl: post.previewUrl,
//                previewName: post.previewName)
//            : firstPhoto
//
//        let postToSave = Post(
//            id: postId,
//            text: text,
//            sphere: post.sphere,
//            timestamp: post.timestamp,
//            photoUrl: photo.photoUrl,
//            photoName: photo.photoName,
//            previewUrl: photo.previewUrl,
//            previewName: photo.previewName,
//            addPhotos: addPhotos)
//
//        database.savePost(postToSave) { [weak self] in
//            guard let self = self else { return }
//            self.stopAnimation()
//            self.editPostCompletion?(postToSave)
//            self.alertService.showSuccessMessage(R.string.localizable.postEditSuccess())
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
}
