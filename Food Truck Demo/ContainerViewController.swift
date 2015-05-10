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

    var mapViewSegue: String = "mapViewSegue"
    var tableViewSegue: String = "tableViewSegue"
    var aboutViewSegue: String = "aboutViewSegue"
    var trucksViewSegue: String = "trucksViewSegue"
    var currentController: UIViewController?
    var currentSegueIdentifier: String = ""
    var renderedViews = [String:UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if (segue.identifier == tableViewSegue && tableViewController == nil) {
            self.tableViewController = segue.destinationViewController as UIViewController
        }
        
        // this will prevent the map view from being rendered every time!
        if (segue.identifier == mapViewSegue && mapViewController == nil) {
            self.mapViewController = segue.destinationViewController as MapViewController
        }
        
        if (segue.identifier == aboutViewSegue && aboutViewController == nil) {
            self.aboutViewController = segue.destinationViewController as UIViewController
        }
        
        if (segue.identifier == trucksViewSegue && trucksViewController == nil) {
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
        if (self.childViewControllers.count == 0) {
            initializeViewDrawing(segue)
            return
        }

        if (segue.identifier == tableViewSegue) {
            self.swapFromViewController(currentController!, to: tableViewController)
        } else if (segue.identifier == mapViewSegue) {
            self.swapFromViewController(currentController!, to: mapViewController)
        } else if (segue.identifier == aboutViewSegue) {
            self.swapFromViewController(currentController!, to: aboutViewController)
        } else if (segue.identifier == trucksViewSegue) {
            self.swapFromViewController(currentController!, to: trucksViewController)
        } else {
            println("Unknown segue detected")
        }
    }
    
    func swapFromViewController(from:UIViewController, to:UIViewController) {
        if (from == to) {
            println("Same controller. do not switch")
            return
        }
        
        from.willMoveToParentViewController(nil)
        self.addChildViewController(to)
        currentController = to
        
        self.transitionFromViewController(from, toViewController: to, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {
            (finished:Bool) -> Void in
            println("Finish transition between view controllers")
        })
    }
    
    func switchToController(targetSegue:String) {
        self.performSegueWithIdentifier(targetSegue, sender: nil)
    }
}
            