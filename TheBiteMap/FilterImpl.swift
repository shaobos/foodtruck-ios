//
//  FilterImpl.swift
//  thebitemap
//
//  Created by Shaobo Sun on 8/9/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import Foundation


class FilterImpl {
    static func filterSchedulesByCategoryAndDate(categoryInput:String, dateInput:String) -> [String: [String: AnyObject]] {
        var ret = [String: [String: AnyObject]]()
        for key in Schedules.schedules.keys {
            var scheduleObject = Schedules.schedules[key]!
            
            var satisfied = true
            if categoryInput != "" {
                if categoryInput == "All" {
                    satisfied = true
                } else {
                    if let truckId: AnyObject = scheduleObject["truck_id"] {
                        if let truckModel = Trucks.trucks[truckId as! String] {
                            var truckCategory:String = truckModel["category"]!
                            var categories = split(truckCategory) { $0 == ","}
                            if (!contains(categories, categoryInput)) {
                                satisfied = false
                            }
                        }
                    }
                }
            }
            
            if dateInput != "" {
                if dateInput == "All" {
                    satisfied = true
                } else {
                    if var scheduleDate: AnyObject = scheduleObject["date"] {
                        if dateInput != scheduleDate as! NSString {
                            satisfied = false
                        }
                    }
                }
            }
            
            
            if (satisfied) {
                ret[key] = scheduleObject
            }
        }
        return ret
    }
    
}