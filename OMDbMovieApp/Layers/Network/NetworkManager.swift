//
//  NetworkManager.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchMovies(search: String, page: Int?, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let endpoint: Endpoint = .search(matching: search, pagination: page)
        
        guard let url = endpoint.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data,
               let result = try? JSONDecoder().decode(MoviesPage.self, from: data), let movies = result.movies {
                completion(.success(movies))
            } else {
                completion(.success([]))
            }
            
        }.resume()
    }
}


