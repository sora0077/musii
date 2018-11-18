//
//  Entity.swift
//  Infrastructure
//
//  Created by 林達也 on 2018/11/18.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import Domain

protocol EntityConvertible {
    associatedtype Impl: EntityImplConvertible
}

protocol EntityImplConvertible {
    associatedtype Storage

    init(storage: Storage)
}
