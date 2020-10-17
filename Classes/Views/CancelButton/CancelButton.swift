//
//  CancelButton.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.07.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

@IBDesignable
class CancelButton: UIButton {
    
    enum Style {
        case violet
        case white
    }
    
    var style: Style = .violet {
        didSet {
            setupStyle()
        }
    }
    
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

     private func setup() {
        self.clipsToBounds = true
        self.setImage(R.image.cancel(), for: .normal)
        self.setTitle("", for: .normal)
        setupStyle()
     }
    
    private func setupStyle() {
        switch style {
        case .violet:
            self.tintColor = .violet
        case .white:
            self.tintColor = .white
        }
    }
}
