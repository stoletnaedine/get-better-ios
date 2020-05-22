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
    @IBOutlet weak var textLabel: UILabel!
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
        textLabel.text = article.text ?? ""
        imageView.image = article.image ?? UIImage()
    }
    
    func customizeView() {
        titleLabel.font = UIFont(name: GlobalDefiitions.Font.mabryProRegular, size: 30)
        textLabel.font = UIFont.systemFont(ofSize: 15)
    }

}
