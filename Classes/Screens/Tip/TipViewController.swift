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
    var like: Bool = false
    let backgrounds: [TipBackground] = [
        TipBackground(style: .light, image: R.image.lightBg1()),
        TipBackground(style: .light, image: R.image.lightBg2()),
        TipBackground(style: .light, image: R.image.lightBg3()),
        TipBackground(style: .light, image: R.image.lightBg4()),
        TipBackground(style: .light, image: R.image.lightBg5()),
        TipBackground(style: .dark, image: R.image.darkBg1()),
        TipBackground(style: .dark, image: R.image.darkBg2()),
        TipBackground(style: .dark, image: R.image.darkBg3()),
        TipBackground(style: .dark, image: R.image.darkBg4()),
        TipBackground(style: .dark, image: R.image.darkBg5()),
        TipBackground(style: .dark, image: R.image.darkBg6()),
        TipBackground(style: .dark, image: R.image.darkBg7()),
        TipBackground(style: .dark, image: R.image.darkBg8()),
        TipBackground(style: .dark, image: R.image.darkBg9())
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
        self.tomorrowLabel.font = .journalDateFont
        
        self.tomorrowLabel.isHidden = true
//        self.tomorrowLabel.textColor = .white
//        self.tomorrowLabel.layer.shadowColor = UIColor.black.cgColor
//        self.tomorrowLabel.layer.shadowOffset = .init(width: 0.5, height: 0.5)
//        self.tomorrowLabel.layer.shadowOpacity = 0.7
//        self.tomorrowLabel.layer.shadowRadius = 5.0
//        self.tomorrowLabel.layer.masksToBounds = false
    }
}
