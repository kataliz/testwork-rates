//
//  Observable+helpers.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 04/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension Observable {
    func first() -> Observable {
        return take(1)
    }
}

extension ObservableType {
    func flatMap<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.E) throws -> O) -> Observable<O.E> {
        return flatMap { [weak obj] value -> Observable<O.E> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    
    func flatMapLatest<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.E) throws -> O) -> Observable<O.E> {
        return flatMapLatest { [weak obj] value -> Observable<O.E> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    
    func flatMapFirst<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.E) throws -> O) -> Observable<O.E> {
        return flatMapFirst { [weak obj] value -> Observable<O.E> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    
    func wrapAsObservable() -> Observable<Observable<Self.E>> {
        return Observable.just(self.asObservable())
    }
}

extension ObservableType where E: Equatable {
    func scanRearange(_ items: Observable<[E]>) -> Observable<[E]> {
        return Observable.combineLatest(items, self.wrapAsObservable()).flatMap { (arguments) -> Observable<[E]> in
            let (items, itemFirst) = arguments
            return itemFirst.scan(items, accumulator: { (result, selected) in
                return result.rarrangedAtStart(selected)
            }).startWith(items)
        }
    }
}

extension Observable {
    static func timer(_ period: RxTimeInterval) -> Observable<UInt64> {
        return Observable<UInt64>.timer(0, period: period, scheduler: MainScheduler.instance)
    }
}

