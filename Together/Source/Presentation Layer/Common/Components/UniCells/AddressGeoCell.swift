//
//  AddressGeoCell.swift
//  Together
//
//  Created by Андрей Цай on 13.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AlamofireImage

struct placeData{
    var location: CLLocationCoordinate2D
    var address: String
    
    init(latitude: Double, longitude: Double, address: String) {
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.address = address
    }
    
    init(location: CLLocationCoordinate2D, address: String) {
        self.location = location
        self.address = address
    }
}

class AddressGeoCell: UITableViewCell {
    
    fileprivate var _place: placeData!
    fileprivate var geoView: GeoSearchViewController!
    fileprivate let searchAddressScreenMultiplier: CGFloat = 0.9
    fileprivate var place: placeData! {
        get{
            return _place
        }
        set{
            _place = newValue
            updatePlace()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapImage: ResizeAwareImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let searchNavigationController = self.geoView
        searchNavigationController?.modalPresentationStyle = .custom
        searchNavigationController?.transitioningDelegate = self
        GUItools.topMostVC?.present(searchNavigationController!, animated: true, completion: nil)
    }
    @IBAction func tapMapAction(_ sender: UITapGestureRecognizer) {
        self.geoView.loadPlace(latitude: self.place.location.latitude, longitude: self.place.location.longitude, address: self.place.address)
        GUItools.topMostVC?.present(geoView, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makePretty()
    }
    
    fileprivate func makePretty() {
        self.geoView = GeoSearchViewController(nibName: "GeoSearchViewController", bundle: nil)
        self.geoView.delegate = self
        self.mapImage.resizingDelegate = self
    }
    
    fileprivate func updatePlace() {
        print(self._place)
        let googleSize = GUItools.calcGoogleMapImageSize(size: mapImage.bounds.size, upscale: 1.1)
        let imageURL = BackEndOverlay.makeGoogleStaticMapURL(
            place.location.latitude,
            longitude: place.location.longitude,
            width: Int(googleSize.width),
            height: Int(googleSize.height),
            zoom: 19,
            scale: 1
        )
        let imageFilter = AspectScaledToFillSizeFilter(size: mapImage.bounds.size)
        self.mapImage.af_setImage(
            withURL: imageURL,
            placeholderImage: UIImage(named: "Synchronize"),
            filter: imageFilter,
            imageTransition: .crossDissolve(0.2)
        )
        self.addressLabel.text = place.address
    }
    
}

extension AddressGeoCell: UniCell {
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        let title = profileData["Title"] as? String ?? ""
        titleLabel.text = title
        let latitude = profileData["Latitude"] as? Double ?? Double()
        let longitude = profileData["Longitude"]  as? Double ?? Double()
        let address = profileData["Address"] as? String ?? ""
        self.addressLabel.text = address
        self.place = placeData(latitude: latitude, longitude: longitude, address: address)
    }
    
    func setupCellData(_ cellData: CellAbstractData) {
    }
    
    func getCellData() -> CellAbstractData {
        return [
            "Address": self.place.address,
            "Latitude": self.place.location.latitude,
            "Longitude": self.place.location.longitude
        ]
    }
}

extension AddressGeoCell: GeoSearchViewControllerDelegate {
    func placeSelected(place: placeData) {
        self.place = place
    }
}

extension AddressGeoCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AddressGeoCell: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                                          presenting: UIViewController?,
                                                                                   source: UIViewController) -> UIPresentationController? {
        let transDelegate = KeyboardusPresentusExtraordinaris(presentedViewController: presented, presenting: presenting)
        transDelegate.heightMultiplier = searchAddressScreenMultiplier
        return transDelegate
    }
    
}

extension AddressGeoCell: ResizeAwareImageViewDelegate {
    func imageViewResized(imageView: ResizeAwareImageView, newSize: CGRect) {
        updatePlace()
    }
}
