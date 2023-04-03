//
//  ImageItem.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit

class ImageItem {
    var image: UIImage?
    let url: String
    let dog: Dog
    var isFavorite: Bool

    init(image: UIImage?, url: String, dog: Dog, isFavorite: Bool = false) {
        self.image = image
        self.url = url
        self.dog = dog
        self.isFavorite = isFavorite
    }
}
