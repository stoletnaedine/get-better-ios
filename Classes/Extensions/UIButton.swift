//
//  UIButton.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 14.07.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    func setImageRightToText() {
        self.semanticContentAttribute = .forceRightToLeft
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
      let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
      UIGraphicsBeginImageContext(minimumSize)

      if let context = UIGraphicsGetCurrentContext() {
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: minimumSize))
      }

      let colorImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
      self.setBackgroundImage(colorImage, for: forState)
    }
}
