//
//  MainTabBarCoordinator.swift
//  CinemaPoint
//
//  Created by diyor on 17/10/25.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var onLogout: (() -> Void)?

    private var moviesCoordinator: MoviesCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?
    private var profileCoordinator: ProfileCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = MainTabBarController()

        // Movies
        let moviesNav = UINavigationController()
        moviesCoordinator = MoviesCoordinator(navigationController: moviesNav)
        moviesCoordinator?.start()
        moviesNav.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)

        // Favorites
        let favoritesNav = UINavigationController()
        favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNav)
        favoritesCoordinator?.start()
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)

        // Profile
        let profileNav = UINavigationController()
        profileCoordinator = ProfileCoordinator(navigationController: profileNav)
        profileCoordinator?.onLogout = { [weak self] in
            self?.onLogout?()
        }
        profileCoordinator?.start()

        tabBarController.viewControllers = [
            moviesNav,
            favoritesNav,
            profileCoordinator!.navigationController
        ]

        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.isNavigationBarHidden = true
    }
}
