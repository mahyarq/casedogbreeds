//
//  DogBreedsResponse.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Foundation

struct DogBreedsResponse: Codable, Equatable {
    let breeds: [String: [String]]
    
    enum CodingKeys: String, CodingKey {
        case breeds = "message"
    }
}
