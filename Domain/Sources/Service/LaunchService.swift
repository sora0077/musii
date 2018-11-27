//
//  LaunchService.swift
//  Domain
//
//  Created by 林達也 on 2018/11/28.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import RxSwift

public protocol LaunchService {
    func launch() -> Single<Void>
}
