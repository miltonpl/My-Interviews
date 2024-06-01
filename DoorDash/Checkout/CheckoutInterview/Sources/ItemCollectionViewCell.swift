//
//  ItemCollectionViewCell.swift
//  CheckoutInterview
//
//  Created by Milton Palaguachi on 3/12/24.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    var item: Item?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stackView = UIStackView(frame: .zero)
    let splitView = UIView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.backgroundColor = .systemGray5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(splitView)
        addSubview(stackView)
    
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            splitView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
