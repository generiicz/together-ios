//
//  ChooseOneWay.swift
//  Together
//
//  Created by Андрей Цай on 16.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

protocol ChooseOneWay: class {
    
    var wayChosen: Bool! { get set }
    
    func chooseWayByButton(_ button: UIButton, completion: ()->Void)
    
    func resetWay()
}

extension ChooseOneWay where Self: UIViewController {
    
    internal func chooseWayByButton(_ button: UIButton, completion: ()->Void) {
        button.isUserInteractionEnabled = false
        if !wayChosen {
            wayChosen = true
            completion()
        }
    }
}
