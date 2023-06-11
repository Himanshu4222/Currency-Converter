//
//  EndPointTypeProtocol.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case get = "GET"
}

typealias Parameters = [String: Any]

extension Parameters {
    var asString: String {
        var paramString = "?"
        for (key, value) in self {
            paramString += "\(key)=\(value)&"
        }
        paramString.removeLast()
        return paramString
    }
}

typealias Body = [String: Any]

protocol EndpointTypeProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var body: Body? { get }
}

