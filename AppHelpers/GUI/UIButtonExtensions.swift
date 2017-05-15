//
//  Buttons.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension UIButton {
    func addCharactersSpacing(_ spacing:CGFloat, state: UIControlState) {
        if let sourceText = self.attributedTitle(for: state){
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, attributedString.mutableString.lowercased.characters.count-1))
            self.setAttributedTitle(attributedString, for: state)
        }
    }
    
    func addUnderline(_ underlineType: Int, underlineColor: UIColor, state: UIControlState){
        if let sourceText = self.attributedTitle(for: state) {
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            let applyRange = NSMakeRange(0, attributedString.mutableString.lowercased.characters.count)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: underlineType, range: applyRange)
            attributedString.addAttribute(NSUnderlineColorAttributeName, value: underlineColor, range: applyRange)
            self.setAttributedTitle(attributedString, for: state)
        }
    }
    
    func setVisuals (_ titleColor: UIColor, borderWidth: CGFloat, borderColor: UIColor, bkgndColor: UIColor, cornerRadius: CGFloat) {
        self.setTitleColor(titleColor, for: UIControlState())
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = bkgndColor
    }
}
