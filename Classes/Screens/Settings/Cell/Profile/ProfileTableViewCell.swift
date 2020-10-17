//
//  ProfileTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 28.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func fillCell(profile: Profile) {
        if let avatarURL = profile.avatarURL {
            self.avatarImageView.kf.setImage(with: avatarURL)
        }
        self.nameLabel.text = profile.name
        self.emailLabel.text = profile.email
    }
    
    private func customizeView() {
        avatarImageView.backgroundColor = .tableViewSectionColor
        nameLabel.font = .journalTitleFont
        emailLabel.text = R.string.localizable.profileLoading()
        emailLabel.font = .journalDateFont
        emailLabel.textColor = .grey
    }
    
}
