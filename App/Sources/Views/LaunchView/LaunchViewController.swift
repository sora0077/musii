//
//  LaunchViewController.swift
//  App
//
//  Created by 林達也 on 2018/11/23.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import ApplicationService

final class LaunchViewController: UIViewController, View {

    var disposeBag = DisposeBag()

    init(reactor: LaunchReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: LaunchReactor) {
        rx.sentMessage(#selector(viewDidAppear))
            .map { _ in Reactor.Action.launch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                self?.view.backgroundColor = isLoading ? .red : .blue
            })
            .disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
}
