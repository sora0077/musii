//
//  OAuth.swift
//  Infrastructure
//
//  Created by 林達也 on 2018/11/24.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import Domain
import DeepLinkKit
import RxSwift
import FirebaseAuth
import Alamofire
import Keys

public protocol _OAuthRequst {
    associatedtype Response: Decodable

    func dataRequest(from manager: SessionManager) -> Single<Response>
}

extension InfrastructureServiceProvider {
    public static func oauth(
        scheme: String,
        session: NetworkSession
    ) -> OAuth {
        return OAuthImpl(
            scheme: scheme,
            session: session
        )
    }
}

extension OAuth {
    public typealias Request = _OAuthRequst
}

final class OAuthImpl: OAuth {

    override var gitHub: OAuth.GitHub { return _gitHub }
    private let _gitHub: OAuth.GitHub

    private let router = DPLDeepLinkRouter()

    init(scheme: String, session: NetworkSession) {
        _gitHub = OAuthGitHub(scheme: scheme, session: session, router: router)
    }

    override func handleURL(_ url: URL) -> Bool {
        return router.handle(url, withCompletion: nil)
    }
}

// MARK: - github
private final class OAuthGitHub: OAuth.GitHub {

    override var authorizeURL: URL {
        var comps = URLComponents(string: "https://github.com/login/oauth/authorize")
        comps?.queryItems = [
            URLQueryItem(name: "client_id", value: MuSiiKeys().githubClientId),
            URLQueryItem(name: "redirect_uri", value: redirectURL.absoluteString),
            URLQueryItem(name: "state", value: state)
        ]

        return comps!.url!
    }

    let redirectURL: URL

    private let session: NetworkSession
    private let state: String
    private let handleURL = PublishSubject<DPLDeepLink>()

    init(scheme: String, session: NetworkSession, state: String = .random(), router: DPLDeepLinkRouter) {
        redirectURL = URL(string: "\(scheme):///oauth/github")!
        self.session = session
        self.state = state
        super.init()

        router.register(redirectURL.absoluteString) { [weak self] link in
            if let link = link {
                self?.handleURL.onNext(link)
            }
        }
    }

    override func authorized() -> Single<Void> {
        return handleURL
            .timeout(60 * 10, scheduler: MainScheduler.instance)
            .catchError { error in
                switch error {
                case RxError.timeout:
                    throw OAuth.Error.timeout
                default:
                    throw error
                }
            }
            .map { [weak self] link in
                switch (link.queryParameters["code"], link.queryParameters["state"]) {
                case (let code as String, let state as String) where state == self?.state:
                    return (code, state)

                default:
                    throw OAuth.Error.invalidState
                }
            }
            .map { code, state in
                GetAccessToken(
                    clientId: MuSiiKeys().githubClientId,
                    clientSecret: MuSiiKeys().githubClientSecret,
                    code: code,
                    state: state
                )
            }
            .take(1)
            .asSingle()
            .flatMap(session.send)
            .map { GitHubAuthProvider.credential(withToken: $0.accessToken) }
            .flatMap(Auth.auth().rx.signInAndRetrieveData(with:))
            .map { _ in }
    }
}

extension OAuthGitHub {
    struct GetAccessToken: OAuth.Request {
        struct Response: Decodable {  // swiftlint:disable:this nesting
            let accessToken: String
            let scope: String
            let tokenType: String
        }

        private let clientId: String
        private let clientSecret: String
        private let code: String
        private let state: String

        init(clientId: String, clientSecret: String, code: String, state: String) {
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.code = code
            self.state = state
        }

        func dataRequest(from manager: SessionManager) -> Single<Response> {
            let parameters = ["client_id": clientId,
                              "client_secret": clientSecret,
                              "code": code,
                              "state": state]
            return Single.create(subscribe: { event in
                let request =  manager.request(URL(string: "https://github.com/login/oauth/access_token")!,
                                               method: .post,
                                               parameters: parameters,
                                               headers: ["Accept": "application/json"])
                request.responseData(queue: .global()) { response in
                    let result = response.result.flatMap { data -> Response in
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        return try decoder.decode(Response.self, from: data)
                    }
                    switch result {
                    case .success(let response):
                        event(.success(response))
                    case .failure(let error):
                        event(.error(error))
                    }
                }
                print(request.debugDescription)
                return Disposables.create {
                    request.cancel()
                }
            })
        }
    }
}

// MARK: - utils
extension String {
    static func random(count: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<count {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

extension Reactive where Base: Auth {
    public func signInAndRetrieveData(with credential: AuthCredential) -> Single<AuthDataResult> {
        return Single.create { event in
            self.base.signInAndRetrieveData(with: credential, completion: { (result, error) in
                switch (result, error) {
                case (_, let error?):
                    event(.error(error))
                case (let result?, _):
                    event(.success(result))
                default:
                    fatalError()
                }
            })
            return Disposables.create()
        }
    }

    public func stateDidChange() -> Observable<(Auth, User?)> {
        return Observable.create { observer in
            let handle = self.base.addStateDidChangeListener { (auth, user) in
                observer.onNext((auth, user))
            }
            return Disposables.create {
                self.base.removeStateDidChangeListener(handle)
            }
        }
    }
}
