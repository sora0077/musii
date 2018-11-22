//
//  AppDependency.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import ApplicationService

struct AppDependency {
    let window: UIWindow
}

final class CompositionRoot {

    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let gatewayReactor = GatewayReactor()
        let gatewayViewController = GatewayViewController(reactor: gatewayReactor)

        window.rootViewController = gatewayViewController
        window.makeKeyAndVisible()

        return AppDependency(
            window: window
        )
    }
}
