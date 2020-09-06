//
//  CommonMetricsTableViewCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct CommonMetricsViewModel {
    let posts: Int
    let average: Double
    let days: Int
}

class CommonMetricsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postsValueLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var averageValueLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var daysValueLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(viewModel: CommonMetricsViewModel) {
        postsValueLabel.text = "\(viewModel.posts)"
        if viewModel.posts == 0 {
            postsValueLabel.textColor = .coral
        } else {
            postsValueLabel.textColor = .darkGray
        }
        averageValueLabel.text = viewModel.average.stringWithComma()
        averageValueLabel.textColor = UIColor.color(for: viewModel.average)
        daysValueLabel.text = "\(viewModel.days)"
    }
    
    private func setupView() {
        postsValueLabel.font = UIFont.systemFont(ofSize: 32)
        postsValueLabel.textColor = .darkGray
        postsLabel.text = "событий"
        postsLabel.font = UIFont.systemFont(ofSize: 14)
        postsLabel.textColor = .gray
        
        averageValueLabel.font = UIFont.systemFont(ofSize: 32)
        averageValueLabel.textColor = .darkGray
        averageLabel.text = "средний балл"
        averageLabel.font = UIFont.systemFont(ofSize: 14)
        averageLabel.textColor = .gray
        
        daysValueLabel.font = UIFont.systemFont(ofSize: 32)
        daysValueLabel.textColor = .darkGray
        daysLabel.font = UIFont.systemFont(ofSize: 14)
        daysLabel.textColor = .gray
        daysLabel.text = "дней"
    }
    
}
