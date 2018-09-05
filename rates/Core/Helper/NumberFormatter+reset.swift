//
//  NumberFormatter+reset.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 02/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

extension NumberFormatter {
    func setUp(currency: Currency) {
        currencySymbol = nil
        currencyCode = currency
        currencySymbol = ""
    }
}
