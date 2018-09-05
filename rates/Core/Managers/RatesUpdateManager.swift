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

    private let ratesService: IRatesService
    
    // MARK: Lifecycle
    
    init(ratesService: IRatesService) {
        self.ratesService = ratesService
    }
    
    // MARK: IRatesUpdateManager implementation
    
    func configureBase(_ baseCurrency: Observable<Currency>) -> Observable<IRatesInfo?> {
        let timer = Observable<UInt64>.timer(0, period: 1.0, scheduler: MainScheduler.instance)
        return Observable.combineLatest(timer, baseCurrency).flatMap(weak: self, selector: { (manager, info) -> Observable<IRatesInfo?> in
            let nilEvent = Observable<IRatesInfo?>.from(optional: nil)
            let loadedEvent = Observable<IRatesInfo?>.create({[weak self] (observer) -> Disposable in
                self?.ratesService.loadRates(base: info.1, completion: { (result) in
                    if let rates = result.value {
                        observer.onNext(rates)
                    } else if let error = result.error {
                        observer.onError(error)
                    }
                })
                
                return Disposables.create()
            })
            
            return Observable.merge([nilEvent, loadedEvent])
        })
    }
}
