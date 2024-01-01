//
//  CharacterCVCell.swift
//  Marvel
//
//  Created by Mohamed Osama on 29/12/2023.
//

import UIKit
import Kingfisher

struct CharacterCellViewModel {
    private let result: Result
    init(result: Result) {
        self.result = result
    }

    var thumbnail: String {
        return result.thumbnail.path + ".\(result.thumbnail.fileExtension)"
    }

    var name: String {
        result.name
    }
}

class CharacterCVCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    public func configure(_ viewModel: CharacterCellViewModel) {
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: URL(string: viewModel.thumbnail))
        nameLabel.text = viewModel.name
    }

}
