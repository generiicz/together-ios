//
//  InputTableCell.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

protocol InputTableCell: class {
    weak var titleLabel: UILabel! {get set}
    
    weak var inputTextField: UnderlinedTextField! {get set}
}


extension InputTableCell {
    
    static func loadCellFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
    func setupInputCell(_ title: String, underline: UnderlineTextFieldParams?, setupClosure: ((_ cell: InputTableCell) -> Void)?){
        titleLabel.text = title
        if let uParams = underline {
            inputTextField.underline = uParams.enabled
            inputTextField.underlineColor = uParams.color
            inputTextField.underlineWidth = uParams.width
        }
        if setupClosure != nil {
            setupClosure!(self)
        }
    }
    
}
