//
//  FavoriteImagesViewModel.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import Foundation
import Combine

final class FavoriteImagesViewModel: ObservableObject {
    @Published private(set) var imageItems: [ImageItem] = []

    let imageItemLocalManager: ImageItemLocalManagerImpl
    let imageCachingManager: ImageCachingManagerImpl
    
    init(
        imageItemLocalManager: ImageItemLocalManagerImpl = ImageItemLocalManager.shared,
        imageCachingManager: ImageCachingManagerImpl = ImageCachingManager.shared
    ) {
        self.imageItemLocalManager = imageItemLocalManager
        self.imageCachingManager = imageCachingManager
    }
    
    func fetchFavoriteImages() {
        imageItems = imageItemLocalManager.getAllFavorites()
    }
    
    func fetchImage(for index: Int, completion: @escaping (ImageItem) -> Void) {
        let item = self.imageItems[index] 
        guard let url = NSURL(string: item.url) else { return completion(item) }

        imageCachingManager.load(url: url) { result in
            switch result {
            case .success(let image):
                item.image = image
                completion(item)
            case .failure(_):
                completion(item)
            }
        }
    }

    func unsetFavorite(for imageItem: ImageItem) {
        let index = imageItems.firstIndex(where: { $0.url == imageItem.url })
        if let index {
            imageItems.remove(at: index)
        }
        imageItemLocalManager.unsetFavorite(imageItem: imageItem)
    }
    
    func getDogBreeds() -> [Dog] {
        let dogs = imageItems.map { $0.dog }
        let unique = Set(dogs)
        let sortedDogs = Array(unique).sorted(by: { $0.breed < $1.breed })
        
        return sortedDogs
    }
}
