//
//  SecureEntryToggle.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

@objc protocol SecureEntryToggle: class {
    var sectureEntryToggleButton: UIButton? { get set }
    func buttonPressed()
}

extension SecureEntryToggle where Self: UITextField {
    
    func setButton() {
        let height = self.frame.height
        let frame = CGRect(x: 0, y: 0, width: height, height: height)
        let button = UIButton(frame: frame)
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        if self.isSecureTextEntry {
            button.setImage(UIImage(named: "eye_closed")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        } else {
            button.setImage(UIImage(named: "eye_opened")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        }
        
        self.sectureEntryToggleButton = button
        
        self.rightViewMode = .always
        self.rightView = self.sectureEntryToggleButton
    }
    
    func doButtonPressed() {
        guard let sectureEntryToggleButton = self.sectureEntryToggleButton else { return }
        self.isSecureTextEntry = !self.isSecureTextEntry
        if self.isSecureTextEntry {
            sectureEntryToggleButton.setImage(UIImage(named: "eye_closed")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        } else {
            sectureEntryToggleButton.setImage(UIImage(named: "eye_opened")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        }
        self.updateCursor()
    }
    
    // Workaround to ensure text filed doesn't have whitespace after secureTextEntry toggle
    fileprivate func updateCursor() {
        let tmpString = self.text
        self.text = ""
        self.text = tmpString
    }
    
}
