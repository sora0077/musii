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

    fileprivate let didLaunch = PublishSubject<Void>()

    init(reactor: LaunchReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() {
            view.addSubview(vc.view)
            constrain(vc.view) { view in
                view.edge.equalTo(view.superview.edge)
            }
            addChild(vc)
            vc.didMove(toParent: self)
        }
    }

    func bind(reactor: LaunchReactor) {
        // input
        reactor.state.map { $0.isLoading }
            .subscribe(onNext: { [weak self] _ in

            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.launched }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(to: didLaunch)
            .disposed(by: disposeBag)

        // output
        rx.viewDidAppear
            .take(1)
            .map { _ in Reactor.Action.launch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == LaunchViewController {
    var didLaunch: ControlEvent<Void> {
        return ControlEvent(events: base.didLaunch)
    }
}
