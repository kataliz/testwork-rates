//
//  CombineUserInputsManagerTest.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 07/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import rates

class CombineUserInputsManagerTest: XCTestCase {
    
    var combineManager: CombineUserInputsManager!
    var formatter: ICurrencyFormatter!
    var formatting: FormatInputed!
    
    var items = PublishSubject<[ConvertCellViewModel]>()
    var select = PublishSubject<ConvertCellViewModel>()
    var currency = PublishSubject<Currency>()
    var rates = PublishSubject<IRatesInfo?>()
    var info: ICombineInfo!
    
    var firstModel: ConvertCellViewModel!
    var secondModel: ConvertCellViewModel!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter(maxLenght: 9)
        combineManager = CombineUserInputsManager(formatter: formatter)
        
        info = CombineInfo(viewModels: items.asObservable(), select: select.asObservable(), currency: currency.asObservable(), rates: rates.asObservable())
        formatting = {(inputed, currency) in
            if let inputed = inputed, !inputed.isEmpty {
                return self.formatter.formatt(inputed: inputed, currency: currency)
            } else {
                return ""
            }
        }
        
        firstModel = ConvertCellViewModel(currency: "USD", name: "USD", formatInputed: formatting)
        secondModel = ConvertCellViewModel(currency: "RUB", name: "RUB", formatInputed: formatting)
    }
    
    override func tearDown() {
        super.tearDown()
        items = PublishSubject<[ConvertCellViewModel]>()
        select = PublishSubject<ConvertCellViewModel>()
        currency = PublishSubject<Currency>()
        rates = PublishSubject<IRatesInfo?>()
        info = CombineInfo(viewModels: items.asObservable(), select: select.asObservable(), currency: currency.asObservable(), rates: rates.asObservable())
        firstModel.text.value = nil
        secondModel.text.value = nil
    }
    
    func testConstruct() {
        let scheduler = TestScheduler(initialClock: 0)
        
        scheduler.scheduleAt(201) {
            self.currency.onNext("USD")
            self.rates.onNext(MockRatesInfo.exampleUsdRub())
            self.items.onNext([self.firstModel,self.secondModel])
        }
        
        scheduler.scheduleAt(210) {
            self.firstModel.text.value = "1.0"
        }
        
        let _ = scheduler.start {
            self.combineManager.connectInputs(self.info, fillOn: scheduler)
        }
        
        XCTAssertEqual(secondModel.text.value, "68.00")
        XCTAssertEqual(firstModel.text.value, "1.0")
    }
    
    func testSelect() {
        let scheduler = TestScheduler(initialClock: 0)
        
        scheduler.scheduleAt(201) {
            self.currency.onNext("USD")
            self.rates.onNext(MockRatesInfo.exampleUsdRub())
            self.items.onNext([self.firstModel,self.secondModel])
        }
        
        scheduler.scheduleAt(210) {
            self.firstModel.text.value = "1.0"
        }
        
        scheduler.scheduleAt(220) {
            self.currency.onNext("RUB")
            self.rates.onNext(MockRatesInfo.exampleRubUsd())
            self.select.onNext(self.secondModel)
        }
        
        let _ = scheduler.start {
            self.combineManager.connectInputs(self.info, fillOn: scheduler)
        }
        
        XCTAssertEqual(secondModel.text.value, "68.00")
        XCTAssertEqual(firstModel.text.value, "6.80")
    }
    
    func testNewRates() {
        let scheduler = TestScheduler(initialClock: 0)
        
        scheduler.scheduleAt(201) {
            self.currency.onNext("USD")
            self.rates.onNext(MockRatesInfo.exampleUsdRub())
            self.items.onNext([self.firstModel,self.secondModel])
        }
        
        scheduler.scheduleAt(210) {
            self.firstModel.text.value = "1.0"
        }
        
        scheduler.scheduleAt(220) {
            self.rates.onNext(MockRatesInfo.exampleUsdRub2())
        }
        
        let _ = scheduler.start {
            self.combineManager.connectInputs(self.info, fillOn: scheduler)
        }
        
        XCTAssertEqual(secondModel.text.value, "50.10")
        XCTAssertEqual(firstModel.text.value, "1.0")
    }
}
