//
//  Schedules.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

/*

scheduleId : {
    "lng": "-122.3940893",
    "end_time": "14:00:00",
    "street_lng": null,
    "address": "Mission Street & Spear Street, San Francisco, CA 94105, USA",
    "street_lat": null,
    "name": "Casey's Pizza",
    "meal": "lunch",
    "img": "trucks/Casey_s_Pizza/logo.jpg",
    "short_address": "Spear and Mission",
    "lat": "37.7925466",
    "start_time": "11:00:00",
    "date": "2015-02-03",
    "truck_id": "124",
    "type": "truck"
}

scheduleId consists of truckId + date + start time + address for now

*/

struct Schedules {
    static var schedules = [String: [String: AnyObject]]()

    static func getSchedulesWithFilter() -> [String: [String: AnyObject]] {
        var ret = [String: [String: AnyObject]]()
        for (scheduleId, scheduleObject) in schedules {
            
            var convert = scheduleObject as [String: AnyObject]
            if (convert["date"] as? String == "2015-03-09") {
                ret[scheduleId] = scheduleObject
            }
        }
        
        return schedules
    }
}

