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

*/

// Model
struct TheTrucks {
    static var trucks = [String: [String: String]]()
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
        
        for truckInfo in TheTrucks.trucks.values {
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
                        TheTrucks.trucks[id] = jsonResult
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