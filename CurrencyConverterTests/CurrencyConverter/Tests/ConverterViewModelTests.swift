//
//  ConverterViewModelTests.swift
//  CurrencyConverterUITests
//
//  Created by Himanshu Dawar on 04/06/23.
//

import XCTest
@testable import CurrencyConverter

final class ConverterViewModelTests: XCTestCase {
    
    var coordinator: CurrencyConverterCoordinatorMock!
    var service: CurrencyConverterServiceMock!
    var viewModel: ConverterViewModel!

    override func setUpWithError() throws {
        coordinator = CurrencyConverterCoordinatorMock()
        service = CurrencyConverterServiceMock()
        viewModel = ConverterViewModel(coordinator: coordinator, service: service)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        service = nil
        viewModel = nil
    }
    
    func test_get_Currencies_List_Success() {
        let expectation = XCTestExpectation(description: "Get currency list")
        service.data = loadStub(name: "CurrencySuccess", extension: "json")

        viewModel.fetchCurrencyRates = { _ in
            expectation.fulfill()
        }
        viewModel.getCurrenciesList()

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_Currencies_List_Error() {
        let expectation = XCTestExpectation(description: "Get currency list")
        service.error = makeError()

        viewModel.fetchError = { _ in
            expectation.fulfill()
        }
        viewModel.getCurrenciesList()

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_Currencies_List_Fail() {
        let expectation = XCTestExpectation(description: "Get currency list")
        service.data = loadStub(name: "CurrencyFail", extension: "json")

        viewModel.fetchError = { _ in
            expectation.fulfill()
        }
        viewModel.getCurrenciesList()

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_Currency_Rates_Success() {
        let expectation = XCTestExpectation(description: "Get currency Rates")
        service.data = loadStub(name: "ConverterSuccess", extension: "json")
        
        viewModel.reloadTable = expectation.fulfill
        viewModel.getCurrencyRates(with: viewModel.currenciesList)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_Currency_Rates_Error() {
        let expectation = XCTestExpectation(description: "Get currency Rates")
        service.error = makeError()
        
        viewModel.fetchError = { _ in
            expectation.fulfill()
        }
        viewModel.getCurrencyRates(with: viewModel.currenciesList)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_Currency_Rates_Fail() {
        let expectation = XCTestExpectation(description: "Get currency Rates")
        service.data = loadStub(name: "ConverterFail", extension: "json")
        
        viewModel.fetchError = { _ in
            expectation.fulfill()
        }
        viewModel.getCurrencyRates(with: viewModel.currenciesList)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_CurrencyName() {
        service.data = loadStub(name: "ConverterSuccess", extension: "json")
        if viewModel.currencyName(for: 0).isEmpty {
            XCTAssertNil(viewModel.currencyRates.first?.name)
        } else {
            XCTAssertEqual(viewModel.currencyName(for: 0), viewModel.currencyRates.first?.name)
        }
    }
}
