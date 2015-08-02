//
//  Annotation.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 7/12/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import MapKit

class AnnotationCreator {

    
    func getTruckCategoryBySchedule(truckId:String) -> String! {
    
        if let truckModel = Trucks.trucks[truckId] {
            return truckModel["category"]!
        }
        
        return ""
    }
    
    func createGroupAnnotation(groupId: String, schedulesOnSameAddress schedules: [[String: AnyObject]]) -> FoodTruckMapAnnotation {
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()

        var temp:String = ""
        for singleSchedule in schedules {
            temp += singleSchedule["name"] as! String
            var category:String = getTruckCategoryBySchedule(singleSchedule["truck_id"] as! String)
            annotation.categories.append(category)
        }
        
        var schedule = schedules.first!
        var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var address:String = schedule["address"] as! String
        annotation.coordinate = newCoordinate
        annotation.title = "\(schedules.count) food trucks: \(address)"
        annotation.subtitle = schedule["date"] as! String + " " + (schedule["start_time"] as! String) + " - " + (schedule["end_time"] as! String)
        annotation.truckId = schedule["truck_id"] as! String
        annotation.groupId = groupId
        annotation.date = schedule["date"] as! String
        
        
        
        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            println("invalid longitude/latitude \(longitude)/\(latitude)")
        }
    
        return annotation
    }
    
    
    func createSingleAnnotation(scheduleId: String, singleScheduleObject schedule: [String: AnyObject]) -> FoodTruckMapAnnotation {
        
        var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()
        var category:String = getTruckCategoryBySchedule(schedule["truck_id"] as! String)
        annotation.categories.append(category)
        annotation.coordinate = newCoordinate
        annotation.title = schedule["name"] as! String
        annotation.subtitle = schedule["date"] as! String + " " + (schedule["start_time"] as! String) + " - " + (schedule["end_time"] as! String)
        annotation.truckId = schedule["truck_id"] as! String
        annotation.scheduleId = scheduleId
        annotation.date = schedule["date"] as! String
        
        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            println("invalid longitude/latitude \(longitude)/\(latitude)")
        }
        
        return annotation
    }
}