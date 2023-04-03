//
//  MockData.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import UIKit
@testable import DogBreeds

struct MockData {
    static let dog = Dog(breed: "boxer", imagePath: "boxer")
    static let dog1 = Dog(breed: "akita", imagePath: "akita")
    
    static let imageItem = ImageItem(
        image: nil,
        url: "https://images.dog.ceo/breeds/boxer/28082007167-min.jpg",
        dog: dog,
        isFavorite: false
    )

    static let imageItem1 = ImageItem(
        image: nil,
        url: "https://images.dog.ceo/breeds/boxer/IMG_0002.jpg",
        dog: dog,
        isFavorite: true
    )
    
    static let imageItem2 = ImageItem(
        image: nil,
        url: "https://example.com/image3.jpg",
        dog: dog1,
        isFavorite: true
    )
    
    static let mockURL = NSURL(string: "https://example.com/image.jpg")!
    static let image = UIImage(named: "dog-test-image")
}
