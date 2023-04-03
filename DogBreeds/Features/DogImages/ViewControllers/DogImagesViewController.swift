//
//  DogImagesViewController.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 12/02/2023.
//

import UIKit
import Combine

protocol DogImagesFavoriteDelegate: AnyObject {
    func didTapFavorite(_ imageItem: ImageItem)
}

class DogImagesViewController: UIViewController {
    // MARK: UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(DogImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: DogImageCollectionViewCell.cellId)
        collectionView.register(ErrorCollectionViewCell.self,
                                forCellWithReuseIdentifier: ErrorCollectionViewCell.cellId)
        
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handlePullToRefresh),
                                 for: .valueChanged)
        refreshControl.tintColor = Theme.textColor
        refreshControl.layer.zPosition = -1
        return refreshControl
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: Binding View Model
    var viewModel: DogImagesViewModel
    private lazy var cancellables: Set<AnyCancellable> = []
    var error: NetworkingManager.NetworkingError?
    
    var hasError: Bool {
        error != nil
    }

    private func bindViewModel() {
        viewModel.$imageItems
            .sink { [weak self] _ in self?.reloadCollectionView() }
                    .store(in: &cancellables)
        viewModel.$error
            .sink { [weak self] in self?.handleError($0) }
                    .store(in: &cancellables)
        viewModel.$isLoading
                    .sink { [weak self] in self?.handleLoading($0) }
                    .store(in: &cancellables)
    }
    
    // MARK: Lifecycle
    init(dog: Dog) {
        self.viewModel = DogImagesViewModel(dog: dog)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchDogImages()
    }
}

// MARK: Setup + handlers
extension DogImagesViewController {
    func setup() {
        view.backgroundColor = Theme.backgroundColor
        navigationItem.title = "\(viewModel.dog.breed.capitalized) images"
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.addSubview(loadingIndicator)
        collectionView.addSubview(refreshControl)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            loadingIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -50),
            loadingIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),

        ])
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func handleError(_ error: NetworkingManager.NetworkingError?) {
        guard let error else { return }
        self.error = error
        collectionView.reloadData()
        
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
        viewModel.fetchDogImages()
        if hasError {
            error = nil
            collectionView.reloadData()
        }
    }
    
}

// MARK: Delegates
extension DogImagesViewController: ErrorViewTapActionDelegate {
    func didRetryFetching() {
        viewModel.fetchDogImages()
        error = nil
        collectionView.reloadData()
    }
}

extension DogImagesViewController: DogImagesFavoriteDelegate {
    func didTapFavorite(_ imageItem: ImageItem) {
        viewModel.favoriteImage(for: imageItem)
    }
}
