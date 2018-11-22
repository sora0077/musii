//
//  GatewayReactor.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import ApplicationService

final class GatewayReactor: Reactor {
    enum Trigger {

    }
    enum Action {
        case open(with: Trigger, applicationState: UIApplication.State)
    }
    struct State {

    }

    var initialState: State { return .init() }
}
