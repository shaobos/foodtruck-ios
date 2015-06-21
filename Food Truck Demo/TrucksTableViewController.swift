//
//  TrucksListViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


// need uppercase function for String
// http://stackoverflow.com/q/26245645/677596
import Foundation

class TrucksTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
//    private let titlesBySection = ["A" : ["Ac", "Ad"], "B": ["bc"], "C": ["cc"]]
//    private let sections = ["A", "B", "C"]
    private let reuseIdentifier = "TruckCell"
    private var trucksIndexedByInitial = [String: [String]]()
    private var trucksSectionHeader = [String]()

    
    private var currentTruckId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        convertTruckData(Trucks.trucks)
    }

    func getTruckByIndexPath(indexPath: NSIndexPath) -> [String:String] {
        var truck = (Array(Trucks.trucks.values)[indexPath.row])
        return truck
    }
    
    func convertTruckData(input: [String:[String: String]]) {
        for truck in input.values {
            var name:String = truck["name"]!
            var truckId:String = truck["id"]!
            var index = advance(name.startIndex, 0)
            var firstCharacter = String(name[index]) // character to string here to avoid annoying conversion
            if trucksIndexedByInitial[firstCharacter] == nil {
                trucksIndexedByInitial[firstCharacter] = [String]()
            }
            trucksIndexedByInitial[firstCharacter]!.insert(truckId, atIndex: 0)
        }
        
        for character in Array(trucksIndexedByInitial.keys).sorted(<) {
            
            trucksSectionHeader.append(String(character))
        }
    }
    
    /*
        how does each cell look like
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var customCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! TruckTableCellCustomView
        var header = trucksSectionHeader[indexPath.section]
        var trucks = trucksIndexedByInitial[header]
        var id = trucks![indexPath.row]
        var truck = Trucks.trucks[id]!
        if let theImage: Image = Images.truckImages[id] {
            customCell.truckImage.image =  theImage.image
        }
        customCell.name.text = truck["name"] ?? "Truck name not found"
        customCell.category.text = truck["category"] ?? "Category not found"
        return customCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var truck = getTruckByIndexPath(indexPath)
        var header = trucksSectionHeader[indexPath.section]
        var trucks = trucksIndexedByInitial[header]
        currentTruckId = trucks![indexPath.row]

        performSegueWithIdentifier("TruckTableToDetail", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var controller:TruckDetailViewController = segue.destinationViewController as! TruckDetailViewController
        controller.truckId(currentTruckId!)
        // TODO: revisit shortly
    }

    /*
        Number Of Rows In Section
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle = trucksSectionHeader[section]
        return trucksIndexedByInitial[sectionTitle]!.count
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        var i:Int = 0
        println(index)
        for head in trucksSectionHeader {
            if head == title {
                println("Found the title!")
                return i
            }
            i++
        }
        return 0
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return trucksSectionHeader
    }
    /*
        decide how many sections
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return trucksSectionHeader.count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trucksSectionHeader[section]
    }
    
    
}