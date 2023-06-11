//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

class ConverterViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ConverterViewModelProtocol
    
    // MARK: - Views
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.placeholder = Constants.Strings.amountTextFieldPlaceHolder
        textField.textColor = .black
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 5
        textField.keyboardType = .decimalPad
        textField.font = Constants.Fonts.amountTextFieldFont
        textField.rightView = UIView(frame: CGRectMake(0, 0, 16, textField.frame.height))
        textField.rightViewMode = .always
        return textField
    }()
    
    private let currencyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.tintColor = .clear
        textField.textColor = .black
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 5
        textField.font = Constants.Fonts.currencyFieldFont
        textField.rightView = UIView(frame: CGRectMake(0, 0, 36, textField.frame.height))
        textField.rightViewMode = .always
        return textField
    }()
    
    private let arrowImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "downArrow")
        return view
    }()
    
    private lazy var currencyStackView = UIStackView(
        subviews: [amountTextField, currencyTextField],
        axis: .vertical,
        distribution: .fillEqually,
        spacing: Constants.stackViewSpacing
    )
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    let currencyPicker = UIPickerView()
    
    private let toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refreshIcon"), for: .normal)
        button.addTarget(self, action: #selector(refreshRates), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: ConverterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    func setupViewModel() {
        viewModel.fetchError = { [weak self] errorMsg in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.rightBarButton.isUserInteractionEnabled = true
                UIAlertController.errorAlert(withMessage: errorMsg, fromViewControler: self)
            }
        }
        
        viewModel.reloadTable = { [weak self] in
            guard let self else { return }
            self.reloadViews()
        }
        viewModel.fetchCurrencyRates = { [weak self] currencyList in
            guard let self else { return }
            self.viewModel.getCurrencyRates(with: currencyList)
        }
        spinner.startAnimating()
        rightBarButton.isUserInteractionEnabled = false
        
        if viewModel.currencyRates.isEmpty {
            viewModel.getCurrenciesList()
        } else {
            reloadViews()
        }
    }
    
    // MARK: - UI
    private func setupUI() {
        addSubviews()
        setupConstraints()
        setupViewDelegates()
        view.backgroundColor = .white
        navigationItem.title = Constants.Strings.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        toolbar.setItems([UIBarButtonItem(title: Constants.Strings.toolbarButtonTitle,
                                          style: .done,
                                          target: self,
                                          action: #selector(doneToolBarAction))],animated: true)
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: - Done toolbar action to refresh data when new currency is selected or to close picker view
    @objc func doneToolBarAction() {
        if amountTextField.isFirstResponder {
            amountTextField.resignFirstResponder()
        } else if currencyTextField.isFirstResponder {
            currencyTextField.resignFirstResponder()
        }
        tableView.reloadData()
    }
    
    // MARK: - Refresh data in app from web service, checks if time is more than 30 minutes than previous fetch, then it allows user to refresh the data.
    @objc func refreshRates() {
        let canRefreshData = viewModel.canRefreshCurrencyData()
        if canRefreshData.value {
            spinner.startAnimating()
            rightBarButton.isUserInteractionEnabled = false
            viewModel.getCurrenciesList()
        } else {
            DispatchQueue.main.async {
                UIAlertController.errorAlert(
                    withMessage: Constants.Strings.cannotRefreshCurrencyDataError + "Please try refreshing after \(canRefreshData.minutesLeft) minutes and \(canRefreshData.secondsLeft) seconds.",
                    fromViewControler: self)
            }
        }
    }
}

// MARK: - ConverterViewController UI Setup
extension ConverterViewController {
    
    private func addSubviews() {
        view.addSubview(currencyStackView)
        view.addSubview(tableView)
        tableView.addSubview(spinner)
        currencyTextField.addSubview(arrowImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyStackView.heightAnchor.constraint(equalToConstant: Constants.currencyStackHeight),
            currencyStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.currencyStackSpacing),
            currencyStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.currencyStackSpacing),
            
            tableView.topAnchor.constraint(equalTo: currencyStackView.bottomAnchor, constant: Constants.stackViewSpacing),
            tableView.leadingAnchor.constraint(equalTo: currencyStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: currencyStackView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            arrowImage.widthAnchor.constraint(equalToConstant: Constants.arrowImageSize),
            arrowImage.heightAnchor.constraint(equalToConstant: Constants.arrowImageSize),
            arrowImage.trailingAnchor.constraint(equalTo: currencyTextField.trailingAnchor, constant: -Constants.arrowImageSize),
            arrowImage.centerYAnchor.constraint(equalTo: currencyTextField.centerYAnchor)])
    }
    
    private func setupViewDelegates() {
        amountTextField.delegate = self
        currencyTextField.delegate = self
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        currencyTextField.inputView = currencyPicker
        currencyTextField.inputAccessoryView = toolbar
        amountTextField.inputAccessoryView = toolbar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyTableViewCell.self)
    }
    
    private func reloadViews() {
        DispatchQueue.main.async {
            if (self.currencyTextField.text ?? "").isEmpty {
                self.currencyTextField.text = self.viewModel.currencyName(for: 0)
            }
            
            self.spinner.stopAnimating()
            self.tableView.reloadData()
            self.rightBarButton.isUserInteractionEnabled = true
        }
    }
}

// MARK: - ConverterViewController UIPickerView delegates
extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.currencyName(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = viewModel.currencyName(for: row)
    }
}

// MARK: - ConverterViewController Tableview delegates
extension ConverterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyTableViewCell = tableView.dequeue(at: indexPath)
        cell.configureCell(
            currencyName: viewModel.currencyName(for: indexPath.row),
            currencyConversion: viewModel.currencyConversion(index: indexPath.row,
                                                             baseCurrency: currencyTextField.text ??  viewModel.currencyName(for: 0),
                                                             amount: Double(amountTextField.text ?? "0.0") ?? 0.0)
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - ConverterViewController TextField delegates
extension ConverterViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        tableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField != currencyTextField
    }
}

// MARK: - ConverterViewController Constants
extension ConverterViewController {
    private struct Constants {
        static let currencyStackHeight: CGFloat = 100
        static let currencyStackSpacing: CGFloat = 16
        static let stackViewSpacing: CGFloat = 10
        static let arrowImageSize: CGFloat = 16
        
        struct Fonts {
            static let amountTextFieldFont: UIFont = .systemFont(ofSize: 18, weight: .bold)
            static let currencyFieldFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
        }
        
        struct Strings {
            static let amountTextFieldPlaceHolder = "Enter amount"
            static let navigationTitle = "Currency Converter"
            static let toolbarButtonTitle = "Done"
            static let cannotRefreshCurrencyDataError = "Cannot refresh Currency data in order to limit Bandwidth Usage. Currency data can be refresh once in every 30 minutes. "
        }
    }
}

