//
//  Label.swift
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
}
