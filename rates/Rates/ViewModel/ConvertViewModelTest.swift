//
//  ConvertViewModelTest.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 05/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import rates

class ConvertViewModelTest: XCTestCase {
    
    var viewModel: ConverterViewModel!
    var updateManager: MockUpdateManager!
    
    override func setUp() {
        super.setUp()
        updateManager = MockUpdateManager()
        viewModel = ConverterViewModel(updateManager: updateManager, constructManager: ConstructConverterManager(currencyInfo: MockCurrencyInfo(), formatter: MockFormatter()), combineInputManager: CombineUserInputsManager(formatter: MockFormatter()))
    }
    
    override func tearDown() {
        super.tearDown()
        updateManager.subject = PublishSubject<IRatesInfo?>()
    }
    
    func testTransform() {
        let scheduler = TestScheduler(initialClock: 0)
        let select = PublishSubject<ConvertCellViewModel>()
        
        scheduler.scheduleAt(201) {
            self.updateManager.subject.onNext(MockRatesInfo.exampleUsdRub())
        }
        
        let results = scheduler.start { () -> Observable<[ConvertCellViewModel]> in
            let output = self.viewModel.transform(input: Input(didSelect: select.asObservable()))
            return Observable.merge([output.viewModels,output.viewModels])
        }
        
        XCTAssertEqual(results.events.first?.value.element?.first?.currency, "USD")
        XCTAssertEqual(results.events.first?.value.element?.second?.currency, "RUB")
    }
    
    func testSelect() {
        let scheduler = TestScheduler(initialClock: 0)
        let select = PublishSubject<ConvertCellViewModel>()
        
        scheduler.scheduleAt(201) {
            self.updateManager.subject.onNext(MockRatesInfo.exampleUsdRub())
        }
        
        scheduler.scheduleAt(210) {
            let rubCell = ConvertCellViewModel(currency: "RUB", name: "", formatInputed: { _,_ in "" })
            select.onNext(rubCell)
        }
        
        scheduler.scheduleAt(220) {
            self.updateManager.subject.onNext(MockRatesInfo.exampleRubUsd())
        }
        
        let results = scheduler.start { () -> Observable<[ConvertCellViewModel]> in
            let output = self.viewModel.transform(input: Input(didSelect: select.asObservable()))
            return Observable.merge([output.viewModels,output.viewModels])
        }
        
        XCTAssertEqual(results.events.last?.value.element?.first?.currency, "RUB")
        XCTAssertEqual(results.events.last?.value.element?.second?.currency, "USD")
    }
}
