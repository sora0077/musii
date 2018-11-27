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

    private let createLaunchView: () -> LaunchViewController
    private let createRootView: () -> RootViewController

    private weak var rootViewController: RootViewController?

    init(reactor: GatewayReactor,
         launchView: @escaping () -> LaunchViewController,
         rootView: @escaping () -> RootViewController) {
        defer { self.reactor = reactor }
        createLaunchView = launchView
        createRootView = rootView
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

    func bind(reactor: GatewayReactor) {
        // input
        reactor.state.map { $0.bootSequence }
            .distinctUntilChanged()
            .bind(to: Binder(self) { vc, bootSequence in
                vc.handleViewController(with: bootSequence)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.trigger }
            .filterNil()
            .distinctUntilChanged { $0 == $1 }
            .bind(to: Binder(self) { vc, args in
                vc.handleTrigger(args.mode, applicationState: args.applicationState)
            })
            .disposed(by: disposeBag)

        // output
        rx.viewDidAppear
            .take(1)
            .map { _ in Reactor.Action.boot }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func handleViewController(with bootSequence: GatewayReactor.BootSequence) {
        if let presented = presentedViewController {
            presented.dismiss(animated: !(presented is LaunchViewController)) {
                self.handleViewController(with: bootSequence)
            }
            return
        }

        guard let reactor = reactor else { return }

        switch bootSequence {
        case .off:
            break

        case .booting:
            let vc = createLaunchView()
            vc.rx.didLaunch
                .map { Reactor.Action.ready }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false, completion: nil)

        case .ready:
            let vc = createRootView()
            rootViewController = vc
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }

    private func handleTrigger(_ trigger: GatewayReactor.Trigger, applicationState: UIApplication.State) {

    }
}
