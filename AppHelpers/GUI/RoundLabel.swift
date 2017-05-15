//
//  Labels.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

@IBDesignable
class RoundLabel: UILabel{
    
    fileprivate var _makeRound: Bool = true
    
     override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            self.updateUI()
        }
     }
    
    @IBInspectable var makeRound: Bool {
        get {
            return _makeRound
        }
        set {
            _makeRound = newValue
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateUI()
    }
    
    func updateUI(){
        if !self.layer.masksToBounds {
            self.layer.masksToBounds = true
        }
        if _makeRound {
            let radius = frame.width >= frame.height ? round(frame.height / 2) : round(frame.width / 2)
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
}

