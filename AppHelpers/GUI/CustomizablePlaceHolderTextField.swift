//
//  CustomizablePlaceHolderTextField.swift
//  Together
//
//  Created by Андрей Цай on 21.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class CustomizablePlaceHolderTextField: UITextField {
    
    override var bounds: CGRect {
        didSet {
            updateVisuals()
        }
    }
    
    convenience init(frame: CGRect, placeholderImage: UIImage, placeholderText: String, placeholderBackgroundColor: UIColor, cornerRadius: CGFloat = 6) {
        self.init(frame: frame)
        self.layer.cornerRadius = cornerRadius
    }

    fileprivate func updateVisuals() {
        
    }
}
