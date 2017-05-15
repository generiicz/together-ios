//
//  SeSAgeCell.swift
//  Together
//
//  Created by Андрей Цай on 01.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import TTRangeSlider

class AgeCell: UITableViewCell {

    @IBOutlet weak var ageEnableSwitch: UISwitch!
    @IBOutlet weak var ageRangeSlider: TTRangeSlider!
    
    @IBAction func ageEnabledChangedAction(_ sender: UISwitch) {
        //self.ageRangeSlider.isEnabled = sender.isOn
        self.ageRangeSlider.isHidden = !sender.isOn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makePretty()
    }
    
    func makePretty() {
        ageRangeSlider.tintColorBetweenHandles = UIColor.colorFromRGB(77, green: 216, blue: 101, alpha: 255)
        ageRangeSlider.handleColor = UIColor.grayColor(230)
        ageRangeSlider.minLabelColour = UIColor.grayColor(90)
        ageRangeSlider.maxLabelColour = UIColor.grayColor(90)
        ageRangeSlider.handleDiameter = 30
        ageRangeSlider.lineHeight = 4
        ageRangeSlider.selectedHandleDiameterMultiplier = 1.2
    }

}

extension AgeCell: UniCell {
    func setupCellData(_ cellData: CellAbstractData) {
        if let selectAge = cellData["selectAge"] as? Bool {
            self.ageEnableSwitch.setOn(selectAge, animated: false)
            self.ageRangeSlider.isEnabled = selectAge
        }
        if let minAge = cellData["minAge"] as? Float, let maxAge = cellData["maxAge"] as? Float {
            let realMinAge: Float = minAge < maxAge ? minAge : maxAge
            var realMaxAge: Float = minAge < maxAge ? maxAge : minAge
            if realMinAge == realMaxAge {
                realMaxAge = realMaxAge + 1
            }
            ageRangeSlider.selectedMinimum = realMinAge
            ageRangeSlider.selectedMaximum = realMaxAge
        }
    }
    
    func getCellData() -> CellAbstractData {
        var res: CellAbstractData = [:]
        res["ageActual"] = ageEnableSwitch.isOn
        res["minAge"] = ageRangeSlider.selectedMinimum
        res["maxAge"] = ageRangeSlider.selectedMaximum
        return res
    }
}
