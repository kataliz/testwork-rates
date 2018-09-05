//
//  IRatesService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

protocol IRatesService {
    func loadRates(base: Currency, completion: @escaping ApiResponse<IRatesInfo>)
}
