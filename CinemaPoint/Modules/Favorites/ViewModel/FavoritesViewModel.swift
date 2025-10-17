//
//  FavoritesViewModel.swift
//  CinemaPoint
//
//  Created by diyor on 16/10/25.
//

import Foundation

final class FavoritesViewModel {
    private(set) var favoriteMovies: [FavoriteMovie] = []

    func fetchFavorites(completion: @escaping () -> Void) {
        favoriteMovies = FavoritesManager.shared.fetchFavorites()
        completion()
    }

    func removeMovie(at index: Int, completion: @escaping () -> Void) {
        let movie = favoriteMovies[index]
        FavoritesManager.shared.removeFromFavorites(id: Int(movie.id))
        favoriteMovies.remove(at: index)
        completion()
    }
}
