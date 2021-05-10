//
//  SphereMetricsTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class AchievementCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func prepareForReuse() {
        setupView()
    }
    
    func fillCell(from achievement: Achievement) {
        titleLabel.text = achievement.title
        descriptionLabel.text = achievement.description
        
        if achievement.unlocked {
            iconLabel.text = achievement.icon
            iconLabel.font = iconLabel.font.withSize(30)
            backgroundColor = .appBackground
        } else {
            iconLabel.text = "•"
            titleLabel.textColor = .grey
            backgroundColor = .lighterGrey
        }
    }
    
    private func setupView() {
        selectionStyle = .none
        titleLabel.font = .journalTitleFont
        titleLabel.textColor = .darkGray
        descriptionLabel.font = .journalTableDateFont
        descriptionLabel.textColor = .grey
    }
}
