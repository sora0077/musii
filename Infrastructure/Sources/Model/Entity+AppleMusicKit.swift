//
//  Entity+AppleMusicKit.swift
//  Infrastructure
//
//  Created by 林達也 on 2018/11/18.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import AppleMusicKit

extension String: Language {}

extension StorefrontImpl.Storage: Storefront {
    typealias Identifier = String
    typealias Language = String

    convenience init(id: Identifier,
                     defaultLanguageTag: Language,
                     name: String,
                     supportedLanguageTags: [Language]) throws {
        self.init()
        self.id = id
        self.defaultLanguageTag = defaultLanguageTag
        self.name = name
        self.supportedLanguageTags.append(objectsIn: supportedLanguageTags)
    }
}
