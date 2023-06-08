//
//  LandingViewController.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

class LandingViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: LandingViewModelProtocol

    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.Strings.title
        label.font = Constants.Fonts.titleLabelFont
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let button = CustomButton(title: Constants.Strings.buttonTitle)

    // MARK: - Initialization
    init(viewModel: LandingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        button.didPress = { [weak self] in
            self?.viewModel.goToConverter()
        }
    }
}

// MARK: - LandingViewController UI Setup
extension LandingViewController {
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(button)
    }

    private func setupConstraints() {
        button.width = Constants.buttonWidth
        button.widthActive = true

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalInset),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalInset),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - LandingViewController Constants
extension LandingViewController {
    private struct Constants {
        static let horizontalInset: CGFloat = 10
        static let verticalInset: CGFloat = 40
        static let buttonWidth: CGFloat = 160

        struct Fonts {
            static let titleLabelFont: UIFont = .systemFont(ofSize: 32, weight: .bold)
        }

        struct Strings {
            static let title = "Welcome to Currency Conversion App"
            static let buttonTitle = "Go To Convertor"
        }
    }
}

