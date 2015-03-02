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
    
//    func getSchedulesName() -> [String] {
//        var ret = [String]()
//        for scheduleInfo in Schedules.schedules {
//            if let scheduleName = scheduleInfo["name"] {
//                ret.insert(scheduleName as String, atIndex: 0)
//            }
//        }
//        
//        return ret
//    }
    
    func composeScheduleId (jsonResult: [String: AnyObject]) -> String{
        
        var scheduleId:String = (jsonResult["truck_id"] as String) + (jsonResult["date"] as String) + (jsonResult["start_time"] as String)
        return scheduleId
    }
    
    func fetchTrucksInfoFromRemote(completionHandler: () -> ())  {
        let startDate = "02/21"
        let endDate = "02/28"
        let urlPath = WebService.baseUrl + "scripts/get_trucks_schedule.php?start_date=\(startDate)&end_date=\(endDate)"
        
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
    
    
}