//
//  ArrowButtonCell.swift
//  Together
//
//  Created by Андрей Цай on 03.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

typealias ArrowButtonCellActionType = (UIButton) -> Void

class ArrowButtonCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }*/
    
}

extension ArrowButtonCell: UniCell {
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let backgroundColor = profileData["backgroundColor"] as? UIColor {
            self.backgroundColor = backgroundColor
        }
    }
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let title = cellData["title"] as? String {
            titleLabel.text = title
        }
    }
    
    func getCellData() -> CellAbstractData {
        return ["":0]
    }
}
