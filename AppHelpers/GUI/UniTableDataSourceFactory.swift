//
//  UniTableDataSourceFactory.swift
//  Together
//
//  Created by Андрей Цай on 18.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class UniTableDataSourceFactory {
    
    static fileprivate let standardMargin: CGFloat = 4
    
    static fileprivate func createStandardFrame(_ height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
    }
    
    static fileprivate func createContainerView(height: CGFloat) -> UIView {
        let newFrame = createStandardFrame(height)
        return UIView(frame: newFrame)
    }
    
    static fileprivate func addToContainerViewWithMargin(_ subView: UIView, containerView: UIView, margin: CGFloat) {
        containerView.addSubview(subView)
        containerView.addMarginsToSubview(top: margin, left: margin, bottom: margin, right: margin, target: subView)
    }
    
    static func createSectionTitle(_ title: String, fontColor: UIColor = TogetherColors.GrayFontDark, fontSize: CGFloat = 18, fontSpacing: CGFloat = 0, backgroundColor: UIColor =  UIColor.white) -> UILabel{
        let margin: CGFloat = 4
        let newFrame = CGRect(x: 0, y: 0, width: fontSize * CGFloat(title.characters.count) + margin, height: fontSize + margin)
        let res = UILabel(frame: newFrame)
        res.backgroundColor = backgroundColor
        let aString = NSMutableAttributedString(string: title)
        let workRange = NSMakeRange(0, aString.mutableString.lowercased.characters.count)
        res.font = UIFont(name: TogetherFontNames.SFUIDisplayRegular, size: fontSize)
        let attrDict: [String:Any] = [
            NSForegroundColorAttributeName: fontColor,
            NSKernAttributeName: fontSpacing
        ]
        aString.addAttributes(attrDict, range: workRange)
        res.attributedText = aString
        return res
    }
    
    static func createSearchButton(_ height: CGFloat) -> UIView {
        let res = SearchButtonView(frame: createStandardFrame(height))
        res.setupView()
        res.addStandardTarget()
        return res
    }
    
    static func createSearchField(_ height: CGFloat) -> UIView {
        let res = createContainerView(height: height)
        return res
    }
    
    static func createFacebookSearchFriends(_ height: CGFloat) -> UIView {
        let res = createContainerView(height: height)
        let fButton = PrettyButton(frame: res.frame.insetBy(dx: standardMargin * 2, dy: standardMargin * 2))
        fButton.setAttributedTitle(NSAttributedString(string: "FIND YOUR FACEBOOK FRIENDS"), for: UIControlState())
        fButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        fButton.addTarget(self, action: #selector(self.facebookSearchFriendsSelector(_:)), for: .touchUpInside)
        addToContainerViewWithMargin(fButton, containerView: res, margin: standardMargin)
        return res
    }
    
    @objc static fileprivate func facebookSearchFriendsSelector(_ sender: PrettyButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name(TogetherNotificationTypes.mainNavSwitch),
            object: nil,
            userInfo: [
                "segueName": "SearchFacebookFriends",
                "segueParams": [
                    "FriendsPerPage": 10
                ]
            ]
        )
    }
    /*
    @objc static fileprivate func searchSelector(_ sender: UIButton) {
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
    }*/
}
