//
//  UILabelExtensions.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension UILabel {
    func addCharactersSpacing(_ spacing:CGFloat) {
        if let sourceText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, attributedString.mutableString.lowercased.characters.count-1))
            self.attributedText = attributedString
        }
    }
    
    func addUnderline(_ underlineType: Int, underlineColor: UIColor){
        if let sourceText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            let applyRange = NSMakeRange(0, attributedString.mutableString.lowercased.characters.count)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: underlineType, range: applyRange)
            attributedString.addAttribute(NSUnderlineColorAttributeName, value: underlineColor, range: applyRange)
            self.attributedText = attributedString
        }
    }
}
