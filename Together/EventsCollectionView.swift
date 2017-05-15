//
//  EventsCollectionView.swift
//  Together
//
//  Created by Андрей Цай on 08.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import AlamofireImage

class EventsCollectionView: UICollectionView {
    
    fileprivate var events: [EventData] = []
    fileprivate var loaded = false
    fileprivate let cellReuseableIdentifier = "EventsCollectionViewCell2"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        register(
            UINib(nibName: "EventsCollectionViewCell2", bundle: nil),
            forCellWithReuseIdentifier: cellReuseableIdentifier)
        dataSource = self
        decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func reloadEvents(_ data: [EventData]){
        self.loaded = false
        self.loadEvents(data)
    }
    
    func loadEvents (_ data: [EventData]) {
        DispatchQueue.main.async {
            if !self.loaded {
                self.events = data
                //self.loaded = true
            }
            self.reloadData()
        }
    }
}

extension EventsCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellReuseableIdentifier, for: indexPath) as! EventsCollectionViewCell2
        let event = self.events[indexPath.row]
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.TitleLabel.text = event.title
        let usersCount = event.participants?.count ?? 0
        cell.UsersCountLabel.text = String(usersCount)
        let ticketsCount = event.extraTickets?.count ?? 0
        cell.ExtraTicketsCountLabel.text = String(ticketsCount)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        DispatchQueue.global(qos: .background).async {
            let eventImage = UIImage(named: event.photoURLs[0])?.af_imageAspectScaled(toFill: cell.EventImageView.frame.size)
            DispatchQueue.main.async {
                cell.EventImageView.image = eventImage
            }
        }
        let eventTapParams = TogetherNotificationParameters(
            notificationType: TogetherNotificationTypes.mainNavSwitch,
            notificationUserDictionary: [
                "segueName": "HomeEventDetails",
                "segueParams": [
                    "eventData": event
                ]
            ]
        )
        cell.EventImageView.addTap(eventTapParams)
        cell.ImageMiniMap.setStaticGoogleMap(location: event.location, placeholderImage: UIImage(named: "Synchronize")!)
        let tapParams = TogetherNotificationParameters(
            notificationType: TogetherNotificationTypes.showEventOnMap,
            notificationUserDictionary: [
                "title": event.title,
                "latitude": event.location.latitude,
                "longitude": event.location.longitude
            ]
        )
        cell.ImageMiniMap.addTap(tapParams)
        return cell
    }
}
