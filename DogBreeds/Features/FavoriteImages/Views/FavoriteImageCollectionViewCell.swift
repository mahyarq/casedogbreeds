//
//  FavoriteImageCollectionViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

class FavoriteImageCollectionViewCell: UICollectionViewCell {
    static let cellId = "FavoriteImageCollectionViewCell"

    // MARK: Configure
    func configure(imageItem: ImageItem, delegate: DogImagesFavoriteDelegate) {
        let dogImageView = DogImageView()
        dogImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dogImageView)
        dogImageView.configure(imageItem: imageItem, showLabel: true, delegate: delegate)
        
        NSLayoutConstraint.activate([
            dogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dogImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
        
    }
}
