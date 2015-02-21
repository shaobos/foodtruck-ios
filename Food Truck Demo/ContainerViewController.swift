//
//  ContainerViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var mapViewController: UIViewController!
    @IBOutlet weak var tableViewController: UIViewController!
    var transitionInProgress: Bool = false
    var mapViewSegue: String = "mapViewSegue"
    var tableViewSegue: String = "tableViewSegue"
    var currentSegueIdentifier: String = ""
    
//    var transitionInProgress: Boolean
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionInProgress = false
        self.currentSegueIdentifier = self.tableViewSegue // table goes first!
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
        println("I'm loaded, I am container view controller")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("ContainerViewController -> prepareForSegue")
        if (segue.identifier == "tableViewSegue") {
            self.tableViewController = segue.destinationViewController as UIViewController
        }
        
        if (segue.identifier == "mapViewSegue") {
            self.mapViewController = segue.destinationViewController as UIViewController
        }
        println(segue.identifier! + " is the current segue")
        println("loaded table/map view controller")
        if (segue.identifier == "tableViewSegue") {

            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(self.childViewControllers[0] as UIViewController, to: self.tableViewController)
            } else {
                println("no child view controller was loaded before. loading..")
                self.addChildViewController(segue.destinationViewController as UIViewController)
                var destView:UIView = (segue.destinationViewController as UIViewController).view
                println("found destView")
                destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                destView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                self.view.addSubview(destView)
                segue.destinationViewController.didMoveToParentViewController(self)
            
            }
        } else if (segue.identifier == "mapViewSegue") {
//            if (self.childViewControllers.count <= 1) {
//                println("no map child view controller was loaded before. loading..")
//                self.addChildViewController(segue.destinationViewController as UIViewController)
//                var destView:UIView = (segue.destinationViewController as UIViewController).view
//                println("found map destView")
//                destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//                destView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//                self.view.addSubview(destView)
//                segue.destinationViewController.didMoveToParentViewController(self)
//                
//            }
            println("Going to swap table view controller with map view controller")
            self.swapFromViewController(self.childViewControllers[0] as UIViewController, to: self.mapViewController)
        } else {
            println("Unknown segue detected")
        }
    }
    
    func swapFromViewController(from:UIViewController, to:UIViewController) {
        to.view.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        from.willMoveToParentViewController(nil)
        self.addChildViewController(to)
        //from.removeFromParentViewController()
        
        
        println("Going to transitionFromViewController: " + from.description)
        self.transitionFromViewController(from, toViewController: to, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {
            (finished:Bool) -> Void in
            println("transitionFromViewController")
            //from.removeFromParentViewController()
            
            to.didMoveToParentViewController(self)
            self.transitionInProgress = false
        })
    }

    func swapViewControllers() {
        var from:UIViewController
        var to:UIViewController
        
        
        if (self.transitionInProgress) {
            return;
        }

        self.transitionInProgress = true
        println("**Before ----> swapViewControllers " +  currentSegueIdentifier)

        self.currentSegueIdentifier = self.currentSegueIdentifier == self.tableViewSegue ? self.mapViewSegue : self.tableViewSegue
        
        println("**After ----> swapViewControllers " +  currentSegueIdentifier)

        if (self.currentSegueIdentifier == self.mapViewSegue && self.mapViewController != nil) {
            from = self.tableViewController
            to = self.mapViewController
            self.swapFromViewController(from, to: to)
            return

        } else if (self.currentSegueIdentifier == self.tableViewSegue && self.tableViewController != nil)   {
            from = mapViewController
            to = tableViewController
            self.swapFromViewController(from, to: to)

            return
        }
        
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
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
