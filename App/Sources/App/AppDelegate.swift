//
//  AppDelegate.swift
//  App
//
//  Created by 林達也 on 2018/11/05.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var dependency: AppDependency!

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        dependency = dependency ?? CompositionRoot.resolve()

        window = dependency.window

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {

        return dependency.openURLHandler(url, app.applicationState)
    }
}
