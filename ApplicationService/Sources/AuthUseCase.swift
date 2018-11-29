//
//  AuthUseCase.swift
//  ApplicationService
//
//  Created by 林達也 on 2018/11/29.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import Domain
import RxSwift

public protocol AuthUseCase {

    var oauth: OAuth { get }
}

extension ApplicationServiceProvider {
    public static func authUseCase(
        oauth: OAuth
    ) -> AuthUseCase {
        return AuthUseCaseImpl(
            oauth: oauth
        )
    }
}

final class AuthUseCaseImpl: AuthUseCase {

    let oauth: OAuth

    init(oauth: OAuth) {
        self.oauth = oauth
    }
}
