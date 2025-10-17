//
//  MovieService.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import Foundation

final class MovieService {
    private let apiKey = "d9a478ef4fc9919cb4f05c2fa8fb1292"
    private let client = APIClient.shared
    
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<[Movie], APIError>) -> Void) {
        let endpoint = Endpoint(
            path: "movie/popular",
            queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: String(page))
            ]
        )

        client.request(endpoint: endpoint) { (result: Result<MovieResponse, APIError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              !q.isEmpty else {
            completion(.success([])); return
        }
        let endpoint = Endpoint(
            path: "search/movie",
            queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "query", value: q),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        )
        client.request(endpoint: endpoint) { (result: Result<MovieResponse, APIError>) in
            switch result {
            case .success(let response): completion(.success(response.results))
            case .failure(let error):    completion(.failure(error))
            }
        }
    }
    // MARK: - Similar movies
    func fetchSimilarMovies(for movieID: Int, completion: @escaping (Result<[Movie], APIError>) -> Void) {
        let endpoint = Endpoint(
            path: "movie/\(movieID)/similar",
            queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1")
            ]
        )

        client.request(endpoint: endpoint) { (result: Result<MovieResponse, APIError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
