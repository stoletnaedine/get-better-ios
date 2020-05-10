//
//  AuthView.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var placeHolderStringAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    
    static var fieldLabelFont: UIFont = UIFont.systemFont(ofSize: 13)
    static var fieldLabelTextColor: UIColor {
        return .gray
    }
    
    static var buttonLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    static var buttonLabelTextColor: UIColor = .white
}
