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
    @IBOutlet weak var cancelButton: UIButton!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = self.post {
            fillViewController(post)
        }
        customizeView()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func fillViewController(_ post: Post) {
        self.title = post.text ?? Constants.Post.titleDefault
        self.textLabel.text = post.text ?? ""
        self.sphereLabel.text = post.sphere?.name ?? ""
        self.dateLabel.text = ""
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
                        self?.photoImageView.isHidden = false
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
        photoImageView.isHidden = true
    }
}
