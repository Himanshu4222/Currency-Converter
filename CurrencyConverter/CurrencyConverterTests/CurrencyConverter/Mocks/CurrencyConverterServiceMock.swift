//
//  CurrencyConverterServiceMock.swift
//  CurrencyConverterUITests
//
//  Created by Himanshu Dawar on 04/06/23.
//

import Foundation

@testable import CurrencyConverter
class CurrencyConverterServiceMock: ConverterServiceProtocol {
    
    var data: Data?
    var error: Error?

    func getCurrencyRates<T>(parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getCurrenciesList<T>(parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

