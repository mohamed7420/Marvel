//
//  GalleryView.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit
import Kingfisher

class GalleryView: UIView {
    @IBOutlet weak var galleryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(image: String) {
        guard let imageURL = URL(string: image) else { return }
        galleryImageView.kf.indicatorType = .activity
        galleryImageView.kf.setImage(with: imageURL)
    }
}
