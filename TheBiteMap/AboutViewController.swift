//
//  AboutViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/16/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
    
        scrollView.contentSize = ContentView.frame.size
        scrollView.scrollEnabled = true
        scrollView.addSubview(ContentView)

        ContentView.frame.size = self.view.frame.size
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitComment(sender: AnyObject) {
        
        post()
    }
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func post() {
        var url = WebService.baseUrl + "scripts/submit_comment.php"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        var joiner = "&"
        var params = [
            "name=\(name.text)",
            "email=\(email.text)",
            "comment=\(comment.text)",
            "client=ios",
            "client_detail=ios"
        ]
        
        var paramList = joiner.join(params)
        request.HTTPBody = paramList.dataUsingEncoding(NSUTF8StringEncoding)
        
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
