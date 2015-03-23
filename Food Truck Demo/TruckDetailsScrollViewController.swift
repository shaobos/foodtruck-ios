//
//  TruckDetailsViewControllerWithScroll.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class TruckDetailsScrollViewController : TruckAwareViewController {
    
    @IBOutlet weak var theTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var imageFetcher = ImageFetcher()

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
        
        imageFetcher.fetchImageByTruckId(self.truckId)
        renderView()
    }
    
    func renderView() {
        // TODO: nil checking
        //var truckId = Schedules.getTruckIdByScheduleId(self.scheduleId)
        if let truck = TheTrucks.trucks[self.truckId!] {
            theTitle.text = truck["name"]
            if let theImage: Image = Images.truckImages[self.truckId!] {
                image?.image =  theImage.image
            }
        }
        
//        startTime.text = schedule["start_time"] as? String
//        endTime.text = schedule["end_time"] as? String
//        address.text = schedule["address"] as? String
//        date.text = schedule["date"] as? String
//        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}