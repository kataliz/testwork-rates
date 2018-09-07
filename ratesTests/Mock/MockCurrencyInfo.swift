//
//  MockCurrencyInfo.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 07/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

@testable import rates

class MockCurrencyInfo: ICurrencyInfoService {
    
    var name: String = ""
    
    func name(for currency: Currency) -> String? {
        return name
    }
}
