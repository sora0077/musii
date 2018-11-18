//
//  Storefront.swift
//  MusicshotDomain
//
//  Created by 林達也.
//  Copyright © 2018年 林達也. All rights reserved.
//

import Foundation

open class Storefront: Entity {
    public typealias Identifier = Tagged<Storefront, String>

    public init(id: Identifier) {
        self.id = id
    }

    /// Persistent identifier of the resource. This member is required.
    public let id: Identifier
    /// The localized name of the storefront.
    open var name: String { abstract() }
    /// The localizations that the storefront supports, represented as an array of language tags.
    open var supportedLanguageTags: [String] { abstract() }
    /// The default language for the storefront, represented as a language tag.
    open var defaultLanguageTag: String { abstract() }

    /// Indicates if the object can no longer be accessed because it is now invalid.
    open var isInvalidated: Bool { abstract() }
}
