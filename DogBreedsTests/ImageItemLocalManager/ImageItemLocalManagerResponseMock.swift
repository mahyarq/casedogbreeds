//
//  ImageItemLocalManagerResponseMock.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import Foundation
@testable import DogBreeds

final class ImageItemLocalManagerResponseMock: ImageItemLocalManagerImpl {
    var favorites: [ImageItem] = []
    
    func setFavorite(imageItem: DogBreeds.ImageItem) {
        guard !favorites.contains(where: { $0.url == imageItem.url }) else {
            return
        }
        favorites.append(imageItem)
    }
    
    func unsetFavorite(imageItem: ImageItem) {
        let removedFavoriteIndex = favorites.firstIndex(where: { $0.url == imageItem.url })
        
        if let removedFavoriteIndex {
            favorites.remove(at: removedFavoriteIndex)
        }
    }
        
    func getAllFavorites() -> [ImageItem] {
        return favorites
    }
        
    func getFavorites(for dogBreed: String) -> [ImageItem] {
        return favorites.filter { $0.dog.breed == dogBreed }
    }
}
