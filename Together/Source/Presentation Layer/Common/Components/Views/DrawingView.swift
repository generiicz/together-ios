//
//  DrawingView.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class drawingView: UIView, drawingObject {
    
    internal var drawPaths: [drawPath]?
    fileprivate var linesAdded: Bool = false
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            self.updateLines()
        }
    }
    
    func getLinesGeometry() -> [[CGPoint]]{
        let lineY = bounds.height / 2
        let firstPoints = [
            CGPoint(x: 0, y: lineY),
            CGPoint(x: floor(bounds.width * 0.43), y: lineY)
        ]
        let secondPoints = [
            CGPoint(x: floor(bounds.width * 0.57), y: lineY ),
            CGPoint(x: bounds.width, y: lineY)
        ]
        return [firstPoints, secondPoints]
    }
    
    func addLines(){
        let geometry = getLinesGeometry()
        let firstLine = drawPath(
            lineWidth: 1.0,
            lineColor: UIColor.grayColor(152) ,
            pathPoints: geometry[0]        )
        let secondLine = drawPath(
            lineWidth: 1.0,
            lineColor: UIColor.grayColor(152) ,
            pathPoints: geometry[1]
        )
        addDrawPath(firstLine)
        addDrawPath(secondLine)
    }
    
    func updateLines(){
        if !linesAdded {
            addLines()
            linesAdded = true
        } else {
            guard self.drawPaths != nil else { return }
            let gData = self.getLinesGeometry()
            for gIndex in 0...gData.count - 1 {
                if gIndex <= drawPaths!.count - 1 {
                    drawPaths![gIndex].pathPoints = gData[gIndex]
                }
            }
        }
        setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        drawAll(true)
    }
}
