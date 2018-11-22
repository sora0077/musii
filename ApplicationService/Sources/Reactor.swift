//
//  Reactor.swift
//  ApplicationService
//
//  Created by 林達也 on 2018/11/22.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
@_exported import ReactorKit
@_exported import class RxSwift.Observable
@_exported import class RxSwift.DisposeBag

public protocol Reactor: ReactorKit.Reactor {

    func reduce(state: inout State, mutation: Mutation)
}

extension Reactor {

    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        reduce(state: &state, mutation: mutation)
        return state
    }

    public func reduce(state: inout State, mutation: Mutation) {}
}
