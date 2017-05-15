//
//  HomeTableViewCell.swift
//  Together
//
//  Created by Андрей Цай on 08.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var EventsCollection: EventsCollectionView!
    
    //Mark: Actions
    @IBAction func SeeAllAction(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubview(toFront: EventsCollection)
    }
}
