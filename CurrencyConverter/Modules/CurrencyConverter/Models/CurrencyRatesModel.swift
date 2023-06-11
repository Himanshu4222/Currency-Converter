//
//  CurrencyRates.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 02/06/23.
//

import Foundation

//  MARK: Model for web service response
struct CurrencyRatesModel: Codable {
    let rates: [String: Double]?
}

