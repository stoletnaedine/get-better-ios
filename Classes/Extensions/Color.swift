//
//  Color.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 19.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var violet: UIColor {
        return #colorLiteral(red: 0.4509803922, green: 0.1411764706, blue: 0.9803921569, alpha: 1)
    }
    
    static var coral: UIColor {
        return #colorLiteral(red: 1, green: 0.4, blue: 0.4, alpha: 1)
    }
    
    static var salad: UIColor {
        return #colorLiteral(red: 0.2, green: 0.8784313725, blue: 0.631372549, alpha: 1)
    }
    
    static var tableViewSectionColor: UIColor {
        return #colorLiteral(red: 0.8470588235, green: 0.8274509804, blue: 0.8784313725, alpha: 1)
    }
    
    static var lifeCircleLineBack: UIColor {
        return #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
    }
    
    static var lifeCircleLineStart: UIColor {
        return #colorLiteral(red: 0.831372549, green: 0.7960784314, blue: 0.9529411765, alpha: 1)
    }
    
    static var lifeCircleLineCurrent: UIColor {
        return .violet
    }
    
    static var lifeCircleFillCurrent: UIColor {
        return #colorLiteral(red: 0.9058823529, green: 0.8823529412, blue: 0.9960784314, alpha: 1)
    }
    
    static var red: UIColor {
        return UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 1)
    }
    
    static var grey: UIColor {
        return UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
    }
    
    static var lightGrey: UIColor {
        return UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    }
    
    static var lighterGrey: UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    
    static var thirtyGrey: UIColor {
        return #colorLiteral(red: 0.737254902, green: 0.7568627451, blue: 0.7607843137, alpha: 1)
    }
    
    static var placeholderGrey: UIColor {
        return UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1)
    }
    
    static var appBackground: UIColor {
        return #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 1, alpha: 1)
    }
    
    static func color(for value: Double) -> UIColor {
        switch value {
        case 0...3.49:
            return .coral
        case 3.5...4.99:
            return .grey
        case 5.0...6.59:
            return .darkGray
        case 6.6...8.99:
            return .salad
        default:
            return .violet
        }
    }
}
