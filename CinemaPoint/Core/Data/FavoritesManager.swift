//
//  FavoritesManager.swift
//  CinemaPoint
//
//  Created by diyor on 16/10/25.
//


import CoreData

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let context = CoreDataManager.shared.context

    private init() {}

    // MARK: - Add
    func addToFavorites(movie: Movie) {
        if isFavorite(id: movie.id) {
            return
        }
        let favorite = FavoriteMovie(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.overview = movie.overview
        favorite.posterPath = movie.posterPath
        favorite.voteAverage = movie.voteAverage
        save()
    }

    // MARK: - Remove
    func removeFromFavorites(id: Int) {
        let fetch: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %d", id)

        if let result = try? context.fetch(fetch), let movie = result.first {
            print("FavoritesManager Удалён из избранного: \(movie.title ?? "Unknown")")
            context.delete(movie)
            save()
        } else {
            print("FavoritesManager Не найден фильм с id \(id) для удаления.")
        }
    }

    // MARK: - Check
    func isFavorite(id: Int) -> Bool {
        let fetch: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %d", id)
        let count = (try? context.count(for: fetch)) ?? 0
        let result = count > 0
        return result
    }

    // MARK: - Fetch All
    func fetchFavorites() -> [FavoriteMovie] {
        let fetch: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        let result = (try? context.fetch(fetch)) ?? []
        return result
    }

    // MARK: - Save
    private func save() {
        CoreDataManager.shared.saveContext()
    }
}
