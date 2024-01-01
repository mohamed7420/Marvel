//
//  ItemHeaderView.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import Foundation

class ItemsHeaderView: UICollectionReusableView {
    lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fill
        stack.alignment = .leading
        stack.addArrangedSubview(titleLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    public func set(title: String) {
        titleLabel.text = title
    }
}
