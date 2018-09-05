//
//  CurrencyFormatter.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 31/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

class CurrencyFormatter: ICurrencyFormatter {
    
    // MARK: Properties
    
    private var maxLenght: Int
    private var formatter: NumberFormatter
    
    // MARK: Lifecycle
    
    init(maxLenght: Int) {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = false
        self.maxLenght = maxLenght
    }
    
    // MARK: ICurrencyFormatter implementation
    
    func formatt(inputed: String, currency: Currency) -> String {
        guard !inputed.isEmpty else {
            return inputed
        }
        
        formatter.setUp(currency: currency)
        
        return separateInputed(inputed)
    }
    
    func formatt(amount: Decimal, currency: Currency) -> String {
        formatter.setUp(currency: currency)
        return formatter.string(from: amount as NSNumber)?.withoutSpaces ?? "\(amount)"
    }
    
    func amount(from formatted: String) -> Decimal? {
        let decimalFormatted = formatted.replacingOccurrences(of: formatter.currencyDecimalSeparator, with: ".")
        return Decimal(string: decimalFormatted)
    }
    
    // MARK: Private
    
    private func separateInputed(_ inputed: String) -> String {
        let separator = formatter.currencyDecimalSeparator ?? "."
        let decimalLenght = formatter.maximumFractionDigits
        let separeted = inputed.prefix(maxLenght).components(separatedBy: separator)
        let integerPart = separeted.first?.integerVariant ?? "0"
        let decimalPart = (separeted.second?.digits.prefix(decimalLenght)).map { "\(separator)\($0)" } ?? ""
        
        return integerPart + decimalPart
    }
}
