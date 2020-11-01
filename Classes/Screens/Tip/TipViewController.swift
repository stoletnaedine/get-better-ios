//
//  TipViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct TipBackground {
    let style: TipStyle
    let image: UIImage?
    
    enum TipStyle {
        case light
        case dark
    }
}

class TipViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var cancelButton: CancelButton!
    
    var tip: Tip?
    private var like: Bool = false
    private let backgrounds: [TipBackground] = [
        TipBackground(style: .dark, image: R.image.darkBg1()),
        TipBackground(style: .dark, image: R.image.darkBg2()),
        TipBackground(style: .dark, image: R.image.darkBg3()),
        TipBackground(style: .dark, image: R.image.darkBg4()),
        TipBackground(style: .dark, image: R.image.darkBg5()),
        TipBackground(style: .dark, image: R.image.darkBg6()),
        TipBackground(style: .dark, image: R.image.darkBg7()),
        TipBackground(style: .dark, image: R.image.darkBg8()),
        TipBackground(style: .dark, image: R.image.darkBg9()),
        TipBackground(style: .dark, image: R.image.darkBg10()),
        TipBackground(style: .dark, image: R.image.darkBg11()),
        TipBackground(style: .dark, image: R.image.darkBg12()),
        TipBackground(style: .dark, image: R.image.darkBg13()),
        TipBackground(style: .dark, image: R.image.darkBg14()),
        TipBackground(style: .dark, image: R.image.darkBg15()),
        TipBackground(style: .dark, image: R.image.darkBg16()),
        TipBackground(style: .dark, image: R.image.darkBg17()),
        TipBackground(style: .dark, image: R.image.darkBg18()),
        TipBackground(style: .dark, image: R.image.darkBg19()),
        TipBackground(style: .dark, image: R.image.darkBg20()),
        TipBackground(style: .dark, image: R.image.darkBg21()),
        TipBackground(style: .dark, image: R.image.darkBg22()),
        TipBackground(style: .dark, image: R.image.darkBg23()),
        TipBackground(style: .dark, image: R.image.darkBg24())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTargets()
        
        if let tip = self.tip {
            configure(tip: tip)
        }
    }
    
    private func setupTargets() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        downSwipe.direction = .down
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.view.addGestureRecognizer(downSwipe)
    }

    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configure(tip: Tip) {
        self.titleLabel.text = tip.title
        self.textLabel.text = tip.text
        self.titleLabel.sizeToFit()
        self.textLabel.sizeToFit()
    }
    
    private func setupView() {
        let days = Date().diffInDaysSince1970()
        let imageIndex = days % backgrounds.count
        let tipBackground = backgrounds[imageIndex]
        
        self.imageView.image = tipBackground.image
        switch tipBackground.style {
        case .light:
            self.titleLabel.textColor = .black
            self.textLabel.textColor = .black
        case .dark:
            self.titleLabel.textColor = .white
            self.textLabel.textColor = .white
        }
        
        self.cancelButton.style = .white
        self.titleLabel.font = UIFont.systemFont(ofSize: 26)
        self.textLabel.font = UIFont.systemFont(ofSize: 18)
    }
}
