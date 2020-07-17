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
        
        if let article = article {
            fillViewController(from: article)
        }
    }

    func fillViewController(from article: Article) {
        titleLabel.text = article.title ?? ""
        if let titleView = article.titleView {
            navigationItem.titleView = titleView
        }
        textView.text = article.text ?? ""
        textView.attributedText = article.text?.htmlToAttributedString
        imageView.image = article.image ?? UIImage()
    }
    
    func customizeView() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.resizeByContent()
        textView.tintColor = .violet
    }
    
}
