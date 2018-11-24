//
//  DomainError.swift
//  Domain
//
//  Created by 林達也 on 2018/11/21.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation

func abstract() -> Never {
    fatalError("abstract")
}

public enum DomainError: Error {

    public struct NotFound<E>: Error {

    }
}
