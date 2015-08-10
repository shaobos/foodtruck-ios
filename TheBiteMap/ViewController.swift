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
    var lastFilter:String = "date"
    var scheduleFetcher = ScheduleFetcher()
    var dates = [String]()
    // convert set to array http://stackoverflow.com/a/29046827/677596
    var categories:[String] = []
    var menuViewState = false
    
    @IBOutlet weak var dateFilterButton: UIButton!
    @IBOutlet weak var categoryFilterButton: UIButton!
    @IBOutlet var containerViewController: ContainerViewController!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var filterView: UIView!

    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var menuView: UIView!
    @IBAction func filterDoneButtonPressed(sender: AnyObject) {
        filterView.hidden = true
    }

    @IBAction func scheduleButtonPressed(sender: AnyObject) {
        menuView.hidden = !menuView.hidden
        searchButton.enabled = true


    }

    @IBAction func mapButtonPressed(sender: AnyObject) {
        
        containerViewController.switchToController("mapViewSegue")
        dateFilterButton.hidden = false

        menuView.hidden = true
        searchButton.enabled = true


    }
    @IBAction func listButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("tableViewSegue")
        dateFilterButton.hidden = false
        menuView.hidden = true
        searchButton.enabled = true

    }

    @IBAction func aboutBarButtonPressed(sender: AnyObject) {
        searchButton.enabled = false

        containerViewController.switchToController("aboutViewSegue")
        

    }
    @IBAction func truckBarButtonPressed(sender: AnyObject) {
        dateFilterButton.hidden = true
        searchButton.enabled = true

        loadCategoryPicker()
        containerViewController.switchToController("trucksViewSegue")
        // it only has category


    }

    @IBAction func scheduleIconButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("tableViewSegue")

    }

    @IBAction func mapIconButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("mapViewSegue")
    }
    @IBAction func searchButtonAction(sender: AnyObject) {
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
        dates = Date.getScheduleDates()
        categories = sorted(Array(Trucks.categories))
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
                dateFilterState = true
                filterViewController.refreshByDate(dates[row])
                currentDateFilter = dates[row]
                
            } else if (lastFilter == "category") {
                categoryFilterState = true
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
        loadCategoryPicker()
    }
    
    func loadCategoryPicker() {
        lastFilter = "category"
        categories = sorted(Array(Trucks.categories))
        picker.reloadAllComponents()
        super.view.bringSubviewToFront(picker)
    }
}

