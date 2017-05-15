//
//  MainDataModel.swift
//  Together
//
//  Created by Андрей Цай on 08.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import CoreLocation
import ObjectMapper

struct EventData: Mappable {
    var uuid = 0
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    fileprivate var lat = 0.0
    fileprivate var lng = 0.0
    var title = ""
    var description = ""
    var photoURL = ""
    var dataFrom = ""
    var dataTo = ""
    var timeFrom = ""
    var timeTo = ""
    var creator = 0
    var category_id = 0
    var participants: Array<String>?
    var extraTickets: Array<String>?
    var address = ""
    var extraData: [String: Any] = [:]
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        uuid        <- map["id"]
        title       <- map["title"]
        description <- map["info"]
        photoURL    <- map["cover"]
        dataFrom <- map["date_from"]
        dataTo <- map["date_to"]
        timeFrom <- map["time_from"]
        timeTo <- map["time_to"]
        creator <- map["user_id"]
        category_id <- map["category_id"]
        lat <- map["lat"]
        lng <- map["lng"]
        address <- map["address"]
    }
}

struct EventGroupData {
    let uuid: Int
    let name: String
    let events: [EventData]
}

struct InterestData: Mappable {
    var uuid = 0
    var title = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        uuid  <- map["id"]
        title <- map["name"]
    }
}

struct Interest {
    var data: InterestData
    var selected = false
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
