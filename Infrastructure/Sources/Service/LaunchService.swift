//
//  LaunchService.swift
//  Infrastructure
//
//  Created by 林達也 on 2018/11/28.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import FirebaseCore
import FirebaseRemoteConfig

extension InfrastructureServiceProvider {
    public static func launchService() -> LaunchService {
        return LaunchServiceImpl()
    }
}

private final class LaunchServiceImpl: LaunchService {
    private struct Static {
        static let load: () -> Void = {
            FirebaseApp.configure()
            return {}
        }()
    }

    init() {
        Static.load()
    }

    func launch() -> Single<Void> {
        return Single.create(subscribe: { event in
            RemoteConfig.remoteConfig().fetch(completionHandler: { status, _ in
                if status == .success {
                    RemoteConfig.remoteConfig().activateFetched()
                }
                event(.success(()))
            })
            return Disposables.create {}
        })
    }
}
