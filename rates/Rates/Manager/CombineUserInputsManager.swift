//
//  CombineUserInputsManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

typealias OutputsTriggered = (Decimal?,IRatesInfo)
typealias InputedPair = (String?, Currency)
typealias OutputsSource = (Variable<String?>, String)

class CombineUserInputsManager: ICombineUserInputsManager {
    
    // MARK: Dependencies
    
    private let formatter: ICurrencyFormatter
    
    // MARK: Lifecycle
    
    init(formatter: ICurrencyFormatter) {
        self.formatter = formatter
    }
    
    // MARK: ICombineUserInputsManager implementation
    
    func connectInputs(_ combineInfo: ICombineInfo, fillOn: SchedulerType) -> Observable<Void> {
        let combinedInputs = combineTriggers(combineInfo)
        let combinedOutputs = combineOutputs(combineInfo)
        
        return fillOutputs(combinedOutputs, with: combinedInputs, fillOn: fillOn)
    }
    
    // MARK: Inputs prepare
    
    private func combineTriggers(_ info: ICombineInfo) -> Observable<OutputsTriggered> {
        let userInputs = info.viewModels.flatMap { Observable.merge($0.map { $0.inputChanged() }) }
        let userInputsFiltered = userInputs.filterOn(info.currency, selector: { $0.1 == $1 })
        let userSelect = info.select.map { ($0.text.value, $0.currency) }
        let userTriggers = Observable.merge([userInputsFiltered, userSelect])
        
        let formattedTriggers = Observable<Decimal?>.formatInputed(userTriggers, formatter: formatter)
        let amountAndRates = Observable.combineLatest(formattedTriggers, info.rates)
        let filtered = amountAndRates.filterOn(info.currency, selector: { $1 == $0.1.baseCurrency })
        
        return filtered
    }
    
    // MARK: Outputs prepare
    
    private func combineOutputs(_ info: ICombineInfo) -> Observable<[OutputsSource]> {
        return Observable.combineLatest(info.viewModels, info.currency).map { (viewModels, currency) in
            return viewModels.filter { $0.currency != currency }.map { ($0.text, $0.currency) }
        }
    }
    
    private func fillOutputs(_ outputs: Observable<[OutputsSource]>,
                             with amount: Observable<OutputsTriggered>, fillOn: SchedulerType) -> Observable<Void> {
        let combined = amount.withLatestFrom(outputs) { ($0, $1) }.observeOn(fillOn)
        return combined.do(onNext: {[weak self] (info) in
            self?.formatter.formattOutputs(info.1, triggered: info.0)
        }).flatMap { _ -> Observable<Void> in return .never() }
    }
}
