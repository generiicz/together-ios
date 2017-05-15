//
//  APIService.swift
//  Together
//
//  Created by developer on 28.04.17.
//  Copyright © 2017 Together LLC. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Alamofire
import PromiseKit

class APIService<B: TargetType & APIProtocol>: APIServiceProtocol  {
    
    typealias Target = B
    
    var provider: MoyaProvider<Target>!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let stubClosure = { (target: Target) -> Moya.StubBehavior in
            return target.localTest ? .immediate : .never
        }
        
        let endpointClosure = { (target: Target) -> Endpoint<Target> in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint = Endpoint<Target>(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, parameters: target.parameters)
            if let headers = target.headers {
                return endpoint.adding(newHTTPHeaderFields: headers)
            } else {
                return endpoint
            }
        }
        
        provider = MoyaProvider<Target>(endpointClosure: endpointClosure, stubClosure: stubClosure, manager: SessionManager(configuration: configuration))
    }

    // MARK: APIServiceProtocol
    func request(target: Target) -> Promise<(json: JSON, code: Int)> {
        return Promise { fulfill, reject in
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    fulfill((json: JSON(data: response.data), code: response.statusCode))
                case let .failure(error):
                    if let response = error.response {
                        fulfill((json: JSON(data: response.data), code: response.statusCode))
                    } else {
                        switch error {
                        case .underlying(let error):
                            reject(error)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}
