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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    var tip: Tip?
    var like: Bool = false
    
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
        self.textView.text = tip.text
    }
    
    private func setupLikeButton() {
        if self.like {
            self.likeButton.setImage(R.image.likeOn(), for: .normal)
        } else {
            self.likeButton.setImage(R.image.likeOff(), for: .normal)
        }
        self.likeButton.imageView?.tint(with: .white)
    }

    private func setupView() {
        self.imageView.image = R.image.lightBackground()
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        self.titleLabel.textColor = .black
        self.textView.font = UIFont.systemFont(ofSize: 22)
        self.textView.textColor = .darkGray
        self.setupLikeButton()
    }
}
