//
//  UIView+Screenshot.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIView {
    
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
