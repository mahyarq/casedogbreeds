//
//  DogImagesResponse.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Foundation

struct DogImagesResponse: Codable, Equatable {
    let imageUrls: [String]
    
    enum CodingKeys: String, CodingKey {
        case imageUrls = "message"
    }
}
