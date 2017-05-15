//
//  LocationManagerDelegate.swift
//  Together
//
//  Created by Андрей Цай on 07.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class RxLocationManagerSharedDelegate: NSObject {
    //fileprivate let disposeBag = DisposeBag()
    fileprivate let locationManager = CLLocationManager()
    var currentLocation = Variable<CLLocation?>(nil)
    var authorizationStatus = Variable<CLAuthorizationStatus>(CLAuthorizationStatus.notDetermined)
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        authorizationStatus.value = CLLocationManager.authorizationStatus()
    }
    
    @discardableResult func askForInUseGeoPermissions() -> Bool {
        return GeoTools.askForInUseGeoPermissions(locationManager: locationManager)
    }
}

extension RxLocationManagerSharedDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locData = locations.first{
            self.currentLocation.value = locData
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("RxLocationManagerSharedDelegate error!\n\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus.value = status
        switch status {
        case .denied, .restricted, .notDetermined:
            locationManager.stopUpdatingLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        }
    }
}
