//
//  ErrorView.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

protocol ErrorViewTapActionDelegate: AnyObject {
    func didRetryFetching()
}

class ErrorView: UIView {
    // MARK: UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Something went wrong"
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var retryButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = Theme.mainColor
        button.titleLabel?.textColor = Theme.textColor
        button.layer.cornerRadius = 10
        button.addGestureRecognizer(
            CustomTapGestureRecognizer(target: self, action: #selector(didTapRetry))
        )
        return button
    }()
    
    private weak var delegate: ErrorViewTapActionDelegate?
    
    func configure(errorDescription: String, delegate: ErrorViewTapActionDelegate) {
        self.delegate = delegate
        errorLabel.text = errorDescription
        
        addSubview(titleLabel)
        addSubview(errorLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            errorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            errorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 15),
            errorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -15),
            
            retryButton.widthAnchor.constraint(equalToConstant: 200),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 50),
            retryButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc func didTapRetry() {
        guard let delegate else { return }
        delegate.didRetryFetching()
    }
}
