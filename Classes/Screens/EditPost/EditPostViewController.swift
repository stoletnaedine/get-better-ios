//
//  EditPostViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class EditPostViewController: AddPostViewController {
    
    var post: Post?
    var editPostCompletion: VoidClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "Редактировать"
    }
    
    override func setupSelectSphereButtonTapHandler() {
    }
    
    override func setupView() {
        super.setupView()
        
        guard let post = post else { return }
        
        selectSphereButton.isEnabled = false
        selectSphereButton.setTitle(post.sphere?.name, for: .normal)
        selectSphereButton.setImage(nil, for: .normal)
        selectSphereButton.tintColor = .violet
        sphereView.layer.borderColor = UIColor.grey.cgColor
        saveButtonView.backgroundColor = .violet
        
        selectedSphere = post.sphere
        postTextView.text = post.text
        dateLabel.text = Date.convertToDateWithWeekday(from: post.timestamp ?? 0)
        
        placeholderLabel.isHidden = true
        attachButton.isHidden = true
    }
    
    override func savePost(text: String, sphere: Sphere, photoResult: Photo) {
        guard let post = post, let postId = post.id else { return }
        
        let postToSave = Post(id: postId,
                        text: text,
                        sphere: post.sphere,
                        timestamp: post.timestamp,
                        photoUrl: post.photoUrl,
                        photoName: post.photoName,
                        previewUrl: post.previewUrl,
                        previewName: post.previewName)
        
        database.savePost(postToSave) { [weak self] in
            guard let self = self else { return }
            self.stopAnimation()
            self.alertService.showSuccessMessage(desc: R.string.localizable.postEditSuccess())
            self.editPostCompletion?()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
