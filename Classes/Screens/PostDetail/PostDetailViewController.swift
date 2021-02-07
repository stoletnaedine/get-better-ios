//
//  PostDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Kingfisher

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: ScaledHeightImageView!
    
    var post: Post?
    var editPostCompletion: VoidClosure?
    let alertService: AlertService = AlertServiceDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        setupEditButton()
        if let post = self.post {
            fillViewController(post)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.isScrollEnabled = false
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = .init(image: R.image.edit(), style: .plain, target: self, action: #selector(editButtonDidTap))
    }
    
    @objc private func editButtonDidTap() {
        let editPostVC = EditPostViewController()
        editPostVC.post = post
        editPostVC.editPostCompletion = { [weak self] in
            self?.editPostCompletion?()
        }
        present(editPostVC, animated: true, completion: nil)
    }

    func fillViewController(_ post: Post) {
        title = post.sphere?.name
        textView.text = post.text
        if let timestamp = post.timestamp {
            self.dateLabel.text = Date.convertToFullDate(from: timestamp)
        }
        
        if let urlString = post.photoUrl,
            let url = URL(string: urlString) {
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
            ])
        }
    }
    
    func customizeView() {
        var textFont = UIFont.systemFont(ofSize: 16)
        if let photoUrl = self.post?.photoUrl, photoUrl.isEmpty,
           let text = self.post?.text, text.count < 30 {
            textFont = UIFont.systemFont(ofSize: 26)
        }
        textView.font = textFont
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .grey
    }
}

class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {
        if let image = self.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let viewWidth = self.frame.size.width

            let ratio = viewWidth/imageWidth
            let scaledHeight = imageHeight * ratio

            return CGSize(width: viewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }

}
