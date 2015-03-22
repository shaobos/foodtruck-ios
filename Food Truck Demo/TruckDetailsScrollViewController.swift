//
//  TruckDetailsViewControllerWithScroll.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class TruckDetailsScrollViewController : ScheduleAwareViewController {
    
    
    @IBOutlet weak var theTitle: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var address: UILabel!
    var prevViewController: UIViewController?
    var previousViewControllerName:String = ""
    var scheduleToTableSegueID : String = "ScheduleToTableSegue"
    var scheduleToMapSegueID : String = "ScheduleToMapSegue"
    var inputLabel:String = ""
    
    @IBOutlet weak var anotherLabel: UILabel!
    @IBAction func backButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("ScheduleToMainSegue", sender: nil)
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
        renderView()
    }
    
    func renderView() {
        // TODO: nil checking
        var schedule:[String: AnyObject] = Schedules.schedules[self.scheduleId]!
        theTitle.text = schedule["name"] as? String
        startTime.text = schedule["start_time"] as? String
        endTime.text = schedule["end_time"] as? String
        address.text = schedule["address"] as? String
        date.text = schedule["date"] as? String
        
        var truckId:String? = schedule["truck_id"] as? String
        if let theImage: Image = Images.truckImages[truckId!] {
            image?.image =  theImage.image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}