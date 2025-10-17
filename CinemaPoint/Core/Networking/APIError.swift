//
//  APIError.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//


import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Error)
}
