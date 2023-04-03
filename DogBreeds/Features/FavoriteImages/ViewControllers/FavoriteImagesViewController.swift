//
//  FavoriteImagesViewController.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit
import Combine

class FavoriteImagesViewController: UIViewController {
    // MARK: UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(FavoriteImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteImageCollectionViewCell.cellId)
        collectionView.register(EmptyStateCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmptyStateCollectionViewCell.cellId)
        
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handlePullToRefresh),
                                 for: .valueChanged)
        refreshControl.tintColor = Theme.textColor
        
        return refreshControl
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .white
        button.setImage(Assets.filter, for: .normal)
        button.addGestureRecognizer(
            CustomTapGestureRecognizer(target: self, action: #selector(didTapFilter))
        )
        return button
    }()
    
    private lazy var resetFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.mainColor
        button.setTitle("Reset filter", for: .normal)
        button.titleLabel?.textColor = Theme.textColor
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.addGestureRecognizer(
            CustomTapGestureRecognizer(target: self, action: #selector(didTapResetFilter))
        )
        return button
    }()
    
    // MARK: Binding View Model
    var viewModel = FavoriteImagesViewModel()
    private lazy var cancellables: Set<AnyCancellable> = []
    
    var filteredImageItems: [ImageItem] = []
    var imageItems: [ImageItem] = []
    
    var hasFavorites: Bool {
        !imageItems.isEmpty
    }

    private func bindViewModel() {
        viewModel.$imageItems
            .sink { [weak self] in
                self?.imageItems = $0
                self?.reloadCollectionView()
            }
            .store(in: &cancellables)
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchFavoriteImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteImages()
        collectionView.setContentOffset(.zero, animated: false)
    }
}

// MARK: Handlers
extension FavoriteImagesViewController {
    func reloadCollectionView() {
        filterButton.isEnabled = hasFavorites
        collectionView.reloadData()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func handlePullToRefresh() {
        viewModel.fetchFavoriteImages()
    }
    
    @objc func didTapFilter() {
        let filterSheetVC = FilterSheetViewController()
        filterSheetVC.dogs = viewModel.getDogBreeds()
        filterSheetVC.delegate = self
        let nav = UINavigationController(rootViewController: filterSheetVC)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true)
    }
    
    @objc func didTapResetFilter() {
        resetFilterButton.isHidden = true
        filteredImageItems = []
        collectionView.reloadData()
    }
}

// MARK: Setup CollectionView
extension FavoriteImagesViewController {
    func setup() {
        view.backgroundColor = Theme.backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        collectionView.addSubview(resetFilterButton)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            resetFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            resetFilterButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            resetFilterButton.widthAnchor.constraint(equalToConstant: 150),
            resetFilterButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
        if let navTargetView = navigationController?.navigationBar {
            navTargetView.addSubview(filterButton)
            NSLayoutConstraint.activate([
                filterButton.bottomAnchor.constraint(equalTo: navTargetView.bottomAnchor, constant: -10),
                filterButton.trailingAnchor.constraint(equalTo: navTargetView.trailingAnchor, constant: -20),
                filterButton.widthAnchor.constraint(equalToConstant: 25),
                filterButton.heightAnchor.constraint(equalToConstant: 25),
            ])
        }
    }
}

// MARK: Delegates
extension FavoriteImagesViewController: DogImagesFavoriteDelegate {
    func didTapFavorite(_ imageItem: ImageItem) {
        viewModel.unsetFavorite(for: imageItem)
        filterButton.isEnabled = hasFavorites
    }
}

extension FavoriteImagesViewController: DogBreedTableViewCellDelegate {
    func didTapCell(for dog: Dog) {
        filteredImageItems = viewModel.imageItems.filter {
            $0.dog.breed == dog.breed
        }
        resetFilterButton.isHidden = false
        collectionView.reloadData()
    }
}
