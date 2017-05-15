//
//  View.swift
//  Together
//
//  Created by Андрей Цай on 24.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import UIKit


class RoundView: UIView {
    
    private func updateUI (){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            self.updateUI()
        }
    }
    
}