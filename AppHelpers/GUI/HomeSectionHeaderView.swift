//
//  HomeSectionHeaderView.swift
//  Together
//
//  Created by Андрей Цай on 30.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class HomeSectionHeaderView: UIView {
    
    fileprivate var uuid: String!

    @IBOutlet weak var eventGroupTitleLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!
    @IBAction func showAllAction(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.grayColor(248)
    }
    
    func setupView(uuid: String, title: String) {
        self.uuid = uuid
        self.eventGroupTitleLabel.text = title
    }

}
