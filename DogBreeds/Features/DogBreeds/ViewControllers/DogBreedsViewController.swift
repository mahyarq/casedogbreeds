//
//  DogBreedsViewController.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit
import Combine

protocol DogBreedTableViewCellDelegate: AnyObject {
    func didTapCell(for dog: Dog)
}

class DogBreedsViewController: UIViewController {
    // MARK: UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(DogBreedTableViewCell.self,
                           forCellReuseIdentifier: DogBreedTableViewCell.cellId)
        tableView.register(ErrorTableViewCell.self,
                           forCellReuseIdentifier: ErrorTableViewCell.cellId)
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by dog breed"
        searchController.hidesNavigationBarDuringPresentation = true
        let directionalMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        searchController.searchBar.directionalLayoutMargins = directionalMargins
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        return searchController

    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handlePullToRefresh),
                                 for: .valueChanged)
        refreshControl.tintColor = Theme.textColor
        refreshControl.backgroundColor = Theme.backgroundColor
        return refreshControl
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    var searchResults: [Dog] = []
    var sortedDogs: [String: [Dog]] = [:]
    var sortedDogKeys: [String] = []
    var error: NetworkingManager.NetworkingError?
    
    var hasError: Bool {
        error != nil
    }
    
    // MARK: Binding View Model
    lazy var viewModel = DogBreedsViewModel()
    private lazy var cancellables: Set<AnyCancellable> = []
    
    private func bindViewModel() {
        viewModel.$sortedDogs
                    .sink { [weak self] sortedDogs in
                        self?.sortedDogs = sortedDogs
                        self?.reloadTableView()
                    }
                    .store(in: &cancellables)
        viewModel.$sortedDogKeys
                    .sink { [weak self] sortedKeys in
                        self?.sortedDogKeys = sortedKeys
                        self?.reloadTableView()
                    }
                    .store(in: &cancellables)
        viewModel.$error
                    .sink { [weak self] in self?.handleError($0) }
                    .store(in: &cancellables)
        viewModel.$isLoading
                    .sink { [weak self] in self?.handleLoading($0) }
                    .store(in: &cancellables)
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDogBreeds()
        bindViewModel()
    }
}

// MARK: Setup & handlers
extension DogBreedsViewController {
    func setup() {
        view.backgroundColor = Theme.backgroundColor
        tableView.backgroundColor = Theme.backgroundColor
        tableView.tableHeaderView = searchController.searchBar
        tableView.refreshControl = refreshControl
        
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.addSubview(loadingIndicator)
        tableView.addSubview(refreshControl)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            
            loadingIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -50),
            loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        ])
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func handleError(_ error: NetworkingManager.NetworkingError?) {
        guard let error else { return }
        self.error = error
        tableView.reloadData()
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func handleLoading(_ isLoading: Bool) {
        guard !refreshControl.isRefreshing else { return }
        if isLoading {
            self.loadingIndicator.alpha = 0
            self.loadingIndicator.startAnimating()
            UIView.animate(withDuration: 0.3) {
                self.loadingIndicator.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.loadingIndicator.alpha = 0
            }, completion: { _ in
                self.loadingIndicator.stopAnimating()
            })
        }
    }

    @objc func handlePullToRefresh() {
        viewModel.fetchDogBreeds()
        if hasError {
            error = nil
            tableView.reloadData()
        }
    }
}

// MARK: Delegates
extension DogBreedsViewController: DogBreedTableViewCellDelegate {
    func didTapCell(for dog: Dog) {
        if searchController.isActive {
            resetSearch()
        }
        let dogImagesVC = DogImagesViewController(dog: dog)
        dogImagesVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dogImagesVC, animated: true)
    }
}

extension DogBreedsViewController: ErrorViewTapActionDelegate {
    func didRetryFetching() {
        viewModel.fetchDogBreeds()
        error = nil
        tableView.reloadData()
    }
}
