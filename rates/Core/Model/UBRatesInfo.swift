//
//  UBRatesInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Unbox

struct UBRatesInfo: IRatesInfo, Unboxable {
    
    // MARK: Properties
    
    var baseCurrency: Currency
    var rates: [Currency: Decimal]
    
    // MARK: Computed
    
    var allCurrencies: [Currency] {
        return Array([[baseCurrency], Array(rates.keys)].joined())
    }
    
    // MARK: Lifecycle
    
    init(unboxer: Unboxer) throws {
        self.baseCurrency = try unboxer.unbox(key: "base")
        self.rates = try unboxer.unbox(key: "rates")
    }
}
