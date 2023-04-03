//
//  NetworkingManager.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Foundation
import UIKit

typealias RequestResult<T> = (Result<T, Error>) -> Void
typealias ImageRequestResult = (Result<UIImage, Error>) -> Void

protocol NetworkingManagerImpl {
    func request<T: Codable>(session: URLSession, endpoint: Endpoint, type: T.Type, completion: @escaping RequestResult<T>)
    func imageRequest(session: URLSession, imageURL: NSURL, cache: NSCache<NSURL, UIImage>, completion: @escaping ImageRequestResult)
}

final class NetworkingManager: NetworkingManagerImpl {
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(
        session: URLSession,
        endpoint: Endpoint,
        type: T.Type,
        completion: @escaping RequestResult<T>
    ) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.custom(error: error!)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.invalidResponse))
                }
                return
            }

            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.invalidStatusCode(statusCode: response.statusCode)))
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.invalidData))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.failedToDecode(error: error)))
                }
            }
        }
        
        dataTask.resume()
    }
    
    func imageRequest(
        session: URLSession,
        imageURL: NSURL,
        cache: NSCache<NSURL, UIImage>,
        completion: @escaping ImageRequestResult
    ) {
        var request = URLRequest(url: imageURL as URL)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.custom(error: error!)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.invalidResponse))
                }
                return
            }

            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.invalidStatusCode(statusCode: response.statusCode)))
                }
                return
            }

            guard let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.invalidData))
                }
                return
            }

            cache.setObject(image, forKey: imageURL, cost: data.count)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        dataTask.resume()
    }
}
