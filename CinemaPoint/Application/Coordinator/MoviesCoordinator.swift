//
//  MovieCoordinator.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import UIKit

// MARK: - MoviesCoordinator
final class MoviesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MoviesListViewModel()
        let moviesVC = MoviesListViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.setViewControllers([moviesVC], animated: false)
    }
    
    // MARK: - showMovieDetails
    func showMovieDetails(for movie: Movie) {
        let detailsViewModel = MovieDetailsViewModel(movie: movie)
        let detailsVC = MovieDetailsViewController(viewModel: detailsViewModel, coordinator: self) // 👈 добавили self
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
