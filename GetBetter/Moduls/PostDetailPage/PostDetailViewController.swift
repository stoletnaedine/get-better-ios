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
        self.textLabel.text = post.text ?? ""
        self.sphereLabel.text = Sphere(rawValue: post.sphere ?? "relax")?.string
        if let timestampString = post.timestamp,
            let timestampNumber = Double(timestampString) {
            let date = Date(timeIntervalSince1970: timestampNumber / 1000)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd/MMM/YY"
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            self.timestampLabel.text = dateString
        } else {
            self.timestampLabel.text = ""
        }
        self.title = post.text ?? "Событие"
    }
    
    func customizeView() {
        textLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        sphereLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBoldC, size: 24)
        timestampLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
    }
}
