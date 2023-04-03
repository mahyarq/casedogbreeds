//
//  NetworkingManagerTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import XCTest
@testable import DogBreeds

final class NetworkingManagerTests: XCTestCase {
    private let bundle = Bundle(for: NetworkingManagerTests.self)
    private var session: URLSession!
    private var url: URL!

    override func setUp() {
        url = URL(string: "https://dog.ceo")
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func testSuccessfulResponseIsValidResponseForDogBreeds() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        let jsonFilePath = "DogBreeds"
        guard let path = bundle.path(forResource: jsonFilePath, ofType: "json"),
              let data = FileManager.default.contents (atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            return (response!, data)
        }

        NetworkingManager.shared.request(session: session, endpoint: .dogBreeds, type: DogBreedsResponse.self) { result in
            switch result {
            case .success(let response):
                let staticJSON = try? StaticJSONMapper.decode(file: jsonFilePath, type: DogBreedsResponse.self)
                XCTAssertEqual(response, staticJSON)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSuccessfulResponseWithoutDataIsInvalid() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            return (response!, nil)
        }
        
        NetworkingManager.shared.request(session: session, endpoint: .dogBreeds, type: DogBreedsResponse.self) { result in
            switch result {
            case .success(_):
                XCTFail("Unexpectedly succeded")
            case .failure(let error):
                guard let networkingError = error as? NetworkingManager.NetworkingError else {
                    XCTFail("Got the wrong type of error, expecting NetworkingManager NetworkingError")
                    return
                }
                XCTAssertEqual(networkingError.errorDescription, "Failed to decode")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUnsuccessfulResponseCodeIsInvalid() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        let invalidStatusCode = 400
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: invalidStatusCode,
                httpVersion: nil,
                headerFields: nil
            )
            return (response!, nil)
        }
        
        NetworkingManager.shared.request(session: session, endpoint: .dogBreeds, type: DogBreedsResponse.self) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let networkingError = error as? NetworkingManager.NetworkingError else {
                    XCTFail("Got the wrong type of error, expecting NetworkingManager NetworkingError")
                    return
                }
                XCTAssertEqual(
                    networkingError,
                    NetworkingManager.NetworkingError.invalidStatusCode(statusCode: invalidStatusCode),
                    "Error should be a networking error which throws an invalid status code"
                )
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSuccessfulResponseWithInvalidJSONIsInvalid() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")

        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            return (response!, nil)
        }
        
        NetworkingManager.shared.request(session: session, endpoint: .dogBreeds, type: DogImagesResponse.self) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let networkingError = error as? NetworkingManager.NetworkingError else {
                    XCTFail("Got the wrong type of error, expecting NetworkingManager NetworkingError")
                    return
                }
                XCTAssertEqual(networkingError.errorDescription, "Failed to decode")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSuccessfulResponseWithValidResponseForAllImages() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        let jsonFilePath = "ImageUrls"
        let dogPath = "hound-afghan"
        
        guard let path = bundle.path(forResource: jsonFilePath, ofType: "json"),
              let data = FileManager.default.contents (atPath: path) else {
            XCTFail("Failed to get the static users file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
            url: self.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
            )
            return (response!, data)
        }

        NetworkingManager.shared.request(session: session, endpoint: .allImages(dogPath: dogPath), type: DogImagesResponse.self) { result in
            switch result {
            case .success(let response):
                let staticJSON = try? StaticJSONMapper.decode(file: jsonFilePath, type: DogImagesResponse.self)
                XCTAssertEqual(response, staticJSON)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSuccessfulResponseIsValidResponseForSingleImage() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        let image = UIImage(named: "dog-test-image")
        let dogPath = "hound-afghan"
        let cache = NSCache<NSURL, UIImage>()
        let imageUrl = NSURL(string: dogPath)!
        
        guard let image, let data = image.pngData() else {
            XCTFail("Failed to get the static image file and convert to Data")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
            url: self.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
            )
            return (response!, data)
        }

        NetworkingManager.shared.imageRequest(session: session, imageURL: imageUrl, cache: cache){ result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.pngData(), data)
                XCTAssertNotNil(cache.object(forKey: imageUrl))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSuccessfulResponseWithInvalidDataForSingleImage() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        let dogPath = "hound-afghan"
        let imageUrl = NSURL(string: dogPath)!

        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
            url: self.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
            )
            return (response!, nil)
        }

        NetworkingManager.shared.imageRequest(session: session, imageURL: imageUrl, cache: NSCache<NSURL, UIImage>()){ result in
            switch result {
            case .success(_):
                XCTFail("Unexpectedly succeded")
            case .failure(let error):
                guard let networkingError = error as? NetworkingManager.NetworkingError else {
                    XCTFail("Got the wrong type of error, expecting NetworkingManager NetworkingError")
                    return
                }
                XCTAssertEqual(networkingError, .invalidData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUnsuccessfulResponseCodeForSingleImage() {
        let expectation = XCTestExpectation(description: "Wait for response to complete")
        let dogPath = "hound-afghan"
        let imageUrl = NSURL(string: dogPath)!
        let invalidStatusCode = 400
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
            url: self.url,
            statusCode: invalidStatusCode,
            httpVersion: nil,
            headerFields: nil
            )
            return (response!, nil)
        }

        NetworkingManager.shared.imageRequest(session: session, imageURL: imageUrl, cache: NSCache<NSURL, UIImage>()){ result in
            switch result {
            case .success(_):
                XCTFail("Unexpectedly succeded")
            case .failure(let error):
                guard let networkingError = error as? NetworkingManager.NetworkingError else {
                    XCTFail("Got the wrong type of error, expecting NetworkingManager NetworkingError")
                    return
                }
                XCTAssertEqual(networkingError, .invalidStatusCode(statusCode: invalidStatusCode))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
