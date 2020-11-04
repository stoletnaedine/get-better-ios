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
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tipEntity: TipEntity?
    
    private let database: GBDatabase = FirebaseDatabase()
    
    private var isLike: Bool = false {
        didSet {
            self.setLikeButton()
        }
    }
    
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
        TipBackground(style: .dark, image: R.image.darkBg23())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSwipeGesture()
        setupCancelButton()
        setupLikeButton()
        setupShadow(for: self.titleLabel)
        setupShadow(for: self.textLabel)
        
        guard let tipEntity = self.tipEntity else { return }
        configure(tip: tipEntity.tip)
    }
    
    private func setupShadow(for label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .init(width: 1, height: 1)
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 10
        label.layer.masksToBounds = false
    }
    
    private func setupSwipeGesture() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
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
    
    private func setupLikeButton() {
        guard let tipId = self.tipEntity?.id else { return }
        
        database.getTipLikes(completion: { [weak self] result in
            switch result {
            case .success(let ids):
                self?.isLike = ids.contains(tipId)
            case .failure:
                self?.isLike = false
            }
        })
        
        self.likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func likeButtonDidTap() {
        guard let tipId = self.tipEntity?.id else { return }
        if self.isLike {
            database.deleteTipLike(id: tipId)
        } else {
            database.saveTipLike(id: tipId)
        }
        self.isLike.toggle()
    }
    
    private func setLikeButton() {
        if self.isLike {
            self.likeButton.setImage(R.image.likeOn(), for: .normal)
        } else {
            self.likeButton.setImage(R.image.likeOff(), for: .normal)
        }
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
        self.titleLabel.font = UIFont.systemFont(ofSize: 30)
        self.textLabel.font = UIFont.systemFont(ofSize: 16)
    }
}
