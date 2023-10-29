//
//  AppCoordinator.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    
    private var window: UIWindow
    internal var childCoordinators: [CoordinatorTypes: Coordinator]
    internal var navigationController: UINavigationController
    
    public var rootViewController: UIViewController {
        return navigationController
    }
    
    init(in window: UIWindow) {
        self.childCoordinators = [:]
        self.navigationController = UINavigationController()
        self.window = window
        self.window.backgroundColor = .white
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    public func start() {
        let homeCoordinator = HomeCoordinator(with: navigationController)
        addChild(coordinator: homeCoordinator, with: .homeCoodinator)
    }
}
