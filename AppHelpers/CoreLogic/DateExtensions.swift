//
//  NSDateExtensions.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

extension Date {
    
    var getTimeInt: (Int, Int, Int){
        get {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components(
                NSCalendar.Unit(rawValue: NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue | NSCalendar.Unit.second.rawValue),
                from: self)
            let hour = components.hour
            let minutes = components.minute
            let seconds = components.second
            return (hour!, minutes!, seconds!)
        }
    }
    
    func displayDate(_ localeStr: String, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = Locale(identifier: localeStr)
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
}
