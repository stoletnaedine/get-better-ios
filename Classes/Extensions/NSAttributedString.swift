//
//  NSAtributedString.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    static func formPlaceholder() -> [NSAttributedString.Key : NSObject] {
        return [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
    }
}
