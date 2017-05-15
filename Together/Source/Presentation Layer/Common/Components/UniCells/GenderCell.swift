//
//  SeSGenderCell.swift
//  Together
//
//  Created by Андрей Цай on 01.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {
    
    @IBOutlet weak var genderSelectSegmented: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension GenderCell: UniCell {
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let currentState = cellData["selectedGender"] as? Int {
            switch currentState {
            case 0...2:
                genderSelectSegmented.selectedSegmentIndex = currentState
            default:
                genderSelectSegmented.selectedSegmentIndex = 0
            }
        }
    }
    
    func getCellData() -> CellAbstractData {
        return ["selectedGender": genderSelectSegmented.selectedSegmentIndex]
    }
}
