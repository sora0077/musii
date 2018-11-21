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

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        print(Single<Int>.self)
        return true
    }
}
