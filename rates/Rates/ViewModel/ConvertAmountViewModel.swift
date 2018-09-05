//
//  ConvertAmountViewModel.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

typealias FormatInputed = (String?, Currency) -> String

struct ConvertAmountViewModel: IdentifiableType, Equatable {
    
    // MARK: Properties
    
    private(set) var currency: String
    private(set) var name: String?
    private(set) var text = Variable<String?>(nil)
    private(set) var formatInputed: FormatInputed?
    
    // MARK: Lifecycle
    
    init(currency: Currency, name: String?, formatInputed: @escaping FormatInputed) {
        self.currency = currency
        self.name = name
        self.formatInputed = formatInputed
    }
    
    // MARK: IdentifiableType
    
    var identity : String {
        return currency
    }
    
    static func ==(lhs: ConvertAmountViewModel, rhs: ConvertAmountViewModel) -> Bool {
        return lhs.currency == rhs.currency
    }
}
