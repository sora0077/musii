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

protocol _OAuthRequst {
    associatedtype Response: Decodable

    func dataRequest(from manager: SessionManager) -> Single<Response>
}

extension OAuth {
    typealias Request = _OAuthRequst
}

final class OAuthImpl: OAuth {
    private let router = DPLDeepLinkRouter()

    override func handleURL(_ url: URL) -> Bool {
        return router.handle(url, withCompletion: nil)
    }
}

// MARK: - github
private final class OAuthGitHub: OAuth.Provider {

    let redirectURL: URL

    private let session: NetworkSession

    init(scheme: String, session: NetworkSession) {
        redirectURL = URL(string: "\(scheme):///oauth/github")!
        self.session = session
    }

    func auth(with context: String) -> Single<Void> {
        let request = GetAccessToken(
            clientId: MuSiiKeys().githubClientId,
            clientSecret: MuSiiKeys().githubClientSecret,
            code: context,
            redirectURL: redirectURL,
            state: String.random()
        )
        return session.send(request)
            .flatMap { response in
                Auth.auth().rx
                    .signInAndRetrieveData(with: GitHubAuthProvider.credential(withToken: response.accessToken))
                    .map { _ in }
            }
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
        private let redirectURL: URL?
        private let state: String?

        init(clientId: String, clientSecret: String, code: String, redirectURL: URL?, state: String?) {
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.code = code
            self.redirectURL = redirectURL
            self.state = state
        }

        func dataRequest(from manager: SessionManager) -> Single<Response> {
            return Single.create(subscribe: { event in
                let request =  manager.request(URL(string: "https://github.com/login/oauth/access_token")!,
                                               method: .post,
                                               parameters: ["client_id": self.clientId])
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
