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
    public typealias Provider = OAuthProvider

    open func handleURL(_ url: URL) -> Bool {
        abstract()
    }
}

public protocol OAuthProvider {
    associatedtype Context

    var redirectURL: URL { get }

    func auth(with context: Context) -> Single<Void>
}
