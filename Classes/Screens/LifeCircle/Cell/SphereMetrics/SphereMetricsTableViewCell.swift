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
    @IBOutlet weak var valueView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(from sphereValue: SphereValue) {
        iconLabel.text = sphereValue.sphere?.icon
        nameLabel.text = sphereValue.sphere?.name
        if let value = sphereValue.value {
            valueLabel.text = value.stringWithComma()
            changeValueLabelColorIfValueIsLow(for: value)
        }
        descriptionLabel.text = sphereValue.sphere?.description
        
    }
    
    private func changeValueLabelColorIfValueIsLow(for value: Double) {
        switch value {
        case 0...3.4:
            valueView.backgroundColor = .coral
        case 3.5...4.0:
            valueView.backgroundColor = .thirtyGray
        case 4.1...6.0:
            valueView.backgroundColor = .gray
        case 6.1...7.4:
            valueView.backgroundColor = .darkGray
        default:
            valueView.backgroundColor = .salad
        }
    }
    
    private func setupView() {
        iconLabel.font = iconLabel.font.withSize(30)
        valueLabel.text = "0.0"
        nameLabel.font = UIFont.systemFont(ofSize: 22)
        nameLabel.textColor = .darkGray
        valueLabel.font = UIFont.systemFont(ofSize: 22)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
        valueView.layer.cornerRadius = 10
        valueLabel.textColor = .white
    }
    
}
