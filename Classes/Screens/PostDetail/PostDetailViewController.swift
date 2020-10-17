//
//  PostDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Kingfisher

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

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: ScaledHeightImageView!
    
    var post: Post?
    var editPostCompletion: (() -> Void)?
    let alertService: AlertService = AlertServiceDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = self.post {
            fillViewController(post)
        }
        registerGestureCopyLabelText()
        customizeView()
        setupEditButton()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = .init(image: R.image.edit(), style: .plain, target: self, action: #selector(editButtonDidTap))
    }
    
    @objc func editButtonDidTap() {
        let editPostVC = EditPostViewController()
        editPostVC.post = post
        editPostVC.editPostCompletion = { [weak self] in
            self?.editPostCompletion?()
        }
        present(editPostVC, animated: true, completion: nil)
    }
    
    func registerGestureCopyLabelText() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(copyLabelText))
//        textLabel.isUserInteractionEnabled = true
//        textLabel.addGestureRecognizer(tap)
    }
    
//    @objc func copyLabelText(_ sender: UITapGestureRecognizer) {
//        if let copyText = textLabel.text {
//            UIPasteboard.general.string = copyText
//            alertService.showSuccessMessage(desc: R.string.localizable.textCopyAlert())
//        }
//    }

    func fillViewController(_ post: Post) {
        self.title = post.sphere?.name
        self.textView.text = post.text
//        self.textLabel.text = post.text
        self.photoImageView.image = post.sphere?.image
        if let timestamp = post.timestamp {
            self.dateLabel.text = Date.convertToFullDate(from: timestamp)
        }
        
        if let urlString = post.photoUrl,
            let url = URL(string: urlString) {
            self.photoImageView.kf.indicatorType = .activity
            self.photoImageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
            ])
            
            DispatchQueue.main.async { [weak self] in
                self?.photoImageView.alpha = 1
                self?.photoImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    func customizeView() {
//        textLabel.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.systemFont(ofSize: 16)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .grey
        photoImageView.alpha = 0.15
    }
}
