//
//  View.swift
//  Together
//
//  Created by Андрей Цай on 24.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadable {}
extension UIView: NibLoadable {}

extension NibLoadable where Self: UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(self, options: nil).first as! Self
    }
    
}
