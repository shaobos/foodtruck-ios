//
//  ContainerViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var mapViewController: MapViewController!
    @IBOutlet weak var tableViewController: UIViewController!
    @IBOutlet weak var aboutViewController: UIViewController!
    @IBOutlet weak var trucksViewController: UIViewController!


    var transitionInProgress: Bool = false
    var mapViewSegue: String = "mapViewSegue"
    var tableViewSegue: String = "tableViewSegue"
    var aboutViewSegue: String = "aboutViewSegue"
    var trucksViewSegue: String = "trucksViewSegue"
    var currentController: UIViewController?
    var currentSegueIdentifier: String = ""
    var renderedViews = [String:UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionInProgress = false
        self.currentSegueIdentifier = self.tableViewSegue // table goes first!
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    func initializeControllers(segue: UIStoryboardSegue) {
        if (segue.identifier == tableViewSegue) {
            self.tableViewController = segue.destinationViewController as UIViewController
        }
        
        // this will prevent the map view from being rendered every time!
        if (segue.identifier == mapViewSegue && mapViewController == nil) {
            println("***** only set it intially*****")
            self.mapViewController = segue.destinationViewController as MapViewController
        }
        
        if (segue.identifier == aboutViewSegue) {
            self.aboutViewController = segue.destinationViewController as UIViewController
        }
        
        if (segue.identifier == trucksViewSegue) {
            self.trucksViewController = segue.destinationViewController as UIViewController
        }
    }
    
    func initializeViewDrawing(segue: UIStoryboardSegue) {
        println("no child view controller was loaded before. loading..")
        
        var defaultViewController:UIViewController = segue.destinationViewController as UIViewController
        currentController = defaultViewController
        self.addChildViewController(defaultViewController)
        var destView:UIView = defaultViewController.view
        destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(destView)
        defaultViewController.didMoveToParentViewController(self)
    }
    
    // prepareForSegue goes before viewDidLoad()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        initializeControllers(segue)
        // tableView is set to the default view in viewDidLoad() so all init code go here
        if (segue.identifier == tableViewSegue) {
            
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(currentController!, to: tableViewController)
            } else {
                initializeViewDrawing(segue)
            }
        } else if (segue.identifier == mapViewSegue) {
            
//            if let val = renderedViews["mapView"] {
//                println("### reuse")
//                self.swapFromViewController(currentController!, to: val)
                // now val is not nil and the Optional has been unwrapped, so use it
//            } else {
//                println("### new")
                self.swapFromViewController(currentController!, to: mapViewController)
//                renderedViews["mapView"] = mapViewController

                
            
        } else if (segue.identifier == aboutViewSegue) {
            self.swapFromViewController(currentController!, to: aboutViewController)
        } else if (segue.identifier == trucksViewSegue) {
            self.swapFromViewController(currentController!, to: trucksViewController)
        } else {
            println("Unknown segue detected")
        }
    }
    
    func swapFromViewController(from:UIViewController, to:UIViewController) {
//        if let nibName = to.nibName {
//            if (contains(renderedViews, nibName)) {
//                println("\(to) has already been rendered")
//            } else {
//                println("** adding \(to.nibName)")
//                println("** adding \(to.restorationIdentifier)")
//                println("** adding \(to.title)")
//
//                // two consecutive calls of swapFromViewController would end up with different instances of "to" controller
//                // adding <foodtruck_ios.MapViewController: 0x7feefa5782d0>
//                // adding <foodtruck_ios.MapViewController: 0x7feeff50e210>
//                
//                // ** adding Optional("axC-Ml-BMx-view-4rm-RL-coS")
//                // ** adding Optional("axC-Ml-BMx-view-4rm-RL-coS")
//
//                to.view.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//                renderedViews.append(nibName)
//            }
//        }
        from.willMoveToParentViewController(nil)
        self.addChildViewController(to)
        currentController = to
        
        self.transitionFromViewController(from, toViewController: to, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {
            (finished:Bool) -> Void in
                self.transitionInProgress = false
        })
    }
    
    func switchToController(targetSegue:String) {
        self.performSegueWithIdentifier(targetSegue, sender: nil)
    }
    
    // this function is only used to switch between schedule table view and single schedule map view
    // should only be accessible in shedule view
    func swapViewControllers() {
        var from:UIViewController
        var to:UIViewController
        
        if (self.transitionInProgress) {
            return;
        }

        self.transitionInProgress = true
        self.currentSegueIdentifier = self.currentSegueIdentifier == self.tableViewSegue ? self.mapViewSegue : self.tableViewSegue
        
        if (self.currentSegueIdentifier == self.mapViewSegue && self.mapViewController != nil) {
            from = self.tableViewController
            to = self.mapViewController
            self.swapFromViewController(from, to: to)
        } else if (self.currentSegueIdentifier == self.tableViewSegue && self.tableViewController != nil)   {
            from = mapViewController
            to = tableViewController
            self.swapFromViewController(from, to: to)
        } else {
            println("Cannot perform segue changes")
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
            