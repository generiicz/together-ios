//
//  UIColorExtensions.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func colorFromRGB(_ red: Int, green: Int, blue: Int, alpha:Int) -> UIColor{
        var colorList: Array<CGFloat> = [
            CGFloat(red),
            CGFloat(green),
            CGFloat(blue),
            CGFloat(alpha)
        ]
        for val in 0...colorList.count - 1 {
            if colorList[val] > 255 {
                colorList[val] = 255
            } else if colorList[val] < 0 {
                colorList[val] = 0
            }
            colorList[val] = colorList[val] / 255
        }
        return UIColor(
            red: colorList[0],
            green: colorList[1],
            blue: colorList[2],
            alpha: colorList[3]
        )
    }
    
    static func grayColor(_ val: Int, alpha: Int = 255) -> UIColor {
        return UIColor.colorFromRGB(val, green: val, blue: val, alpha: alpha)
    }
    
    func getInvertedColor () -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        let res = UIColor(
            red: 1 - red,
            green: 1 - green,
            blue: 1 - blue,
            alpha: alpha)
        
        return res
    }
}
