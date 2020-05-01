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
    
    let lowValue = 5.0
    
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
        if let value = sphereValue.value {
            self.valueLabel.text = "\(value)"
            changeValueLabelColorIfValueIsLow(for: value)
        }
        self.descriptionLabel.text = sphereValue.sphere?.description
    }
    
    private func changeValueLabelColorIfValueIsLow(for value: Double) {
        if value < lowValue {
            self.valueLabel.textColor = .red
        }
    }
    
    private func setupView() {
        valueLabel.text = "0.0"
        nameLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 22)
        valueLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 30)
        descriptionLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 13)
    }
    
}
