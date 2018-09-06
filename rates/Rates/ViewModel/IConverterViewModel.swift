//
//  IConverterViewModel.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 04/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

protocol IConverterViewModel {
    func transform(input: Input) -> Output
}

struct Input {
    let didSelect: Observable<ConvertAmountViewModel>
}

struct Output {
    let viewModels: Observable<[ConvertAmountViewModel]>
    let error: Observable<String>
}
