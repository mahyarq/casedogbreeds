//
//  DogBreedsViewModelFailureTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 14/02/2023.
//

import XCTest
import Combine
@testable import DogBreeds

final class DogBreedsViewModelFailureTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var vm: DogBreedsViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerDogBreedsFailureMock()
        vm = DogBreedsViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func testDogBreedsFetchFailure() {
        let expect = XCTestExpectation(description: "Wait for publishers update")
        var cancellables: Set<AnyCancellable> = []
        
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        vm.fetchDogBreeds()
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
