//
//  MainCoordinator.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    func start()
}

// MARK: - CoordinatorProtocol

final class MainCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = RocketListViewModel(coordinator: self)
        let viewController = RocketListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - RocketListCoordinatorProtocol

extension MainCoordinator: RocketListCoordinatorProtocol {

    func onRocketTapped(_ rocket: Rocket) {
        let viewModel = RocketDetailsViewModel(rocket: rocket)
        let viewController = RocketDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
