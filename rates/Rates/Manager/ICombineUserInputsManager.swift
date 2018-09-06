//
//  ICombineUserInputsManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

struct CombineInfo {
    var viewModels: Observable<[ConvertAmountViewModel]>
    var select: Observable<ConvertAmountViewModel>
    var currency: Observable<Currency>
    var rates: Observable<IRatesInfo?>
}

protocol ICombineUserInputsManager {
    func connectInputs(_ combineInfo: CombineInfo) -> Observable<String>
}
