//
//  SocialAPI.swift
//  Together
//
//  Created by developer on 13.05.17.
//  Copyright © 2017 Андрей Цай. All rights reserved.
//

import Foundation
import PromiseKit
import FBSDKCoreKit
import FacebookCore
import FacebookLogin
import TwitterKit


class SocialService {
    
    class func login(type: SocialType, sender: UIViewController) -> Promise<String> {
        return Promise(resolvers: { (fulfill, reject) in
            switch type {
            case .facebook:
                LoginManager().logIn([ .publicProfile ], viewController: sender) { loginResult in
                    switch loginResult {
                    case .success(_, _, let accessToken):
                        fulfill(accessToken.authenticationToken)
                    default:
                        reject(CatchError.denyAccess)
                    }
                }
            case .twitter:
                Twitter.sharedInstance().logIn(with: sender, completion: { (session, error) in
                    guard let token = session?.authToken else {
                        reject(CatchError.denyAccess)
                        return
                    }
                    fulfill(token)
                })
            }
        })
    }
    
}
