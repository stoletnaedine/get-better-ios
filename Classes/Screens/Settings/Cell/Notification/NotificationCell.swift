//
//  NotificationTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var subscribeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var switchClosure: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: NotificationCellViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        subscribeSwitch.isOn = model.isOn
        subscribeSwitch.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
    }
    
    @objc private func handleSwitch() {
        switchClosure?(subscribeSwitch.isOn)
    }
}
