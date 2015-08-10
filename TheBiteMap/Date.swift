//
//  Date.swift
//  thebitemap
//
//  Created by Shaobo Sun on 8/9/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import Foundation


class Date {
    
    static let lengthOfSchedules:Int = 6 // days, since it's 0-based

    
    static func getStartDate() -> String {
        var today = getToday()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.stringFromDate(today)
    }
    
    static func getToday() -> NSDate {
        return NSDate()
    }
    
    static func getEndDate() -> String {
        var today = getToday()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitDay,
            value: lengthOfSchedules,
            toDate: today,
            options: NSCalendarOptions(0))
        
        return formatter.stringFromDate(tomorrow!)
    }
    
    static func getScheduleDates () -> [String] {
        var today = getToday()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        var dates = [String]()
        
        // this can definitely be more efficient
        for i in 0...lengthOfSchedules {
            let currentDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .CalendarUnitDay,
                value: i,
                toDate: today,
                options: NSCalendarOptions(0))
            var currentDateInString = formatter.stringFromDate(currentDate!)
            dates.insert(currentDateInString, atIndex: dates.endIndex)
        }
        
        // the first element is All for clear the filter
        dates.insert("All", atIndex: 0)
        
        return dates
    }
}