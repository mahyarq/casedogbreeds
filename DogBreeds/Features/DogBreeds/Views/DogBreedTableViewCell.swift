//
//  DogBreedTableViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

class DogBreedTableViewCell: UITableViewCell {
    static let cellId = "DogBreedTableViewCell"
    
    // MARK: UI
    private lazy var containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.cellBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var moreIndicator: UIImageView = {
        let imageView = UIImageView(image: Assets.moreIndicator)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Theme.textColor
        return imageView
    }()
    
    private weak var delegate: DogBreedTableViewCellDelegate?
    private var dog: Dog?

    // MARK: Lifecycle
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
}

extension DogBreedTableViewCell {
    func configure(dog: Dog?, delegate: DogBreedTableViewCellDelegate) {
        self.delegate = delegate
        self.dog = dog
        titleLabel.text = dog?.breed.capitalized
        
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(moreIndicator)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        
            moreIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            moreIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
        ])

        containerView.addGestureRecognizer(CustomTapGestureRecognizer(target: self, action: #selector(didTapCell)))
    }
    
    @objc func didTapCell() {
        guard let dog, let delegate else { return }
        delegate.didTapCell(for: dog)
    }
}




