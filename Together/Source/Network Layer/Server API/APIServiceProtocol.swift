//
//  APIServiceProtocol.swift
//  Together
//
//  Created by developer on 28.04.17.
//  Copyright © 2017 Together LLC. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import PromiseKit

typealias ResponseClosure = (_ json: JSON, _ code: Int) -> Void

protocol APIServiceProtocol: class {
    
    associatedtype Target
 
    func request(target: Target) -> Promise<(json: JSON, code: Int)>
    
}
