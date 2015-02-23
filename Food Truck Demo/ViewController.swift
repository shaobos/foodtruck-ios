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
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSgue")
        if (segue.identifier == "embedSegue") {
            containerViewController = segue.destinationViewController as ContainerViewController
        }
    }

    override func showMenu() {
        super.showMenu()
        super.view.bringSubviewToFront(super.menu)
    }
    
    @IBAction func ButtonPressed(sender: AnyObject) {
        println("Button pressed. Swapping child view..")
        containerViewController.swapViewControllers()
    }
}

