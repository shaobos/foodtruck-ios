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
}