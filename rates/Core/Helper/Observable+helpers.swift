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
    
    func filterOn<T>(_ observable: Observable<T>, selector: @escaping (E, T) -> Bool) -> Observable<E> {
        return withLatestFrom(observable) { ($0, $1) }.filter(selector).map( { $0.0 })
    }
}

extension ObservableType where E: Equatable {
    func sortToFirst(_ items: Observable<[E]>) -> Observable<[E]> {
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
    
    static func combineLatest<O1,O2: OptionalType>(_ source1: Observable<O1>, andWaitValueIn source2: Observable<O2>) -> Observable<(O1,O2.Wrapped)> {
        return Observable<(O1,O2)>.combineLatest(source1, source2) { (value1: O1, value2: O2) in
            return (value1, value2)
            }.flatMap { (arg) -> Observable<(O1,O2.Wrapped)> in
                let (value1, value2) = arg
                return value2.optional.map { Observable<(O1,O2.Wrapped)>.just((value1,$0)) } ?? Observable<(O1,O2.Wrapped)>.never()
            }
    }
}

extension Observable {
    static func formatInputed(_ observable: Observable<InputedPair>, formatter: ICurrencyFormatter) -> Observable<Decimal?> {
        return observable.map {(inputed) -> Decimal? in
            return inputed.0.map { formatter.amount(from: $0) } ?? nil
        }
    }
}

extension ConvertCellViewModel {
    func inputChanged() -> Observable<InputedPair> {
        let currency = self.currency
        return text.asObservable().distinctUntilChanged().map { ($0, currency) }
    }
}

