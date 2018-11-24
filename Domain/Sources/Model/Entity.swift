//
//  Entity.swift
//  Domain
//
//  Created by 林達也 on 2018/11/18.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
@_exported import Tagged

public protocol Identifiable: Hashable {
    associatedtype IdentifierTag
    associatedtype IdentifierRawValue
    typealias Identifier = Tagged<IdentifierTag, IdentifierRawValue>

    var id: Identifier { get }
}

extension Identifiable where Self.IdentifierRawValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Identifiable where Self.IdentifierRawValue: Hashable {
    public var hashValue: Int { return id.hashValue }
}

//
// MARK: -
public protocol Entity: Identifiable {}

extension Entity {
    public typealias NotFound = DomainError.NotFound<Self>
}
