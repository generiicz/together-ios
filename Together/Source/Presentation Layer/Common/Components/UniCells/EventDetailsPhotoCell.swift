//
//  EventDetailsPhotoCell.swift
//  Together
//
//  Created by Андрей Цай on 14.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

class EventDetailsPhotoCell: HEDUniCell {
    
    //fileprivate var eventData = Variable<EventData?>(nil)
    //fileprivate var disposeBag = DisposeBag()

    @IBOutlet weak var eventPhoto: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var usersCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        eventData.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: displayEventData)
            .addDisposableTo(disposeBag)*/
    }
    
    override func displayEventData( event: EventData?) {
        //setNeedsLayout()
        //layoutIfNeeded()
        if let eData = event {
            titleLabel.text = eData.title
            let index = eData.address.index(eData.address.startIndex , offsetBy: 20)
            placeLabel.text = eData.address.substring(to: index)
            if let uCount = eData.participants?.count {
                usersCountLabel.text = "\(uCount)"
            } else {
                usersCountLabel.text = "-"
            }
            setNeedsLayout()
            layoutIfNeeded()
            DispatchQueue.global(qos: .background).async {
                if let eventImage = UIImage(named: eData.photoURL)?.af_imageAspectScaled(toFill: self.eventPhoto.frame.size) {
                    DispatchQueue.main.async {
                        self.eventPhoto.image = eventImage
                    }
                }
            }
            //setNeedsLayout()
            //layoutIfNeeded()
        }
    }
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let backgroundColor = profileData["backgroundColor"] as? UIColor {
            self.backgroundColor = backgroundColor
        }
    }
}
/*
extension EventDetailsPhotoCell: UniCell {
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let eventData = cellData["event"] as? EventData {
            self.eventData.value = eventData
        }
    }
}*/
