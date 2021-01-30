//
//  TitleSubtitleCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 30.01.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit

class TitleSubtitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .appBackground
        accessoryType = .disclosureIndicator
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: TitleSubtitleCellViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    private func setupView() {
        subtitleLabel.textColor = .gray
    }
    
}
