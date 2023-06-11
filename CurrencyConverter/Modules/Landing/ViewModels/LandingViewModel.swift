//
//  LandingViewModel.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

protocol LandingViewModelProtocol {
    func goToConverter()
}

class LandingViewModel: LandingViewModelProtocol {

    // MARK: - Properties
    private weak var coordinator: LandingCoordinatorProtocol?

    // MARK: - Initialization
    init(coordinator: LandingCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    // MARK: - Callbacks
    func goToConverter() {
        coordinator?.goToConverter()
    }
}

