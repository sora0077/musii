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
    enum Trigger {
        case `default`
        case openURL(URL)
        case universalLink(URL)
        case notification(UNNotificationResponse)
    }
    enum BootSequence {
        case off
        case booting
        case ready
    }
    enum Action {
        case open(with: Trigger, applicationState: UIApplication.State)
    }
    enum Mutation {
        case setBootSequence(BootSequence)
        case setTrigger(Trigger, applicationState: UIApplication.State)
    }
    struct State {
        var bootSequence: BootSequence = .off
        var trigger: Trigger = .default
        var applicationState: UIApplication.State = .background
    }

    var initialState: State { return .init() }

    private let bootedSignal: Observable<Void>

    init(bootedSignal: Observable<Void>) {
        self.bootedSignal = bootedSignal
    }

    func mutate(action: Action) -> Observable<Mutation> {
        guard case let .open(trigger, applicationState) = action else { return .empty() }
        switch currentState.bootSequence {
        case .off:
            return .concat([
                .just(.setTrigger(trigger, applicationState: applicationState)),
                .just(.setBootSequence(.booting)),
                bootedSignal.map { .setBootSequence(.ready) }
            ])

        case .booting, .ready:
            return .just(.setTrigger(trigger, applicationState: applicationState))
        }
    }

    func reduce(state: inout State, mutation: Mutation) {
        switch mutation {
        case .setBootSequence(let bootSequence):
            state.bootSequence = bootSequence

        case .setTrigger(let trigger, let applicationState):
            state.trigger = trigger
            state.applicationState = applicationState
        }
    }
}
