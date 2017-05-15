//
//  SecondViewController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController, MainTabChild, BackNavigation {
    
    //MARK: properties
    weak var MainNavController: UINavigationController!
    //fileprivate var locationManager: CLLocationManager?
    fileprivate var eventsList: [EventData] = []
    fileprivate var eventMarkers: [EventMarker] = []
    fileprivate var phoneLocationDataProvider: RxLocationManagerSharedDelegate?
    fileprivate let disposeBag = DisposeBag()
    fileprivate var currentPosition: CLLocationCoordinate2D? = nil {
        didSet {
            if self.isViewLoaded && (self.view.window != nil) {
                displayCurrentPosition()
            }
        }
    }
    fileprivate var currentZoom: Float? = nil {
        didSet {
            if self.isViewLoaded && (self.view.window != nil) {
                displayCurrentPosition()
            }
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var mapView: GMSMapView!

    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
        //self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.locationManager?.delegate = self
        //self.refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayCurrentPosition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.locationManager?.delegate = nil
    }
    
    func loadTestData (location: CLLocationCoordinate2D) {
        BackEndOverlay.getEventsForMap(location: location, validRadius: 5555){ (result) in
            switch result {
            case .success(let events):
                self.eventsList = events
                self.placeEventsMarkers()
            case .failure(let error):
                print("Error loading events! \(error)")
            }
        }
    }
    
    func refreshEventsData(){
        guard let currentPosition = self.currentPosition else { return }
        self.loadTestData(location: currentPosition)
    }
    
    fileprivate func placeEventsMarkers() {
        guard currentPosition != nil else { return }
        if eventsList.count > 0 {
            mapView.clear()
            eventMarkers.removeAll()
            for event in self.eventsList {
                eventMarkers.append(EventMarker(data: event, mapView: mapView))
            }
        }
    }
    
    func setCurrentPosition(_ location: CLLocationCoordinate2D, zoom: Float?) {
        self.currentPosition = location
        if let zoom = zoom {
            self.currentZoom = zoom
        } else {
            self.currentZoom = mapView.camera.zoom
        }
    }
    
    fileprivate func displayCurrentPosition() {
        guard let pos = self.currentPosition, let zm = self.currentZoom else { return }
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.centerMapOn(pos, zoom: zm)
        refreshEventsData()
    }
    
    fileprivate func phoneLocationChanged(_ location: CLLocation?) {
        guard currentPosition == nil else { return }
        setCurrentPosition(location!.coordinate, zoom: 17)
        print(location!.coordinate)
    }
    
    func centerMapOn(_ location: CLLocationCoordinate2D, zoom: Float) {
        //self.setCurrentPosition(location, zoom: zoom)
        self.mapView.animate(with: GMSCameraUpdate.setTarget(location, zoom: zoom))
    }
    
    func setupMap() {
        mapView.delegate = self
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        phoneLocationDataProvider = appDelegate.locationDataProvider
        phoneLocationDataProvider?.askForInUseGeoPermissions()
        phoneLocationDataProvider?.currentLocation.asObservable()
                .filter{$0 != nil}
                .subscribe(onNext: self.phoneLocationChanged)
                .addDisposableTo(disposeBag)
        self.mapView.isBuildingsEnabled = true
    }

}
// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print (coordinate.latitude, coordinate.longitude)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let myLoc = phoneLocationDataProvider?.currentLocation.value else { return true}
        setCurrentPosition(myLoc.coordinate, zoom: nil)
        return false
    }
}
