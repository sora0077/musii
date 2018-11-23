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

    private let launchView: () -> LaunchViewController

    private weak var launchViewController: LaunchViewController?

    init(reactor: GatewayReactor,
         launchView: @escaping () -> LaunchViewController) {
        defer { self.reactor = reactor }
        self.launchView = launchView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: GatewayReactor) {
        rx.sentMessage(#selector(viewDidLoad))
            .take(1)
            .map { _ in Reactor.Action.open(with: .default, applicationState: .active) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let bootSequence = reactor.state.map { $0.bootSequence }

        bootSequence
            .map { $0 == .booting }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.presentLaunchView()
                } else {
                    self?.dismissLaunchView()
                }
            })
            .disposed(by: disposeBag)

        bootSequence
            .filter { $0 == .ready }
            .withLatestFrom(reactor.state.map { ($0.trigger, $0.applicationState) })
            .subscribe(onNext: { [weak self] in
                print($0)
            })
            .disposed(by: disposeBag)
    }

    private func presentLaunchView() {
        let vc = launchView()
        launchViewController = vc

        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)

        vc.view.alpha = 0
        UIView.animate(withDuration: 0.1, animations: { vc.view.alpha = 1 })
    }

    private func dismissLaunchView() {
        guard let vc = launchViewController else { return }

        vc.willMove(toParent: nil)

        UIView.animate(
            withDuration: 0.1,
            animations: {
                vc.view.alpha = 0
            },
            completion: { _ in
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            })
    }
}
