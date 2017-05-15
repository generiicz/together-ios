//
//  UIImageExtensions.swift
//  Together
//
//  Created by Андрей Цай on 04.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension UIImage {
    
    func getPixelColor(_ pos: CGPoint) -> UIColor {
        let RGBcolor = self.getPixelColorRGB(pos)
        return UIColor.colorFromRGB(
            Int(RGBcolor.0),
            green: Int(RGBcolor.1),
            blue: Int(RGBcolor.2),
            alpha: Int(RGBcolor.3)
        )
    }
    
    func getPixelColorRGB(_ pos: CGPoint) -> (UInt8, UInt8, UInt8, UInt8) {
        
        let pixelData = (self.cgImage)?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = data[pixelInfo]
        let g = data[pixelInfo+1]
        let b = data[pixelInfo+2]
        let a = data[pixelInfo+3]
        
        return (r, g, b, a)
    }
    
    func getAveragePixelsColor(_ rect: CGRect) -> UIColor {
        let limitX = Int(rect.origin.x + rect.width)
        let limitY = Int(rect.origin.y + rect.height)
        let count = (limitX - Int(rect.origin.x)) * (limitY - Int(rect.origin.y))
        let xRange = Int(rect.origin.x)...limitX
        let yRange = Int(rect.origin.y)...limitY
        var allRed:Int = 0, allGreen:Int = 0, allBlue:Int = 0, allAlpha:Int = 0
        for cX in xRange {
            for cY in yRange{
                let cColor = self.getPixelColorRGB(CGPoint(x: cX, y: cY))
                allRed +=  Int(cColor.0)
                allGreen += Int(cColor.1)
                allBlue += Int(cColor.2)
                allAlpha += Int(cColor.3)
            }
        }
        
        return UIColor.colorFromRGB(
            allRed / count,
            green: allGreen / count,
            blue: allGreen / count,
            alpha: allGreen / count
        )
    }
    
}
