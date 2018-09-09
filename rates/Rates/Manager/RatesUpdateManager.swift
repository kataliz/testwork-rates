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
    private let scheduler: SchedulerType
    
    // MARK: Lifecycle
    
    init(ratesService: IRxRatesService, scheduler: SchedulerType) {
        self.ratesService = ratesService
        self.scheduler = scheduler
    }
    
    // MARK: IRatesUpdateManager implementation
    
    func configureBase(_ baseCurrency: Observable<Currency>, timer: Observable<UInt64>) -> Observable<IRatesInfo> {
        let result = Observable.combineLatest(timer.observeOn(scheduler), baseCurrency)
            .flatMapFirst(weak: self) { (cSelf, info) -> Observable<IRatesInfo> in
                cSelf.ratesService.loadRequest(currency: info.1)
            }
        
        return result
    }
}
