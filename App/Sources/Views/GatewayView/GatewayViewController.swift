//
//  GatewayViewController.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import ApplicationService

final class GatewayViewController: UIViewController, View {

    var disposeBag = DisposeBag()

    init(reactor: GatewayReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: GatewayReactor) {
        print("bind")
    }
}
