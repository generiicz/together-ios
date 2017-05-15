//
//  UserAPI.swift
//  Together
//
//  Created by developer on 14.05.17.
//  Copyright © 2017 Андрей Цай. All rights reserved.
//

import Foundation
import Moya
import SwiftyUserDefaults

enum UserAPI {
    case info
    case update(name: String)
}

extension UserAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: NetworkConfig.site)!
    }
    
    var path: String {
        return "/user"
    }
    
    var method: Moya.Method {
        switch self {
        case .info:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .update(let name):
            return ["name": name]
        default:
            return [:]
        }
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

extension UserAPI: APIProtocol {
    
    var headers: [String: String]? {
        return ["X-Api-Token": Defaults[.token]]
    }
    
    var localTest: Bool {
        return false
    }
    
}
