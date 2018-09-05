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
        return ConverterViewModel(
            updateManager: ratesUpdateManager,
            formatter: currencyFormatter,
            currencyInfoService: currencyInfoService
        )
    }
    
    // MARK: Computed
    
    private var ratesUpdateManager: IRatesUpdateManager {
        return RatesUpdateManager(ratesService: ratesSerivce)
    }
}
