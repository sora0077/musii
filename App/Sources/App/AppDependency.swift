//
//  AppDependency.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import ApplicationService
import Keys

struct AppDependency {
    typealias OpenURLHandler = (URL, UIApplication.State) -> Bool

    let window: UIWindow
    let openURLHandler: OpenURLHandler
}

final class CompositionRoot {

    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let launchService = ApplicationServiceProvider.launchService()

        let gatewayReactor = GatewayReactor()
        let gatewayViewController = GatewayViewController(
            reactor: gatewayReactor,
            launchView: {
                LaunchViewController(
                    reactor: LaunchReactor(launchService: launchService)
                )
            }
        )

        window.rootViewController = gatewayViewController
        window.makeKeyAndVisible()

        return AppDependency(
            window: window,
            openURLHandler: { [weak gatewayReactor] url, state in
                gatewayReactor?.action.onNext(.open(with: .openURL(url), applicationState: state))
                return true
            }
        )
    }
}
