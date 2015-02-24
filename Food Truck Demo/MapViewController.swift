//
//  MapViewController.swift
//  Food Truck Demo
//
//  Created by Shaobo Sun on 2/7/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate {

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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        // 37.424436, -122.070587
        
        
        var latitute:CLLocationDegrees = 37.393315
        var longitute : CLLocationDegrees = -122.061475
        
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitute, longitute)
        
        setRegion(latitute, longitute: longitute)
        addAnnotation(newCoordinate, title: "Linkedin Headquarter", subtitle: "The food here is good")
        
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinate
        annotation.title = "hey"
        annotation.subtitle = "it's good"
        
        mapView.addAnnotation(annotation)
        
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: ScheduleDetailsViewController = segue.destinationViewController as ScheduleDetailsViewController
        destViewController.setPrevViewController(self)
        destViewController.setTitle("hey")
        
        
    }
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        performSegueWithIdentifier("MapToDetailSegue", sender: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        
        pinAnnotationView.pinColor = .Purple
        pinAnnotationView.draggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = true
        
        let deleteButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
        deleteButton.backgroundColor = UIColor.redColor()
        //            deleteButton.titleLabel?.text = "Click me"
        
        pinAnnotationView.leftCalloutAccessoryView = deleteButton
        
        return pinAnnotationView
        
    }
    

    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("hello")
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, #title:String, #subtitle: String) {
        // set annotation
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        
        println("going to add annotation")
        
        mapView.addAnnotation(annotation)
        
    }

    
    func setRegion(latitute:CLLocationDegrees, longitute:CLLocationDegrees) {
        // how many degrees it would zoom out by default, 1 would be a lot
        var latDelta:CLLocationDegrees = 1
        var lonDelta:CLLocationDegrees = 1
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitute, longitute)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
    }


}
