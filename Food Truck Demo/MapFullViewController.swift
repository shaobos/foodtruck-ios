//
//  MapFullViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 4/5/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class MapFullViewController: UIViewController, MKMapViewDelegate {
    
    var scheduleFetcher = ScheduleFetcher()
    var trucks = Trucks()
    var imageFetcher = ImageFetcher()
    // TODO: a dirty solution to pass around schedule id
    var currentScheduleId : String = ""
    var previousController : String = ""
    var toTruckDetailViewSegue = "MapFullToDetailSegue"
    var annotations = [FoodTruckMapAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterAnnotationByDate(date:String) {
        if (annotations.count > 0) {
            for annotation in annotations {
                // TODO: subtitle is date, but this is confusing
                var viewForAnnotation = self.mapView.viewForAnnotation(annotation)
                if annotation.subtitle == date {
                    viewForAnnotation.hidden = false
                } else {
                    viewForAnnotation.hidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trucks.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchTrucksInfoFromRemote() {
                println("Schedules are ready")
                // TODO: extract some code from here and MapViewController
                var schedules = self.scheduleFetcher.getSchedules()
                for scheduleId in schedules.keys {
                    var schedule:[String: AnyObject] = schedules[scheduleId]!
                    var annotation = self.createAnnotations(scheduleId, singleScheduleObject: schedule)
                    self.annotations.append(annotation)
                }
            }
        }
    }

    func createAnnotations(scheduleId: String, singleScheduleObject schedule: [String: AnyObject]) -> FoodTruckMapAnnotation {
        
        println("scheduleId is \(scheduleId)")
        
        var latitude:CLLocationDegrees = (schedule["lat"] as NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = schedule["name"] as String
        annotation.subtitle = schedule["date"] as String
        annotation.truckId = schedule["truck_id"] as String
        annotation.scheduleId = scheduleId
        
        println("1. \(annotation.scheduleId)")
        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            println("invalid longitude/latitude \(longitude)/\(latitude)")
        } else {
            self.setRegion(latitude, longitude: longitude)
            self.mapView.addAnnotation(annotation)
        }
        
        return annotation
        
    }
    
    /*
        tell schedule detail view what should be prepared for dinner today
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier! == toTruckDetailViewSegue) {
            var destViewController: TruckDetailsScrollViewController = segue.destinationViewController as TruckDetailsScrollViewController
            //destViewController.setPrevViewController("Map!")
            var truckId = Schedules.getTruckIdByScheduleId(currentScheduleId)
            destViewController.setTruckId(truckId!)
        }
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
        performSegueWithIdentifier("MapFullToDetailSegue", sender: nil)
        // this is the last stop where we can still access annotation
    }
    
    func setRegion(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        // how many degrees it would zoom out by default, 1 would be a lot
        var latDelta:CLLocationDegrees = 1
        var lonDelta:CLLocationDegrees = 1
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)

        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            
        } else {
            mapView.setRegion(region, animated: false)

        }
        //mapView.setRegion(region, animated: true)
    }

    
//    func refreshByDate(date:String) {
//        self.cellContent = self.scheduleFetcher.getSchedulesBydate(date)
//        self.theTableView.reloadData()
//    }
    
    
    
}
