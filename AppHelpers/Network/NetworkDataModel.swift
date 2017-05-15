//
//  NetworkDataModel.swift
//  Together
//
//  Created by Андрей Цай on 07.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

enum BackEndErrors: Error {
    case wrongQueryType
}

enum GetUsersQueryType {
    case friends(String)
    case eventParticipants(String)
    case eventCreator(String)
}

