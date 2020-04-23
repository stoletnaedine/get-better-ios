//
//  WelcomeViewController.swift
//  GetBetter
//
//  Created by Исламгулова Лариса on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view.backgroundColor = .lightGrey
        titleLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 25)
        titleLabel.text = Properties.Welcome.title
        descriptionLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        descriptionLabel.text = Properties.Welcome.description
    }

}
