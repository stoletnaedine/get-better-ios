//
//  JournalCellTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(_ post: Post) {
        self.sphereLabel.text = post.sphere?.name ?? ""
        self.postLabel.text = post.text ?? ""
        if let timestamp = post.timestamp {
            self.timestampLabel.text = Date.convertToDate(from: timestamp)
        }
        
    }
}
