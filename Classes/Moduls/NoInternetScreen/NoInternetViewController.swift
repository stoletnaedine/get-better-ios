//
//  NoInternetViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 26.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Reachability

class NoInternetViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    let rootManager = RootManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @IBAction func retryButtonDidTap(_ sender: UIButton) {
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            rootManager.start()
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupView() {
        
    }
}
