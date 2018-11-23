//
//  LaunchService.swift
//  ApplicationService
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import RxSwift

public protocol LaunchService {

    func launch() -> Single<Void>
}

extension ApplicationServiceProvider {
    public static func launchService() -> LaunchService {
        return LaunchServiceImpl()
    }
}

private final class LaunchServiceImpl: LaunchService {

    func launch() -> Single<Void> {
        return Single.just(())//.delay(0.1, scheduler: MainScheduler.instance)
    }
}
