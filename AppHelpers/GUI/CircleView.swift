//
//  CircleView.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var fillColor:UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let inset:CGFloat = 1
        var newRect = rect.insetCGRect(
            inset,
            insetY: inset,
            insetWidth: inset,
            insetHeight: inset
        )
        newRect.size.width = floor(newRect.size.width)
        newRect.size.height = floor(newRect.size.height)
        let cPath = UIBezierPath(ovalIn: newRect)
        fillColor.setFill()
        cPath.fill()
    }
}
