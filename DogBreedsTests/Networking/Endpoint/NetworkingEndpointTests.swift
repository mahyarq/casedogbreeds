//
//  NetworkingEndpointTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import XCTest
@testable import DogBreeds

final class NetworkingEndpointTests: XCTestCase {
    
    func testDogBreedsEndpointIsValid() {
        let endpoint = Endpoint.dogBreeds
        
        XCTAssertEqual(
            endpoint.host,
            "dog.ceo",
            "The host should be dog.ceo"
        )
        XCTAssertEqual(
            endpoint.path,
            "/api/breeds/list/all",
            "The path should be /api/breeds/list/all"
        )
        XCTAssertEqual(
            endpoint.url?.absoluteString,
            "https://dog.ceo/api/breeds/list/all",
            "The generated URL doesnt match endpoint"
        )
    }
    
    func testAllImagesEndpointIsValid() {
        let dogBreed = "akita"
        let endpoint = Endpoint.allImages(dogPath: dogBreed)
        
        XCTAssertEqual(
            endpoint.host,
            "dog.ceo",
            "The host should be dog.ceo"
        )
        XCTAssertEqual(
            endpoint.path,
            "/api/breed/\(dogBreed)/images",
            "The path should be /api/breed/\(dogBreed)/images"
        )
        XCTAssertEqual(
            endpoint.url?.absoluteString,
            "https://dog.ceo/api/breed/\(dogBreed)/images",
            "The generated URL doesnt match endpoint"
        )
    }
}
