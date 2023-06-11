//
//  CurrencyConverterCoordinatorMock.swift
//  CurrencyConverterUITests
//
//  Created by Himanshu Dawar on 04/06/23.
//

import UIKit

@testable import CurrencyConverter
class CurrencyConverterCoordinatorMock: ConverterCoordinatorProtocol {
    
    // MARK: - Properties
    var didGoToCurrencyConverter = false
    
    var onDismiss: VoidCompletion?
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()

    func goToConverter() {
        didGoToCurrencyConverter = true
    }
}
