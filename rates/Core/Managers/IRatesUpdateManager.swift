//
//  IRatesUpdateManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 02/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol IRatesUpdateManager: class {
    func configureBase(_ baseCurrency: Observable<Currency>, timer: Observable<UInt64>) -> Observable<IRatesInfo?>
}
