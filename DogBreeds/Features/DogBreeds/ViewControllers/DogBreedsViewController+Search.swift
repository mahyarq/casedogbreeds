//
//  DogBreedsViewController+Search.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

// MARK: Search Bar updating
extension DogBreedsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        filterDogsForSearch(with: query)
    }
    
    func filterDogsForSearch(with searchText: String) {
        searchResults = viewModel.dogs.filter { dog -> Bool in
            dog.breed.contains(searchText.lowercased())
        }
        searchResults.sort(by: { $0.breed < $1.breed })
        reloadTableView()
    }
    
    func resetSearch() {
        searchController.dismiss(animated: false)
        searchController.searchBar.text = ""
    }
}
