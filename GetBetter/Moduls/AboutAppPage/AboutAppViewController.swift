//
//  WelcomeViewController.swift
//  GetBetter
//
//  Created by Исламгулова Лариса on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view.backgroundColor = .lighterGray
        titleLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 25)
        titleLabel.text = Properties.AboutApp.title
        descriptionLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        descriptionLabel.text = Properties.AboutApp.description
    }

}