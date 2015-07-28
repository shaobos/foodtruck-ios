//
//  ViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: DropdownMenuController {
    
    var lastFilter:String = ""
    var scheduleFetcher = ScheduleFetcher()
    func getDates() -> [String]{
        return dates
    }
    
    var dates = [String]()
    // convert set to array http://stackoverflow.com/a/29046827/677596
    var categories:[String] = []
    @IBOutlet var containerViewController: ContainerViewController!
    @IBOutlet weak var picker: UIPickerView!


    @IBAction func aboutBarButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("aboutViewSegue")

    }
    @IBAction func truckBarButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("trucksViewSegue")

    }

    @IBAction func scheduleIconButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("tableViewSegue")

    }

    @IBAction func mapIconButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("mapViewSegue")
    }
    @IBAction func categoryButtonAction(sender: AnyObject) {
        println("category button boom!")
        lastFilter = "category"
        categories = Array(Trucks.categories)
        println(categories)
        picker.hidden = !picker.hidden
        picker.reloadAllComponents()
        super.view.bringSubviewToFront(picker)
    }
    
    @IBAction func dateButtonAction(sender: AnyObject) {
        lastFilter = "date"
        picker.hidden = !picker.hidden
        picker.reloadAllComponents()
        super.view.bringSubviewToFront(picker)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "embedSegue") {
            containerViewController = segue.destinationViewController as! ContainerViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dates = scheduleFetcher.getScheduleDates()
        categories = Array(Trucks.categories)
    }

    // needs to override showMenu to add bringSubviewToFront
    // otherwise container view will appear above menu view
    override func showMenu() {
        super.showMenu()
        super.view.bringSubviewToFront(super.menu)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (lastFilter == "date") {
            return dates.count
        } else if (lastFilter == "category") {
            return categories.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        println("lastFilter \(lastFilter)")
        println("categories \(categories)")
        if (lastFilter == "date") {
            return dates[row]
        } else if (lastFilter == "category") {
            return categories[row]
        } else {
            return "Invalid"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Schedules.getSchedulesWithFilter()
        
        if let filterViewController = containerViewController.currentController as? FilterProtocol {
            if (lastFilter == "date") {
                filterViewController.refreshByDate(dates[row])
            } else if (lastFilter == "category") {
                filterViewController.refreshByCategory(categories[row])
            }
        } else {
            println("\(containerViewController.currentController) does not conform to FilterProtocol")
        }

        pickerView.hidden = true
    }
    
}

