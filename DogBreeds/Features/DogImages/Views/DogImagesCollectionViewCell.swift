//
//  DogImagesCollectionViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

class DogImageCollectionViewCell: UICollectionViewCell {
    static let cellId = "DogImageCollectionViewCell"

    // MARK: Configure
    func configure(imageItem: ImageItem, delegate: DogImagesFavoriteDelegate) {
        let dogImageView = DogImageView()
        dogImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dogImageView)
        dogImageView.configure(imageItem: imageItem, showLabel: false, delegate: delegate)
        
        NSLayoutConstraint.activate([
            dogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dogImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
}
