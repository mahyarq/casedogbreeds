//
//  ErrorCollectionViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

class ErrorCollectionViewCell: UICollectionViewCell {
    static let cellId = "ErrorCollectionViewCell"
    
    // MARK: UI
    private lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
    }()

    // MARK: Configure + tapAction
    func configure(
        error: NetworkingManager.NetworkingError,
        delegate: ErrorViewTapActionDelegate
    ) {
        backgroundColor = .clear
    
        contentView.addSubview(errorView)
        errorView.configure(errorDescription: error.errorDescription, delegate: delegate)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
