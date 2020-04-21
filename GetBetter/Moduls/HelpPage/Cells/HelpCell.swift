//
//  HelpCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class HelpCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func fillCell(category: CategoryStruct) {
        if let imageName = category.imageName {
            imageView.image = UIImage(named: imageName)
        }
        titleLabel.text = category.title
    }
}
