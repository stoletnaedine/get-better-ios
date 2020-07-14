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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        showImageInCell(false)
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
                        self?.photoImageView.image = image
                        self?.showImageInCell(true)
                    }
                }
            }
        }
    }
    
    func setupView() {
        showImageInCell(false)
        photoImageView.layer.cornerRadius = 5
        photoImageView.layer.masksToBounds = true
        sphereView.layer.cornerRadius = 10
        sphereNameLabel.font = .sphereLabelFont
        titleLabel.font = .journalTableTitleFont
        titleLabel.textColor = .darkGray
        dateLabel.font = .journalTableDateFont
        dateLabel.textColor = .gray
        titleLabelNoImage.font = .journalTableTitleFont
        titleLabelNoImage.textColor = .darkGray
        dateLabelNoImage.font = .journalTableDateFont
        dateLabelNoImage.textColor = .gray
    }
    
    private func showImageInCell(_ show: Bool) {
        photoImageView?.isHidden = !show
        titleLabel.isHidden = !show
        dateLabel.isHidden = !show
        titleLabelNoImage.isHidden = show
        dateLabelNoImage.isHidden = show
    }
}
