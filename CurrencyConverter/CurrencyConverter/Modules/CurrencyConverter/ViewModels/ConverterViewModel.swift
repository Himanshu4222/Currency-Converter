//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit
import CoreData

protocol ConverterViewModelProtocol {
    var fetchError: StringCompletion? { get set }
    var reloadTable: VoidCompletion? { get set }
    var fetchCurrencyRates: StringArrayCompletion? { get set }
    var numberOfRows: Int { get }
    var currencyRates: [CurrencyDetailModel] { get }
    
    func getCurrenciesList()
    func getCurrencyRates(with currencies: [String])
    func canRefreshCurrencyData() -> (value: Bool, minutesLeft: Int, secondsLeft: Int)
    func currencyName(for index: Int) -> String
    func currencyConversion(index: Int, baseCurrency: String, amount: Double) -> String
}

class ConverterViewModel: ConverterViewModelProtocol {
    
    //    MARK: - Properties
    private weak var coordinator: ConverterCoordinatorProtocol?
    private let service: ConverterServiceProtocol
    private let storageService: StorageServiceProtocol
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var managedContext = appDelegate.persistentContainer.viewContext
    
    var fetchError: StringCompletion?
    var reloadTable: VoidCompletion?
    var fetchCurrencyRates: StringArrayCompletion?
    
    var currenciesList: [String] = [] {
        didSet {
            fetchCurrencyRates?(currenciesList)
        }
    }
    
    var currencyRates: [CurrencyDetailModel] {
        return storageService.retrieveCurrencyRatesData()
    }
    
    var numberOfRows: Int {
        return currencyRates.count
    }
    
    //    MARK: - Initialization
    init(coordinator: ConverterCoordinatorProtocol,
         service: ConverterServiceProtocol = ConverterService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.coordinator = coordinator
        self.service = service
        self.storageService = storageService
    }
    
    //    MARK: - Networking
    func getCurrenciesList() {
        let parameters: Parameters = [Constants.Strings.parameter_prettyPrint: true,
                                      Constants.Strings.parameter_showAlternative: false,
                                      Constants.Strings.parameter_showInActive: false]
        
        service.getCurrenciesList(parameters: parameters) { [weak self] (result: Result<[String: String],Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                if !data.isEmpty {
                    self.currenciesList = data.map({$0.key}).sorted(by: {$0 < $1})
                }
                
            case .failure(let error):
                self.fetchError?(error.localizedDescription)
            }
        }
    }
    
    
    func getCurrencyRates(with currencies: [String]) {
        var currencyCodeString = ""
        for item in currencies {
            currencyCodeString.append("\(item),")
        }
        let parameters: Parameters = [Constants.Strings.parameter_base: "USD",
                                      Constants.Strings.parameter_symbols: currencyCodeString.dropLast(1),
                                      Constants.Strings.parameter_prettyPrint: true,
                                      Constants.Strings.parameter_showAlternative: false]
        
        service.getCurrencyRates(parameters: parameters) { [weak self] (result: Result<CurrencyRatesModel,Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                if let curencyRates = data.rates {
                    self.storageService.saveCurrencyRates(currencyRates: curencyRates.map({ (key, value) in
                        return CurrencyDetailModel(name: key, value: value)
                    }))
                    self.reloadTable!()
                }
                
            case .failure(let error):
                self.fetchError?(error.localizedDescription)
            }
        }
    }
    
    //    MARK: - Check if user can refresh the data from web service
    func canRefreshCurrencyData() -> (value: Bool, minutesLeft: Int, secondsLeft: Int) {
        if let savedTimeStamp = storageService.retrieveSavedTimeStamp() {
            let difference = Int(Date().timeIntervalSince1970) - savedTimeStamp
            let secondsBandWidth = 60 * 30
            return (value: difference > secondsBandWidth,
                    minutesLeft: ((secondsBandWidth - difference) % 3600) / 60,
                    secondsLeft: ((secondsBandWidth - difference) % 3600) % 60)
        }
        return (value: false, minutesLeft: 0, secondsLeft: 0)
    }
    
    //    MARK: - Gets currency name with respect to index argument
    func currencyName(for index: Int) -> String {
        return !currencyRates.isEmpty ? currencyRates[index].name : ""
    }
    
    //    MARK: - Calculate exchange rate between the base and target currency
    func currencyConversion(index: Int, baseCurrency: String, amount: Double) -> String {
        let currencyRate = amount * convertCurrency(fromUSDToBaseCurrency: currencyRates.first(where: {$0.name == baseCurrency})?.value ?? 0,
                                                    fromUSDToTargetCurrency: currencyRates[index].value)
        return "\(currencyRate.rounded(toPlaces: 5))"
    }
    
    private func convertCurrency(fromUSDToBaseCurrency usdToBase: Double, fromUSDToTargetCurrency usdToTarget: Double) -> Double {
        let exchangeRate = (usdToTarget / usdToBase).rounded(toPlaces: 5)
        return exchangeRate
    }
}

// MARK: - ConverterViewModel Constants
extension ConverterViewModel {
    private struct Constants {
        struct Strings {
            static let parameter_prettyPrint = "prettyprint"
            static let parameter_showAlternative = "show_alternative"
            static let parameter_showInActive = "show_inactive"
            static let parameter_base = "base"
            static let parameter_symbols = "symbols"
        }
    }
}
