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
    
    func fillCell(from sphereValue: SphereValue) {
        self.iconLabel.text = sphereValue.sphere?.icon
        self.nameLabel.text = sphereValue.sphere?.name
        self.valueLabel.text = "\(sphereValue.value ?? 0.0)"
        self.descriptionLabel.text = sphereValue.sphere?.description
    }
    
    func setupView() {
        nameLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 22)
        valueLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 30)
        descriptionLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 13)
    }
    
}
