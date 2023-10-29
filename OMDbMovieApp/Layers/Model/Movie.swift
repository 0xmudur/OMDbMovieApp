//
//  Movie.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 29.10.2023.
//

import Foundation

struct Movie: Decodable {
    let title: String?
    let year: String?
    let imdbID : String?
    let type: MovieType?
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case title = "Title"
        case year =  "Year"
        case poster = "Poster"
        case imdbID
    }
    
    enum MovieType : String, Decodable {
        case game
        case movie
        case series
    }
}
