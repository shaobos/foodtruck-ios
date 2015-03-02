//
//  TableViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/8/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var theTableView: UITableView!
    var cellContent:[[String: AnyObject]] = []
    var scheduleFetcher = ScheduleFetcher()
    var trucks = Trucks()
    var imageFetcher = ImageFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: better to intialize data fetch in main view controller
        trucks.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchTrucksInfoFromRemote() {
                println("Schedules are ready")
                self.cellContent = self.scheduleFetcher.getSchedules()
                self.theTableView.reloadData()
                self.imageFetcher.fetchImages {
                    println("imageFetch is done")
                    self.theTableView.reloadData()
                    println("refreshed table view")

                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // dynamically define how many rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    // define the content of each individual cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var customCell : TableCellCustomView = tableView.dequeueReusableCellWithIdentifier("TableCellCustomView") as TableCellCustomView

        var schedule = cellContent[indexPath.row] as [String: AnyObject]
        customCell.truckName.text = schedule["name"] as? String

//        customCell.address.text = schedule["short_address"] as? String
        customCell.startTime.text = schedule["start_time"] as? String
        customCell.endTime.text = schedule["end_time"] as? String
        customCell.city.text = schedule["address"] as? String
        customCell.date.text = schedule["date"] as? String


        var truckId:String? = schedule["truck_id"] as? String
        
        if let theImage: Image = Images.truckImages[truckId!] {
            
            customCell.truckImage?.image =  theImage.image
        }
        
        
        return customCell
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ToTruckDetailSegue", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath = self.theTableView.indexPathForSelectedRow()!//indexPathForSelectedRow
        var destViewController : ScheduleDetailsViewController = segue.destinationViewController as ScheduleDetailsViewController
        destViewController.setPrevViewController("Table!")
    }
}
