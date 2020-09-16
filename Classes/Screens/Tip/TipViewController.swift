//
//  TipViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tomorrowLabel: UILabel!
    
    var tip: Tip?
    var like: Bool = false
    let backgrounds = [
        R.image.tipBackground1(),
        R.image.tipBackground2(),
        R.image.tipBackground3(),
        R.image.tipBackground4(),
        R.image.tipBackground5(),
        R.image.tipBackground6()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if let tip = self.tip {
            configure(tip: tip)
        }
    }

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        self.like.toggle()
        self.setupLikeButton()
    }
    
    private func configure(tip: Tip) {
        self.titleLabel.text = tip.title
        self.textLabel.text = tip.text
        self.titleLabel.sizeToFit()
        self.textLabel.sizeToFit()
    }
    
    private func setupLikeButton() {
        if self.like {
            self.likeButton.setImage(R.image.likeOn(), for: .normal)
        } else {
            self.likeButton.setImage(R.image.likeOff(), for: .normal)
        }
    }

    
    private func setupView() {
        let days = Date().diffInDaysSince1970()
        let imageIndex = days % backgrounds.count
        self.imageView.image = backgrounds[imageIndex]
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        self.titleLabel.textColor = .black
        self.textLabel.font = UIFont.systemFont(ofSize: 18)
        self.textLabel.textColor = .black
        self.tomorrowLabel.textColor = .white
        self.tomorrowLabel.font = .journalDateFont
        self.tomorrowLabel.layer.shadowColor = UIColor.black.cgColor
        self.tomorrowLabel.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        self.tomorrowLabel.layer.shadowOpacity = 0.7
        self.tomorrowLabel.layer.shadowRadius = 5.0
        self.tomorrowLabel.layer.masksToBounds = false
        
        self.setupLikeButton()
        self.likeButton.isHidden = true
    }
}
