//
//  HomeCoordinator.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    internal var navigationController: UINavigationController
    internal var childCoordinators: [CoordinatorTypes: Coordinator]
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = [:]
        start()
    }
    
    internal func start() {
        let homeViewController = HomeBuilderImplementation().build(coordinatorDelegate: self)
        navigate(to: homeViewController, with: .push)
    }
    
    internal func navigateToMovieDetail(data: Movie) {
        let movieDetailViewController = MovieDetailBuilderImplementation().build(coordinatorDelegate: self, data: data)
        navigate(to: movieDetailViewController, with: .push, animated: false)
    }
}
