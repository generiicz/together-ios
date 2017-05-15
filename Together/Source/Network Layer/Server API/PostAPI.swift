//
//  PostAPI.swift
//  Together
//
//  Created by developer on 14.05.17.
//  Copyright © 2017 Андрей Цай. All rights reserved.
//

import Foundation
import Moya
import SwiftyUserDefaults

enum PostAPI {
    case categories
    case feed
    case detail(id: Int)
}

extension PostAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: NetworkConfig.site)!
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/post/categories"
        case .feed:
            return "/post/get"
        case .detail(let id):
            return "/post/get/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        return [:]
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
    
    var validate: Bool {
        return false
    }
    
}

extension PostAPI: APIProtocol {
    
    var headers: [String: String]? {
        return ["X-Api-Token": Defaults[.token]]
    }
    
    var localTest: Bool {
        return false
    }
    
}
