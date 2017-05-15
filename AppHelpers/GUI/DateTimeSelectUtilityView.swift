//
//  DateTimeSelectUtilityView.swift
//  Together
//
//  Created by Андрей Цай on 08.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class DateTimeSelectUtilityView: drawingView {

    override func getLinesGeometry() -> [[CGPoint]] {
        let lineG1 = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: frame.width, y:0)
        ]
        let lineG2 = [
            CGPoint(x: 0, y: frame.height),
            CGPoint(x: frame.width, y:frame.height)
        ]
        let middleX = round(frame.width / 2)
        let lineG3 = [
            CGPoint(x: middleX, y: frame.height * 0.1),
            CGPoint(x: middleX, y:frame.height * 0.9)
        ]
        return [lineG1, lineG2, lineG3]
    }
    
    override func addLines() {
        let gList = getLinesGeometry()
        addDrawPath(drawPath(
            lineWidth: 1.0,
            lineColor: UIColor.grayColor(178),
            pathPoints: gList[0]))
        addDrawPath(drawPath(
            lineWidth: 1.0,
            lineColor: UIColor.grayColor(178),
            pathPoints: gList[1]))
        addDrawPath(drawPath(
            lineWidth: 1.0,
            lineColor: UIColor.grayColor(178),
            pathPoints: gList[2]))
    }
}
