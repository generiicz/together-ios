//
//  ErrorHandling.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
