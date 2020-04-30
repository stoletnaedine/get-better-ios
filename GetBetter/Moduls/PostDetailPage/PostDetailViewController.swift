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
    @IBOutlet weak var iconLabel: UILabel!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = self.post {
            fillViewController(post)
        }
        customizeView()
    }

    func fillViewController(_ post: Post) {
        self.title = post.text ?? Constants.Post.titleDefault
        self.textLabel.text = post.text ?? ""
        self.sphereLabel.text = post.sphere?.name
        self.iconLabel.text = post.sphere?.icon
        self.timestampLabel.text = ""
        if let timestamp = post.timestamp {
            self.timestampLabel.text = Date.convertToFullDate(from: timestamp)
        }
    }
    
    func customizeView() {
        textLabel.font = UIFont(name: Constants.Font.SFUITextRegular, size: 15)
        sphereLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 24)
        timestampLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 12)
        iconLabel.font = UIFont.systemFont(ofSize: 200)
        iconLabel.alpha = 0.3
    }
}
