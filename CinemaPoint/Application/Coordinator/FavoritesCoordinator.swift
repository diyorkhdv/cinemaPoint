//
//  FavoritesCoordinator.swift
//  CinemaPoint
//
//  Created by diyor on 16/10/25.
//


import UIKit

final class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = FavoritesViewModel()
        let favoritesVC = FavoritesViewController(viewModel: viewModel)
        navigationController.setViewControllers([favoritesVC], animated: false)
    }
}
