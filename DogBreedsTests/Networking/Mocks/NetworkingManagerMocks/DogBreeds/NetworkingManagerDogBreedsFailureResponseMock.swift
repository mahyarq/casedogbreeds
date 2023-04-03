//
//  NetworkingManagerDogBreedsFailureResponseMock.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import UIKit
@testable import DogBreeds

class NetworkingManagerDogBreedsFailureMock: NetworkingManagerImpl {
    func request<T: Codable>(session: URLSession, endpoint: DogBreeds.Endpoint, type: T.Type, completion: @escaping DogBreeds.RequestResult<T>) {
        let success = try? StaticJSONMapper.decode(file: "DogBreeds", type: DogBreedsResponse.self)
        completion(.failure(NetworkingManager.NetworkingError.invalidURL))
    }
    
    func imageRequest(session: URLSession, imageURL: NSURL, cache: NSCache<NSURL, UIImage>, completion: @escaping DogBreeds.ImageRequestResult) {}
}
