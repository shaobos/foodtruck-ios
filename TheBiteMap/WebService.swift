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
    
    static func post() {
        var url = baseUrl + "scripts/submit_comment.php"

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let postString = "name=ios-test&email=ios-test@thebitemap.com&comment=good&client=test client&client_detail=no_detail"
        var params = [
            "name":"ios-test",
            "email":"ios-test@thebitemap.com",
            "comment": "no",
            "client": "test client",
            "client_detail": "client details"
            ] as Dictionary<String, String>
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
    }
}