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

class MapViewController: ScheduleAwareViewController, MKMapViewDelegate {

    var scheduleFetcher = ScheduleFetcher()
    var trucks = Trucks()
    var imageFetcher = ImageFetcher()
    // TODO: a dirty solution to pass around schedule id
    var currentScheduleId : String = ""
    @IBOutlet weak var mapView: MKMapView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        trucks.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchTrucksInfoFromRemote() {
                println("Schedules are ready")
                // TODO: should be able to decide the region more intelligently
                // TODO: refactor the craps here
//                var latitute:CLLocationDegrees = 37.393315
//                var longitute:CLLocationDegrees = -122.061475
                var schedules = self.scheduleFetcher.getSchedules()
                
               // for scheduleId in schedules.keys {
                    var schedule:[String: AnyObject] = schedules[self.scheduleId]!
                    self.createAnnotations(self.scheduleId, singleScheduleObject: schedule)
               // }
            }
        }
    }
    
    
    
    func createAnnotations(scheduleId: String, singleScheduleObject schedule: [String: AnyObject]) {
        
        println("scheduleId is \(scheduleId)")
        
        var lat:CLLocationDegrees = (schedule["lat"] as NSString).doubleValue
        var lon:CLLocationDegrees = (schedule["lng"] as NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = schedule["name"] as String
        annotation.subtitle = schedule["date"] as String
        annotation.truckId = schedule["truck_id"] as String
        annotation.scheduleId = scheduleId
        
        println("1. \(annotation.scheduleId)")
        self.setRegion(lat, longitute: lon)

        self.mapView.addAnnotation(annotation)
    }

    /*
        tell schedule detail view what should be prepared for dinner today
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: TruckDetailsScrollViewController = segue.destinationViewController as TruckDetailsScrollViewController
        //destViewController.setPrevViewController("Map!")
        var truckId = Schedules.getTruckIdByScheduleId(self.scheduleId)
        destViewController.setTruckId(truckId!)
    }
    
    
    
    /*
        customize annotation view
    
        By this point, all data should be available in memory so we can read directly
    */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var foodTruckAnnotation = annotation as FoodTruckMapAnnotation
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        
        pinAnnotationView.pinColor = .Purple
        pinAnnotationView.draggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = false
        
        let deleteButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
        var scheduleId: String  = foodTruckAnnotation.truckId
        
        if let theImage: Image = Images.truckImages[scheduleId] {
            println("image retrieved: \(theImage.image)")
            deleteButton.setBackgroundImage(theImage.image, forState: UIControlState.Normal)
        }
        
        pinAnnotationView.leftCalloutAccessoryView = deleteButton

        return pinAnnotationView
    }

    /*
        this function customizes what happens when button in left callout accessory view is clicked..
    */
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {

        var foodTruckAnnotation = view.annotation as FoodTruckMapAnnotation
        self.currentScheduleId = foodTruckAnnotation.scheduleId
        performSegueWithIdentifier("MapToDetailSegue", sender: nil)
        // this is the last stop where we can still access annotation
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
