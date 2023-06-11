//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var onDismiss: VoidCompletion? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func dismiss()
}

extension Coordinator {
    func start() {}

    func dismiss() {
        print("Dismissing \(String(describing: self))")
        onDismiss?()
    }

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func removeChild(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
}
