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
    
    func wrapAsObservable() -> Observable<Observable<Self.E>> {
        return Observable.just(self.asObservable())
    }
}

extension ObserverType {
    
    //    func combineIgnoreNil(_ observable: Observable) -> Observable<(Element.Wrapped, Element.Wrapped)> {
    //        let some = Observable.combineLatest(self, observable)
    //
    ////        return Observable.combineLatest(self, observable).flatMap { (value, other) in
    ////            guard let value = value, let other = other else {
    ////                return Observable<(Element.Wrapped, Element.Wrapped)>.empty()
    ////            }
    ////            return Observable<(Element.Wrapped, Element.Wrapped)>.just((value, other))
    ////        }
    //        fatalError()
    //    }
    
//    public static func combineIgnoreNil
//        public static func combineLatest<O1, O2>(_ source1: O1, _ source2: O2) -> RxSwift.Observable<(O1.E, O2.E)> where O1 : ObservableType, O2 : ObservableType
}

