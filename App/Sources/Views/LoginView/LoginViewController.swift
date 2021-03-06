//
//  LoginViewController.swift
//  App
//
//  Created by 林達也 on 2018/11/28.
//  Copyright © 2018 林達也. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import ApplicationService
import RxCocoa

final class LoginViewController: UIViewController, View {

    var disposeBag = DisposeBag()

    fileprivate let didLogin = PublishSubject<Void>()

    init(reactor: LoginReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    func bind(reactor: LoginReactor) {
        reactor.state.map { $0.didLogin }
            .distinctUntilChanged()
            .filterTrue()
            .bind(to: didLogin)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .bind(to: Binder(self) { [weak reactor] from, _ in
                guard let reactor = reactor else { return }
                let safariVC = SFSafariViewController(url: reactor.authUseCase.oauth.gitHub.authorizeURL)
                from.present(safariVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        reactor.authUseCase.oauth.gitHub.authorized()
            .asObservable()
            .map { Reactor.Action.didLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: LoginViewController {
    var didLogin: ControlEvent<Void> {
        return ControlEvent(events: base.didLogin)
    }
}
