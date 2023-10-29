//
//  MovieDetailBuilder.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 29.10.2023.
//

import UIKit

protocol MovieDetailBuilder {
    func build(coordinatorDelegate: Coordinator?, data: Movie) -> UIViewController
}

struct MovieDetailBuilderImplementation: MovieDetailBuilder {
    
    func build(coordinatorDelegate: Coordinator?, data: Movie) -> UIViewController {
        let viewController = MovieDetailViewController()
        viewController.coordinatorDelegate = coordinatorDelegate
        viewController.injectDependencies(data: data)
        return viewController
    }
}
