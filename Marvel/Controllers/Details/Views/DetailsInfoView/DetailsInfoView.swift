//
//  DetailsInfoView.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit

class DetailsInfoView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public func configure(name: String, description: String) {
        nameLabel.text = name
        descriptionLabel.text = description
    }
}
