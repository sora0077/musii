//
//  MainViewController.swift
//  App
//
//  Created by 林達也 on 2018/11/28.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import StoreKit
import ApplicationService

final class RootViewController: UIViewController, View {

    var disposeBag = DisposeBag()

    private let loginView: () -> LoginViewController

    init(reactor: RootReactor,
         loginView: @escaping () -> LoginViewController) {
        defer { self.reactor = reactor }
        self.loginView = loginView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: RootReactor) {
        // input
        rx.viewDidAppear
            .take(1)
            .withLatestFrom(reactor.state.map { $0.isLoggedIn })
            .distinctUntilChanged()
            .bind(to: Binder(self) { vc, isLoggedIn in
                if isLoggedIn {
                } else {
                    vc.presentLoginView()
                }
            })
            .disposed(by: disposeBag)

        // output

    }

    private func presentLoginView() {
        if let presented = presentedViewController {
            presented.dismiss(animated: true) {
                self.presentLoginView()
            }
            return
        }

        let vc = loginView()
        vc.rx.didLogin
            .bind(to: Binder(self) { [weak vc] from, _ in
                from.dismiss(animated: true, completion: nil)
            })
            .disposed(by: vc.disposeBag)
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
