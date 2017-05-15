//
//  AccountCreateMasterThirdTableViewCell.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class AccountCreateMasterThirdTableViewCell: UITableViewCell {

    let pointColors: [UIColor] = [
        UIColor.colorFromRGB(255, green: 172, blue: 28, alpha: 255),
        UIColor.colorFromRGB(199, green: 105, blue: 191, alpha: 255),
        UIColor.colorFromRGB(105, green: 166, blue: 234, alpha: 255),
        UIColor.colorFromRGB(255, green: 107, blue: 100, alpha: 255),
        UIColor.colorFromRGB(157, green: 100, blue: 44, alpha: 255),
        UIColor.colorFromRGB(181, green: 30, blue: 23, alpha: 255),
        UIColor.colorFromRGB(47, green: 47, blue: 47, alpha: 255),
        UIColor.colorFromRGB(163, green: 220, blue: 81, alpha: 255),
        UIColor.colorFromRGB(44, green: 142, blue: 157, alpha: 255),
        UIColor.colorFromRGB(157, green: 100, blue: 44, alpha: 255),
        UIColor.colorFromRGB(255, green: 0, blue: 0, alpha: 255),
        UIColor.colorFromRGB(0, green: 126, blue: 255, alpha: 255)
    ]
    
    var selectCallBack: ((Bool) -> Void)?
    
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var InterestTitleLabel: UILabel!
    @IBOutlet weak var InterstCircleView: CircleView!

    @IBAction func checkAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let callBack = self.selectCallBack else { return }
        callBack(sender.isSelected)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func selectPointColor(_ val: Int){
        if val <= pointColors.count - 1 {
            InterstCircleView.fillColor = pointColors[ val ]
        } else {
            let newIndex: Int = val % (pointColors.count - 1)
            InterstCircleView.fillColor = pointColors[ newIndex ]
        }
    }
}
