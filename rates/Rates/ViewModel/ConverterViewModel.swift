//
//  IConverterViewModel.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias OutputsTriggered = (inputed: Decimal?, rates: IRatesInfo)
typealias OutputsSource = (Variable<String?>, String)
typealias OutputsAgregated = (triggered: OutputsTriggered, source: [OutputsSource])

typealias InputedPair = (String?, Currency)
typealias ChangedAmountRates = (Decimal?, IRatesInfo)

class ConverterViewModel: IConverterViewModel {
    
    // MARK: Dependencies
    
    private var currencyInfoService: ICurrencyInfoService
    private let formatter: ICurrencyFormatter
    private let updateManager: IRatesUpdateManager

    // MARK: Lifecycle
    
    init(updateManager: IRatesUpdateManager, formatter: ICurrencyFormatter, currencyInfoService: ICurrencyInfoService) {
        self.updateManager = updateManager
        self.formatter = formatter
        self.currencyInfoService = currencyInfoService
    }
    
    // MARK: IConverterViewModel implementation
    
    func transform(input: Input) -> Output {
        let select = input.didSelect.share(replay: 1)
        let selectCurrency = select.map( { $0.currency }).startWith("USD")
        let rates = updateManager.configureBase(selectCurrency).share(replay: 1)
        let viewModels = createViewModels(from: rates)
        
        let amountChanged = mergeOutputs(viewModels: viewModels, with: select)
        let filteredAmount = filterOutput(amountChanged: amountChanged, on: selectCurrency)
        let formattedAmount = formatOutput(filteredAmount, formatter: formatter)
        let amountWithRates = combineOutput(formattedAmount, with: rates)
        
        let outputs = combineOutputs(viewModels: viewModels, without: selectCurrency)
        let connected = fillOutputs(outputs, with: amountWithRates, use: formatter)
        
        let convertAmounts = sortViewModels(viewModels, on: select)
        
        return Output(convertAmounts: convertAmounts, error: connected)
    }
    
    private func formattingInput() -> FormatInputed {
        return {[weak self] (text, currency) in
            guard let `self` = self, let text = text else {
                return ""
            }
            
            return self.formatter.formatt(inputed: text, currency: currency)
        }
    }
    
    // MARK: Constructing
    
    private func createViewModels(from rates: Observable<IRatesInfo?>) -> Observable<[ConvertAmountViewModel]> {
        return rates.ignoreNil().first().flatMap(weak: self, selector: { (tSelf, info) -> Observable<[ConvertAmountViewModel]> in
            return Observable.from(optional: tSelf.constructViewModels(from: info))
        }).share(replay: 1)
    }
    
    private func constructViewModels(from rates: IRatesInfo) -> [ConvertAmountViewModel] {
        let info = currencyInfoService
        let formatting = formattingInput()
        return rates.allCurrencies.map({ (currency) in
            let name = info.name(for: currency)
            return ConvertAmountViewModel(currency: currency, name: name, formatInputed: formatting)
        })
    }
    
    private func sortViewModels(_ viewModels: Observable<[ConvertAmountViewModel]>, on select: Observable<ConvertAmountViewModel>) -> Observable<[ConvertAmountViewModel]> {
        return Observable.combineLatest(viewModels, select.wrapAsObservable()).flatMap { (viewModels, select) in
            return select.scan(viewModels, accumulator: { (result, selected) in
                return result.rarrangedAtStart(selected)
            }).startWith(viewModels)
        }
    }
    
    class private func fillInputs(triggered: OutputsTriggered, source: [OutputsSource], formatter: ICurrencyFormatter) {
        source.forEach({ (input) in
            if let output = triggered.inputed, output > 0.0, let rate = triggered.rates.rates[input.1] {
                input.0.value = formatter.formatt(amount: rate * output, currency: input.1)
            } else {
                input.0.value = ""
            }
        })
    }
    
    // MARK: ViewModels output
    
    private func mergeOutputs(viewModels: Observable<[ConvertAmountViewModel]>, with select: Observable<ConvertAmountViewModel>) -> Observable<InputedPair> {
        let userOutputs = mergeOutputs(viewModels: viewModels)
        let selectOutput = select.map { ($0.text.value, $0.currency) }
        return Observable.merge([userOutputs, selectOutput])
    }
    
    private func mergeOutputs(viewModels: Observable<[ConvertAmountViewModel]>) -> Observable<InputedPair> {
        return viewModels.flatMap { (viewModels) -> Observable<(String?, Currency)> in
            return Observable.merge( viewModels.map { viewModel in
                let currency = viewModel.currency
                return viewModel.text.asObservable().distinctUntilChanged().map({ (text) -> (String?, Currency) in
                    return (text, currency)
                })
            })
        }
    }
    
    private func filterOutput(amountChanged: Observable<InputedPair>, on base: Observable<Currency>) -> Observable<InputedPair> {
        return amountChanged.withLatestFrom(base) { ($0, $1) }.filter( { $0.0.1 == $0.1 }).map( { $0.0 })
    }
    
    private func formatOutput(_ output: Observable<InputedPair>, formatter: ICurrencyFormatter) -> Observable<Decimal?> {
        return output.map {(inputed) -> Decimal? in
            return inputed.0.map { formatter.amount(from: $0) } ?? nil
        }
    }
    
    private func combineOutput(_ output: Observable<Decimal?>, with rates: Observable<IRatesInfo?>) -> Observable<ChangedAmountRates> {
        return Observable.combineLatest(output, rates).flatMap { (inputed, rates) -> Observable<ChangedAmountRates> in
            return rates.map { Observable.just((inputed, $0)) } ?? Observable.empty()
        }
    }
    
    // MARK: ViewModels input
    
    private func fillOutputs(_ outputs: Observable<[(Variable<String?>, String)]>, with amount: Observable<ChangedAmountRates>, use formatter: ICurrencyFormatter) -> Observable<String> {
        let combined = amount.withLatestFrom(outputs) { ($0, $1) }.observeOn(MainScheduler.asyncInstance)
        return combined.do(onNext: { (info) in
            ConverterViewModel.fillInputs(triggered: info.0, source: info.1, formatter: formatter)
        }).flatMap { _ -> Observable<String> in return .never() }
    }
    
    private func combineOutputs(viewModels: Observable<[ConvertAmountViewModel]>, without base: Observable<Currency>) -> Observable<[(Variable<String?>, String)]> {
        return Observable.combineLatest(viewModels, base).map { (viewModels, currency) in
            return viewModels.filter { $0.currency != currency }.map { ($0.text, $0.currency) }
        }
    }
}

