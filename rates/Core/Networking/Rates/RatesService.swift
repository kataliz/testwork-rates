//
//  RatesService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Unbox

class RatesService: IRatesService {
    
    // MARK: Dependencies
    
    private var network: INetworkService
    
    // MARK: Lifecycle
    
    init(network: INetworkService) {
        self.network = network
    }
    
    // MARK: IRatesService implementation
    
    func loadRates(base: Currency, completion: @escaping ApiResponse<IRatesInfo>) {
        let resource = ResourceInfo.getBy(path: ApiPath.rates(base))
        let completion: ApiResponse<UBRatesInfo> = unboxable(completion: completion)
        
        network.request(info: resource, completion: completion)
    }
}
