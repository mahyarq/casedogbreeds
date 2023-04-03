//
//  ErrorTableViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    static let cellId = "ErrorTableViewCell"
    
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
        selectionStyle = .none
        
        contentView.addSubview(errorView)
        errorView.configure(errorDescription: error.errorDescription, delegate: delegate)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

