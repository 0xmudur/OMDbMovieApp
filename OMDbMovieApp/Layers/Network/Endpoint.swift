//
//  Endpoint.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func search(matching query: String, pagination number: Int?) -> Endpoint {
        var queryItems = [URLQueryItem(name: "apikey", value: "2e1e970c"),
                          URLQueryItem(name: "s", value: query)]
        if let number = number {
            queryItems.append(URLQueryItem(name: "page", value: "\(number)"))
        }
        
        return Endpoint(path: "/", queryItems: queryItems)
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "omdbapi.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}

