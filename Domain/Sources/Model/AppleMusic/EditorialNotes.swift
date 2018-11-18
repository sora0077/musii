//
//  EditorialNotes.swift
//  MusicshotDomain
//
//  Created by 林達也.
//  Copyright © 2018年 林達也. All rights reserved.
//

import Foundation

open class EditorialNotes {
    public init() {}

    /// Notes shown when the content is being prominently displayed.
    open var standard: String { abstract() }
    /// Abbreviated notes shown in-line or when the content is shown alongside other content.
    open var short: String { abstract() }

    /// Indicates if the object can no longer be accessed because it is now invalid.
    open var isInvalidated: Bool { abstract() }
}
