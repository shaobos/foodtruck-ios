//
//  ViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: DropdownMenuController {

    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet var containerViewController: ContainerViewController!
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSgue")
        if (segue.identifier == "embedSegue") {
            println("embedSegue")
            containerViewController = segue.destinationViewController as ContainerViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println("View controller loaded")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("view did appear")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func menuButtonAction(sender: UIButton!) {
        println("i fucked up")
        super.menuButtonAction(sender)
        
    }
    
    func customizeMenu() {
        
       // for (button: Button in self.buttons) {
            
       // }
    }

    @IBAction func ButtonPressed(sender: AnyObject) {
        println("Button pressed. Swapping child view..")
        containerViewController.swapViewControllers()
        //println(containerViewController.description)
//        containerViewController.
    }
}

