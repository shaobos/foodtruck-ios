//
//  ScheduleFetcher.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/28/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class ScheduleFetcher {
        
    func getSchedules() -> [String: [String: AnyObject]] {
        return Schedules.schedules
    }
    
    func getSchedulesByCategoryAndDate(categoryInput:String, dateInput:String) -> [String: [String: AnyObject]] {
        return FilterImpl.filterSchedulesByCategoryAndDate(categoryInput, dateInput: dateInput)
    }
    
    func getSchedulesByCategory(category:String) -> [String: [String: AnyObject]] {
        return getSchedulesByCategoryAndDate(category, dateInput: "")
    }
    
    func getSchedulesBydate(date:String) -> [String: [String: AnyObject]] {
        return getSchedulesByCategoryAndDate("", dateInput: date)
    }

    func getSchedulesByTruck(targetTruckId:String) -> [String: [String: AnyObject]] {
        var ret = [String: [String: AnyObject]]()
        for key in Schedules.schedules.keys {
            var scheduleObject = Schedules.schedules[key]!
            if var truckId: AnyObject = scheduleObject["truck_id"] {
                if targetTruckId == truckId as! NSString {
                    ret[key] = scheduleObject
                }
            }
        }
        
        return ret
    }
    
    func composeScheduleId (jsonResult: [String: AnyObject]) -> String {
        var scheduleId:String = (jsonResult["truck_id"] as! String) + (jsonResult["date"] as! String) + (jsonResult["start_time"] as! String) + (jsonResult["address"] as! String)
        return scheduleId
    }
    
    func fetchSchedules(completionHandler: () -> ())  {
        let startDate = Date.getStartDate()
        //let startDate = "07/13"
        let endDate = Date.getEndDate()
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
}