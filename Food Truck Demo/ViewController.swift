//
//  ViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: DropdownMenuController {

    @IBOutlet var containerViewController: ContainerViewController!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func dateButtonAction(sender: AnyObject) {
        
        picker.hidden = !picker.hidden
        super.view.bringSubviewToFront(picker)
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
        super.viewDidLoad()
        println(super.menuButton)
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
    
    
    var colors = ["3/1","3/2","3/3","3/4"]

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return colors[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("this guy selected \(colors[row])")
    }
    
}

