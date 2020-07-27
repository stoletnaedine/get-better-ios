//
//  CancelButton.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.07.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

@IBDesignable
final class CancelButton: UIButton {
    
    override init(frame: CGRect){
         super.init(frame: frame)
     }

     required init?(coder: NSCoder) {
        super.init(coder: coder)
     }

     override func layoutSubviews() {
         super.layoutSubviews()
         setup()
     }

     func setup() {
        self.clipsToBounds = true
        self.setImage(R.image.cancel(), for: .normal)
        self.setTitle("", for: .normal)
        self.tintColor = .violet
     }
}
