//
//  AppSession.swift
//  Domain
//
//  Created by 林達也 on 2018/11/21.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation

open class AppSession: Entity {
    public typealias Identifier = Tagged<Activity, String>

    public init(id: Identifier) {
        self.id = id
    }

    public let id: Identifier

    open var developerToken: String? { abstract() }
}
