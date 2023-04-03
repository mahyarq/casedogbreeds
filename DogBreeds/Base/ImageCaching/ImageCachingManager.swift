//
//  ImageCachingManager.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

protocol ImageCachingManagerImpl {
    var placeholderImage: UIImage { get }
    func image(url: NSURL) -> UIImage?
    func load(url: NSURL, completion: @escaping (Result<UIImage, Error>) -> Void)
    
}

public class ImageCachingManager: ImageCachingManagerImpl {
    static let shared = ImageCachingManager()
    let placeholderImage = UIImage(named: "placeholder")!
    let cachedImages = NSCache<NSURL, UIImage>()
    let networkingManager: NetworkingManagerImpl
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: NSURL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
        
        networkingManager.imageRequest(session: .shared, imageURL: url, cache: cachedImages) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
