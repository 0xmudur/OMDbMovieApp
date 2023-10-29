//
//  FilmSearchResult.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import Foundation

struct MoviesPage: Decodable {
    let movies: [Movie]?
    let totalResults: String?
    let response: String?
    
    private enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}




