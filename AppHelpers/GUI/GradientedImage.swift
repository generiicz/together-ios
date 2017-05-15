//
//  GradientedImage.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class GradientedImage: UIImageView {
    
    fileprivate var gradientLayer = CAGradientLayer()
    fileprivate var gradientLayerInserted: Bool = false
    fileprivate var _gradientCoverage: CGFloat = 1.0
    
    var gradientStartLocation: NSNumber = 0 {
        didSet {
            updateUI()
        }
    }
    var gradientEndLocation: NSNumber = 1 {
        didSet {
            updateUI()
        }
    }
    var gradientCoverage: CGFloat {
        set {
            _gradientCoverage = getAbsZeroOne(newValue)
            updateUI()
        }
        get {
            return _gradientCoverage
        }
    }
    var gradientStartColor: UIColor = UIColor.darkText {
        didSet {
            updateUI()
        }
    }
    var gradientEndColor:UIColor = UIColor.lightText {
        didSet {
            updateUI()
        }
    }
    var gradientType: GradientTypeValue = GradientTypeValue.bottomTop {
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
    
    fileprivate func getAbsZeroOne(_ val: CGFloat) -> CGFloat{
        let res = abs(val) > 1 ? abs(1 / val) : abs(val)
        return res
    }
    
    fileprivate func insertGradientLayer(){
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        setGradientPoints(gradientType)
        gradientLayer.locations = [gradientStartLocation, gradientEndLocation]
        backgroundColor = UIColor.clear
        //layer.insertSublayer(gradientLayer, atIndex: 0)
        layer.addSublayer(gradientLayer)
        gradientLayerInserted = true
    }
    
    fileprivate func setGradientPoints(_ type: GradientTypeValue){
        
        switch type {
        case .bottomTop:
            let gHeight = frame.height * _gradientCoverage
            let gStartY = frame.height - gHeight
            gradientLayer.frame.origin = CGPoint(x: 0, y: gStartY)
            gradientLayer.frame.size.width = frame.width
            gradientLayer.frame.size.height = gHeight
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topBottom:
            let gHeight = frame.height * _gradientCoverage
            gradientLayer.frame.origin = CGPoint(x: 0, y: 0)
            gradientLayer.frame.size.width = frame.width
            gradientLayer.frame.size.height = gHeight
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .leftRight:
            let gWidth = frame.width * _gradientCoverage
            gradientLayer.frame.origin = CGPoint(x: 0, y: 0)
            gradientLayer.frame.size.width = gWidth
            gradientLayer.frame.size.height = frame.height
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightLeft:
            let gWidth = frame.width * _gradientCoverage
            let gStartX = frame.width - gWidth
            gradientLayer.frame.origin = CGPoint(x: gStartX, y: 0)
            gradientLayer.frame.size.width = gWidth
            gradientLayer.frame.size.height = frame.height
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
    }
    
    fileprivate func updateUI(){
        if !gradientLayerInserted {
            insertGradientLayer()
        } else {
            gradientLayer.locations = [gradientStartLocation, gradientEndLocation]
            gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
            setGradientPoints(gradientType)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
}
