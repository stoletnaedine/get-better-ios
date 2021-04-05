//
//  UILabel.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UILabel {
    
    func underline() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(   NSAttributedString.Key.underlineStyle,
                                             value: NSUnderlineStyle.single.rawValue,
                                             range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }

    func addShadow(shadowRadius: CGFloat? = nil) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = shadowRadius ?? 10
        self.layer.masksToBounds = false
    }
    
}
