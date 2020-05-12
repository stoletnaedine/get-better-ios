//
//  SphereMetricsTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(from achievement: Achievement) {
        self.titleLabel.text = achievement.title
        self.descriptionLabel.text = achievement.description
        
        if achievement.unlocked {
            self.iconLabel.text = achievement.icon
            setupUnlockedView()
        }
    }
    
    private func setupUnlockedView() {
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        descriptionLabel.textColor = .gray
        iconLabel.font = iconLabel.font.withSize(30)
    }
    
    private func setupView() {
        iconLabel.text = "◉"
        titleLabel.textColor = .gray
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
    }
    
}
