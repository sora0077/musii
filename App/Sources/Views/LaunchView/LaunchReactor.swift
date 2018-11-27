//
//  LaunchReactor.swift
//  App
//
//  Created by 林達也 on 2018/11/22.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import ApplicationService

final class LaunchReactor: Reactor {
    enum Action {
        case launch
    }
    enum Mutation {
        case setLaunched
        case setLoading(Bool)
    }
    struct State {
        var launched: Bool = false
        var isLoading: Bool = false
    }

    var initialState: State { return .init() }

    private let launchService: LaunchService

    init(launchService: LaunchService) {
        self.launchService = launchService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .launch:
            return .concat([
                .just(.setLoading(true)),
                launchService.launch().asObservable()
                    .map { .setLaunched }
                    .catchError { _ in .empty() },
                .just(.setLoading(false))
            ])
        }
    }

    func reduce(state: inout State, mutation: Mutation) {
        switch mutation {
        case .setLaunched:
            state.launched = true

        case .setLoading(let value):
            state.isLoading = value
        }
    }
}
