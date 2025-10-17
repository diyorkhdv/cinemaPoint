//
//  MovieDetailsViewModel.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//


import Foundation

final class MovieDetailsViewModel {
    let movie: Movie
    private let service = MovieService()
    private(set) var similarMovies: [Movie] = []
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchSimilar(completion: @escaping () -> Void) {
        service.fetchSimilarMovies(for: movie.id) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.similarMovies = movies
            case .failure(let error):
                print("|| Similar error:", error)
            }
            completion()
        }
    }
}
