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
    
    override func setUp() {
        super.setUp()
        ratesService = MockService()
        updateManager = RatesUpdateManager(ratesService: ratesService)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConfigureBase() {
        let scheduler = TestScheduler(initialClock: 0)
        let timer = scheduler.timer(start: 200, period: 1, endTime: 220)
        let currency = PublishSubject<Currency>()
        
        scheduler.scheduleAt(201) {
            currency.onNext("USD")
        }
        
        scheduler.scheduleAt(210) {
            self.ratesService.send(rates: MockRatesInfo.example(base: "USD"))
        }
        
        let results = scheduler.start {
            self.updateManager.configureBase(currency.asObservable(), timer: timer.asObservable())
        }
        
        XCTAssertEqual(results.events.count, 2)
        XCTAssertEqual(results.events[1].value.element?.optional as? MockRatesInfo, MockRatesInfo.example(base: "USD"))
    }
    
    func testFailedLoadBase() {
        let scheduler = TestScheduler(initialClock: 0)
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
        
        XCTAssertNil(results.events.second?.value.element?.optional)
    }
    
    func testNoEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let timer = scheduler.timer(start: 200, period: 1, endTime: 210)
        let currency = PublishSubject<Currency>()
        
        let results = scheduler.start {
            self.updateManager.configureBase(currency.asObservable(), timer: timer.asObservable())
        }
        
        XCTAssertEqual(results.events.count, 0)
    }
    
    func testClearOldAndWait() {
        let scheduler = TestScheduler(initialClock: 0)
        let timer = scheduler.timer(start: 200, period: 1, endTime: 260)
        let currency = PublishSubject<Currency>()
        
        scheduler.scheduleAt(201) {
            currency.onNext("USD")
        }
        
        scheduler.scheduleAt(202) {
            currency.onNext("USD")
        }
        
        scheduler.scheduleAt(203) {
            currency.onNext("USD")
        }
        
        scheduler.scheduleAt(204) {
            currency.onNext("USD")
        }
        
        scheduler.scheduleAt(250) {
            self.ratesService.send(rates: MockRatesInfo.example(base: "USD"))
        }
        
        scheduler.scheduleAt(253) {
            currency.onNext("USD")
        }
        
        let results = scheduler.start {
            self.updateManager.configureBase(currency.asObservable(), timer: timer.asObservable())
        }
        
        XCTAssertEqual(results.events.count, 6)
        XCTAssertEqual(results.events[4].value.element?.optional as? MockRatesInfo, MockRatesInfo.example(base: "USD"))
    }
}
