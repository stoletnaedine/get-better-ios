//
//  PostDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cancelImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var post: Post?
    
    let alertService: AlertService = AlertServiceDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            fillViewController(post)
        }
        registerGestureCopyLabelText()
        customizeView()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerGestureCopyLabelText() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyLabelText))
        textLabel.isUserInteractionEnabled = true
        textLabel.addGestureRecognizer(tap)
    }
    
    @objc func copyLabelText(_ sender: UITapGestureRecognizer) {
        if let copyText = textLabel.text {
            UIPasteboard.general.string = copyText
            alertService.showSuccessMessage(desc: R.string.localizable.textCopyAlert())
        }
    }

    func fillViewController(_ post: Post) {
        self.title = post.text ?? R.string.localizable.postTitleDefault()
        self.textLabel.text = post.text ?? ""
        self.sphereLabel.text = post.sphere?.name ?? ""
        self.dateLabel.text = ""
        self.photoImageView.image = post.sphere?.image
        if let timestamp = post.timestamp {
            self.dateLabel.text = Date.convertToFullDate(from: timestamp)
        }
        DispatchQueue.global().async { [weak self] in
            if let urlString = post.photoUrl,
                let url = URL(string: urlString) {
                
                DispatchQueue.main.async {
                    guard let selfView = self?.view else { return }
                    self?.showActivityIndicator(onView: selfView)
                }
                
                if let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.removeActivityIndicator()
                        self?.photoImageView.image = image
                        self?.photoImageView.alpha = 1
                        self?.photoImageView.contentMode = .scaleAspectFill
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.removeActivityIndicator()
                    }
                }
            }
        }
    }
    
    func customizeView() {
        textLabel.font = UIFont.systemFont(ofSize: 18)
        sphereLabel.font = UIFont.boldSystemFont(ofSize: 24)
        sphereLabel.textColor = .violet
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        cancelButton.setTitle("", for: .normal)
        photoImageView.alpha = 0.15
        cancelImageView.tint(with: .violet)
    }
}
