//
//  SecureVievableTextField.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class SecureViewableTextField: UnderlinedTextField, SecureEntryToggle {
    
    var sectureEntryToggleButton: UIButton?
    
    func buttonPressed() {
        doButtonPressed()
    }
}