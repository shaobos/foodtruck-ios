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
                //results  = jsonResults
                for responseObject in jsonResults {
                    if let jsonResult = responseObject as? Dictionary<String, String> {
                        println(jsonResult)
                        TheTrucks.trucks.insert(jsonResult, atIndex: 0)
//                        var image:UIImage = self.fetchImage(jsonResult)
//                        self.truckPhotos.insert(image, atIndex: 0)
                    }
                }
                
                //completionHandler(images: image!)
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(images: self.truckPhotos)
                })
            }
            
        })
        task.resume()
    }

    func fetchImage(jsonResult:[String: String]) -> UIImage {
        //println(jsonResultAsDict)
        // TODO: find a URL resovler library in swift
        let imageUrl = baseUrl + (jsonResult["img"]! as String)
        let url = NSURL(string: imageUrl);
        let imageData = NSData(contentsOfURL: url!)!
        
        let image = UIImage(data: imageData)
        if (image == nil) {
            println(imageUrl + " is nil!!")
       
        }
        
        return image!
    }
    
    func setCoreData() {
        
        // var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        // var context : NSManagedObjectContext = appDel.managedObjectContext!
        // var trucksCoreData = NSEntityDescription.insertNewObjectForEntityForName("Trucks", inManagedObjectContext: context) as NSManagedObject
    }

}