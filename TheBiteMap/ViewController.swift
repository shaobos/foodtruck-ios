//
//  ViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: DropdownMenuController {
    
    var categoryFilterState = false
    var dateFilterState = false
    var currentDateFilter = ""
    var currentCategoryFilter = ""
    var lastFilter:String = ""
    var scheduleFetcher = ScheduleFetcher()
    func getDates() -> [String]{
        return dates
    }
    @IBOutlet var containerViewController: ContainerViewController!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var dateStatusButton: UIButton!
    @IBOutlet weak var categoryStatusButton: UIButton!
    @IBOutlet weak var filterView: UIView!

    @IBAction func filterDoneButtonPressed(sender: AnyObject) {
        filterView.hidden = true
    }
    var dates = [String]()
    // convert set to array http://stackoverflow.com/a/29046827/677596
    var categories:[String] = []


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
    @IBAction func searchButtonAction(sender: AnyObject) {
        lastFilter = "date"
        categories = Array(Trucks.categories)
        filterView.hidden = !filterView.hidden
        picker.reloadAllComponents()
        super.view.bringSubviewToFront(picker)
    }
    
    @IBAction func dateButtonAction(sender: AnyObject) {
        filterView.hidden = !filterView.hidden
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    // initialize container view controllers
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
        if (lastFilter == "date") {
            return dates[row]
        } else if (lastFilter == "category") {
            return categories[row]
        } else {
            return "Invalid"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let filterViewController = containerViewController.currentController as? FilterProtocol {
            if (lastFilter == "date") {
                setStatusOn(dateStatusButton)
                dateFilterState = true
                filterViewController.refreshByDate(dates[row])
                currentDateFilter = dates[row]
                
            } else if (lastFilter == "category") {
                categoryFilterState = true
                setStatusOn(categoryStatusButton)
                filterViewController.refreshByCategory(categories[row])
                currentCategoryFilter = categories[row]

            }
        } else {
            println("\(containerViewController.currentController) does not conform to FilterProtocol")
        }
    }

    

    
    @IBAction func DateSwitchButtonPressed(sender: AnyObject) {
        lastFilter = "date"
        picker.reloadAllComponents()
        super.view.bringSubviewToFront(picker)
    }
    
    @IBAction func CategorySwitchButtonPressed(sender: AnyObject) {
        lastFilter = "category"
        categories = Array(Trucks.categories)
        picker.reloadAllComponents()
        super.view.bringSubviewToFront(picker)
    }
    
    func clearFilter(targetFilter:String) {
        if let filterViewController = containerViewController.currentController as? FilterProtocol {
            if (targetFilter == "date") {
                println("Going to clear date filter...")
                dateFilterState = false
                filterViewController.clearDateFilter()
                currentDateFilter = ""
            } else if (targetFilter == "category") {
                categoryFilterState = false
                filterViewController.clearCategoryFilter()
                currentCategoryFilter = ""
            }
        }
    }
    
    @IBAction func DateStatusButtonPressed(sender: AnyObject) {
        if (dateFilterState) {
            setStatusOff(dateStatusButton)
            clearFilter("date")
        }
        
        dateFilterState = !dateFilterState
    }
    @IBAction func CategoryStatusButtonPressed(sender: AnyObject) {
        if (categoryFilterState) {
            // Turn it off
            setStatusOff(categoryStatusButton)
            clearFilter("category")
        }
        
        categoryFilterState = !categoryFilterState
    }
    
    func setStatusOff(button:UIButton) {
        let image = UIImage(named: "ImageSelectedSmallOff.png")
        button.setImage(image, forState: UIControlState.Normal)
    }
    
    func setStatusOn(button:UIButton) {
        let image = UIImage(named: "ImageSelectedSmallOn.png")
        button.setImage(image, forState: UIControlState.Normal)
    }
}

