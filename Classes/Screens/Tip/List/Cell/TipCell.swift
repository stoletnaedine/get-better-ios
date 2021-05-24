//
//  TipCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 07.03.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit

class TipCell: UITableViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!

    private let tipStorage = TipStorage()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.textColor = .white
        likesCountLabel.textColor = .white
        heartImageView.image = R.image.tip.likeOn()
    }

    func configure(from model: TipLikeCellViewModel) {
        titleLabel.text = model.title
        likesCountLabel.text = "\(model.likeCount)"
        backImageView.image = model.backgroundImage
    }

}
