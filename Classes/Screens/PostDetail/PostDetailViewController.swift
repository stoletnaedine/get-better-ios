//
//  PostDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Kingfisher
import Lightbox

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: ScaledHeightImageView!
    @IBOutlet weak var photoCounterLabel: UILabel!

    var post: Post?
    var editPostCompletion: VoidClosure?
    let alertService: AlertServiceProtocol = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        setupEditButton()
        setupPhotoImageViewTapHandler()
        configure()
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

    private func setupPhotoImageViewTapHandler() {
        photoImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoImageViewDidTap))
        photoImageView.addGestureRecognizer(tap)
    }

    @objc private func photoImageViewDidTap() {
        LightboxConfig.loadImage = { imageView, URL, completion in
            imageView.kf.setImage(with: URL)
        }
        LightboxConfig.makeLoadingIndicator = { UIView() }
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.CloseButton.image = R.image.cancelDownload()

        let mainPhotoUrl = post?.photoUrl
        let additionalPhotosUrls = post?.photos?.map { $0.url } ?? []
        let imageUrls = [mainPhotoUrl] + additionalPhotosUrls
        let images: [LightboxImage] = imageUrls.compactMap {
            guard let url = $0, let imageUrl = URL(string: url) else { return nil }
            return LightboxImage(imageURL: imageUrl)
        }
        let controller = LightboxController(images: images, startIndex: 0)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func editButtonDidTap() {
        let editPostVC = EditPostViewController()
        editPostVC.post = post
        editPostVC.editPostCompletion = { [weak self] postToSave in
            guard let self = self else { return }
            self.post = postToSave
            self.customizeView()
            self.configure()
            self.editPostCompletion?()
            editPostVC.dismiss(animated: true, completion: nil)
        }
        present(editPostVC, animated: true, completion: nil)
    }

    func configure() {
        guard let post = self.post else { return }
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
        } else if let urlString = post.photos?.first?.url,
                  let url = URL(string: urlString) {
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } else {
            photoImageView.image = nil
        }
        if let photos = post.photos {
            var count = photos.count
            if let mainPhotoUrl = post.photoUrl, !mainPhotoUrl.isEmpty  {
                count += 1
            }
            if count > 1 {
                photoCounterLabel.text = "+\(count - 1)"
            }
        }
    }
    
    func customizeView() {
        guard let post = self.post else { return }
        var textFont = UIFont.systemFont(ofSize: 16)
        if let photoUrl = post.photoUrl, photoUrl.isEmpty,
           let text = post.text, text.count < 30 {
            textFont = UIFont.systemFont(ofSize: 20)
        }
        textView.font = textFont
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .grey
        photoCounterLabel.textColor = .white
        photoCounterLabel.font = .photoCounterFont
        photoCounterLabel.addShadow(shadowRadius: 2)
        photoCounterLabel.text = nil
    }
}

// MARK: — ScaledHeightImageView

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
        return CGSize(width: 0, height: 0)
    }

}
