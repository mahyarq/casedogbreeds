//
//  NetworkingManagerDogImagesSuccessResponseMock.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import UIKit
@testable import DogBreeds

class NetworkingManagerDogImagesSuccessResponseMock: NetworkingManagerImpl {
    func request<T: Codable>(session: URLSession, endpoint: DogBreeds.Endpoint, type: T.Type, completion: @escaping DogBreeds.RequestResult<T>) {
        let success = try? StaticJSONMapper.decode(file: "ImageUrls", type: DogImagesResponse.self)
        completion(.success(success as! T))
    }
    
    func imageRequest(session: URLSession, imageURL: NSURL, cache: NSCache<NSURL, UIImage>, completion: @escaping DogBreeds.ImageRequestResult) {}
}
