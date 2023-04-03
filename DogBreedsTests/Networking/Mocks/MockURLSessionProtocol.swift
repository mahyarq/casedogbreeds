//
//  MockURLSessionProtocol.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import Foundation
import XCTest

typealias MockLoadingHandler = (() -> (HTTPURLResponse, Data?))

class MockURLSessionProtocol: URLProtocol {
    static var loadingHandler: MockLoadingHandler?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLSessionProtocol.loadingHandler else {
            XCTFail("Loading handler is not set")
            return
        }
        
        let (response, data) = handler()
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
