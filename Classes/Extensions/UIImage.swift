//
//  UIImage.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func imageWithInsets(insetDimension: CGFloat) -> UIImage? {
        return imageWithInsets(insets: UIEdgeInsets(top: insetDimension, left: insetDimension, bottom: insetDimension, right: insetDimension))
    }
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        let size = CGSize(width: self.size.width + insets.left + insets.right,
                          height: self.size.height + insets.top + insets.bottom)
        let origin = CGPoint(x: insets.left, y: insets.top)
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
        UIGraphicsEndImageContext()
        
        return imageWithInsets
    }
    
}
