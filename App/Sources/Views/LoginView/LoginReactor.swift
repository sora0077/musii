//
//  LoginReactor.swift
//  App
//
//  Created by 林達也 on 2018/11/22.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import ApplicationService

final class LoginReactor: Reactor {
    enum Action {
        case didLogin
    }
    struct State {
        var didLogin: Bool = false
    }

    var initialState: State { return .init() }

    let authUseCase: AuthUseCase

    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }

    func reduce(state: inout State, mutation: Action) {
        switch mutation {
        case .didLogin:
            state.didLogin = true
        }
    }
}
