//
//  CollectionView+Extension.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit

class VerticalIntrinsicCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
