//
//  ConverterCoordinator.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

protocol ConverterCoordinatorProtocol: Coordinator {
    func goToConverter()
}

class ConverterCoordinator: ConverterCoordinatorProtocol {

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
        goToConverter()
    }

    func goToConverter() {
        let viewModel = ConverterViewModel(coordinator: self)
        let destinationVC = ConverterViewController(viewModel: viewModel)
        navigationController.setViewControllers([destinationVC], animated: true)
    }
}

