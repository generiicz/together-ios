//
//  APIProtocol.swift
//  Together
//
//  Created by developer on 28.04.17.
//  Copyright © 2017 Together LLC. All rights reserved.
//

import UIKit
import Moya

protocol APIProtocol {
    
    var headers: [String: String]? { get }
    
    var localTest: Bool { get }
    
}
