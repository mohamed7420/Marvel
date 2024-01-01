//
//  View+Extension.swift
//  Marvel
//
//  Created by Mohamed Osama on 30/12/2023.
//

import UIKit

extension UIView {
    static func loadFromXib() -> Self {
        func instantiateFromNib<T: UIView>() -> T {
            UINib(nibName: "\(T.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        return instantiateFromNib()
    }
}
