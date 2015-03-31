//
//  ScheduleFetcher.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/28/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class ScheduleFetcher {
    
    let lengthOfSchedules:Int = 6 // days
    
    func getSchedules() -> [String: [String: AnyObject]] {
        return Schedules.schedules
    }
    
    func getSchedulesByTruck(targetTruckId:String) -> [String: [String: AnyObject]] {
        var ret = [String: [String: AnyObject]]()
        for key in Schedules.schedules.keys {
            var scheduleObject = Schedules.schedules[key]!
            if var truckId: AnyObject = scheduleObject["truck_id"] {
//                println("printing")
                if targetTruckId == truckId as NSString {
                    println("Found target schedule!! \(scheduleObject)")
                    ret[key] = scheduleObject
                }
            }
        }
        
        return ret
    }
    
    func composeScheduleId (jsonResult: [String: AnyObject]) -> String {
        var scheduleId:String = (jsonResult["truck_id"] as String) + (jsonResult["date"] as String) + (jsonResult["start_time"] as String) + (jsonResult["address"] as String)
        return scheduleId
    }
    
    func fetchTrucksInfoFromRemote(completionHandler: () -> ())  {
        //let startDate = getStartDate()
        let startDate = "03/01"
        let endDate = getEndDate()
        let urlPath = WebService.baseUrl + "scripts/get_trucks_schedule.php?start_date=\(startDate)&end_date=\(endDate)"
        
        println("DEBUG: \(urlPath)")
        
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error -> Void in
            
            if (error != nil) {
                println(error)
            } else {
                
                if data != nil {
                    let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray
                    
                    if jsonResults != nil {
                        for responseObject in jsonResults! {
                            // Attention: needs to be AnyObject here as value cannot be assumed to be String
                            if let jsonResult = responseObject as? [String: AnyObject] {
                                var scheduleId = self.composeScheduleId(jsonResult)
                                Schedules.schedules[scheduleId] = jsonResult
                            }
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler()
                })
            }
            
        })
        task.resume()
    }
    
    
    func getStartDate() -> String {
        var today = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.stringFromDate(today)
    }
    
    func getEndDate() -> String {
        var today = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitDay,
            value: lengthOfSchedules,
            toDate: today,
            options: NSCalendarOptions(0))
        
        return formatter.stringFromDate(tomorrow!)
    }
    
    func getScheduleDates () -> [String] {
        var today = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        var dates = [String]()


        // this can definitely be more efficient
        for i in 0...lengthOfSchedules {
            let currentDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .CalendarUnitDay,
                value: i,
                toDate: today,
                options: NSCalendarOptions(0))
            var currentDateInString = formatter.stringFromDate(currentDate!)
            println(currentDateInString)
            dates.insert(currentDateInString, atIndex: dates.endIndex)
        }
        
        return dates
    }
    
    
}