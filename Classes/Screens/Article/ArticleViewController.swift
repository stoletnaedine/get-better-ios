//
//  ArticleViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        guard let article = self.article else { return }
        fillViewController(from: article)
    }

    func fillViewController(from article: Article) {
        navigationItem.titleView = article.titleView
        titleLabel.text = article.title
        textView.attributedText = article.text?.htmlToAttributedString
        textView.sizeToFit()
        imageView.image = article.image?.aspectFitImage(inRect: imageView.frame)
        imageView.contentMode = .top
    }
    
    func customizeView() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.tintColor = .violet
    }
    
}
