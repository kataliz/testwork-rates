//
//  CurrencyInfoService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

class CurrencyInfoService: ICurrencyInfoService {
    
    // MARK: Properties
    
    private var locale: Locale = Locale.current
    
    // MARK: ICurrencyInfoService implementation
    
    func name(for currency: Currency) -> String? {
        return locale.localizedString(forCurrencyCode: currency)
    }
}
