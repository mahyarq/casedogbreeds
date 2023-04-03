//
//  TabBarController.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        
        tabBar.tintColor = .label
        setupVCs()
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(
                for: DogBreedsViewController(),
                title: "All DogBreeds",
                image: Assets.magnifyingGlass
            ),
            createNavController(
                for: FavoriteImagesViewController(),
                title: "Favorite images",
                image: Assets.heartFill
            ),
            createNavController(
                for: SettingsViewController(),
                title: "Settings",
                image: Assets.settings
            ),
            
        ]
    }

    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage?
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        configureTabBarAppearence()
        
        return navController
    }
    
    private func configureTabBarAppearence() {
        // Fix issue with tabbar being transparent on smaller devices
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
}
