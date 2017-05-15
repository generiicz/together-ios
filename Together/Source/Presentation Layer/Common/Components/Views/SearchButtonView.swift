//
//  SearchButtonView.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class SearchButtonView: UIView {
    
    var horizontalMargin: CGFloat = 20
    var verticalMargin: CGFloat = 10
    fileprivate var searchButton: UIButton!

    override func layoutSubviews() {
        super.layoutSubviews()
        let heartInsetH = searchButton.frame.height*0.15
        let subWidth = searchButton.frame.width - searchButton.frame.height + heartInsetH*2
        let heartInsetRight = subWidth*0.6
        let heartInsetLeft = subWidth*0.4
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(
            heartInsetH,
            heartInsetLeft,
            heartInsetH,
            heartInsetRight
        )
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(
            0,
            -searchButton.frame.width*0.1,
            0,
            0)
    }
    
    func setupView(
        _ viewBackColor: UIColor = UIColor.white,
        buttonBackColor: UIColor = UIColor.grayColor(245),
        buttonFontColor: UIColor = UIColor.grayColor(142),
        horizontalMargin: CGFloat = 20,
        verticalMargin: CGFloat  = 10) {
        let newRect = CGRect(
            x: 0,
            y: 0,
            width: frame.width - horizontalMargin,
            height: frame.height - verticalMargin
        )
        self.verticalMargin = verticalMargin
        self.horizontalMargin = horizontalMargin
        backgroundColor = UIColor.white
        searchButton = UIButton(frame: newRect)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchButton)
        searchButton.setVisuals(
            buttonFontColor,
            borderWidth: 0,
            borderColor: buttonBackColor,
            bkgndColor: buttonBackColor,
            cornerRadius: 6
        )
        searchButton.tintColor = buttonFontColor
        searchButton.setImage(GUItools.iconicImage("search"), for: UIControlState())
        let bTitle = NSAttributedString(
            string: "Search",
            attributes: [
                NSFontAttributeName: UIFont(name: TogetherFontNames.SFUIDisplayRegular, size: 17)!,
                NSForegroundColorAttributeName: buttonFontColor
            ]
        )
        searchButton.setAttributedTitle(bTitle, for: UIControlState())
        self.addConstraint(NSLayoutConstraint(
            item: searchButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: searchButton,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: searchButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: frame.width - horizontalMargin))
        self.addConstraint(NSLayoutConstraint(
            item: searchButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: frame.height - verticalMargin))
    }
    
    fileprivate func getLayoutFrame(_ frame: CGRect) -> CGRect {
        let newRect = CGRect(
            x: 0,
            y: 0,
            width: frame.width - horizontalMargin,
            height: frame.height - verticalMargin
        )
        return newRect
    }
    
    fileprivate func adaptFrame() {
        let newFrame = getLayoutFrame((superview?.frame)!)
        self.frame = newFrame
    }
    
    func addTarget(_ target: AnyObject, action: Selector) {
        searchButton.addTarget(
            target,
            action: action,
            for: .touchUpInside
        )
    }
    
    func addStandardTarget() {
        searchButton.addTarget(self, action: #selector(self.searchSelector(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func searchSelector(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name(TogetherNotificationTypes.mainNavSwitch),
            object: nil,
            userInfo: [
                "segueName": "SearchSettings",
                "segueParams": [
                    "SearchSettingsPage": 1
                ]
            ]
        )
    }

}
