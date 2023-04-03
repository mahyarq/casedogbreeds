//
//  DogImagesViewModelSuccessTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import XCTest
import Combine
@testable import DogBreeds

final class DogImagesViewModelSuccessTests: XCTestCase {
    private var networkingMock: NetworkingManagerImpl!
    private var imageItemLocalMock: ImageItemLocalManagerImpl!
    private var imageCachingMock: ImageCachingManagerImpl!
    private var vm: DogImagesViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerDogImagesSuccessResponseMock()
        imageItemLocalMock = ImageItemLocalManagerResponseMock()
        imageCachingMock = ImageCachingManagerResponseMock()

        vm = DogImagesViewModel(
            dog: MockData.dog,
            networkingManager: networkingMock,
            imageItemLocalManager: imageItemLocalMock,
            imageCachingManager: imageCachingMock
        )
    }
    
    override func tearDown() {
        networkingMock = nil
        imageItemLocalMock = nil
        imageCachingMock = nil
        vm = nil
    }
    
    func testDogImageItemsArrayIsSetSuccess() {
        let expect = XCTestExpectation(description: "Wait for publisher update")
        var cancellables: Set<AnyCancellable> = []
        
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        vm.fetchDogImages()
        vm.$imageItems
            .sink { imageItems in
                XCTAssertEqual(imageItems.count, 149, "There should be 149 items in imageItems")
                imageItems.forEach {
                    XCTAssertNotNil($0.image, "Expect all items to have a placeholder image")
                    XCTAssertEqual($0.dog, MockData.dog, "All dogs in item should match the provided ViewModel dog")
                }
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertEqual(vm.dog, MockData.dog, "The VM dog should be the provided dog")
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        wait(for: [expect], timeout: 5)
    }
    
    func testDogImagesLoadFavoritesSuccess() {
        let expect = XCTestExpectation(description: "Wait for publisher update")
        var cancellables: Set<AnyCancellable> = []
        let favoriteItem = MockData.imageItem
        let favoriteItem1 = MockData.imageItem1
        
        self.imageItemLocalMock.setFavorite(imageItem: favoriteItem)
        self.imageItemLocalMock.setFavorite(imageItem: favoriteItem1)
        
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        vm.fetchDogImages()
        vm.$imageItems
            .sink { imageItems in
                XCTAssertEqual(imageItems.count, 149, "There should be 149 items in imageItems")
                let favoritedItems = imageItems.filter {
                    $0.isFavorite == true
                }
                if favoritedItems.count == 2 {
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        

        wait(for: [expect], timeout: 5)
    }
    
    func testDogImagesSetFavoriteSuccess() {
        let favoriteItem = MockData.imageItem
        favoriteItem.isFavorite = true
        vm.favoriteImage(for: favoriteItem)
        
        let cachedItems = imageItemLocalMock.getFavorites(for: MockData.dog.breed)
        XCTAssertTrue(cachedItems.contains(where: { $0.url == favoriteItem.url }),
                      "Expect imageItem to be added to cache")
    }
    
    func testDogImagesUnsetFavoriteSuccess() {
        let favoriteItem = MockData.imageItem
        favoriteItem.isFavorite = true
        imageItemLocalMock.setFavorite(imageItem: favoriteItem)
        XCTAssertTrue(imageItemLocalMock.getAllFavorites()[0].url == favoriteItem.url,
                       "Expect imageItem to be in cache")

        favoriteItem.isFavorite = false
        vm.favoriteImage(for: favoriteItem)
        let cachedItems = imageItemLocalMock.getFavorites(for: MockData.dog.breed)
        
        XCTAssertFalse(cachedItems.contains(where: { $0.url == favoriteItem.url }),
                       "Expect imageItem to be removed from cache")
    }
    
    func testFetchImageSuccess() {
        let expect = expectation(description: "Completion handler called")
        let item = MockData.imageItem
        
        vm.fetchDogImages()
        vm.fetchImage(for: 0) { imageItem in
            XCTAssertEqual(imageItem.url, item.url, "URL of returned item should match input item")
            XCTAssertNotNil(imageItem.image, "Image should not be nil after fetching")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}
