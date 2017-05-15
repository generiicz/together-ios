//
//  GeoSearchViewController.swift
//  Together
//
//  Created by Андрей Цай on 19.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RxSwift

protocol GeoSearchDelegate {
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

protocol GeoSearchViewControllerDelegate {
    func placeSelected(place: placeData)
}

class GeoSearchViewController: KeyboardableViewController {
    //MARK: proprties
    var delegate: GeoSearchViewControllerDelegate?
    fileprivate var bottomConstraintNormalValue: CGFloat = 8
    //fileprivate var locationManager: CLLocationManager?
    fileprivate var resultsArray: [String] = []
    fileprivate let standardMapCameraZoom: Float = 19
    fileprivate var place: placeData!
    fileprivate var phoneLocationProvider: RxLocationManagerSharedDelegate?
    
    //MARK: outlets
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var searchField: UnderlinedTextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchResultsTable: GeoSearchResultsTableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var customNavBar: UINavigationBar!
    //MARK: actions
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion:  nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makePretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.customNavBar.isHidden {
            self.customNavBar.setItems([], animated: false)
            self.customNavBar.setItems([self.navigationItem, self.navigationItem], animated: false)
        }
        if let place = self.place {
            setPlace(latitude: place.location.latitude, longitude: place.location.longitude, title: place.address, zoom: standardMapCameraZoom)
        }
        searchField.text?.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if let lm = locationManager {
        //    GeoTools.askForInUseGeoPermissions(locationManager: lm)
        //}
        phoneLocationProvider?.askForInUseGeoPermissions()
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        print(keyboardHeight)
        
        bottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight + self.keyboardBottomConstraint
        self.view.setNeedsLayout()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {[weak self] in
                self?.mapView.isHidden = !shown
                self?.searchResultsTable.isHidden = shown
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    override internal func setNormalConstraints() {
        self.bottomConstraintNormalValue = self.bottomConstraint.constant
    }
    
    func loadPlace(latitude: Double, longitude: Double, address: String) {
        self.place = placeData(latitude: latitude, longitude: longitude, address: address)
    }
    
    fileprivate func searchAddress(address: String) {
        print(address)
        let placesClient = GMSPlacesClient.shared()
        placesClient.autocompleteQuery(address, bounds: nil, filter: nil) { (results, error) -> Void in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                self.resultsArray.append(result.attributedFullText.string)
            }
            self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        }
    }
    
    fileprivate func makePretty() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //self.locationManager = appDelegate.locationManager
            self.phoneLocationProvider = appDelegate.locationDataProvider
        }
        keyboardBottomConstraint = 10
        self.searchField.delegate = self
        self.searchResultsTable.geoDelegate = self
        self.mapView.delegate = self
        self.aLabel.lineBreakMode = .byWordWrapping
        self.aLabel.numberOfLines = 0
        let obs = searchField.rx.textInput.text.distinctUntilChanged()
        obs.subscribe(onNext: self.searchAddress).addDisposableTo(self.disposeBag)
        self.edgesForExtendedLayout = .bottom
        if self.navigationController != nil {
            self.customNavBar.isHidden = true
            self.navigationItem.title = "Select Place"
        } else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.doneAction(_:)))
            self.customNavBar.delegate = self
        }
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        searchField.leftViewMode = .always
        searchField.leftView = UIImageView(image: UIImage(named: "check"))
    }
    
    fileprivate func placeMarkerOnMap(_ location: CLLocationCoordinate2D, title: String, zoom: Float? = nil){
        let zoom = zoom ?? self.mapView.camera.zoom
        self.mapView.clear()
        let marker = GMSMarker(position: location)
        let camera  = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: zoom)
        self.mapView.camera = camera
        marker.title = title
        marker.map = self.mapView
        
    }
    
    fileprivate func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            var res: String? = nil
            if let address = response?.firstResult(), let lines = address.lines {
                res = lines.joined(separator: "\n")
            }
            completion(res)
        }
    }
    
    fileprivate func setPlace(latitude: Double, longitude: Double, title: String, zoom: Float? = nil) {
        if (searchField.text?.characters.count)! > 0 {
            searchField.text?.removeAll()
        }
        self.place = placeData(latitude: latitude, longitude: longitude, address: title)
        self.aLabel.text = title
        placeMarkerOnMap(place.location, title: title, zoom: zoom)
        if self.delegate != nil && self.isViewLoaded && self.view.window != nil {
            self.delegate?.placeSelected(place: self.place)
        }
    }
    
    //MARK: TextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.searchResultsTable.reloadDataWithArray([])
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension GeoSearchViewController: GeoSearchDelegate {
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async{[weak self] in
            self?.setPlace(latitude: lat, longitude: lon, title: title)
            self?.searchField.endEditing(true)
        }
    }
}

extension GeoSearchViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        reverseGeocodeCoordinate(coordinate){ placeTitle in
            let title = placeTitle ?? "Unknown"
            DispatchQueue.main.async{ [weak self] in
                self?.setPlace(latitude: coordinate.latitude, longitude: coordinate.longitude, title: title)
            }
        }
    }
}

extension GeoSearchViewController: UINavigationBarDelegate {
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if item == self.navigationItem {
            let callBack = item.backBarButtonItem?.action
            self.performSelector(onMainThread: callBack!, with: item, waitUntilDone: false)
        }
        return false
    }
}
