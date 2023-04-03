//
//  Endpoint.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Foundation

enum Endpoint {
    case dogBreeds
    case allImages(dogPath: String)
}

extension Endpoint {
    var host: String { "dog.ceo" }
    var path: String {
        switch self {
        case .dogBreeds:
            return "/api/breeds/list/all"
        case .allImages(dogPath: let dogPath):
            return "/api/breed/\(dogPath)/images"
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        return urlComponents.url
    }
}
