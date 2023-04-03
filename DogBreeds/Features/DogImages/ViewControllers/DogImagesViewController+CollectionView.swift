//
//  DogImagesViewController+CollectionView.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

// MARK: CollectionView Datasource
extension DogImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hasError ? 1 : viewModel.imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let error {
            return setupErrorCell(for: collectionView, at: indexPath, error: error)
        }
        
        return setupCell(for: collectionView, at: indexPath)
    }
    
    func setupCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> DogImageCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogImageCollectionViewCell.cellId, for: indexPath) as? DogImageCollectionViewCell else { return DogImageCollectionViewCell() }
        
        viewModel.fetchImage(for: indexPath.item) { imageItem in
            cell.tag = indexPath.item
            cell.configure(imageItem: imageItem, delegate: self)
            
        }
        
        return cell
    }
    
    func setupErrorCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        error: NetworkingManager.NetworkingError
    ) -> ErrorCollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCollectionViewCell.cellId, for: indexPath) as? ErrorCollectionViewCell else { return ErrorCollectionViewCell() }
            cell.configure(error: error, delegate: self)
            
            return cell
    }
}

// MARK: CollectionView Delegate
extension DogImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if hasError {
            return CGSize(width: view.frame.width, height: view.frame.height * 0.5)
        }
        let length = view.frame.width
        return CGSize(width: length, height: length)
    }
}
