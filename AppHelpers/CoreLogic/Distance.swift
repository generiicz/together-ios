//
//  Distance.swift
//  Together
//
//  Created by Андрей Цай on 11.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

struct usaDistance {
    private let milesToMeters: Double = 1609.34
    private let kilometersToMeters: Double = 1000
    private let yardsToMeters: Double = 0.91439773
    private let feetsToMeters: Double = 0.30479924
    var meters: Double
    var miles: Double {
        get{
            return meters / milesToMeters
        }
    }
    var kilometers: Double {
        get {
            return meters / kilometersToMeters
        }
    }
    
    var yards: Double {
        get {
            return meters / yardsToMeters
        }
    }
    
    var feets: Double {
        get {
            return meters / feetsToMeters
        }
    }
    
    var usaDistanceString: String {
        get {
            let val = self.miles < 0.25 ? self.feets: self.miles
            let unit = self.miles < 0.25 ? " ft.": " mi."
            let str = String(format: "%.2f", val) + unit
            return str
        }
    }
    
    var metricDistanceString: String {
        get {
            let val = self.meters < kilometersToMeters ? self.meters: self.kilometers
            let unit = self.meters < kilometersToMeters ? " m.": " km."
            let str = String(format: "%.2f", val) + unit
            return str
        }
    }
    
    init(meters: Double) {
        self.meters = meters
    }
    
    init(miles: Double) {
        self.meters = miles * milesToMeters
    }
    
    init(kilometers: Double) {
        self.meters = kilometers * kilometersToMeters
    }
    
    init(yards: Double) {
        self.meters = yards * yardsToMeters
    }
    
    init(feets: Double) {
        self.meters = feets * feetsToMeters
    }
}
