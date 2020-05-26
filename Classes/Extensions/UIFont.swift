//
//  UIFont.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var formLabelFieldFont: UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    
    static var formNoticeFont: UIFont {
        return formLabelFieldFont
    }
    
    static var formFieldFont: UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    static var formButtonFont: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
}
