//
//  TruckPageViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class TruckDetailsViewController: UIViewController {

    @IBOutlet weak var truckName: UILabel!
    
    var prevViewController: UIViewController?
    
    func setTitle() {
        
    }
    
    func setPrevViewController(prev: UIViewController) {
        self.prevViewController = prev
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("who is my previous controller \(self.prevViewController)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
