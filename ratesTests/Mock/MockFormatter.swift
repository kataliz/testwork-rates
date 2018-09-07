//
//  MockFormatter.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 07/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

@testable import rates

class MockFormatter: ICurrencyFormatter {
    func formatt(inputed: String, currency: Currency) -> String {
        return "1.23"
    }
    
    func formatt(amount: Decimal, currency: Currency) -> String {
        return "1.23"
    }
    
    func amount(from formatted: String) -> Decimal? {
        return 1.23
    }
}
