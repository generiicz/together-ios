//
//  StaticGoogleMapCell.swift
//  Together
//
//  Created by Андрей Цай on 17.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import CoreLocation

class StaticGoogleMapCell: HEDUniCell {
    fileprivate var eventLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var staticMapImage: UIImageView!
    @IBOutlet weak var goToMapButton: PrettyButton!
    
    @IBAction func goToMapAction(_ sender: PrettyButton) {
        guard let eventLocation = self.eventLocation else { return }
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: TogetherNotificationTypes.mainNavSwitch),
            object: self,
            userInfo: [
                "segueName": "ShowEventOnMap",
                "segueParams": [
                    "location": eventLocation
                ]
            ]
        )
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        makePretty()
    }
    
    override func displayEventData(event: EventData?) {
        if let eData = event {
            eventLocation = eData.location
            setNeedsLayout()
            layoutIfNeeded()
            staticMapImage.setStaticGoogleMap(location: eData.location, placeholderImage: UIImage(named: "Synchronize")!)
        }
    }
    
    fileprivate func makePretty() {
        goToMapButton.loadStatesProfile(TogetherPrettyButtonProfiles.RedPlainButton)
    }
}
/*
extension StaticGoogleMapCell: UniCell {
    func setupCellData(_ cellData: CellAbstractData) {
        if let location = cellData["location"] as? CLLocationCoordinate2D {
            eventLocation = location
        }
    }
}*/
