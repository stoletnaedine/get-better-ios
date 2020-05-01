//
//  JournalCellTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    @IBOutlet weak var sphereView: UIView!
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(_ post: Post) {
        self.sphereView.backgroundColor = post.sphere?.color
        self.sphereNameLabel.text = post.sphere?.name ?? ""
        self.titleLabel.text = post.text ?? ""
    }
    
    func setupView() {
        sphereNameLabel.textColor = .white
        sphereNameLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 12)
    }
}
