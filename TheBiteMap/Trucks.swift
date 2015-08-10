//
//  WebService.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/18/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


/*


original response from web service:
{
    category = Asian;
    category_detail = "Asian Fusion";
    id = 136;
    img = "trucks/3_Brothers_Kitchen/logo.jpg";
    name = "3 Brothers Kitchen";
    url = "http://www.3brotherskitchen.com";
}

after processing:
"136": {
    category = Asian;
    category_detail = "Asian Fusion";
    id = 136;
    img = "trucks/3_Brothers_Kitchen/logo.jpg";
    name = "3 Brothers Kitchen";
    url = "http://www.3brotherskitchen.com";
}

*/

// Model
struct Trucks {
    static var categories = Set<String>()
    static var trucks = [String: [String: String]]()
    
    static func getTrucksByCategory(categoryInput:String) -> [String: [String: String]]{
        
        var filtered = [String: [String: String]]()
        
        for truck_key in Trucks.trucks.keys {
            if categoryInput != "" {
                if categoryInput == "All" {
                    return Trucks.trucks
                } else {
//                    satisfied = true
                    if let truck = Trucks.trucks[truck_key] {
                        var truckCategory:String = truck["category"]!
                        var categories = split(truckCategory) { $0 == ","}
                        if (contains(categories, categoryInput)) {
                            filtered[truck_key] = truck
                        }
                    }
                
                }
            }
        }
        
        return filtered
    }
}