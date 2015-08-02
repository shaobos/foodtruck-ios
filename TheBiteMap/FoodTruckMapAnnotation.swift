//
//  MapAnnotation.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/1/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


import MapKit

class FoodTruckMapAnnotation : MKPointAnnotation {
    
    // for image
    var groupId:String = ""
    var truckId: String = ""
    // for schedule details view
    var scheduleId: String = ""
    var date: String = ""
    var categories = [String]()
}