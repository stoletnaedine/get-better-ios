//
//  Atricle.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 09.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct Article {
    let title: String
    let titleView: UIView?
    let text: String
    let image: UIImage?
    
    init( title: String, titleView: UIView? = nil, text: String, image: UIImage? = nil) {
        self.title = title
        self.titleView = titleView
        self.text = text
        self.image = image
    }
}
