//
//  UITableview+Extra.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

extension UITableView {

    // MARK: - Dequeue UITableViewCell
    func register<T>(_: T.Type) where T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    func dequeue<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return T()
        }
        return cell
    }
}
