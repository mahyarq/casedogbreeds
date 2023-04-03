//
//  ImageCachingManagerTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import XCTest
@testable import DogBreeds

final class ImageCachingManagerTests: XCTestCase {
    private var networkingMock: NetworkingManagerImpl!
    private var imageCachingManager: ImageCachingManager!
    private let testKey = "TestFavoriteData"
    
    override func setUp() {
        networkingMock = NetworkingManagerImageRequestSuccessResponseMock()
        imageCachingManager = ImageCachingManager(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        imageCachingManager = nil
    }
    
    func testImageCachingImageWithImageFromCacheSuccess() {
        let url = MockData.mockURL
        let image = MockData.image
        
        imageCachingManager.cachedImages.setObject(image!, forKey: url)
        
        XCTAssertEqual(imageCachingManager.image(url: url), image)
    }
    
    func testImageCachingImageLoadFromNetworkSuccess() {
        let expectation = XCTestExpectation(description: "Wait for image load to complete")
        let url = MockData.mockURL
        
        imageCachingManager.load(url: url) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure(_):
                XCTFail("Failed to load image from network")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
