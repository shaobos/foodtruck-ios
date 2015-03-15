//
//  WebService.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/18/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


import UIKit
import CoreData


struct TruckInfo {
    let name:String
    let imageUrl:String
}

struct TheTrucks {
    
    static var trucks = [Dictionary<String, String>]()
}


class Trucks {
    
    var truckPhotos = [UIImage]()
    var results:NSArray = []
    let baseUrl = "http://130.211.191.208/"
    
    
    func getTruckNames() -> [String] {
        var ret = [String]()
        if (TheTrucks.trucks.count == 0) {
            println("????? what are you talking about? there is no fucking truck!!!")
        }
        
        for truckInfo in TheTrucks.trucks {
            ret.insert(truckInfo["name"]!, atIndex: 0)
        }
        
        return ret
    }

    func fetchTrucksInfoFromRemote(completionHandler: (images: [UIImage]) -> ())  {
        let urlPath = baseUrl + "scripts/get_trucks.php"

        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                println(error)
            } else {
                
                let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                for responseObject in jsonResults {
//                    println(responseObject)
                    if let jsonResult = responseObject as? Dictionary<String, String> {
                        TheTrucks.trucks.insert(jsonResult, atIndex: 0)

                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(images: self.truckPhotos)
                })
            }
            
        })
        task.resume()
    }


    
    func setCoreData() {
        
        // var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        // var context : NSManagedObjectContext = appDel.managedObjectContext!
        // var trucksCoreData = NSEntityDescription.insertNewObjectForEntityForName("Trucks", inManagedObjectContext: context) as NSManagedObject
    }

}