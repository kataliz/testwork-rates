//
//  ConstructConverterManagerTest.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 07/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import rates

class ConstructConverterManagerTest: XCTestCase {
    
    var constructManager: ConstructConverterManager!
    var info: MockCurrencyInfo!
    var formatter: MockFormatter!
    
    override func setUp() {
        super.setUp()
        info = MockCurrencyInfo()
        formatter = MockFormatter()
        constructManager = ConstructConverterManager(currencyInfo: info, formatter: formatter)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConstruct() {
        let publishRates = PublishSubject<IRatesInfo>()
        let rates = MockRatesInfo.example(base: "USD")
        let scheduler = TestScheduler(initialClock: 0)
        
        info.name = "LONGNAME"
        
        scheduler.scheduleAt(201) {
            publishRates.onNext(rates)
        }
        
        let results = scheduler.start {
            self.constructManager.construct(rates: publishRates.asObservable())
        }
        
        XCTAssertEqual(results.events.count, 1)
        XCTAssertEqual(results.events.first?.value.element?.count, 3)
        XCTAssertEqual(results.events.first?.value.element?.first?.currency, "USD")
        XCTAssertEqual(results.events.first?.value.element?.first?.name, "LONGNAME")
        XCTAssertEqual(results.events.first?.value.element?.first?.text.value, nil)
        
        let formatted = results.events.first?.value.element?.first?.formatInputed?("123","USD")
        XCTAssertEqual(formatted, "1.23")
    }
}
