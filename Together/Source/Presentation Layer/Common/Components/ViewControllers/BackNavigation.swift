//
//  BackNavigation.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

protocol BackNavigation {
    
    func backByStep(_ step: Int)
    func changeBackNavItem(_ title: String, tintColor: UIColor?, image: UIImage?)
}

extension BackNavigation where Self: UIViewController {
    
    func changeBackNavItem(_ title: String, tintColor: UIColor? = nil, image: UIImage? = nil){
        if navigationItem.backBarButtonItem == nil {
            navigationItem.backBarButtonItem = UIBarButtonItem()
        }
        navigationItem.backBarButtonItem?.title = title
        if tintColor != nil {
            navigationItem.backBarButtonItem?.tintColor = tintColor!
        }
        if image != nil {
            navigationItem.backBarButtonItem?.image = image
        }
    }
    
    func backByStep(_ step: Int) {
        guard self.navigationController != nil else { return }
        let zeroStep = step + 1
        var backNum = (self.navigationController?.viewControllers.count)!
        if backNum >= zeroStep {
            backNum -= zeroStep
        } else {
            backNum = 0
        }
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[backNum])!, animated: true)
    }
}
