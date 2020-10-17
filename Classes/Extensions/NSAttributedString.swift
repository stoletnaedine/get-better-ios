//
//  NSAtributedString.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    static var formFieldPlaceholderAttributes: [NSAttributedString.Key : NSObject] {
        return [NSAttributedString.Key.foregroundColor: UIColor.placeholderGrey,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
    }
}
