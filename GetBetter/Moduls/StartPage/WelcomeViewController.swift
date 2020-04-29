//
//  WelcomeViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
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
        view.backgroundColor = .lightGray
        titleLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 25)
        titleLabel.text = Constants.Welcome.title
        descriptionLabel.font = UIFont(name: Constants.Font.SFUITextRegular, size: 15)
        descriptionLabel.text = Constants.Welcome.description
    }

}
