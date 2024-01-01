//
//  URLElementCVCell.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit

class URLElementCVCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    public var action: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
            action?()
    }
}
