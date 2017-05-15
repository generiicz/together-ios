//
//  AddTapNotification.swift
//  Together
//
//  Created by Андрей Цай on 31.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit


protocol AddTapNotification: class {
    var tapRec: UIGestureRecognizer? {get set}
    var selectron: TapSelectron! {get set}
}

extension AddTapNotification where Self: UIView {
    
    func addTap(_ params: TogetherNotificationParameters){
        if !self.isUserInteractionEnabled {
            self.isUserInteractionEnabled = true
        }
        self.gestureRecognizers?.removeAll()
        //if self.tapRec == nil {
        self.selectron = TapSelectron(params.notificationType, notificationData: params.notificationUserDictionary)
        self.tapRec = UITapGestureRecognizer(target: self.selectron, action: #selector(
            self.selectron.sendTapNotification
            ))
        self.addGestureRecognizer(self.tapRec!)
        //}
    }
}

class TapSelectron {
    
    fileprivate var notificationType: String!
    fileprivate var notificationUserData: [AnyHashable: Any]!
    
    init(_ notificationType: String, notificationData:[AnyHashable: Any]) {
        self.notificationType = notificationType
        self.notificationUserData = notificationData
    }
    
    @objc func sendTapNotification(){
        guard let notificationType = self.notificationType, let notificationUserData = self.notificationUserData else { return }
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: notificationType),
            object: self,
            userInfo: notificationUserData
        )
    }
}
