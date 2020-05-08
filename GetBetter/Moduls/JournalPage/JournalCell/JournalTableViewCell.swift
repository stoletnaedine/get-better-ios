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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabelNoImage: UILabel!
    @IBOutlet weak var dateLabelNoImage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(from post: Post) {
        sphereNameLabel.text = post.sphere?.name ?? ""
        sphereNameLabel.textColor = post.sphere?.titleColor
        sphereView.backgroundColor = post.sphere?.color
        titleLabel.text = post.text ?? ""
        titleLabelNoImage.text = post.text ?? ""
        dateLabel.text = Date.convertToDateWithWeekday(from: post.timestamp ?? 0)
        dateLabelNoImage.text = Date.convertToDateWithWeekday(from: post.timestamp ?? 0)
        
        if let urlString = post.previewUrl,
            !urlString.isEmpty {
        
            DispatchQueue.global().async { [weak self] in
                
                if let url = URL(string: urlString),
                    let imageData = try? Data(contentsOf: url),
                    let image = UIImage(data: imageData) {
                
                    DispatchQueue.main.async {
                        self?.switchImage(show: true)
                        self?.photoImageView.image = image
                    }
                }
            }
        }
    }
    
    func setupView() {
        switchImage(show: false)
        sphereView.layer.cornerRadius = 10
        sphereNameLabel.font = UIFont.boldSystemFont(ofSize: 10)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        titleLabelNoImage.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabelNoImage.textColor = .darkGray
        dateLabelNoImage.font = UIFont.systemFont(ofSize: 12)
        dateLabelNoImage.textColor = .gray
    }
    
    private func switchImage(show: Bool) {
        if show {
            photoImageView?.isHidden = false
            titleLabel.isHidden = false
            dateLabel.isHidden = false
            titleLabelNoImage.isHidden = true
            dateLabelNoImage.isHidden = true
        } else {
            photoImageView?.isHidden = true
            titleLabel.isHidden = true
            dateLabel.isHidden = true
            titleLabelNoImage.isHidden = false
            dateLabelNoImage.isHidden = false
        }
    }
}
