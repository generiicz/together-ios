//
//  DrawingObject.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

struct drawPath{
    var lineWidth: CGFloat
    var lineColor: UIColor
    var pathPoints: [CGPoint]
}

protocol drawingObject: class {
    
    var drawPaths: [drawPath]? {get set}
    
    //func addDrawPath(path: drawPath)
}

extension drawingObject where Self: UIView {
    
    func addDrawPath(_ path: drawPath) -> Int {
        if drawPaths == nil {
            drawPaths = [drawPath]()
        }
        drawPaths!.append(path)
        return drawPaths!.count - 1
    }
    
    internal func drawAll(_ clear: Bool) {
        guard self.drawPaths != nil else {return}
        if clear {
            let context: CGContext = UIGraphicsGetCurrentContext()!
            //backgroundColor = UIColor.whiteColor()
            backgroundColor?.setFill()
            context.clear(self.bounds)
            context.fill(self.bounds)
        }
        for dPath in self.drawPaths! {
            let bPath = UIBezierPath()
            bPath.lineWidth = dPath.lineWidth
            dPath.lineColor.setStroke()
            
            for i in 0...dPath.pathPoints.count - 1 {
                if i == 0 {
                    bPath.move(to: dPath.pathPoints[i])
                } else {
                    bPath.addLine(to: dPath.pathPoints[i])
                }
            }
            bPath.stroke()
        }
    }
}









