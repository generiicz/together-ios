//
//  UniCell.swift
//  Together
//
//  Created by Андрей Цай on 14.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

@objc protocol UniCell: class {
    @objc optional func setupCellProfile(_ profileData: CellAbstractData)
    func setupCellData(_ cellData: CellAbstractData)
    @objc optional func getCellData() -> CellAbstractData
    
}
