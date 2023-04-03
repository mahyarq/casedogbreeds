//
//  DogBreedsViewModel.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import Combine

final class DogBreedsViewModel: ObservableObject {
    @Published private(set) var sortedDogs: [String: [Dog]] = [:]
    @Published private(set) var sortedDogKeys: [String] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading = false
    private(set) var dogs: [Dog] = []

    private let networkingManager: NetworkingManagerImpl

    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    func fetchDogBreeds() {
        isLoading = true
        error = nil
        
        networkingManager.request(
            session: .shared,
            endpoint: .dogBreeds,
            type: DogBreedsResponse.self
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.mapToDogs(from: response)
                self.isLoading = false
            case .failure(let error):
                if let networkingError = error as? NetworkingManager.NetworkingError {
                    self.error = networkingError
                } else {
                    self.error = .custom(error: error)
                }
                self.isLoading = false
            }
        }
    }
    
    func mapToDogs(from response: DogBreedsResponse) {
        dogs = response.breeds.flatMap { breed -> [Dog] in
            if breed.value.isEmpty {
                return [Dog(breed: breed.key, imagePath: breed.key)]
            } else {
                return breed.value.map {
                    let dogBreed = $0 + " " + breed.key
                    return Dog(breed: dogBreed, imagePath: "\(breed.key)/\($0)")
                }
            }
        }
        self.sortDogsAlphabetically()
    }
    
    private func sortDogsAlphabetically() {
        dogs.forEach { dog in
            let firstLetter = String(dog.breed.prefix(1))
            if var dogsForLetter = sortedDogs[firstLetter] {
                guard !dogsForLetter.contains(where: { $0.breed == dog.breed} ) else { return }
                dogsForLetter.append(dog)
                sortedDogs[firstLetter] = dogsForLetter
            } else {
                sortedDogs[firstLetter] = [dog]
            }
        }
        sortedDogKeys = Array(sortedDogs.keys).sorted()
        sortedDogKeys.forEach { key in
            sortedDogs[key]?.sort(by: { $0.breed < $1.breed })
        }
    }
}
