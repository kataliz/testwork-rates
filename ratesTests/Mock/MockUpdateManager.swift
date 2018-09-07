//
//  MockUpdateManager.swift
//  ratesTests
//
//  Created by Chimit Zhanchipzhapov on 07/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift

@testable import rates

class MockUpdateManager: IRatesUpdateManager {
    
    var subject = PublishSubject<IRatesInfo?>()
    
    func configureBase(_ baseCurrency: Observable<Currency>, timer: Observable<UInt64>) -> Observable<IRatesInfo?> {
        return subject.asObservable()
    }
}
