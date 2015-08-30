//
//  TableViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/8/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit


/**
    Table view needs to support two use cases:
    1. when it displays schdules from all available trucks, and embedded into main view controller
    1. when it displays schdules from a specific truck, and embedded into truck detail view controller
*/
class TableViewController: UIViewController, UITableViewDelegate, FilterProtocol {
    @IBOutlet weak var theTableView: UITableView!
    
    // TableViewController will be embedded into the following controllers
    var truckDetailViewController:TruckDetailViewController?
    var containerViewController:ContainerViewController?
    
    var cellContent:[String: [String: AnyObject]] = [:]
    var scheduleFetcher = ScheduleFetcher()
    var trucks = TruckFetcher()
    var imageFetcher = ImageFetcher()
    var currentDateFilter = ""
    var currentCategoryFilter = ""
    var truckId:String? // used when called from truckd detail view
    
    var shouldRefresh = false
    var parentController:UIViewController? // indicate where the table view controller is embedded
    
    // TODO: duplicate code in Map view
    // TODO: empty checking upon using
    var currentScheduleId : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: better to intialize data fetch in main view controller
        
        println(" ** viewDidload")
        if (truckId != nil) {
            // Dangerous: this is not atomic.
            self.cellContent = self.scheduleFetcher.getSchedulesByTruck(truckId!)
            self.theTableView.reloadData()
        } else {
            fetchSchedules()
        }
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        println(" ** didMoveToParentViewController")

        super.didMoveToParentViewController(parent)
        // only needs to initialize once. once you know your parent, you know!!
        
        if parent is ContainerViewController {
            if containerViewController == nil {
                println("Initilizing..")
                containerViewController = parent as? ContainerViewController
                println(containerViewController)
            }
            parentController = containerViewController
            shouldRefresh = true
            println("Table moved to container")
        } else if parent is TruckDetailViewController {
            truckDetailViewController = parent as? TruckDetailViewController
            println("Table moved to truck details")
            parentController = truckDetailViewController


        } else {
            shouldRefresh = true
            println("Unrecognized parent from TableViewController: \(parent)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        println(" ** viewDidAppear")

        println("\(currentDateFilter) \(currentCategoryFilter)")
        // it should only refresh when the table view is moved into container view
        if (shouldRefresh) {
            refreshTable()
            shouldRefresh = false
        } else {
            println("Do not refresh table view as it's shown in truck detail view")
        }
    }
    
    func truckId(truckId: String) {
        self.truckId = truckId
    }
    

    
    func setDateFilter(date:String) {
        currentDateFilter = date
    }
    func setCategoryFilter(category:String) {
        currentCategoryFilter = category
    }
    
    func refreshTable() {
        println("Table-refreshMap() current filter state \(currentDateFilter) \(currentCategoryFilter)")

        cellContent = FilterImpl.filterSchedulesByCategoryAndDate(currentCategoryFilter, dateInput: currentDateFilter)
        theTableView.reloadData()
    }
    
    func refreshByDate(date:String) {
        currentDateFilter = date
        refreshTable()
    }
    
    func refreshByCategory(category:String) {
        currentCategoryFilter = category
        refreshTable()
    }
    
    func fetchSchedules() {
        var dates:[String] = Date.getScheduleDates()

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
        var customCell : TableCellCustomView = tableView.dequeueReusableCellWithIdentifier("TableCellCustomView") as! TableCellCustomView
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
        
        if let p = parentController {
            if p is ContainerViewController {
                if let c = containerViewController {
                    if (c.mapViewController == nil) {

                        c.switchToController("mapViewSegue")
                        var mapViewController = c.mapViewController as! MapViewController

                        mapViewController.scheduleId(self.currentScheduleId)
                    } else {
                        var mapViewController = c.mapViewController as! MapViewController

                        mapViewController.scheduleId(self.currentScheduleId)
                        c.switchToController("mapViewSegue")
                    }
                }
            } else if p is TruckDetailViewController {
            
                println("no this is not working so far")
                
                
            }
        } else {
            println("WARN: parent controller of table view controller has not been detected")
        }


    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath = self.theTableView.indexPathForSelectedRow()!//indexPathForSelectedRow
        var destViewController = segue.destinationViewController as! ScheduleAwareViewController
        // both TruckDetailsView and MapView can implement the same interface
        destViewController.scheduleId(self.currentScheduleId)
    }
    

}
