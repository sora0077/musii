//
//  AppDependency.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import Domain
import Infrastructure
import ApplicationService

struct AppDependency {
    typealias OpenURLHandler = (URL, UIApplication.State) -> Bool

    let window: UIWindow
    let openURLHandler: OpenURLHandler
}

final class CompositionRoot {

    static func resolve() -> AppDependency {

        let launchService = InfrastructureServiceProvider.launchService()
        let launchUseCase = ApplicationServiceProvider.launchUseCase(with: launchService)

        let gatewayReactor = GatewayReactor()
        let gatewayViewController = GatewayViewController(
            reactor: gatewayReactor,
            launchView: {
                LaunchViewController(
                    reactor: LaunchReactor(launchUseCase: launchUseCase)
                )
            }
        )

        let window = UIWindow(frame: UIScreen.main.bounds)
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
