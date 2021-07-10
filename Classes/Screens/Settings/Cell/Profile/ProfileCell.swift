//
//  ProfileTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 28.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
        selectionStyle = .none
        backgroundColor = .appBackground
    }
    
    func configure(model: Profile) {
        if let avatarURL = model.avatarURL {
            self.avatarImageView.kf.setImage(with: avatarURL)
        }
        self.nameLabel.text = model.name
        self.emailLabel.text = model.email
    }
    
    private func customizeView() {
        avatarImageView.backgroundColor = .tableViewSectionColor
        nameLabel.font = .journalTitleFont
        emailLabel.text = R.string.localizable.profileLoading()
        emailLabel.font = .journalDateFont
        emailLabel.textColor = .grey
    }
    
}
