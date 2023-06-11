//
//  Router.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import Foundation

typealias StringCompletion = (String) -> Void
typealias StringArrayCompletion = ([String]) -> Void
typealias VoidCompletion = () -> Void

class Router {
    func requestData<T>(_ route: EndpointTypeProtocol, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        var path = route.path
        if let params = route.parameters {
            path += params.asString
        }
        guard let url = URL(string: path, relativeTo: route.baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = route.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                completion(.success(try JSONDecoder().decode(T.self, from: data)))
            } catch let error {
                print(String(data: data, encoding: .utf8) ?? "nothing received")
                completion(.failure(error))
            }
        }.resume()
    }
}

