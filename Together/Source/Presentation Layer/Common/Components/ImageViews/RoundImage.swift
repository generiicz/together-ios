//
//  ImageView.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class RoundImage: UIImageView, AddTapNotification {
    
    internal var tapRec: UIGestureRecognizer?
    internal var selectron: TapSelectron!
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            self.updateUI()
        }
    }
    
    fileprivate func updateUI (){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }

}

