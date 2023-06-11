//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

class AppCoordinator: Coordinator {

//  MARK: - Properties
    var window: UIWindow

    var onDismiss: VoidCompletion?
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()

//  MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
    }

//  MARK: - Coordination
    func start() {
        goToLanding()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func goToLanding() {
        let coordinator = LandingCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.onDismiss = { [weak self] in
            self?.removeChild(coordinator)
            self?.goToConverterScreen()
        }
    }

    func goToConverterScreen() {
        let coordinator = ConverterCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.onDismiss = { [weak self] in
            self?.removeChild(coordinator)
        }
    }
}
