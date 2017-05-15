//
//  Defaults.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let defaultsValid = DefaultsKey<Bool>("firstLaunch")
    static let firstStart = DefaultsKey<Bool>("firstStart")
    static let mainTabIndex = DefaultsKey<Int>("mainTabIndex")
}

struct DefaultsTools {
    
    static func initValues() {
        Defaults[.defaultsValid] = true
        Defaults[.firstStart] = true
        Defaults[.mainTabIndex] = 2
    }
    
}
