//
//  DogImagesViewModel.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Combine
import UIKit

final class DogImagesViewModel: ObservableObject {
    @Published private(set) var imageItems: [ImageItem] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading = false

    let dog: Dog
    let networkingManager: NetworkingManagerImpl
    let imageItemLocalManager: ImageItemLocalManagerImpl
    let imageCachingManager: ImageCachingManagerImpl
    
    init(
        dog: Dog,
        networkingManager: NetworkingManagerImpl = NetworkingManager.shared,
        imageItemLocalManager: ImageItemLocalManagerImpl = ImageItemLocalManager.shared,
        imageCachingManager: ImageCachingManagerImpl = ImageCachingManager.shared
    ) {
        self.dog = dog
        self.networkingManager = networkingManager
        self.imageItemLocalManager = imageItemLocalManager
        self.imageCachingManager = imageCachingManager
    }
    
    func fetchDogImages() {
        isLoading = true
        error = nil
        networkingManager.request(
            session: .shared,
            endpoint: .allImages(dogPath: dog.imagePath),
            type: DogImagesResponse.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                if response.imageUrls.isEmpty {
                    self.error = NetworkingManager.NetworkingError.failedToFetchImages
                    self.isLoading = false
                    return
                }
                self.imageItems = response.imageUrls.map { url in
                    let placeholder = self.imageCachingManager.placeholderImage
                    return ImageItem(image: placeholder, url: url, dog: self.dog)
                }
                self.loadFavorites()
                self.isLoading = false
            case .failure(let error):
                if let networkingError = error as? NetworkingManager.NetworkingError {
                    self.error = networkingError
                } else {
                    self.error = .custom(error: error)
                }
                self.isLoading = false
            }
        }
        
    }
    
    private func loadFavorites() {
        let favorites = imageItemLocalManager.getFavorites(for: dog.breed)

        imageItems.forEach { item in
            if favorites.contains(where: { $0.url == item.url }) {
                item.isFavorite = true
            }
        }
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
    
    func favoriteImage(for imageItem: ImageItem) {
        if imageItem.isFavorite {
            imageItemLocalManager.setFavorite(imageItem: imageItem)
        } else {
            imageItemLocalManager.unsetFavorite(imageItem: imageItem)
        }
    }
}
