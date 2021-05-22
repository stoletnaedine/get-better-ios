//
//  UIView+AppLogoNavBar.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.05.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit

extension UIView {

    static func appLogo() -> UIView {
        let appTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let aboutAppImageView = UIImageView(image: R.image.titleViewLogo())
        aboutAppImageView.frame = CGRect(origin: CGPoint(x: 35, y: 5), size: CGSize(width: 30, height: 30))
        appTitleView.addSubview(aboutAppImageView)
        return appTitleView
    }

}
