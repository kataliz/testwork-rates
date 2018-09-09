//
//  ICombineUserInputsManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

protocol ICombineUserInputsManager {
    func connectInputs(_ combineInfo: ICombineInfo, fillOn: SchedulerType) -> Observable<Void>
}
