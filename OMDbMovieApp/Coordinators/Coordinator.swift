//
//  Coordinator.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [CoordinatorTypes: Coordinator] { get set }
    
    func start()
    func addChild(coordinator: Coordinator, with key: CoordinatorTypes)
    func removeChild(coordinator: Coordinator)
}

extension Coordinator {
    
    func addChild(coordinator: Coordinator, with key: CoordinatorTypes) {
        childCoordinators[key] = coordinator
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.value !== coordinator }
    }
}

extension Coordinator {
    
    func navigate(to viewController: UIViewController, with presentationStyle: navigationStyle, animated: Bool = true) {
        switch presentationStyle {
        case .present:
            navigationController.present(viewController, animated: animated, completion: nil)
        case .push:
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
}

enum navigationStyle {
    case present
    case push
}
