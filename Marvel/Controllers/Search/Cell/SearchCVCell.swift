//
//  SearchCVCell.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit

struct SearchCellViewModel {
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

class SearchCVCell: UICollectionViewCell {

    @IBOutlet weak var marvelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    public func configure(viewModel: SearchCellViewModel) {
        marvelImageView.kf.indicatorType = .activity
        marvelImageView.kf.setImage(with: URL(string: viewModel.thumbnail))
        nameLabel.text = viewModel.name
    }
}
