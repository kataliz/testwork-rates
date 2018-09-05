//
//  IRatesInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

protocol IRatesInfo {
    var baseCurrency: Currency { get }
    var rates: [Currency: Decimal] { get }
    var allCurrencies: [Currency] { get }
}
