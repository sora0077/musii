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

    private weak var launchViewController: UIViewController?

    init(reactor: GatewayReactor,
         launchView: @escaping () -> LaunchViewController) {
        defer { self.reactor = reactor }
        self.createLaunchView = launchView
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
            .subscribe(onNext: { [weak self] in
                print($0)
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
            presented.dismiss(animated: true) {
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
            break
        }
    }

    private func presentLaunchView() {
        let vc = createLaunchView()
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
