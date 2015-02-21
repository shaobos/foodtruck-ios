//
//  DropdownViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/11/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class DropdownViewController: DropdownMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("GridView Loaded!")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeMenu() {
        println("customizeMenu!")
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
