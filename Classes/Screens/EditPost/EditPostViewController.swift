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
    var editPostCompletion: VoidClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postType = .edit
        self.titleLabel.text = R.string.localizable.postEditTitle()

        guard let post = post else { return }
        
        loadImageButton.isHidden = false
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
            symbolsCountLabel.text = "\(textCount)/\(super.maxSymbolsCount)"
        }
        dateLabel.text = Date.convertToDateWithWeekday(from: post.timestamp ?? 0)
        
        if let urlString = post.previewUrl,
           let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
            cancelLoadButton.isHidden = false
            loadImageButton.isHidden = true
        }
    }
    
    override func setupSelectSphereButtonTapHandler() {
        // disabled
    }
    
    override func savePost(text: String, sphere: Sphere, photoResult: Photo) {
        guard let post = post, let postId = post.id else { return }
        
        let photo: Photo = super.isOldPhoto
            ? Photo(
                photoUrl: post.photoUrl,
                photoName: post.photoName,
                previewUrl: post.previewUrl,
                previewName: post.previewName
            )
            : photoResult
        
        let postToSave = Post(id: postId,
                        text: text,
                        sphere: post.sphere,
                        timestamp: post.timestamp,
                        photoUrl: photo.photoUrl,
                        photoName: photo.photoName,
                        previewUrl: photo.previewUrl,
                        previewName: photo.previewName)
        
        database.savePost(postToSave) { [weak self] in
            guard let self = self else { return }
            self.stopAnimation()
            self.alertService.showSuccessMessage(desc: R.string.localizable.postEditSuccess())
            self.editPostCompletion?()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
