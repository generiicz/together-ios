//
//  HEDExtraTicketsCell.swift
//  Together
//
//  Created by Андрей Цай on 02.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class HEDExtraTicketsCell: HEDUniCell {

    @IBOutlet weak var TicketsCountLabel: RoundLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func displayEventData(event: EventData?) {
        if let eData = event, let tCount = eData.extraTickets?.count{
            TicketsCountLabel.text = String(tCount)
        }
    }
    
}
