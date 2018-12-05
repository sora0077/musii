//
//  Utility.swift
//  App
//
//  Created by 林達也 on 2018/11/27.
//  Copyright © 2018 林達也. All rights reserved.
//

import RxSwift
import RxCocoa

extension Observable {
    func filterNil<T>() -> Observable<T> where Element == T? {
        return filter { $0 != nil }.map { $0! }
    }

    func map<T>(_ keyPath: KeyPath<Element, T>) -> Observable<T> {
        return map { $0[keyPath: keyPath] }
    }

    func map<T, U>(_ keyPath: KeyPath<Element, T>, _ transform: @escaping (T) throws -> U) -> Observable<U> {
        return map { try transform($0[keyPath: keyPath]) }
    }
}

extension Observable where Element == Bool {
    func filterTrue() -> Observable<Void> {
        return filter { $0 }.map { _ in }
    }

    func filterFalse() -> Observable<Void> {
        return filter { !$0 }.map { _ in }
    }
}

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(
            events: sentMessage(#selector(Base.viewDidLoad))
                .map { _ in }
        )
    }
    var viewDidAppear: ControlEvent<Bool> {
        return ControlEvent(
            events: sentMessage(#selector(Base.viewDidAppear))
                .map { args in args.first as? Bool ?? false }
        )
    }
}
