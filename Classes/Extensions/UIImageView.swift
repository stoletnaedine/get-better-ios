//
//  UIImageView.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 02.07.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIImageView {

    func tint(with color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }

}
