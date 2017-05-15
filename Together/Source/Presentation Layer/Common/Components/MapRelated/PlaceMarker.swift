//
//  PlaceMarker.swift
//  PokLocator
//
//  Created by Андрей Цай on 22.07.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//



import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {

    init(coordinates: CLLocationCoordinate2D, mapView: GMSMapView) {
        super.init()
        position = coordinates
        groundAnchor = CGPoint(x: 0.5, y: 1)
//        appearAnimation = kGMSMarkerAnimationPop
        map = mapView
    }

}
class StaticMarker: GMSMarker {
    
    init(coordinates: CLLocationCoordinate2D, mapView: GMSMapView) {
        super.init()
        position = coordinates
        groundAnchor = CGPoint(x: 0.5, y: 1)
//        appearAnimation = kGMSMarkerAnimationPop
        isDraggable = false
        map = mapView
    }
}

class EventMarker: GMSMarker {
    
    init(data: EventData, mapView: GMSMapView) {
        super.init()
        position = data.location
        title = data.title
        snippet = data.description
        groundAnchor = CGPoint(x: 0.5, y: 1)
//        appearAnimation = kGMSMarkerAnimationPop
        map = mapView
    }
}
