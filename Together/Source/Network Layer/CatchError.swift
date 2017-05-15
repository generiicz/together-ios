//
//  CatchError.swift
//  Together
//
//  Created by developer on 29.04.17.
//  Copyright © 2017 Together LLC. All rights reserved.
//

import Foundation

enum CatchError: Error {
    case invalideJSON
    case emptyArray
    case nullObject
    case dbExeption
    case rejectRequest
    case denyAccess
}

extension CatchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalideJSON:
            return "Invalide JSON data"
        case .emptyArray:
            return "Array is Empty"
        case .nullObject:
            return "Object is Null"
        case .dbExeption:
            return "Something problem with db"
        case .rejectRequest:
            return "Server reject request"
        case .denyAccess:
            return "Deny access to service"
        }
    }
}
