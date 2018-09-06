//
//  ConstructConverterManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

class ConstructConverterManager: IConstructConverterManager {
    
    // MARK: Dependencies
    
    private var currencyInfo: ICurrencyInfoService
    private let formatter: ICurrencyFormatter
    
    // MARK: Lifecycle
    
    init(currencyInfo: ICurrencyInfoService, formatter: ICurrencyFormatter) {
        self.currencyInfo = currencyInfo
        self.formatter = formatter
    }
    
    // MARK: IConstructConverterManager implementation
    
    func construct(rates: Observable<IRatesInfo>) -> Observable<[ConvertAmountViewModel]> {
        return rates.flatMap(weak: self, selector: { (tSelf, info) -> Observable<[ConvertAmountViewModel]> in
            return Observable.from(optional: tSelf.constructViewModels(from: info))
        })
    }
    
    private func constructViewModels(from rates: IRatesInfo) -> [ConvertAmountViewModel] {
        let info = currencyInfo
        let formatting: FormatInputed =  {[weak formatter] (text, currency) in
            guard let text = text, let formatter = formatter else {
                return ""
            }
            
            return formatter.formatt(inputed: text, currency: currency)
        }
        
        return rates.allCurrencies.map({ (currency) in
            let name = info.name(for: currency)
            return ConvertAmountViewModel(currency: currency, name: name, formatInputed: formatting)
        })
    }
}
