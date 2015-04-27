//
//  ViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: DropdownMenuController {
    
    var scheduleFetcher = ScheduleFetcher()
    func getDates() -> [String]{
        return dates
    }
    
    var dates = [String]()
    @IBOutlet var containerViewController: ContainerViewController!
    @IBOutlet weak var picker: UIPickerView!
    @IBAction func aboutButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("aboutViewSegue")
        hideMenu()
    }
    @IBAction func trucksButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("trucksViewSegue")
        hideMenu()
    }
    @IBAction func schedulesButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("tableViewSegue")
        hideMenu()
    }
    @IBAction func dateButtonAction(sender: AnyObject) {
        
        picker.hidden = !picker.hidden
        super.view.bringSubviewToFront(picker)
    }
    @IBAction func mapsButtonPressed(sender: AnyObject) {
        containerViewController.switchToController("mapViewSegue")
        hideMenu()
    }
    
    @IBAction func categoryButtonAction(sender: AnyObject) {
        picker.hidden = !picker.hidden
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "embedSegue") {
            containerViewController = segue.destinationViewController as ContainerViewController
        }
    }
    
    override func viewDidLoad() {
        println("before super.viewDidLoad()")
        super.viewDidLoad()
        println("view controller loaded")
        dates = scheduleFetcher.getScheduleDates()
        //dates = ["2015-03-01", "2015-03-02", "2015-03-03"]
    }

    // needs to override showMenu to add bringSubviewToFront
    // otherwise container view will appear above menu view
    override func showMenu() {
        super.showMenu()
        super.view.bringSubviewToFront(super.menu)
    }
    
    @IBAction func ButtonPressed(sender: AnyObject) {
        println("Button pressed. Swapping child view..")
        containerViewController.swapViewControllers()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dates.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return dates[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Schedules.getSchedulesWithFilter()
        
        if let table = containerViewController.currentController as? TableViewController {
            table.refreshByDate(dates[row])
        } else if let map = containerViewController.currentController as? MapViewController {
            // TODO: wait until "unexpectedly found nil" is fixed
            map.refreshByDate(dates[row])
            
        }
        pickerView.hidden = true
    }
    
}

