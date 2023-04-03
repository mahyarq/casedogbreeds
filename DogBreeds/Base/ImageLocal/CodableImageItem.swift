//
//  CodableImageItem.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import Foundation

struct CodableImageItem: Codable {
    let url: String
    let dog: Dog
    let isFavorite: Bool
}
