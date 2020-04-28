//
//  WelcomeViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class AboutCircleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        title = Properties.AboutCircle.viewTitle
        view.backgroundColor = .lighterGray
        titleLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 25)
        titleLabel.text = Properties.AboutCircle.title
        descriptionLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 14)
        descriptionLabel.text = Properties.AboutCircle.description
    }

}
