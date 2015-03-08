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
    
    func composeScheduleId (jsonResult: [String: AnyObject]) -> String {
        
        var scheduleId:String = (jsonResult["truck_id"] as String) + (jsonResult["date"] as String) + (jsonResult["start_time"] as String)
        return scheduleId
    }
    
    func fetchTrucksInfoFromRemote(completionHandler: () -> ())  {
        let startDate = getStartDate()
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

                let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                for responseObject in jsonResults {
                    // Attention: needs to be AnyObject here as value cannot be assumed to be String
                    if let jsonResult = responseObject as? [String: AnyObject] {
                        var scheduleId = self.composeScheduleId(jsonResult)
                        Schedules.schedules[scheduleId] = jsonResult
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