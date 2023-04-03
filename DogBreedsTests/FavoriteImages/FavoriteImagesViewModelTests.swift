//
//  FavoriteImagesViewModelTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import XCTest
import Combine
@testable import DogBreeds

final class FavoriteImagesViewModelTests: XCTestCase {
    private var imageItemLocalMock: ImageItemLocalManagerImpl!
    private var imageCachingMock: ImageCachingManagerImpl!
    private var vm: FavoriteImagesViewModel!
    
    override func setUp() {
        imageItemLocalMock = ImageItemLocalManagerResponseMock()
        imageCachingMock = ImageCachingManagerResponseMock()

        vm = FavoriteImagesViewModel(
            imageItemLocalManager: imageItemLocalMock,
            imageCachingManager: imageCachingMock
        )
    }
    
    override func tearDown() {
        imageItemLocalMock = nil
        imageCachingMock = nil
        vm = nil
    }

    func testFavoriteImagesLoadFavoritesSuccess() {
        let expect = XCTestExpectation(description: "Wait for publisher update")
        var cancellables: Set<AnyCancellable> = []
        let favoriteItem = MockData.imageItem
        let favoriteItem1 = MockData.imageItem1
        
        imageItemLocalMock.setFavorite(imageItem: favoriteItem)
        imageItemLocalMock.setFavorite(imageItem: favoriteItem1)
        
        vm.fetchFavoriteImages()
        vm.$imageItems
            .sink { imageItems in
                XCTAssertEqual(imageItems.count, 2, "There should be 2 favorited imageItems")
                XCTAssertEqual(imageItems[0].url, favoriteItem.url)
                XCTAssertEqual(imageItems[1].url, favoriteItem1.url)
                expect.fulfill()
            }
            .store(in: &cancellables)
        

        wait(for: [expect], timeout: 5)
    }
    
    func testFetchImageSuccess() {
        let expect = expectation(description: "Completion handler called")
        let favoriteItem = MockData.imageItem

        imageItemLocalMock.setFavorite(imageItem: favoriteItem)
        
        vm.fetchFavoriteImages()
        vm.fetchImage(for: 0) { imageItem in
            XCTAssertEqual(imageItem.url, favoriteItem.url, "URL of returned item should match input item")
            XCTAssertNotNil(imageItem.image, "Image should not be nil after fetching")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testDogImagesUnsetFavoriteSuccess() {
        let favoriteItem = MockData.imageItem
        
        imageItemLocalMock.setFavorite(imageItem: favoriteItem)
        XCTAssertTrue(imageItemLocalMock.getAllFavorites()[0].url == favoriteItem.url,
                       "Expect imageItem to in from cache")
        
        vm.unsetFavorite(for: favoriteItem)
        let cachedItems = imageItemLocalMock.getFavorites(for: MockData.dog.breed)
        
        XCTAssertFalse(cachedItems.contains(where: { $0.url == favoriteItem.url }),
                       "Expect imageItem to be removed from cache")
    }
    
    func testDogBreedsAreMappedFromImageItemsSuccess() {
        let favoriteItem = MockData.imageItem
        let favoriteItem1 = MockData.imageItem1
        
        imageItemLocalMock.setFavorite(imageItem: favoriteItem)
        imageItemLocalMock.setFavorite(imageItem: favoriteItem1)
        XCTAssertTrue(imageItemLocalMock.getAllFavorites().count == 2,
                      "Expect imageItems to in from cache")
        
        vm.fetchFavoriteImages()
        XCTAssertTrue(vm.imageItems.count == 2, "Expect imageItems to be fetched")
        
        let dogs = vm.getDogBreeds()
        XCTAssertEqual(dogs, [MockData.dog], "Expect array of dog to be mapped from imageItems and unique by breed")
    }
}
