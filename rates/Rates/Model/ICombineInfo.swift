//
//  ICombineInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

protocol ICombineInfo {
    var viewModels: Observable<[ConvertCellViewModel]> { get }
    var select: Observable<ConvertCellViewModel> { get }
    var currency: Observable<Currency> { get }
    var rates: Observable<IRatesInfo?> { get }
}

struct CombineInfo: ICombineInfo {
    let viewModels: Observable<[ConvertCellViewModel]>
    let select: Observable<ConvertCellViewModel>
    let currency: Observable<Currency>
    let rates: Observable<IRatesInfo?>
}
