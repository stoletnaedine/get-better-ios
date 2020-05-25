//
//  UITextView.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UITextView {
    
    func resizeByContent() {
        self.isScrollEnabled = false
        var newFrame = self.frame
        let width = newFrame.size.width
        let newSize = self.sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        self.frame = newFrame
    }
}
