//
//  EventsCollectionViewCell2.swift
//  Together
//
//  Created by Андрей Цай on 17.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class EventsCollectionViewCell2: UICollectionViewCell {

    @IBOutlet weak var EventImageView: EventTappableGradientedPhoto!
    @IBOutlet weak var ImageMiniMapVertical: NSLayoutConstraint!
    @IBOutlet weak var ImageMiniMap: RoundImage!
    @IBOutlet weak var ExtraTicketsCountLabel: RoundLabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PlaceLabel: UILabel!
    @IBOutlet weak var UsersCountLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makePretty()
    }
    
    fileprivate func makePretty () {
        ImageMiniMapVertical.constant = -(ImageMiniMap.bounds.height / 2)
        EventImageView.gradientStartColor = UIColor.black
        EventImageView.gradientEndColor = UIColor.clear
        EventImageView.gradientStartLocation = -0.3
        EventImageView.gradientEndLocation = 0.3
    }

}
