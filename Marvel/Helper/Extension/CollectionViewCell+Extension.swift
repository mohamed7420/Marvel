//
//  CollectionViewCell+Extension.swift
//  Marvel
//
//  Created by Mohamed Osama on 30/12/2023.
//

import UIKit

extension UICollectionViewCell {
   static var identifier: String {
        "\(Self.self)"
    }

    static var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    static func register(collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
