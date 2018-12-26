//
//  Signal.swift
//  Domain
//
//  Created by 林達也 on 2018/12/12.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import RxSwift

open class SignalOf<E: Entity> {
    public enum Event<Value> {
        case some(Value)
        case none

        public var value: Value? {
            switch self {
            case .some(let value): return value
            case .none: return nil
            }
        }
    }

    public init() {}

    open func on(_ id: E.Identifier) -> Observable<Event<E>> {
        abstract()
    }

    public func on<V>(_ id: E.Identifier, _ keyPath: KeyPath<E, V>) -> Observable<Event<V>> {
        return on(id).map {
            switch $0 {
            case .some(let entity): return .some(entity[keyPath: keyPath])
            case .none: return .none
            }
        }
    }
}


public protocol NewPlaylist {

    func get() -> (Observable<[Any]>, () -> Void)
}
