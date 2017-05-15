//
//  MainDataModel.swift
//  Together
//
//  Created by Андрей Цай on 08.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import CoreLocation

struct EventData {
    let uuid:String
    let location: CLLocationCoordinate2D
    let title: String
    let description: String
    let photoURLs: [String]
    let startTime: Date
    let endTime: Date
    let creator: String
    let participants: Array<String>?
    let extraTickets: Array<String>?
    let address: String
    let extraData: [String: Any]
}

struct EventGroupData {
    let uuid: String
    let name: String
    let events: [EventData]
}

struct InterestData {
    let uuid: String
    let title:String
}

struct MessageData{
    let uuid: String
    let from: String
    let to: String
    let time: Date
    let text: String
}

struct UserData {
    let uuid: String
    let firstName: String
    let lastName: String
    let email: String
    let photoUUID: String
    let gender: Bool
}
