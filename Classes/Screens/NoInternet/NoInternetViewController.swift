//
//  NoInternetViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 26.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    let connectionHelper = ConnectionHelper()
    let alertService: AlertService = AlertServiceDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @IBAction func retryButtonDidTap(_ sender: UIButton) {
        if connectionHelper.connectionAvailable() {
            alertService.showSuccessMessage(desc: R.string.localizable.noInternetTryConnectAlert())
            NotificationCenter.default.post(name: .enterApp, object: nil)
        }
    }
    
    private func setupView() {
        imageView.image = R.image.noInternet()
        titleLabel.text = R.string.localizable.noInternetTitle()
        titleLabel.font = .journalTitleFont
        titleLabel.textColor = .violet
        noticeLabel.text = R.string.localizable.noInternetNotice()
        retryButton.setTitle(R.string.localizable.noInternetButton(), for: .normal)
        retryButton.setTitleColor(.violet, for: .normal)
    }
}
