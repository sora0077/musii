//
//  Session.swift
//  Infrastructure
//
//  Created by 林達也 on 2018/11/18.
//  Copyright © 2018 林達也. All rights reserved.
//

import Foundation
import RxSwift
import AppleMusicKit
import Alamofire

final class SessionImpl {

    var authorization: Authorization?

    private let manager: SessionManager

    init(manager: SessionManager = .default) {
        self.manager = manager
    }

    func send<Req: AppleMusicKit.Request>(_ request: Req) -> Single<Req.Response> {
        let manager = self.manager
        return Single.create(subscribe: { [weak self] event in
            func fetcher(urlRequest: URLRequest,
                         completion: @escaping (Data, HTTPURLResponse?) -> Void) -> DataRequest {
                return manager.request(urlRequest).responseData(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        completion(data, response.response)

                    case .failure(let error):
                        event(.error(error))
                    }
                })
            }

            let req = build(request, authorization: self?.authorization, using: fetcher) { response in
                do {
                    event(.success(try response()))
                } catch {
                    event(.error(error))
                }
            }

            return Disposables.create {
                req?.cancel()
            }
        })
    }
}
