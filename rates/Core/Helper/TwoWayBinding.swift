//
//  TwoWayBinding.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 03/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <->

func <-> <T: Comparable>(property: ControlProperty<T?>, variable: Variable<T?>) -> Disposable {
    let bindToUiDisposable = variable.asObservable().bind(to: property)
    let bindToVariable = property.observeOn(MainScheduler.asyncInstance).filter( { $0 != variable.value }).subscribe(onNext: { (value) in
        variable.value = value
    }, onCompleted: {
        bindToUiDisposable.dispose()
    })
    
    return CompositeDisposable(bindToUiDisposable, bindToVariable)
}
