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
    @IBOutlet weak var likesCounterLabel: UILabel!
    
    var tipEntity: TipEntity?
    
    private let database: GBDatabase = FirebaseDatabase()
    
    private var isLike: Bool = false {
        didSet {
            self.setLikeButton()
        }
    }
    
    private let backgroundNames = [
        R.image.tip.darkBg.darkBg1.name,
        R.image.tip.darkBg.darkBg2.name,
        R.image.tip.darkBg.darkBg3.name,
        R.image.tip.darkBg.darkBg4.name,
        R.image.tip.darkBg.darkBg5.name,
        R.image.tip.darkBg.darkBg6.name,
        R.image.tip.darkBg.darkBg7.name,
        R.image.tip.darkBg.darkBg8.name,
        R.image.tip.darkBg.darkBg9.name,
        R.image.tip.darkBg.darkBg10.name,
        R.image.tip.darkBg.darkBg11.name,
        R.image.tip.darkBg.darkBg12.name,
        R.image.tip.darkBg.darkBg13.name,
        R.image.tip.darkBg.darkBg14.name,
        R.image.tip.darkBg.darkBg15.name,
        R.image.tip.darkBg.darkBg16.name,
        R.image.tip.darkBg.darkBg17.name,
        R.image.tip.darkBg.darkBg18.name,
        R.image.tip.darkBg.darkBg19.name,
        R.image.tip.darkBg.darkBg20.name,
        R.image.tip.darkBg.darkBg21.name,
        R.image.tip.darkBg.darkBg22.name,
        R.image.tip.darkBg.darkBg23.name
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
    
    @IBAction private func shareButtonDidTap(_ sender: Any) {
        setVisibleForUI(hidden: true)
        guard let screenshot = self.view.takeScreenshot() else { return }
        setVisibleForUI(hidden: false)
        
        let activityVC = UIActivityViewController(activityItems: [screenshot, R.string.localizable.shareText()],
                                                  applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func setVisibleForUI(hidden: Bool) {
        cancelButton.isHidden = hidden
        shareButton.isHidden = hidden
        likeButton.isHidden = hidden
        likesCounterLabel.isHidden = hidden
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
        view.addGestureRecognizer(downSwipe)
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configure(tip: Tip) {
        titleLabel.text = tip.title
        textLabel.text = tip.text
        titleLabel.sizeToFit()
        textLabel.sizeToFit()
    }
    
    private func setupLikeButton() {
        guard let tipId = self.tipEntity?.id else { return }
        
        database.getTipLikeIds(completion: { [weak self] result in
            switch result {
            case .success(let ids):
                self?.isLike = ids.contains(tipId)
            case .failure:
                self?.isLike = false
            }
        })
        
        fetchLikesCount()
        
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
    
    private func fetchLikesCount() {
        guard let tipId = self.tipEntity?.id else { return }
        
        database.getTipLikesCount(for: tipId, completion: { [weak self] result in
            switch result {
            case .success(let likesCount):
                self?.setupLikesCount(likesCount)
            case .failure:
                break
            }
        })
    }
    
    @objc private func likeButtonDidTap() {
        guard let tipId = self.tipEntity?.id else { return }
        var likesCount: Int = Int(self.likesCounterLabel.text ?? "0") ?? .zero
        
        if isLike {
            database.deleteTipLike(id: tipId)
            likesCount -= 1
        } else {
            database.saveTipLike(id: tipId)
            likesCount += 1
        }
        
        isLike.toggle()
        setupLikesCount(likesCount)
    }
    
    private func setupLikesCount(_ count: Int) {
        let countString: String? = count <= .zero ? nil : "\(count)"
        likesCounterLabel.text = countString
    }
    
    private func setLikeButton() {
        if isLike {
            likeButton.setImage(R.image.tip.likeOn(), for: .normal)
        } else {
            likeButton.setImage(R.image.tip.likeOff(), for: .normal)
        }
    }
    
    private func setupView() {
        guard let tipId = self.tipEntity?.id else { return }
        let imageIndex = tipId % backgroundNames.count
        let tipBackground = TipBackground(style: .dark,
                                          image: UIImage(named: backgroundNames[imageIndex]))
        
        imageView.image = tipBackground.image
        cancelButton.style = .white
        likesCounterLabel.textColor = .white
        likesCounterLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        textLabel.font = UIFont.systemFont(ofSize: 16)
        
        switch tipBackground.style {
        case .light:
            titleLabel.textColor = .black
            textLabel.textColor = .black
        case .dark:
            titleLabel.textColor = .white
            textLabel.textColor = .white
        }
    }
}
