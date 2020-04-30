//
//  SphereMetricsTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 30.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SphereMetricsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(sphereName: String, value: Double, description: String, icon: String) {
        self.iconLabel.text = icon
        self.nameLabel.text = sphereName
        self.valueLabel.text = "\(value)"
        self.descriptionLabel.text = description
    }
    
    func setupView() {
        nameLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 22)
        valueLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 25)
        descriptionLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 13)
    }
    
}
