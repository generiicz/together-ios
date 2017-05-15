//
//  Notifications.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

struct TogetherNotificationTypes {
    static let showEventOnMap = "TogetherShowEventOnMapNotification"
    static let removeMainTabShadow = "TogetherRemoveMainTabShadowNotification"
    static let summonMainTabShadow = "TogetherSummonMainTabShadowNotification"
    static let mainNavSwitch = "TogetherMainNavSwitchNotification"
}

struct TogetherNotificationParameters {
    var notificationType: String
    var notificationUserDictionary: [AnyHashable: Any]
}


