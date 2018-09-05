//
//  UBRate.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

struct UBRate: IRate {
    
    // MARK: Properties
    
    var currency: Currency
    var rate: Decimal
    
    // MARK: Lifecycle
    
    init(currency: Currency, rate: Decimal) {
        self.currency = currency
        self.rate = rate
    }
}
