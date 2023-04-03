//
//  DogBreedsViewController+TableView.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

// MARK: TableView Datasource
extension DogBreedsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive || hasError {
            return 1
        }
        return sortedDogKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive || hasError {
            return nil
        }
        return sortedDogKeys[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        }
        if hasError {
            return 1
        }
        
        let key = sortedDogKeys[section]
        if let dogsForKey = sortedDogs[key] {
            return dogsForKey.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let error {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.cellId, for: indexPath) as? ErrorTableViewCell else { return ErrorTableViewCell() }
            cell.configure(error: error, delegate: self)
            
           return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DogBreedTableViewCell.cellId, for: indexPath) as? DogBreedTableViewCell
        else { return DogBreedTableViewCell() }
        
        if searchController.isActive && !searchResults.isEmpty {
            cell.configure(dog: searchResults[indexPath.row], delegate: self)
        } else {
            let key = sortedDogKeys[indexPath.section]
            cell.configure(dog: sortedDogs[key]?[indexPath.row], delegate: self)
        }
        
        
        return cell
    }
}


// MARK: TableView Delegate
extension DogBreedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hasError {
            return view.frame.height * 0.5
        }
        return UITableView.automaticDimension
    }
}
