//
//  XCTestCase.swift
//  CurrencyConverterUITests
//
//  Created by Himanshu Dawar on 04/06/23.
//

import XCTest

extension XCTestCase {
    
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }

    func loadModelFromStub<T: Decodable>(name: String, extension: String) -> T {
        let data = loadStub(name: name, extension: `extension`)

        return try! JSONDecoder().decode(T.self, from: data)
    }

    func makeError() -> NSError {
        let message = "error"
        let status = ["devMessage": message]
        let response = ["status": status]
        let userInfo = ["response": response]
        let error = NSError(domain: "testingError", code: -99, userInfo: userInfo)
        return error
    }
}

