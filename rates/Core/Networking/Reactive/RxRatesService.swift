//
//  RxRatesService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

class RxRatesService: IRxRatesService {
    
    // MARK: Dependencies
    
    private let service: IRatesService
    
    // MARK: Lifecycle
    
    init(service: IRatesService) {
        self.service = service
    }
    
    // MARK: IRxRatesService implementation
    
    func loadRequest(currency: Currency) -> Observable<IRatesInfo?> {
        return Observable<IRatesInfo?>.create({[weak self] (observer) -> Disposable in
            self?.service.loadRates(base: currency, completion: { (result) in
                if let rates = result.value {
                    observer.onNext(rates)
                    observer.onCompleted()
                } else if let error = result.error {
                    observer.onError(error)
                }
            })
            
            return Disposables.create()
        })
    }
}
