//
//  RootFactory.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Simple container

class RootFactory {
    
    // MARK: Common
    
    private lazy var network: INetworkService = NetworkService(sessionManager: SessionManager.default)
    
    // MARK: Dependencies
    
    public lazy var currencyInfoService: ICurrencyInfoService = CurrencyInfoService()
    public lazy var ratesSerivce: IRatesService = RatesService(network: network)
    public lazy var currencyFormatter: ICurrencyFormatter = CurrencyFormatter(maxLenght: 9)
    
    public var converterViewModel: ConverterViewModel {
        return ConverterViewModel(updateManager: ratesUpdateManager, constructManager: converterConstructManager,
                                  combineInputManager: combineConvertersManager)
    }
    
    // MARK: Computed
    
    private var ratesUpdateManager: IRatesUpdateManager {
        let rxService = RxRatesService.init(service: ratesSerivce)
        return RatesUpdateManager(ratesService: rxService)
    }
    
    private var converterConstructManager: IConstructConverterManager {
        return ConstructConverterManager(currencyInfo: currencyInfoService, formatter: currencyFormatter)
    }
    
    private var combineConvertersManager: ICombineUserInputsManager {
        return CombineUserInputsManager(formatter: currencyFormatter)
    }
}
