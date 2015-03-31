//
//  TrucksListViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


class TrucksTableViewController : UIViewController, UITableViewDelegate{
    private let reuseIdentifier = "TruckCell"
    private var currentTruckId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getTruckByIndexPath(indexPath: NSIndexPath) -> [String:String] {
        var truck = (Array(TheTrucks.trucks.values)[indexPath.row])
        return truck
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var customCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as TruckTableCellCustomView

        var truck = getTruckByIndexPath(indexPath)
        var id = truck["id"] as String!
        if let theImage: Image = Images.truckImages[id] {
            customCell.truckImage.image =  theImage.image
        }
        return customCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var truck = getTruckByIndexPath(indexPath)
        currentTruckId = truck["id"]
        performSegueWithIdentifier("TruckTableToDetail", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var controller:TruckDetailsScrollViewController = segue.destinationViewController as TruckDetailsScrollViewController
        controller.setTruckId(currentTruckId!)
        // TODO: revisit shortly
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TheTrucks.trucks.count
    }
}