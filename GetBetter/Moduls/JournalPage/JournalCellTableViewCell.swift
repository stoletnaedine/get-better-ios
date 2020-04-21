//
//  JournalCellTableViewCell.swift
//  GetBetter
//
//  Created by Исламгулова Лариса on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class JournalCellTableViewCell: UITableViewCell {

    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(sphere: String?, post: String?, timestamp: String?) {
        self.sphereLabel.text = sphere
        self.postLabel.text = post
        self.timestampLabel.text = timestamp
    }
}
