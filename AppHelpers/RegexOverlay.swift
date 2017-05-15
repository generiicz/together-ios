//
//  RegexOverlay.swift
//  Academia
//
//  Created by Андрей Цай on 23.06.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import UIKit

struct RegexOverlay {
    
    static func simpleMatchInString (_ text: String, regex: String) throws -> Bool {
        var res: Bool = false
        var workRE: NSRegularExpression? = nil
        let workRange = NSMakeRange(0,text.characters.count)
        do {
            workRE = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
        } catch let createREerror as NSError {
            throw createREerror
        }
        
        if let re = workRE {
            let matchObj = re.firstMatch(in: text, options: .reportCompletion, range: workRange)
            if (matchObj?.range.length)! > 0 {
                res = true
            }
        }
        return res
    }
}
