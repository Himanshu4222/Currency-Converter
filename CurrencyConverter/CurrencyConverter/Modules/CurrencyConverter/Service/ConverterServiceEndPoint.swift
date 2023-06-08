//
//  ConverterServiceEndPoint.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 28/05/23.
//

import Foundation

enum ConverterServiceEndPoint {
    case currencyRates(parameters: Parameters)
    case currenciesList(parameters: Parameters)
}

extension ConverterServiceEndPoint: EndpointTypeProtocol {

    // MARK: openexchangerates base url
    var baseURL: URL {
        guard let url = URL(string: "https://openexchangerates.org/api/") else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    // MARK: openexchangerates API key
    var appID: String {
        return "fc43bed5b46840428c8a41916b8ac381"
    }
    
    var path: String {
        switch self {
        case .currencyRates:
            return "latest.json"
        case .currenciesList:
            return "currencies.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .currencyRates:
            return .get
        case .currenciesList:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .currencyRates(var parameters):
            parameters["app_id"] = appID
            return parameters
        case .currenciesList(var parameters):
            parameters["app_id"] = appID
            return parameters
        }
    }

    var body: Body? { nil }

    var headers: HTTPHeaders? { nil }
}
