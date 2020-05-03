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
    @IBOutlet weak var timestampLabel: UILabel!
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
        self.sphereLabel.text = "\(post.sphere?.icon ?? "") \(post.sphere?.name ?? "")"
        self.timestampLabel.text = ""
        if let timestamp = post.timestamp {
            self.timestampLabel.text = Date.convertToFullDate(from: timestamp)
        }
    }
    
    func customizeView() {
        textLabel.font = UIFont(name: Constants.Font.SFUITextRegular, size: 20)
        sphereLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 24)
        timestampLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 14)
        cancelButton.setTitle("✖️", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
    }
}
