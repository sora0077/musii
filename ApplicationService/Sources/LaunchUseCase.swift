//
//  LaunchService.swift
//  ApplicationService
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public protocol LaunchUseCase {

    func launch() -> Single<Void>
}

extension ApplicationServiceProvider {
    public static func launchUseCase(with service: LaunchService) -> LaunchUseCase {
        return LaunchUseCaseImpl(service: service)
    }
}

private final class LaunchUseCaseImpl: LaunchUseCase {

    private let service: LaunchService

    init(service: LaunchService) {
        self.service = service
    }

    func launch() -> Single<Void> {
        return service.launch()
    }
}
