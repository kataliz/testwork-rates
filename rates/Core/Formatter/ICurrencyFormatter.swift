//
//  ICurrencyFormatter.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 31/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

protocol ICurrencyFormatter {
    func formatt(inputed: String, currency: Currency) -> String
    func formatt(amount: Decimal, currency: Currency) -> String
    func amount(from formatted: String) -> Decimal?
}
