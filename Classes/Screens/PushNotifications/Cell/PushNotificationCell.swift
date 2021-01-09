//
//  PushNotificationCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.01.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit

class PushNotificationCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .appBackground
        layer.masksToBounds = false
        clipsToBounds = true
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: PushNotificationModel) {
        iconLabel.text = model.icon
        nameLabel.text = model.name
        timeLabel.text = model.time
    }
    
    private func setupView() {
        iconLabel.font = iconLabel.font.withSize(24)
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .darkGray
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        timeLabel.textColor = .white
        timeView.layer.cornerRadius = 10
        timeView.backgroundColor = .violet
        
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = .init(width: 1, height: 1)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 10
    }
    
}
