//
//  ButtonCell.swift
//  Together
//
//  Created by Андрей Цай on 19.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

typealias ButtonCellActionType = (PrettyButton) -> Void

class ButtonCell: UITableViewCell {
    
    fileprivate var action: ButtonCellActionType?

    @IBOutlet weak var cellButton: PrettyButton!
    
    @IBAction func cellButtonAction(_ sender: PrettyButton) {
        guard let action = self.action else { return }
        action(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ButtonCell: UniCell {
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let title = profileData["title"] as? String {
            cellButton.setTitle(title, for: .normal)
            cellButton.setAttributedTitle(NSAttributedString(string: title), for: .normal)
        }
        if let vProfile = profileData["visualProfile"] as? [UInt: ButtonParameters] {
            cellButton.loadStatesProfile(vProfile)
        }
        if let callBack = profileData["action"] as? ButtonCellActionType {
            action = callBack
        }
        if let backgroundColor = profileData["backgroundColor"] as? UIColor {
            self.backgroundColor = backgroundColor
            self.selectedBackgroundView?.backgroundColor = backgroundColor
        }
    }
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let state = cellData["state"] as? UIControlState {
            switch state {
            case UIControlState.disabled:
                cellButton.isEnabled = false
            case UIControlState.highlighted:
                cellButton.isHighlighted = true
            case UIControlState.selected:
                cellButton.isSelected = true
            default:
                cellButton.isEnabled = true
                cellButton.isSelected = false
                cellButton.isHighlighted = false
                cellButton.isHidden = false
            }
        }
    }
    
    
}
