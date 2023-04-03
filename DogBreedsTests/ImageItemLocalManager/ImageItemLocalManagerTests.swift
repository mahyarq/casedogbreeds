//
//  ImageItemLocalManagerTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import XCTest
@testable import DogBreeds

class ImageItemLocalManagerTests: XCTestCase {
    private var imageItemLocalManager: ImageItemLocalManager!
    private let testKey = "TestFavoriteData"
    
    override func setUp() {
        imageItemLocalManager = ImageItemLocalManager(key: testKey)
    }
    
    override func tearDown() {
        imageItemLocalManager = nil
        UserDefaults.standard.removeObject(forKey: testKey)
    }
    
    
    func testSetFavorite() {
        let imageItem = MockData.imageItem
        imageItemLocalManager.setFavorite(imageItem: imageItem)
        
        XCTAssertTrue(
            imageItemLocalManager.getAllFavorites().contains(where: { $0.url == imageItem.url}),
            "imageItem should be in user defaults"
        )
    }
    
    func testUnsetFavorite() {
        let imageItem = MockData.imageItem
        imageItemLocalManager.setFavorite(imageItem: imageItem)
        XCTAssertFalse(imageItemLocalManager.getAllFavorites().isEmpty,
                       "imageItem should be in user defaults")
        
        imageItemLocalManager.unsetFavorite(imageItem: imageItem)
        
        // then
        XCTAssertTrue(imageItemLocalManager.getAllFavorites().isEmpty,
                      "User defaults should be empty after unset favorite")
    }

    func testGetAllFavorites() {
        let imageItem = MockData.imageItem
        let imageItem1 = MockData.imageItem1
        imageItemLocalManager.setFavorite(imageItem: imageItem)
        imageItemLocalManager.setFavorite(imageItem: imageItem1)

        let allFavorites = imageItemLocalManager.getAllFavorites()

        XCTAssertTrue(allFavorites[0].url == imageItem.url)
        XCTAssertTrue(allFavorites[1].url == imageItem1.url)
    }

    func testGetFavoritesForDogBreed() {
        let imageItem = MockData.imageItem
        let imageItem1 = MockData.imageItem1
        let imageItem2 = MockData.imageItem2
        
        
        imageItemLocalManager.setFavorite(imageItem: imageItem)
        imageItemLocalManager.setFavorite(imageItem: imageItem1)
        imageItemLocalManager.setFavorite(imageItem: imageItem2)

        let boxerFavorites = imageItemLocalManager.getFavorites(for: MockData.dog.breed)
        let akitaFavorites = imageItemLocalManager.getFavorites(for: MockData.dog1.breed)

        // then
        XCTAssertEqual(boxerFavorites.count, 2)
        XCTAssertTrue(boxerFavorites[0].url == imageItem.url)
        XCTAssertTrue(boxerFavorites[1].url == imageItem1.url)
        
        XCTAssertEqual(akitaFavorites.count, 1)
        XCTAssertTrue(akitaFavorites[0].url == imageItem2.url)
    }
}
