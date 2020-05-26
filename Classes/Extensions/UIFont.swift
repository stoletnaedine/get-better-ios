//
//  UIFont.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIFont {
    
    // MARK: Form
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
    
    // MARK: Journal
    static var sphereLabelFont: UIFont {
        return UIFont.boldSystemFont(ofSize: 10)
    }
    
    static var journalTableTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    static var journalTableDateFont: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    
    static var journalTitleFont: UIFont {
        return UIFont.boldSystemFont(ofSize: 24)
    }
    
    static var journalButtonFont: UIFont {
        return UIFont.boldSystemFont(ofSize: 18)
    }
    
    static var journalDateFont: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}
