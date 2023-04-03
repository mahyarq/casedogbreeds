//
//  ImageItemLocalManager.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

protocol ImageItemLocalManagerImpl {
    func setFavorite(imageItem: ImageItem)
    func unsetFavorite(imageItem: ImageItem)
    func getAllFavorites() -> [ImageItem]
    func getFavorites(for dogBreed: String) -> [ImageItem]
}

struct ImageItemLocalManager: ImageItemLocalManagerImpl {
    static let shared = ImageItemLocalManager()
    
    private let defaults = UserDefaults.standard
    private var key: String
    
    init(key: String = "FavoriteData") {
        self.key = key
    }
    
    func setFavorite(imageItem: ImageItem) {
        var favorites: [ImageItem] = getAllFavorites()
        guard !favorites.contains(where: { $0.url == imageItem.url }) else {
            return
        }
        favorites.append(imageItem)
        
        save(items: favorites)
    }
    
    func unsetFavorite(imageItem: ImageItem) {
        var favorites: [ImageItem] = getAllFavorites()
        let removedFavoriteIndex = favorites.firstIndex(where: { $0.url == imageItem.url })
        
        if let removedFavoriteIndex {
            favorites.remove(at: removedFavoriteIndex)
        }
        
        save(items: favorites)
    }
    
    func getAllFavorites() -> [ImageItem] {
        if let arrayData = defaults.object(forKey: key) as? Data {
            let codableFavoriteItems = try? JSONDecoder().decode([CodableImageItem].self, from: arrayData)
            let favoriteItems = mapToImageItem(items: codableFavoriteItems)
            return favoriteItems
        }
        return []
    }
    
    func getFavorites(for dogBreed: String) -> [ImageItem] {
        let favorites = getAllFavorites().filter {
            $0.dog.breed == dogBreed
        }
        
        return favorites
    }
    
    private func save(items: [ImageItem]) {
        let codableItems = mapToCodable(items: items)
        if let encodedFavorites = try? JSONEncoder().encode(codableItems) {
            defaults.set(encodedFavorites, forKey: key)
        }
    }
    
    private func mapToCodable(items: [ImageItem]) -> [CodableImageItem] {
        let codableImageItems = items.map { item in
            return CodableImageItem(
                url: item.url,
                dog: item.dog,
                isFavorite: item.isFavorite
            )
        }
        return codableImageItems
    }
    
    func mapToImageItem(items: [CodableImageItem]?) -> [ImageItem] {
        guard let items else { return [] }
        let imageItems = items.map { item in
            return ImageItem(
                image: nil,
                url: item.url,
                dog: item.dog,
                isFavorite: item.isFavorite
            )
        }
        return imageItems
    }
}
