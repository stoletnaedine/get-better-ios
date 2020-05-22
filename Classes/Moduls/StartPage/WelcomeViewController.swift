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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = Constants.Welcome.title
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.text = Constants.Welcome.description
    }

}