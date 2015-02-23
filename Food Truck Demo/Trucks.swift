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


class Trucks {
    
    var truckPhotos = [UIImage]()
    var results:NSArray = []
    var truckNames:[String] = ["a", "b", "c"]
    
    
    
    func getTruckNames() -> [String] {
        
        return truckNames
        
    }

    func fetchTrucksInfoFromRemote(completionHandler: (images: [UIImage]) -> ())  {

        
       // var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
       // var context : NSManagedObjectContext = appDel.managedObjectContext!
       // var trucksCoreData = NSEntityDescription.insertNewObjectForEntityForName("Trucks", inManagedObjectContext: context) as NSManagedObject
        
        
        let baseUrl = "http://130.211.191.208/"
        let urlPath = baseUrl + "scripts/get_trucks.php"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        
        
        
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                println(error)
            } else {
                
                let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                //results  = jsonResults
                for jsonResult in jsonResults {

                    let jsonResultAsDict = jsonResult as NSDictionary
                    //println(jsonResultAsDict)
                    // TODO: find a URL resovler library in swift
                    let imageUrl = baseUrl + (jsonResultAsDict["img"] as NSString)
                    let url = NSURL(string: imageUrl);
                    let imageData = NSData(contentsOfURL: url!)!

                    let image = UIImage(data: imageData)
                    if (image == nil) {
                        println(imageUrl + " is nil!!")
                    } else {
                        self.truckPhotos.insert(image!, atIndex: 0)
                        
                    }

                    //}
                } // end of for loop
                
                //completionHandler(images: image!)
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(images: self.truckPhotos)
                })
            }
            
        })
        task.resume()
    }
    
    
    
}