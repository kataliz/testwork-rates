//
//  MockRatesInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 05/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

struct MockRatesInfo: IRatesInfo, Equatable {
    
    var baseCurrency: Currency
    var rates: [Currency : Decimal]
    
    var allCurrencies: [Currency] {
        return Array(rates.keys)
    }
    
    static func mock(json: [Currency: Decimal], base: Currency) -> MockRatesInfo {
        return MockRatesInfo(baseCurrency: base, rates: json)
    }
    
    static func example(base: Currency) -> MockRatesInfo {
        return mock(json: ["RUB": 68.1, "EUR": 0.8], base: base)
    }
}
