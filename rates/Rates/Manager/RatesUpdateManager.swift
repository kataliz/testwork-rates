//
//  RatesUpdateManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 02/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RatesUpdateManager: IRatesUpdateManager {
    
    // MARK: Dependencies

    private let ratesService: IRxRatesService
    
    // MARK: Lifecycle
    
    init(ratesService: IRxRatesService) {
        self.ratesService = ratesService
    }
    
    // MARK: IRatesUpdateManager implementation
    
    func configureBase(_ baseCurrency: Observable<Currency>, timer: Observable<UInt64>) -> Observable<IRatesInfo?> {
        let result = Observable.combineLatest(timer, baseCurrency)
            .flatMapFirst(weak: self) { $0.ratesService.loadRequest(currency: $1.1) }
        
        let nulledRates: Observable<IRatesInfo?> = baseCurrency.map { _ in return nil }
        
        return Observable.merge(nulledRates, result)
    }
    
}
