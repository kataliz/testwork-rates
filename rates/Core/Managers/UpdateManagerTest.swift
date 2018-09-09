//
//  UpdateManagerTest.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 05/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Alamofire

@testable import rates

class UpdateManagerTest: XCTestCase {
    
    var updateManager: RatesUpdateManager!
    var ratesService: MockService!
    var scheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        super.setUp()
        ratesService = MockService()
        updateManager = RatesUpdateManager(ratesService: ratesService, scheduler: scheduler)
    }
    
    override func tearDown() {
        super.tearDown()
        scheduler.stop()
    }
    
    func testConfigureBase() {
        let timer = scheduler.timer(start: 200, period: 1, endTime: 220)
        let currency = PublishSubject<Currency>().startWith("USD")
        
        scheduler.scheduleAt(210) {
            self.ratesService.send(rates: MockRatesInfo.example(base: "USD"))
        }
        
        let results = scheduler.start {
            self.updateManager.configureBase(currency.asObservable(), timer: timer.asObservable())
        }
        
        XCTAssertEqual(results.events.count, 1)
        XCTAssertEqual(results.events[0].value.element as? MockRatesInfo, MockRatesInfo.example(base: "USD"))
    }
    
    func testFailedLoadBase() {
        let timer = scheduler.timer(start: 200, period: 1, endTime: 220)
        let currency = PublishSubject<Currency>()
        
        scheduler.scheduleAt(201) {
            currency.onNext("USD")
        }
        
        scheduler.scheduleAt(210) {
            self.ratesService.loadRequestSubject.onError(NetworkError.failed)
        }
        
        let results = scheduler.start {
            self.updateManager.configureBase(currency.asObservable(), timer: timer.asObservable())
        }
        
        XCTAssertNil(results.events.first?.value.element)
    }
    
    func testNoEvents() {
        let timer = scheduler.timer(start: 200, period: 1, endTime: 210)
        let currency = PublishSubject<Currency>()
        
        let results = scheduler.start {
            self.updateManager.configureBase(currency.asObservable(), timer: timer.asObservable())
        }
        
        XCTAssertEqual(results.events.count, 0)
    }
}
