//
//  SettingsMenuCell.swift
//  Together
//
//  Created by Андрей Цай on 14.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class SettingsMenuCell: UITableViewCell {

    @IBOutlet weak var menuItemImage: UIImageView!
    @IBOutlet weak var menuItemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension SettingsMenuCell: UniCell {
    func setupCellProfile(_ profileData: CellAbstractData) {
        menuItemTitle.textColor = profileData["TitleColor"] as? UIColor ?? UIColor.black
        self.tintColor = profileData["TintColor"] as? UIColor ?? UIColor.gray
    }

    func setupCellData(_ cellData: CellAbstractData) {
        menuItemTitle.text = cellData["Title"] as? String ?? "Menu Item"
        let imageName = cellData["ImageName"] as? String ?? "first"
        menuItemImage.setTemplateRenderingModeImage(UIImage(named: imageName)!)
    }
    
    func getCellData() -> CellAbstractData {
        return ["Title": self.menuItemTitle.text as Any]
    }
}
