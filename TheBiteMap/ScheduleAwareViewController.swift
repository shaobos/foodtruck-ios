//
//  ScheduleDriven.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/15/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class ScheduleAwareViewController : UIViewController {
    var scheduleId: String = ""
    
    func scheduleId(scheduleId: String) {
        print("** Set schedule ID happens")
        self.scheduleId = scheduleId
    }
}