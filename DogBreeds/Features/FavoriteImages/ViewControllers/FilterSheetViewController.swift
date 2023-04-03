//
//  FilterSheetViewController.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

class FilterSheetViewController: UIViewController {
    // MARK: UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(DogBreedTableViewCell.self,
                           forCellReuseIdentifier: DogBreedTableViewCell.cellId)
        return tableView
    }()
    
    var dogs: [Dog] = []
    weak var delegate: DogBreedTableViewCellDelegate?

    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
}

// MARK: Setup
extension FilterSheetViewController {
    func setup() {
        view.backgroundColor = Theme.backgroundColor
        navigationItem.title = "Filter by dog"
        tableView.backgroundColor = Theme.backgroundColor
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: TableView DataSource
extension FilterSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DogBreedTableViewCell.cellId, for: indexPath) as? DogBreedTableViewCell
        else { return DogBreedTableViewCell() }
    
        cell.configure(dog: dogs[indexPath.row], delegate: self)
        
        return cell
    }
}

// MARK: TableView Delegate
extension FilterSheetViewController: DogBreedTableViewCellDelegate {
    func didTapCell(for dog: Dog) {
        delegate?.didTapCell(for: dog)
        dismiss(animated: true)
    }
}
