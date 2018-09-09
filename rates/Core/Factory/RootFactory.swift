//
//  RootFactory.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class RootFactory {
    
    // MARK: Scheduler
    
    private lazy var queue = DispatchQueue.global(qos: .background)
    private lazy var scheduler = ConcurrentDispatchQueueScheduler(queue: queue)
    
    // MARK: Common
    
    private lazy var network: INetworkService = NetworkService(sessionManager: SessionManager.default, queue: queue)
    
    // MARK: Dependencies
    
    public lazy var currencyInfoService: ICurrencyInfoService = CurrencyInfoService()
    public lazy var ratesSerivce: IRatesService = RatesService(network: network)
    public lazy var currencyFormatter: ICurrencyFormatter = CurrencyFormatter(maxLenght: 9)
    
    public var converterViewModel: ConverterViewModel {
        return ConverterViewModel(updateManager: ratesUpdateManager, constructManager: converterConstructManager,
                                  combineInputManager: combineConvertersManager, scheduler: scheduler)
    }
    
    // MARK: Computed
    
    private var ratesUpdateManager: IRatesUpdateManager {
        let rxService = RxRatesService(service: ratesSerivce)
        return RatesUpdateManager(ratesService: rxService, scheduler: scheduler)
    }
    
    private var converterConstructManager: IConstructConverterManager {
        return ConstructConverterManager(currencyInfo: currencyInfoService, formatter: currencyFormatter)
    }
    
    private var combineConvertersManager: ICombineUserInputsManager {
        return CombineUserInputsManager(formatter: currencyFormatter)
    }
}
