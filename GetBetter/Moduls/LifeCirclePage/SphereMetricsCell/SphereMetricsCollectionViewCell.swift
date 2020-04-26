//
//  SphereMetricsCollectionViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 26.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SphereMetricsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var sphereValueLabel: UILabel!
    @IBOutlet weak var sphereDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func fillCell(sphere: String, value: Double, description: String) {
        self.sphereNameLabel.text = sphere
        self.sphereValueLabel.text = "\(value)"
        self.sphereDescriptionLabel.text = description
    }
    
    func setupView() {
        sphereNameLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 22)
        sphereValueLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 25)
        sphereDescriptionLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 13)
    }
}
