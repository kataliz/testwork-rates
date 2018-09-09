//
//  IConverterViewModel.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

class ConverterViewModel: IConverterViewModel {
    
    // MARK: Dependencies
    
    private let updateManager: IRatesUpdateManager
    private let constructManager: IConstructConverterManager
    private let combineInputManager: ICombineUserInputsManager
    private let scheduler: SchedulerType
    
    // MARK: Lifecycle
    
    init(updateManager: IRatesUpdateManager, constructManager: IConstructConverterManager, combineInputManager: ICombineUserInputsManager, scheduler: SchedulerType) {
        self.updateManager = updateManager
        self.constructManager = constructManager
        self.combineInputManager = combineInputManager
        self.scheduler = scheduler
    }
    
    // MARK: IConverterViewModel implementation
    
    func transform(input: Input) -> Output {
        let selectViewModel = input.didSelect.share(replay: 1).observeOn(scheduler)
        let selectCurrency = selectViewModel.map( { $0.currency }).startWith("USD")
        
        let rates = updateManager.configureBase(selectCurrency, period: 1.0).share(replay: 1)
        let viewModels = constructManager.construct(rates: rates.first()).share(replay: 1)
        let sortedViewModels = selectViewModel.sortToFirst(viewModels)
        
        let combineInfo = CombineInfo(viewModels: viewModels, select: selectViewModel, currency: selectCurrency, rates: rates)
        let connected = combineInputManager.connectInputs(combineInfo, fillOn: scheduler)
        
        return Output(viewModels: sortedViewModels, hold: connected)
    }
}

