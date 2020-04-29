//
//  WelcomeViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class AboutJournalViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        title = Constants.AboutJournal.viewTitle
        view.backgroundColor = .lighterGray
        titleLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 25)
        titleLabel.text = Constants.AboutJournal.title
        descriptionLabel.font = UIFont(name: Constants.Font.SFUITextRegular, size: 14)
        descriptionLabel.text = Constants.AboutJournal.description
    }
}
