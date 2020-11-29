//
//  ArticleViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Lottie

class ArticleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: ScaledHeightImageView!
    private var animationView: AnimationView?
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        guard let article = self.article else { return }
        fillViewController(from: article)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.isScrollEnabled = false
    }

    private func fillViewController(from article: Article) {
        titleLabel.text = article.title
        textView.attributedText = article.text.htmlToAttributedString
        textView.sizeToFit()
        imageView.image = article.image
        
        if let navBarTitleView = article.titleView {
            let tap = UITapGestureRecognizer(target: self, action: #selector(startAnimation))
            navBarTitleView.isUserInteractionEnabled = true
            navBarTitleView.addGestureRecognizer(tap)
            navigationItem.titleView = navBarTitleView
        }
    }
    
    @objc private func startAnimation() {
        self.showAnimation(name: .confetti, on: self.view)
    }
    
    private func setupView() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.tintColor = .violet
    }
    
}
