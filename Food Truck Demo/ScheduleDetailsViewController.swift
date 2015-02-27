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
    
    var inputLabel:String = ""
    
    
    
    @IBOutlet weak var anotherLabel: UILabel!
    @IBAction func backButton(sender: UIBarButtonItem) {

        
        performSegueWithIdentifier("ScheduleToMainSegue", sender: nil)

        
    }
    
    func setTitle(inputTitle : String) {
        inputLabel = inputTitle
    }
    
    func setPrevViewController(prev: String) {
        self.previousViewControllerName = prev
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("who is my previous controller \(self.previousViewControllerName)")

        // Do any additional setup after loading the view.
        theTitle.text = inputLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
