//
//  CGRectExtensions.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension CGRect {
    
    func insetCGRect (_ insetX: CGFloat, insetY: CGFloat, insetWidth: CGFloat, insetHeight: CGFloat) -> CGRect {
        let insetVal = UIEdgeInsetsMake(insetX, insetY, insetWidth, insetHeight)
        let newRect = UIEdgeInsetsInsetRect(self, insetVal)
        return newRect
    }
    
}
