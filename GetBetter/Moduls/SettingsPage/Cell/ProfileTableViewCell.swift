//
//  ProfileTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 28.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(profile: Profile) {
        print("self.avatarImageView = \(self.avatarImageView)")
        self.avatarImageView.image = profile.avatar ?? UIImage(named: "defaultAvatar")
        self.nameLabel.text = profile.name ?? ""
        self.emailLabel.text = profile.email ?? ""
    }
    
    func customizeView() {
        avatarImageView.image = UIImage(named: "defaultAvatar")
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.backgroundColor = .lightGray
        nameLabel.text = "Имя"
        emailLabel.text = Properties.Profile.loading
        nameLabel.font = UIFont(name: Properties.Font.SFUITextMedium, size: 20)
    }
    
}
