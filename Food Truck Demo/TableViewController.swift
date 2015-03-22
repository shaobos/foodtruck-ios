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
    var cellContent:[String: [String: AnyObject]] = [:]
    var scheduleFetcher = ScheduleFetcher()
    var trucks = Trucks()
    var imageFetcher = ImageFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: better to intialize data fetch in main view controller
        
        trucks.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchTrucksInfoFromRemote() {
                //println("Schedules are ready")
                self.cellContent = self.scheduleFetcher.getSchedules()
                self.theTableView.reloadData()
                self.imageFetcher.fetchImages {
                    //println("imageFetch is done")
                    self.theTableView.reloadData()
                    //println("refreshed table view")
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


        var schedule = Array(cellContent.values)[indexPath.row] as [String: AnyObject]
        
        customCell.truckName.text = schedule["name"] as? String
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentScheduleId = Array(cellContent.keys)[indexPath.row] as String
        println("1. \(self.currentScheduleId)")
        performSegueWithIdentifier("tableToMapSegue", sender: nil)
    }
    
    // TODO: duplicate code in Map view
    // TODO: empty checking upon using
    var currentScheduleId : String = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath = self.theTableView.indexPathForSelectedRow()!//indexPathForSelectedRow
        var destViewController = segue.destinationViewController as ScheduleAwareViewController
        println("2. \(self.currentScheduleId)")
        //destViewController.setPrevViewController("Table!")
        // both TruckDetailsView and MapView can implement the same interface
        destViewController.setScheduleId(self.currentScheduleId)
    }
}
