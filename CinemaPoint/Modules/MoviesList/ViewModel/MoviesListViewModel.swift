//
//  MoviesListViewModel.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import Foundation

enum MoviesMode {
    case popular
    case search(query: String)
}

final class MoviesListViewModel {
    weak var coordinator: MoviesCoordinator?
    private let service = MovieService()

    private(set) var movies: [Movie] = []

    private(set) var mode: MoviesMode = .popular
    private var currentPage = 1
    private var isLoading = false
    private var canLoadMore = true

    // MARK: - Public API
    func resetToPopular(completion: @escaping () -> Void) {
        mode = .popular
        currentPage = 1
        canLoadMore = true
        movies.removeAll()
        fetchNextPage(completion: completion)
    }

    func startSearch(query: String, completion: @escaping () -> Void) {
        mode = .search(query: query)
        currentPage = 1
        canLoadMore = true
        movies.removeAll()
        fetchNextPage(completion: completion)
    }

    func fetchNextPage(completion: @escaping () -> Void) {
        guard !isLoading, canLoadMore else { completion(); return }
        isLoading = true

        let handleResult: (Result<[Movie], APIError>) -> Void = { [weak self] result in
            guard let self else { completion(); return }
            self.isLoading = false
            switch result {
            case .success(let new):
                if new.isEmpty { self.canLoadMore = false }
                self.movies.append(contentsOf: new)
                self.currentPage += 1
            case .failure(let error):
                print("|| Fetch error:", error)
                self.canLoadMore = false
            }
            completion()
        }

        switch mode {
        case .popular:
            service.fetchPopularMovies(page: currentPage, completion: handleResult)
        case .search(let q):
            service.searchMovies(query: q, page: currentPage, completion: handleResult)
        }
    }
}
