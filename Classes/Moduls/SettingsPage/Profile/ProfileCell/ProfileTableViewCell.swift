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
        if let avatar = profile.avatar {
            self.avatarImageView.image = avatar
        }
        self.nameLabel.text = profile.name ?? ""
        self.emailLabel.text = profile.email ?? ""
    }
    
    func customizeView() {
        avatarImageView.backgroundColor = .tableViewSectionColor
        nameLabel.text = ""
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emailLabel.text = GlobalDefiitions.Profile.loading
        emailLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
}
