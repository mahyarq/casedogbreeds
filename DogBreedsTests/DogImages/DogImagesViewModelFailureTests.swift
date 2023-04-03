//
//  DogImagesViewModelFailureTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import XCTest
import Combine
@testable import DogBreeds

final class DogImagesViewModelFailureTests: XCTestCase {
    private var networkingMock: NetworkingManagerImpl!
    private var vm: DogImagesViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerDogImagesFailureMock()
        
        vm = DogImagesViewModel(
            dog: MockData.dog,
            networkingManager: networkingMock
        )
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func testDogImageItemsArrayIsSetSuccess() {
        let expect = XCTestExpectation(description: "Wait for publisher update")
        var cancellables: Set<AnyCancellable> = []
        
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        vm.fetchDogImages()
        vm.$error
            .sink {
                XCTAssertNotNil($0, "VM error should be set")
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        wait(for: [expect], timeout: 5)
    }
}
