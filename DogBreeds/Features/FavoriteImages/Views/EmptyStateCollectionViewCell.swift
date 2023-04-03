//
//  EmptyStateCollectionViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {
    static let cellId = "EmptyStateCollectionViewCell"

    // MARK: UI
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -15),
        ])
    }
}

