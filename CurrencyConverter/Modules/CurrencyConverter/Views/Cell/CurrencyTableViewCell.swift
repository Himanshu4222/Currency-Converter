//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    // MARK: - Views
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.currencyNameLabelFont
        return label
    }()
    
    private let currencyConversionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.currencyConversionLabelFont
        label.textAlignment = .right
        return label
    }()

    private lazy var stackView = UIStackView(
        subviews: [currencyNameLabel, currencyConversionLabel],
        axis: .horizontal,
        distribution: .fillProportionally,
        alignment: .fill
    )

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupUI() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.topInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.leadingInset),
            
            currencyConversionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8)
        ])
    }

    func configureCell(currencyName: String, currencyConversion: String) {
        currencyNameLabel.text = "\(currencyName)"
        currencyConversionLabel.text = currencyConversion
    }
}

// MARK: - Constants
extension CurrencyTableViewCell {
    private struct Constants {
        static let topInset: CGFloat = 10
        static let leadingInset: CGFloat = 16

        struct Fonts {
            static let currencyNameLabelFont: UIFont = .systemFont(ofSize: 18)
            static let currencyConversionLabelFont: UIFont = .systemFont(ofSize: 18, weight: .bold)
        }
    }
}
