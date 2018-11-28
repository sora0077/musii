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
    struct Trigger: Equatable {
        private struct Static {  // swiftlint:disable:this nesting
            static var counter: UInt64 {
                defer { _counter &+= 1 }
                return _counter
            }
            private static var _counter: UInt64 = 0
        }
        enum Event: Equatable {  // swiftlint:disable:this nesting
            case openURL(URL)
            case universalLink(URL)
            case notification(UNNotificationResponse)
        }
        private let id = Static.counter
        let event: Event
        let applicationState: UIApplication.State
    }
    enum BootSequence: Equatable {
        case off
        case booting
        case ready
    }
    enum Action {
        case boot
        case ready
        case open(with: Trigger.Event, applicationState: UIApplication.State)
    }
    enum Mutation {
        case setBootSequence(BootSequence)
        case setTrigger(Trigger.Event, applicationState: UIApplication.State)
    }
    struct State {
        var bootSequence: BootSequence = .off
        var trigger: Trigger? {
            return bootSequence == .ready ? _trigger : nil
        }
        fileprivate var _trigger: Trigger?
    }

    var initialState: State { return .init() }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .boot:
            return .just(.setBootSequence(.booting))

        case .ready:
            return .just(.setBootSequence(.ready))

        case .open(with: let event, applicationState: let state):
            return .just(.setTrigger(event, applicationState: state))
        }
    }

    func reduce(state: inout State, mutation: Mutation) {
        switch mutation {
        case .setBootSequence(let bootSequence):
            state.bootSequence = bootSequence

        case .setTrigger(let event, let applicationState):
            state._trigger = Trigger(event: event, applicationState: applicationState)
        }
    }
}
