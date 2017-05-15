//
//  UIViewExtensions.swift
//  Together
//
//  Created by Андрей Цай on 11.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeSizeRestrictedView(size: CGSize) {
        if self.translatesAutoresizingMaskIntoConstraints {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        self.frame.size = size
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: size.width)
        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: size.height)
        self.addConstraints([widthConstraint, heightConstraint])
    }
    
    func addMarginsToSubview(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, target: UIView) {
        let tMargin = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: target,
            attribute: .top,
            multiplier: 1.0,
            constant: top)
        let lMargin = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: target,
            attribute: .leading,
            multiplier: 1.0,
            constant: left)
        let bMargin = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: target,
            attribute: .bottom,
            multiplier: 1.0,
            constant: bottom)
        let rMargin = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: target,
            attribute: .trailing,
            multiplier: 1.0,
            constant: right)
        self.addConstraints([tMargin, lMargin, bMargin, rMargin])
    }    
}
