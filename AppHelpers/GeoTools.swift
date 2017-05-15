//
//  GeoTools.swift
//  Together
//
//  Created by Андрей Цай on 10.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import CoreLocation

struct GeoTools {

    static func askForInUseGeoPermissions(locationManager: CLLocationManager) -> Bool {
        var res = false
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            res = true
            break
        }
        return res
    }
}
