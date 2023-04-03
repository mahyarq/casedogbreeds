//
//  NetworkingManager+Extension.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Foundation

extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidURL
        case invalidData
        case invalidStatusCode(statusCode: Int)
        case invalidResponse
        case custom(error: Error)
        case failedToDecode(error: Error)
        case failedToFetchImages
    }
}

extension NetworkingManager.NetworkingError {
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "URL isn't valid"
        case .invalidStatusCode( let statusCode):
            return "Status code falls into the wrong range. Statuscode: \(statusCode)"
        case .invalidData:
            return "Response data is invalid"
        case .invalidResponse:
            return "Response is invalid"
        case .failedToDecode:
            return "Failed to decode"
        case .custom(let err):
            return "\(err.localizedDescription)"
        case .failedToFetchImages:
            return "There doesnt seem to be any images for this dog for some reason.\n\nTry again later if this keeps happening."
        }
    }
}

extension NetworkingManager.NetworkingError: Equatable {
    static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
            switch(lhs, rhs) {
            case (.invalidURL, .invalidURL):
                return true
            case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
                return lhsType == rhsType
            
            case (.invalidData, .invalidData):
                return true
            case (.invalidResponse, .invalidResponse):
                return true
            case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
                return lhsType.localizedDescription == rhsType.localizedDescription
            case (.custom(let lhsType), .custom(let rhsType)):
                return lhsType.localizedDescription == rhsType.localizedDescription
            case (.failedToFetchImages, .failedToFetchImages):
                return true
            default:
                return false
            }
        }
}
