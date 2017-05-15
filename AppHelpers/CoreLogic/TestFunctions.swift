//
//  TestFunctions.swift
//  Together
//
//  Created by Андрей Цай on 16.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

func delayNetwork(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

func generateRandomBool() -> Bool {
    return arc4random_uniform(2) > 0 ? true : false
}
