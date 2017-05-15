//
//  GradientedLabel.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import UIKit


enum GradientTypeValue{
    case topBottom
    case bottomTop
    case leftRight
    case rightLeft
}

@IBDesignable
class gradientedLabel: UILabel {
    
    fileprivate var gradientLayer = CAGradientLayer()
    fileprivate var gradientLayerInserted: Bool = false
    
    @IBInspectable var gradientStartColor: UIColor = UIColor.darkText {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var gradientEndColor:UIColor = UIColor.lightText {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var gradientType: GradientTypeValue = GradientTypeValue.bottomTop {
        didSet {
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
    
    fileprivate func insertGradientLayer(){
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        setGradientPoints(gradientType)
        gradientLayer.locations = [0.0, 1.0]
        backgroundColor = UIColor.clear
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayerInserted = true
    }
    
    fileprivate func setGradientPoints(_ type: GradientTypeValue){
        gradientLayer.frame.origin = CGPoint(x: 0,y: 0)
        gradientLayer.frame.size.width = frame.width
        gradientLayer.frame.size.height = frame.height
        switch type {
        case .bottomTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .leftRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
    }
    
    fileprivate func updateUI(){
        if !gradientLayerInserted {
            insertGradientLayer()
        } else {
            gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
            setGradientPoints(gradientType)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
}

