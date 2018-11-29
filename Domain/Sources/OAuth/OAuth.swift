//
//  OAuth.swift
//  Domain
//
//  Created by 林達也 on 2018/11/24.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import RxSwift

open class OAuth {
    open var gitHub: GitHub { abstract() }

    public init() {}

    open func handleURL(_ url: URL) -> Bool {
        abstract()
    }
}

extension OAuth {
    public enum Error: Swift.Error {
        case timeout
        case invalidState
    }
}

extension OAuth {
    open class GitHub {
        open var authorizeURL: URL { abstract() }

        public init() {}

        open func authorized() -> Single<Void> {
            abstract()
        }
    }
}
