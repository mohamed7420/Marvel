//
//  ItemCVCell.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit
import Kingfisher

class ItemCVCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(title: String, image: String) {
        guard let imageURL = URL(string: image) else { return }
        titleLabel.text = title

        itemImageView.kf.indicatorType = .activity
        itemImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
    }
}
