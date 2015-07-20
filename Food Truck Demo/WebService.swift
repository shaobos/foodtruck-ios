//
//  WebService.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/28/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


struct WebService {
    static let baseUrl: String = "http://130.211.191.208/"

    static func request(url:String, callback completeHandler: (data: NSData) -> Void) {
        let NSUrl = NSURL(string: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSUrl!, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error)
            } else {
                completeHandler(data: data)
            }
        })
        
        task.resume()
    }
    
    
    static func post( ) {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:4567/login")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = [
            "name":"ios-test",
            "email":"ios-test@thebitemap.com",
            "comment": "it's good!",
            "client": "test client",
            "client_detail": "client details"
            ] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
    
    
}