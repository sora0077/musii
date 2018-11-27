//
//  GatewayReactor.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import UserNotifications
import ApplicationService

final class GatewayReactor: Reactor {
    enum Trigger: Equatable {
        case openURL(URL)
        case universalLink(URL)
        case notification(UNNotificationResponse)
    }
    enum BootSequence: Equatable {
        case off
        case booting
        case ready
    }
    enum Action {
        case boot
        case ready
        case open(with: Trigger, applicationState: UIApplication.State)
    }
    enum Mutation {
        case setBootSequence(BootSequence)
        case setTrigger(Trigger, applicationState: UIApplication.State)
    }
    struct State {
        var bootSequence: BootSequence = .off
        var trigger: (mode: Trigger, applicationState: UIApplication.State)? {
            return bootSequence == .ready ? _trigger : nil
        }
        fileprivate var _trigger: (mode: Trigger, applicationState: UIApplication.State)?
    }

    var initialState: State { return .init() }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .boot:
            return .just(.setBootSequence(.booting))

        case .ready:
            return .just(.setBootSequence(.ready))

        case .open(with: let trigger, applicationState: let state):
            return .just(.setTrigger(trigger, applicationState: state))
        }
    }

    func reduce(state: inout State, mutation: Mutation) {
        switch mutation {
        case .setBootSequence(let bootSequence):
            state.bootSequence = bootSequence

        case .setTrigger(let trigger, let applicationState):
            state._trigger = (trigger, applicationState)
        }
    }
}
