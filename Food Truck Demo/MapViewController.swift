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

    var scheduleFetcher = ScheduleFetcher()
    var trucks = Trucks()
    var imageFetcher = ImageFetcher()
    var schedules:[[String: AnyObject]] = []

    
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
        
        trucks.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchTrucksInfoFromRemote() {
                println("Schedules are ready")
                self.schedules = self.scheduleFetcher.getSchedules()
                
                
                // TODO: should be able to decide the region more intelligently
                var latitute:CLLocationDegrees = 37.393315
                var longitute:CLLocationDegrees = -122.061475
                self.setRegion(latitute, longitute: longitute)
                for schedule in self.schedules {
                    println(schedule)
                    println(schedule["lat"])
    
                    var lat:CLLocationDegrees = (schedule["lat"] as NSString).doubleValue
                    var lon:CLLocationDegrees = (schedule["lng"] as NSString).doubleValue
                    var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)

                    self.addAnnotation(newCoordinate, title: schedule["name"] as String, subtitle: schedule["date"] as String)
                    

                }
            }
        }


        
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: ScheduleDetailsViewController = segue.destinationViewController as ScheduleDetailsViewController
        println("Going to set prev VC to map!")
        destViewController.setTitle("hey")
        destViewController.setPrevViewController("Map!")
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        //performSegueWithIdentifier("MapToDetailSegue", sender: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    /*
      customize annotation view
    
      By this point, all data should be available in memory so we can read directly
    */
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
