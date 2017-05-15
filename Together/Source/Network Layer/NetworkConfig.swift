//
//  NetworkConfig.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

struct NetworkConfig {
    static let site = "http://together.titorenko.in.ua/api"
    static let port = "8080"
    static let GoogleMapsStaticURL = "https://maps.googleapis.com/maps/api/staticmap?"
    static let GoogleMapsAPIkey = "AIzaSyBvX9-VA9gZncBL_V48nAg5toXoXCpcR7Y"
    static let errorDictionary = [
        -2 : "General Error",
        -3 : "Wrong username/password",
        -4 : "Servers offline",
        -5 : "Can't load profile from server",
        -6 : "Profile loading timeout"
    ]
}
