//
//  HomeBuilder.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

protocol HomeBuilder {
    func build(coordinatorDelegate: Coordinator?) -> UIViewController
}

struct HomeBuilderImplementation: HomeBuilder {
    
    func build(coordinatorDelegate: Coordinator?) -> UIViewController {
        let viewController = HomeViewController()
        let viewModel = HomeViewModelImplementation()
        viewController.coordinatorDelegate = coordinatorDelegate
        viewController.injectDependencies(viewModel: viewModel)
        return viewController
    }
}
