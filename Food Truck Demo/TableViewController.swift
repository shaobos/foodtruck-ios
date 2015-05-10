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
    
    var containerViewController:ContainerViewController?
    var cellContent:[String: [String: AnyObject]] = [:]
    var scheduleFetcher = ScheduleFetcher()
    var trucks = TruckFetcher()
    var imageFetcher = ImageFetcher()
    
    var truckId:String? // could be called from truckd detail view
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        if containerViewController == nil {
            containerViewController = parent as? ContainerViewController
        }
    }
    func setTruckId(truckId: String) {
        self.truckId = truckId
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: better to intialize data fetch in main view controller
        
        if (truckId != nil) {
            // Dangerous: this is not atomic.
            self.cellContent = self.scheduleFetcher.getSchedulesByTruck(truckId!)
            self.theTableView.reloadData()
        } else {
            fetchSchedules()
        }
    }
    
    func refreshByDate(date:String) {
        self.cellContent = self.scheduleFetcher.getSchedulesBydate(date)
        self.theTableView.reloadData()
    }
    
    func fetchSchedules() {
        
        var dates:[String] = self.scheduleFetcher.getScheduleDates()

        if Schedules.schedules.count > 0 {
            self.cellContent = self.scheduleFetcher.getSchedulesBydate(dates[0])
            if Images.truckImages.count > 0 {
                self.theTableView.reloadData()
            } else {
                self.imageFetcher.fetchImages {
                    self.theTableView.reloadData()
                }
            }
        } else {
            trucks.fetchTrucksInfoFromRemote {
                loadedImages in
                self.scheduleFetcher.fetchSchedules() {
                    // initialize schedules with the first day of 7 days
                    if (dates.count > 0) {
                        println("Initilize table view with date \(dates[0])")
                        //refreshByDate(dates[0])
                        self.cellContent = self.scheduleFetcher.getSchedulesBydate(dates[0])

                    } else {
                        println("Cannot initialize table view with the first day. Date info is not available yet")
                    }
                    self.theTableView.reloadData()
                    self.imageFetcher.fetchImages {
                        self.theTableView.reloadData()
                    }
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

    /*
        what happens when table row is selected
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentScheduleId = Array(cellContent.keys)[indexPath.row] as String
        if let c = containerViewController {
            println("** boom")
            c.switchToController("mapViewSegue")
            c.mapViewController.setScheduleId(self.currentScheduleId)
        }
    }
    
    // TODO: duplicate code in Map view
    // TODO: empty checking upon using
    var currentScheduleId : String = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath = self.theTableView.indexPathForSelectedRow()!//indexPathForSelectedRow
        var destViewController = segue.destinationViewController as ScheduleAwareViewController
        // both TruckDetailsView and MapView can implement the same interface
        destViewController.setScheduleId(self.currentScheduleId)
    }
}
