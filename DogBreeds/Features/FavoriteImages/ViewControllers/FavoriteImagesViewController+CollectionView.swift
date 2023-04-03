//
//  FavoriteImagesViewController+CollectionView.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

// MARK: CollectionView Datasource
extension FavoriteImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !filteredImageItems.isEmpty {
            return filteredImageItems.count
        }
        if !hasFavorites {
            return 1
        }
        return viewModel.imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !hasFavorites {
            return setupEmptyStateCell(for: collectionView, at: indexPath)
        }
        
        return setupCell(for: collectionView, at: indexPath)
    }
        
    func setupCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> FavoriteImageCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteImageCollectionViewCell.cellId, for: indexPath) as? FavoriteImageCollectionViewCell else {
            return FavoriteImageCollectionViewCell()
        }
        
        if !filteredImageItems.isEmpty {
            cell.configure(imageItem: filteredImageItems[indexPath.item], delegate: self)
            return cell
        }
        
        viewModel.fetchImage(for: indexPath.item) { imageItem in
            cell.configure(imageItem: imageItem, delegate: self)
        }
        
        return cell
    }
    
    func setupEmptyStateCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> EmptyStateCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCollectionViewCell.cellId, for: indexPath) as? EmptyStateCollectionViewCell else {
            return EmptyStateCollectionViewCell()
        }
        cell.configure(
            title: "No favorites selected",
            message: "You have currently not liked any dog images. Favorite an image in order to see them here."
        )
        return cell
    }
}

// MARK: CollectionView Delegate
extension FavoriteImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !hasFavorites {
            return CGSize(width: view.frame.width, height: view.frame.height * 0.5)
        }
        let length = view.frame.width
        return CGSize(width: length, height: length)
    }
}
