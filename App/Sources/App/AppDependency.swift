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

        let session = InfrastructureServiceProvider.session()

        let launchService = InfrastructureServiceProvider.launchService()
        let launchUseCase = ApplicationServiceProvider.launchUseCase(with: launchService)

        let oauth = InfrastructureServiceProvider.oauth(scheme: "musicshot-dev-oauth", session: session)
        let authUseCase = ApplicationServiceProvider.authUseCase(oauth: oauth)

        let gatewayReactor = GatewayReactor()
        let gatewayViewController = GatewayViewController(
            reactor: gatewayReactor,
            launchView: {
                LaunchViewController(
                    reactor: LaunchReactor(launchUseCase: launchUseCase)
                )
            },
            rootView: {
                RootViewController(
                    reactor: RootReactor(),
                    loginView: {
                        LoginViewController(
                            reactor: LoginReactor(authUseCase: authUseCase)
                        )
                    }
                )
            }
        )

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = gatewayViewController
        window.makeKeyAndVisible()

        return AppDependency(
            window: window,
            openURLHandler: { [weak oauth, weak gatewayReactor] url, state in
                if oauth?.handleURL(url) ?? false {
                    return true
                }

                gatewayReactor?.action.onNext(.open(with: .openURL(url), applicationState: state))
                return true
            }
        )
    }
}
