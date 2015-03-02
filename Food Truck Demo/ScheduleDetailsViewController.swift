//
//  TruckPageViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ScheduleDetailsViewController: UIViewController {

    @IBOutlet weak var theTitle: UILabel!
    
    var prevViewController: UIViewController?
    var previousViewControllerName:String = ""
    var scheduleToTableSegueID : String = "ScheduleToTableSegue"
    var scheduleToMapSegueID : String = "ScheduleToMapSegue"
    var scheduleId:String = ""
    var inputLabel:String = ""

    @IBOutlet weak var anotherLabel: UILabel!
    @IBAction func backButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("ScheduleToMainSegue", sender: nil)
    }
    
    // truck id can be used for retrieving schedule info
    func setScheduleId(scheduleId: String) {
        println("setting schedule id here")
        self.scheduleId = scheduleId
    }
    func setPrevViewController(prev: String) {
        self.previousViewControllerName = prev
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("who is my previous controller \(self.previousViewControllerName)")

        // Do any additional setup after loading the view.
        theTitle.text = inputLabel
        println("schedule id is \(self.scheduleId)")

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
