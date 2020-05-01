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
        self.avatarImageView.image = profile.avatar ?? UIImage(named: "defaultAvatar")
        self.nameLabel.text = profile.name ?? ""
        self.emailLabel.text = profile.email ?? ""
    }
    
    func customizeView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.backgroundColor = .lightGray
        nameLabel.text = ""
        nameLabel.font = UIFont(name: Constants.Font.SFUITextMedium, size: 20)
        emailLabel.text = Constants.Profile.loading
        emailLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 14)
        
    }
    
}
