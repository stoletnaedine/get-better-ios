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
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = self.post {
            fillViewController(post)
        }
        customizeView()
    }

    func fillViewController(_ post: Post) {
        self.title = post.text ?? Properties.Post.titleDefault
        self.textLabel.text = post.text ?? ""
        self.sphereLabel.text = Sphere(rawValue: post.sphere ?? "relax")?.name
        self.timestampLabel.text = ""
        if let timestamp = post.timestamp {
            self.timestampLabel.text = Date.convertToDate(from: timestamp)
        }
    }
    
    func customizeView() {
        textLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        sphereLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 24)
        timestampLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
    }
}
