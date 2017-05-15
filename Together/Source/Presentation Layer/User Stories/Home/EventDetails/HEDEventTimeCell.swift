//
//  HEDEventTimeCell.swift
//  Together
//
//  Created by Андрей Цай on 31.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class HEDEventTimeCell: HEDUniCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func displayEventData(event: EventData?) {
        if let _ = event {
//            eventStartLabel.text = eData.startTime.displayDate("en_US", dateStyle: .short, timeStyle: .short)
//            eventEndLabel.text = eData.endTime.displayDate("en_US", dateStyle: .short, timeStyle: .short)
        }
    }
    
}
/*
extension HEDEventTimeCell: UniCell {
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let eventStartTime = cellData["startTime"] as? Date{
            eventStartLabel.text = eventStartTime.displayDate("en_US", dateStyle: .short, timeStyle: .short)
        }
        
        if let eventEndTime = cellData["endTime"] as? Date {
            eventEndLabel.text = eventEndTime.displayDate("en_US", dateStyle: .short, timeStyle: .short)
        }
    }
}*/
