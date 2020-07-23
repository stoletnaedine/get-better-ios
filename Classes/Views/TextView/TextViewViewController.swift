//
//  TextViewViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.07.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class TextViewViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
         
        if let text = text {
            textView.text = text
        }
    }
    
    private func setupView() {
        textView.contentInset = .init(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
    }
}
