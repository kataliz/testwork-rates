//
//  Observable+helper.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift
import RxTest

extension TestScheduler {
    func timer(start: TestTime, period: TestTime, endTime: TestTime) -> TestableObservable<UInt64> {
        var nextes = [Recorded<Event<UInt64>>]()
        for time in stride(from: start, to: endTime, by: period) {
            nextes.append(next(time, UInt64(time)))
        }
        
        nextes.append(completed(endTime))
        
        return createHotObservable(nextes)
    }
}
