//
//  UnderlinedTextField.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

@IBDesignable
class UnderlinedTextField: UITextField, drawingObject {
    
    internal var drawPaths: [drawPath]?
    fileprivate var underlineAdded: Bool = false
    fileprivate var underlineIndex: Int = 0
    fileprivate var _underline: Bool = false
    fileprivate var _underlineWidth: CGFloat = 1
    fileprivate var _underlineColor: UIColor = UIColor.black
    
    @IBInspectable var underline: Bool {
        set {
            _underline = newValue
            if newValue {
                setNeedsDisplay()
            } else {
                removeUnderline()
            }
        }
        get {
            return _underline
        }
    }
    
    @IBInspectable var underlineWidth: CGFloat {
        set {
            _underlineWidth = newValue
            if _underline {
                setNeedsDisplay()
            } else {
                removeUnderline()
            }
        }
        get {
            return _underlineWidth
        }
    }
    
    @IBInspectable var underlineColor: UIColor {
        set {
            _underlineColor = newValue
            if _underline {
                setNeedsDisplay()
            } else {
                removeUnderline()
            }
        }
        get {
            return _underlineColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        if underlineAdded {
            updateUnderline()
        } else {
            addUnderline()
        }
        drawAll(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    fileprivate func getUnderlinePoints() -> [CGPoint]{
        let uY = frame.height - 1
        let begPoint = CGPoint(x: 0, y: uY)
        let endPoint = CGPoint(x: frame.width, y: uY)
        return [begPoint, endPoint]
    }
    
    fileprivate func addUnderline(){
        let dPath = drawPath(
            lineWidth: _underlineWidth,
            lineColor: _underlineColor,
            pathPoints: getUnderlinePoints()
        )
        if drawPaths == nil {
            drawPaths = [drawPath]()
        }
        drawPaths?.append(dPath)
        underlineIndex = drawPaths!.count - 1
        underlineAdded = true
        contentMode = UIViewContentMode(rawValue: contentMode.rawValue | UIViewContentMode.redraw.rawValue)!
    }
    
    fileprivate func updateUnderline(){
        var uPath = drawPaths![underlineIndex]
        uPath.lineColor = _underlineColor
        uPath.lineWidth = _underlineWidth
        uPath.pathPoints = getUnderlinePoints()
    }
    
    fileprivate func removeUnderline(){
        guard underlineAdded else {return}
        if let _ = drawPaths?[underlineIndex] {
            drawPaths?.remove(at: underlineIndex)
            underlineAdded = false
        }
        setNeedsDisplay()
    }
    
}
