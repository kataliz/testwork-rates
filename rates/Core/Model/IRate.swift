//
//  IRate.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

protocol IRate {
    var currency: Currency { get }
    var rate: Decimal { get }
}
