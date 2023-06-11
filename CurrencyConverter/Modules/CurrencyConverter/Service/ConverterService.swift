//
//  ConverterService.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import Foundation

protocol ConverterServiceProtocol {
    func getCurrencyRates<T>(parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) where T: Codable
    func getCurrenciesList<T>(parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) where T: Codable
}

class ConverterService: ConverterServiceProtocol {
    
    private let router = Router()

    func getCurrencyRates<T>(parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        router.requestData(ConverterServiceEndPoint.currencyRates(parameters: parameters),
                           completion: completion)
    }
    
    func getCurrenciesList<T>(parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        router.requestData(
            ConverterServiceEndPoint.currenciesList(parameters: parameters),
            completion: completion
        )
    }
}
