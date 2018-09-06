//
//  CombineUserInputsManager.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

typealias OutputsTriggered = (inputed: Decimal?, rates: IRatesInfo)
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
    
    func connectInputs(_ combineInfo: CombineInfo) -> Observable<String> {
        let combinedInputs = combineUserInputs(combineInfo.viewModels, select: combineInfo.select)
        let filteredInputs = filterInputs(combinedInputs, on: combineInfo.currency)
        let formatInputed = formatInput(filteredInputs)
        let amountWithRates = combineInputed(formatInputed, with: combineInfo.rates)
    
        let combinedOutputs = combineOutputs(combineInfo.viewModels, without: combineInfo.currency)
        
        return fillOutputs(combinedOutputs, with: amountWithRates)
    }
    
    // MARK: Inputs prepare
    
    private func combineUserInputs(_ viewModels: Observable<[ConvertAmountViewModel]>,
                           select: Observable<ConvertAmountViewModel>) -> Observable<InputedPair> {
        let userInputs = mergeVariables(viewModels: viewModels)
        let userSelect = select.map { ($0.text.value, $0.currency) }

        return Observable.merge([userInputs, userSelect])
    }
    
    private func mergeVariables(viewModels: Observable<[ConvertAmountViewModel]>) -> Observable<InputedPair> {
        return viewModels.flatMap { (viewModels) -> Observable<(String?, Currency)> in
            return Observable.merge( viewModels.map { viewModel in
                let currency = viewModel.currency
                return viewModel.text.asObservable().distinctUntilChanged().map({ (text) -> (String?, Currency) in
                    return (text, currency)
                })
            })
        }
    }
    
    private func filterInputs(_ amountChanged: Observable<InputedPair>, on base: Observable<Currency>) -> Observable<InputedPair> {
        return amountChanged.withLatestFrom(base) { ($0, $1) }.filter( { $0.0.1 == $0.1 }).map( { $0.0 })
    }
    
    private func combineInputed(_ output: Observable<Decimal?>, with rates: Observable<IRatesInfo?>) -> Observable<OutputsTriggered> {
        return Observable.combineLatest(output, rates).flatMap { (inputed, rates) -> Observable<OutputsTriggered> in
            return rates.map { Observable.just((inputed, $0)) } ?? Observable.empty()
        }
    }
    
    private func formatInput(_ output: Observable<InputedPair>) -> Observable<Decimal?> {
        let formatter = self.formatter
        return output.map {(inputed) -> Decimal? in
            return inputed.0.map { formatter.amount(from: $0) } ?? nil
        }
    }
    
    // MARK: Outputs prepare
    
    private func combineOutputs(_ viewModels: Observable<[ConvertAmountViewModel]>, without base: Observable<Currency>) -> Observable<[OutputsSource]> {
        return Observable.combineLatest(viewModels, base).map { (viewModels, currency) in
            return viewModels.filter { $0.currency != currency }.map { ($0.text, $0.currency) }
        }
    }
    
    private func fillOutputs(_ outputs: Observable<[OutputsSource]>, with amount: Observable<OutputsTriggered>) -> Observable<String> {
        let combined = amount.withLatestFrom(outputs) { ($0, $1) }.observeOn(MainScheduler.asyncInstance)
        return combined.do(onNext: {[weak self] (info) in
            self?.fillOutputs(info.1, triggered: info.0)
        }).flatMap { _ -> Observable<String> in return .never() }
    }

    private func fillOutputs(_  outputs: [OutputsSource], triggered: OutputsTriggered) {
        outputs.forEach({ (input) in
            if let output = triggered.inputed, output > 0.0, let rate = triggered.rates.rates[input.1] {
                input.0.value = formatter.formatt(amount: rate * output, currency: input.1)
            } else {
                input.0.value = ""
            }
        })
    }
}
