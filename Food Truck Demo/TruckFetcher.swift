//
//  TruckFetcher.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 4/26/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class TruckFetcher {

    var truckPhotos = [UIImage]()
    var results:NSArray = []
    let baseUrl = "http://130.211.191.208/"
    
    func getTruckNames() -> [String] {
        var ret = [String]()
        if (Trucks.trucks.count == 0) {
            println("No truck found")
        }
        
        for truckInfo in Trucks.trucks.values {
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
                    if let jsonResult = responseObject as? Dictionary<String, String> {
                        var id = jsonResult["id"]!
                        Trucks.trucks[id] = jsonResult
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(images: self.truckPhotos)
                })
            }
            
        })
        task.resume()
    }
}