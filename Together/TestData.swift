//
//  TestData.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import GoogleMapsBase

//MARK: Test Data

let testUsers: [UserData] = [
    UserData(
        uuid: "testUser1",
        firstName: "John",
        lastName: "Smith",
        email: "johnS@conspiracy.org",
        photoUUID: "User-1",
        gender: true
    ),
    UserData(
        uuid: "testUser2",
        firstName: "Ivan",
        lastName: "Smith",
        email: "elenS@conspiracy.org",
        photoUUID: "User-2",
        gender: false
    ),
    UserData(
        uuid: "testUser3",
        firstName: "Sam",
        lastName: "Smith",
        email: "samS@conspiracy.org",
        photoUUID: "User-3",
        gender: true
    ),
    UserData(
        uuid: "testUser4",
        firstName: "Evgeny",
        lastName: "Smith",
        email: "evgenyS@conspiracy.org",
        photoUUID: "User-4",
        gender: true
    ),
    UserData(
        uuid: "testUser5",
        firstName: "Eva",
        lastName: "Smith",
        email: "evaS@conspiracy.org",
        photoUUID: "User-5",
        gender: false
    )
]

let testInterests = [
    InterestData(uuid: "wefkgineroi", title: "Backend"),
    InterestData(uuid: "lmvvneiiurv", title: "Frontend"),
    InterestData(uuid: "oecnenceowncon", title: "Programming"),
    InterestData(uuid: "flw[epervhbjvi", title: "Management"),
    InterestData(uuid: "ffe[fp[rkomdndbeyey", title: "Trading"),
    InterestData(uuid: "kwdnceeuyyer", title: "Travelling"),
    InterestData(uuid: "wefkgineroi", title: "Backend"),
    InterestData(uuid: "lmvvneiiurv", title: "Frontend"),
    InterestData(uuid: "oecnenceowncon", title: "Programming"),
    InterestData(uuid: "flw[epervhbjvi", title: "Management"),
    InterestData(uuid: "ffe[fp[rkomdndbeyey", title: "Trading"),
    InterestData(uuid: "kwdnceeuyyer", title: "Travelling"),
    InterestData(uuid: "wefkgineroi", title: "Backend"),
    InterestData(uuid: "lmvvneiiurv", title: "Frontend"),
    InterestData(uuid: "oecnenceowncon", title: "Programming"),
    InterestData(uuid: "flw[epervhbjvi", title: "Management"),
    InterestData(uuid: "ffe[fp[rkomdndbeyey", title: "Trading"),
    InterestData(uuid: "kwdnceeuyyer", title: "Travelling"),
    InterestData(uuid: "wefkgineroi", title: "Backend"),
    InterestData(uuid: "lmvvneiiurv", title: "Frontend"),
    InterestData(uuid: "oecnenceowncon", title: "Programming"),
    InterestData(uuid: "flw[epervhbjvi", title: "Management"),
    InterestData(uuid: "ffe[fp[rkomdndbeyey", title: "Trading"),
    InterestData(uuid: "kwdnceeuyyer", title: "Travelling"),
    InterestData(uuid: "wefkgineroi", title: "Backend"),
    InterestData(uuid: "lmvvneiiurv", title: "Frontend"),
    InterestData(uuid: "oecnenceowncon", title: "Programming"),
    InterestData(uuid: "flw[epervhbjvi", title: "Management"),
    InterestData(uuid: "ffe[fp[rkomdndbeyey", title: "Trading"),
    InterestData(uuid: "kwdnceeuyyer", title: "Travelling")
]

let testMessages:[MessageData] = [
    MessageData(
        uuid: "podjk90bhw23bf",
        from: "testUser2",
        to: "testUser1",
        time: Date(),
        text: "Helo, my dear!"
    ),
    MessageData(
        uuid: "podjk90bhw23bf",
        from: "testUser3",
        to: "testUser1",
        time: Date(),
        text: "Welcome to my manor for delicious dinner!"
    ),
    MessageData(
        uuid: "podjk90bhw23bf",
        from: "testUser4",
        to: "testUser1",
        time: Date(),
        text: "Tatooine needs you!"
    ),
    MessageData(
        uuid: "podjk90bhw23bf",
        from: "testUser1",
        to: "testUser5",
        time: Date(),
        text: "Cover blown. Request withdrawal immediately."
    )
]

let firstGroup = EventGroupData(uuid: "123456", name: "Cats", events:
    [
        EventData(
            uuid: "epfjrkeknrv",
            location: CLLocationCoordinate2D(latitude: 57.639958, longitude: 39.885146),
            title: "Jet Cat",
            description: "Super fluffy flying pet only dollar one to get!",
            photoURLs: ["Cat-4"],
            startTime: Date(),
            endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "cw4t4t",
            location: CLLocationCoordinate2D(latitude: 38.5804462, longitude: -121.5135527),
            title: "Raccoon Cat",
            description: "Puper-Super",
            photoURLs: ["Cat-5"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
            
        ),
        EventData(
            uuid: "hgrthrth",
            location: CLLocationCoordinate2D(latitude: 42.493633, longitude: -71.09906),
            title: "Cat Dog",
            description: "Puper-Super",
            photoURLs: ["Cat-6"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "f34cy45vy",
            location: CLLocationCoordinate2D(latitude: 42.0299159, longitude: -71.2191324),
            title: "Cat Man",
            description: "Puper-Super",
            photoURLs: ["Cat-3"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser5", "testUser1", "testUser4", "testUser3", "testUser2"],
            extraTickets: ["testUser1", "testUser2", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "c5g6b67i",
            location: CLLocationCoordinate2D(latitude: 48.8599614, longitude: 2.3265614),
            title: "Cat Boy",
            description: "Puper-Super",
            photoURLs: ["Cat-1"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
            
        ),
        EventData(
            uuid: "btyntyn6656",
            location: CLLocationCoordinate2D(latitude: 51.796219, longitude: 0.132606),
            title: "Cat Car",
            description: "Puper-Super",
            photoURLs: ["Cat-2"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        )
    ]
)

let secondGroup = EventGroupData(uuid: "123456", name: "Concerts", events:
    [
        EventData(
            uuid: "muyilm56",
            location: CLLocationCoordinate2D(latitude: 11, longitude: 11),
            title: "Pink Floyd",
            description: "Puper-Super",
            photoURLs: ["Concert-1"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser3", "testUser4"],
            extraTickets: ["testUser1", "testUser4", "testUser3"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "xxe45bj7n78hg",
            location: CLLocationCoordinate2D(latitude: 22, longitude: 22),
            title: "Doors",
            description: "Puper-Super",
            photoURLs: ["Concert-2"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
            
        ),
        EventData(
            uuid: "ret344tr5gy56h",
            location: CLLocationCoordinate2D(latitude: 33, longitude: 33),
            title: "Rolling Stones",
            description: "Puper-Super",
            photoURLs: ["Concert-3"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        )
    ]
)

let thirdGroup = EventGroupData(uuid: "123456", name: "Races", events:
    [
        EventData(
            uuid: "cethnjuynuj78o9",
            location: CLLocationCoordinate2D(latitude: 43.256491, longitude: -78.926314),
            title: "Lotus Race",
            description: "Lotus rules! Came on Lotus and get bonus!",
            photoURLs: ["Races-1"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser2", "testUser5"],
            extraTickets: ["testUser2", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "sxqwxwqqwqw4334fv5y6u",
            location: CLLocationCoordinate2D(latitude: 43.256241, longitude: -78.93482),
            title: "Abarth Race",
            description: "Mini-cars with super-powers!",
            photoURLs: ["Races-2"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
            
        ),
        EventData(
            uuid: "hvtrhrth45543c",
            location: CLLocationCoordinate2D(latitude: 43.258097, longitude: -78.916021),
            title: "True Man's Race",
            description: "Feel the speed!",
            photoURLs: ["Races-3"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "ikmumoopopnt3344v",
            location: CLLocationCoordinate2D(latitude: 55.01, longitude: 55),
            title: "Atomic Race",
            description: "The power of Atom!",
            photoURLs: ["Races-4"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        ),
        EventData(
            uuid: "cerrcwaxex44x6hv6",
            location: CLLocationCoordinate2D(latitude: 55, longitude: 55.01),
            title: "Prototype Race",
            description: "To the future and beyond!",
            photoURLs: ["Races-5"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
            
        ),
        EventData(
            uuid: "imuukn56erce45",
            location: CLLocationCoordinate2D(latitude: 55, longitude: 55),
            title: "Russian Race",
            description: "If you madly want to fly.",
            photoURLs: ["Races-6"],
            startTime: Date(), endTime: Date(),
            creator: "testUser1",
            participants: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            extraTickets: ["testUser1", "testUser2", "testUser3", "testUser4", "testUser5"],
            address: "Catlying, Cat avenue",
            extraData: ["":""]
        )
    ]
)

let testEvents = [
    firstGroup,
    secondGroup,
    thirdGroup
]
