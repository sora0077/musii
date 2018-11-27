//
//  RootReactor.swift
//  App
//
//  Created by 林達也 on 2018/11/28.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import ApplicationService

final class RootReactor: Reactor {
    enum Action {}
    struct State {}

    var initialState: State { return .init() }
}
