//
//  DiscoveryAPI.swift
//  Together
//
//  Created by developer on 28.04.17.
//  Copyright © 2017 Together LLC. All rights reserved.
//

import UIKit
import Moya

enum SocialType: String {
    case facebook = "fb"
    case twitter = "tw"
}

enum AuthAPI {
    case registation(email: String, password: String)
    case login(email: String, password: String)
    case social(type: SocialType, token: String)
}

extension AuthAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: NetworkConfig.site)!
    }
    
    var path: String {
        switch self {
        case .registation:
            return "/auth/registration"
        case .login:
            return "/auth/login"
        case .social:
            return "/auth/soc"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .registation(let email, let password):
            return ["email": email, "password": password]
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .social(let type, let token):
            return ["type": type.rawValue, "access_token": token]
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

extension AuthAPI: APIProtocol {
    var headers: [String: String]? {
        return nil
    }
    
    var localTest: Bool {
        return false
    }
}
