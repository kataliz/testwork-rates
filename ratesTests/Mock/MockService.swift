//
//  MockService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 05/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

@testable import rates

class MockService: IRxRatesService {

    var loadRequestSubject = PublishSubject<IRatesInfo>()
    
    func send(rates: IRatesInfo) {
        loadRequestSubject.onNext(rates)
    }
    
    func loadRequest(currency: Currency) -> Observable<IRatesInfo> {
        return loadRequestSubject.asObservable()
    }
}
