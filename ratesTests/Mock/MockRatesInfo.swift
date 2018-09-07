//
//  MockRatesInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 05/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

@testable import rates

struct MockRatesInfo: IRatesInfo, Equatable {
    
    var baseCurrency: Currency
    var rates: [Currency : Decimal]
    
    var allCurrencies: [Currency] {
        return Array([[baseCurrency], Array(rates.keys)].joined())
    }
    
    static func mock(json: [Currency: Decimal], base: Currency) -> MockRatesInfo {
        return MockRatesInfo(baseCurrency: base, rates: json)
    }
    
    static func example(base: Currency) -> MockRatesInfo {
        return mock(json: ["RUB": 68.1, "EUR": 0.8], base: base)
    }
    
    static func exampleUsdRub() -> MockRatesInfo {
        return mock(json: ["RUB": 68.0], base: "USD")
    }
    
    static func exampleUsdRub2() -> MockRatesInfo {
        return mock(json: ["RUB": 50.1], base: "USD")
    }
    
    static func exampleRubUsd() -> MockRatesInfo {
        return mock(json: ["USD": 0.1], base: "RUB")
    }
}
