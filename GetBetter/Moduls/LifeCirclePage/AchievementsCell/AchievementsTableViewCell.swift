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
        self.iconLabel.text = achievement.icon
        self.titleLabel.text = achievement.title
        self.descriptionLabel.text = achievement.description
    }
    
    private func setupView() {
        iconLabel.font = iconLabel.font.withSize(30)
        iconLabel.text = "🏆"
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
    }
    
}
