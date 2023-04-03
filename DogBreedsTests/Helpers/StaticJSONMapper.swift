//
//  StaticJSONMapper.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import Foundation

struct StaticJSONMapper {
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
        let bundle = Bundle(for: MockURLSessionProtocol.self)
        guard !file.isEmpty,
              let path = bundle.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToGetContents
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
    }
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
