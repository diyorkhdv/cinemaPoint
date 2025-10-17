//
//  Endpoint.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import Foundation

struct Endpoint {
    private let path: String
    private let queryItems: [URLQueryItem]

    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/\(path)"
        components.queryItems = queryItems
        return components.url
    }
}
