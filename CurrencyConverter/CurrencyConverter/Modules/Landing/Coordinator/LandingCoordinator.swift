//
//  LandingCoordinator.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

protocol LandingCoordinatorProtocol: Coordinator {
    func goToLanding()
    func goToConverter()
}

class LandingCoordinator: LandingCoordinatorProtocol {

    // MARK: - Properties
    var onDismiss: VoidCompletion?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start
    func start() {
        goToLanding()
    }

    func goToLanding() {
        let viewModel = LandingViewModel(coordinator: self)
        let destinationVC = LandingViewController(viewModel: viewModel)
        navigationController.setViewControllers([destinationVC], animated: true)
    }

    func goToConverter() {
        dismiss()
    }
}

