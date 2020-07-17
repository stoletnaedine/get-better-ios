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
         
        if let text = text {
            textView.text = text
        }
    }
}
