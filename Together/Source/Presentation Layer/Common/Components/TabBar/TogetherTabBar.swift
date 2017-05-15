//
//  TogetherTabBar.swift
//  Together
//
//  Created by Андрей Цай on 15.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class TogetherTabBar: UITabBar {
    
    fileprivate let itemImageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    
    func setupTabBar() {
        isTranslucent = false
        delegate = self
        generateItems()
    }
    
    fileprivate func makeItemWithTag(_ tag: Int, title: String, image: UIImage, selectedImage: UIImage, imageInsets: UIEdgeInsets? = nil) -> UITabBarItem{
        let res = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        res.tag = tag
        if let imageInsets = imageInsets {
            res.imageInsets = imageInsets
        }
        return res
    }
    
    fileprivate func generateItems() {
        let items = [
            makeItemWithTag(0, title: "", image: UIImage(named: "shake")!, selectedImage: UIImage(named: "shake")!, imageInsets: itemImageInsets),
            makeItemWithTag(1, title: "", image: UIImage(named: "map")!, selectedImage: UIImage(named: "map")!, imageInsets: itemImageInsets),
            makeItemWithTag(2, title: "", image: UIImage(named: "home")!, selectedImage: UIImage(named: "home")!, imageInsets: itemImageInsets),
            makeItemWithTag(3, title: "", image: UIImage(named: "mail")!, selectedImage: UIImage(named: "mail")!, imageInsets: itemImageInsets),
            makeItemWithTag(4, title: "", image: UIImage(named: "user")!, selectedImage: UIImage(named: "user")!, imageInsets: itemImageInsets)
        ]
        self.setItems(items, animated: false)
    }

}

extension TogetherTabBar: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedItem = nil
        let nota = Notification(
            name: Notification.Name(rawValue: TogetherNotificationTypes.mainNavSwitch),
            object: tabBar,
            userInfo: [
                "segueName": "Root",
                "segueParams": [
                    "tabIndex": item.tag
                ]
            ])
        NotificationCenter.default.post(nota)
    }

}
