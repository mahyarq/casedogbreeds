//
//  ImageCachingManagerResponseMock.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import UIKit
@testable import DogBreeds

final class ImageCachingManagerResponseMock: ImageCachingManagerImpl {
    var placeholderImage: UIImage = UIImage(named: "placeholder")!
    var cachedImages: [NSURL: UIImage] = [:]
    
    func image(url: NSURL) -> UIImage? {
        return cachedImages[url]
    }
    
    func load(url: NSURL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
        
        let image = UIImage()
        cachedImages[url] = image
        
        DispatchQueue.main.async {
            completion(.success(image))
        }
    }
}
