//
//  DogBreedsViewModelSuccessTests.swift
//  DogBreedsTests
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import XCTest
import Combine
@testable import DogBreeds

final class DogBreedsViewModelSuccessTests: XCTestCase {
    
    private var networkingMock: NetworkingManagerImpl!
    private var vm: DogBreedsViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerDogBreedsSuccessResponseMock()
        vm = DogBreedsViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func testDogBreedsIsSetAndSortedSuccessful() {
        let expect = XCTestExpectation(description: "Wait for publishers update")
        var cancellables: Set<AnyCancellable> = []
        var dogsDict: [String: [Dog]] = [:]
        var dogKeys: [String] = []
        
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        vm.fetchDogBreeds()
        vm.$sortedDogs
            .sink { dogsDict = $0 }
            .store(in: &cancellables)
        vm.$sortedDogKeys
            .sink {
                dogKeys = $0
                XCTAssertEqual(dogKeys.count, 22, "There should be 22 keys in dogsKeys")
                XCTAssertEqual(dogKeys, Array(dogsDict.keys).sorted())
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertEqual(vm.dogs.count, 148, "There should be 148 dogs")
        XCTAssertFalse(vm.isLoading, "ViewModel shouldnt be loading anything")
        wait(for: [expect], timeout: 5)
    }
    
    func testDogBreedsMappingResponseToDogsDictionarySuccessful() {
        let dogBreedsResponse = DogBreedsResponse(breeds: [
            "briard": [],
            "buhund": [
                "norwegian"
            ],
            "bulldog": [
                "boston",
                "english",
                "french"
            ],
        ])
        vm.mapToDogs(from: dogBreedsResponse)
        
        let briardDog = vm.dogs.first(where: { $0.breed == "briard" })
        XCTAssertNotNil(briardDog, "Expect to return key if value is empty")
        
        let norwegianBuhund = vm.dogs.first(where: { $0.breed == "norwegian buhund" })
        XCTAssertNotNil(norwegianBuhund, "Expect to combine the each value for key")
        
        let bostonBulldog = vm.dogs.first(where: { $0.breed == "boston bulldog" })
        XCTAssertNotNil(bostonBulldog, "Expect to combine the each value for key")
        
        let englishBulldog = vm.dogs.first(where: { $0.breed == "english bulldog" })
        
        XCTAssertNotNil(englishBulldog, "Expect to combine the each value for key")
        
        let frenchBulldog = vm.dogs.first(where: { $0.breed == "french bulldog" })
        XCTAssertNotNil(frenchBulldog, "Expect to combine the each value for key")
    }
}
