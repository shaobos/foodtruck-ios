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

    
    func initializeControllers(segue: UIStoryboardSegue) -> UIViewController {
        if segue.identifier == tableViewSegue {
            if tableViewController == nil {
                self.tableViewController = segue.destinationViewController as! UIViewController
            }
            
            return tableViewController
        }
        
        // this will prevent the map view from being rendered every time!
        if segue.identifier == mapViewSegue {
            if mapViewController == nil {
                self.mapViewController = segue.destinationViewController as! UIViewController
            }
            
            return mapViewController
        }
        
        if segue.identifier == aboutViewSegue {
            
            if aboutViewController == nil {
                self.aboutViewController = segue.destinationViewController as! UIViewController
            }
            return aboutViewController
        }
        
        if segue.identifier == trucksViewSegue {
            if trucksViewController == nil {
                self.trucksViewController = segue.destinationViewController as! UIViewController
            }
            
            return trucksViewController
        }
        
        return trucksViewController
    }
    
    func initializeViewDrawing(segue: UIStoryboardSegue) {
        print("no child view controller was loaded before. loading..")
        
        var defaultViewController:UIViewController = segue.destinationViewController as! UIViewController
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
        var destViewController = initializeControllers(segue)
        // tableView is set to the default view in viewDidLoad() so all init code go here
        if (self.childViewControllers.count == 0) {
            initializeViewDrawing(segue)
            return
        }
        
        var parent = self.parentViewController as! ViewController
        
        if let filterViewController = destViewController as? FilterProtocol {
            filterViewController.setCategoryFilter(parent.currentCategoryFilter)
            filterViewController.setDateFilter(parent.currentDateFilter)
        }

        self.swapFromViewController(currentController!, to: destViewController)
    }
    
    func swapFromViewController(from:UIViewController, to:UIViewController) {
        if (from == to) {
            print("Same controller. do not switch")
            return
        }
        
        from.willMoveToParentViewController(nil)
        self.addChildViewController(to)
        currentController = to
        
        self.transitionFromViewController(from, toViewController: to, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {
            (finished:Bool) -> Void in
            print("Finish transition between view controllers")
        })
    }
    
    func switchToController(targetSegue:String) {
        self.performSegueWithIdentifier(targetSegue, sender: nil)
    }
}
            