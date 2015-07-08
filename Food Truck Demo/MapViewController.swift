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

class MapViewController: ScheduleAwareViewController, MKMapViewDelegate {
    
    var schedules = [String: [String: AnyObject]]()
    var scheduleFetcher = ScheduleFetcher()
    var trucks = TruckFetcher()
    var imageFetcher = ImageFetcher()
    // TODO: a dirty solution to pass around schedule id
    var currentScheduleId : String = ""
    var previousController : String = ""
    var toTruckDetailViewSegue = "MapFullToDetailSegue"
    var annotationsBySchedule = [String: FoodTruckMapAnnotation]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
        Since we're going to only instantiate map view once, we need to tell when the view is loaded again in container view. luckily, we can use didMoveToParentViewController()
    */
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        highlightAnnotation(self.scheduleId)
        setRegionBySchedule(self.scheduleId)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchedules()
    }
    
    func fetchSchedules() {
        trucks.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchSchedules() {
                self.schedules = self.scheduleFetcher.getSchedules()
                var count:Double = Double(self.schedules.count)
                var latitudeSum:Double = 0
                var longitudeSum:Double = 0
                
                var groupByAddress = [String: [[String: AnyObject]]]()
                for scheduleId in self.schedules.keys {
                    var schedule:[String: AnyObject] = self.schedules[scheduleId]!
                    var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
                    var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
                    
                    if let address = schedule["address"] as? String {
                        if groupByAddress[address] == nil {
                            groupByAddress[address] = [[String: AnyObject]]()
                        }
                        
                        groupByAddress[address]?.append(schedule)
                    }
                    latitudeSum += latitude
                    longitudeSum += longitude
                    
                    //var annotation = self.createAnnotations(scheduleId, singleScheduleObject: schedule)
                    //self.annotationsBySchedule[scheduleId] = annotation
                }
                
                for groupId in groupByAddress.keys {
                    println(groupId)
                    self.createAnnotationsByGroup("blah", schedulesOnSameAddress: groupByAddress[groupId]!)
                    for singleSchedule in groupByAddress[groupId]! {
                        println(singleSchedule["name"])
                    }
                }
                
                // TODO: refactor this shit
                if (self.scheduleId == "") {
                    var centralLatitude:Double = latitudeSum / count
                    var centralLongwitude:Double = longitudeSum / count
                    self.setRegion(centralLatitude, longitude: centralLongwitude)
                } else {
                    self.setRegionBySchedule(self.scheduleId)
                    self.highlightAnnotation(self.scheduleId)
                }
            }
        }
    }
    
    /*
        set the region when user clicks on a schedule from table view and then switch to the map
    */
    func setRegionBySchedule(scheduleId:String) {
        if (scheduleId == "") {
            return
        }
        
        var schedule:[String: AnyObject] = self.schedules[scheduleId]!
        var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
        self.setRegion(latitude, longitude: longitude, delta: 0.5)
    }

    func groupAnnotationBySameAddress() {
        
    }
    
    func createAnnotationsByGroup(address: String, schedulesOnSameAddress schedules: [[String: AnyObject]]) -> FoodTruckMapAnnotation {

        
        var temp:String = ""
        for singleSchedule in schedules {
            temp += singleSchedule["name"] as! String
        }
        
        var schedule = schedules.first!
        var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = temp
        annotation.subtitle = schedule["date"] as! String + " " + (schedule["start_time"] as! String) + " - " + (schedule["end_time"] as! String)
        
        annotation.truckId = schedule["truck_id"] as! String
        annotation.scheduleId = scheduleId
        annotation.date = schedule["date"] as! String
        
        
        
        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            println("invalid longitude/latitude \(longitude)/\(latitude)")
        } else {
            self.mapView.addAnnotation(annotation)
        }
        
        return annotation
    }
    
    func createAnnotations(scheduleId: String, singleScheduleObject schedule: [String: AnyObject]) -> FoodTruckMapAnnotation {
        
        var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = schedule["name"] as! String
        annotation.subtitle = schedule["date"] as! String + " " + (schedule["start_time"] as! String) + " - " + (schedule["end_time"] as! String)
        annotation.truckId = schedule["truck_id"] as! String
        annotation.scheduleId = scheduleId
        annotation.date = schedule["date"] as! String
        
        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            println("invalid longitude/latitude \(longitude)/\(latitude)")
        } else {
            self.mapView.addAnnotation(annotation)
        }
        
        return annotation
    }
    
    /*
        show annotation view
    */
    func highlightAnnotation(scheduleId:String) {
        if (scheduleId == "") {
            return
        }
        
        var annotation = annotationsBySchedule[self.scheduleId]
        // this is how selected pin view is displayed programmatically
        // http://stackoverflow.com/a/2339556/677596
        mapView.selectAnnotation(annotation, animated: false)
    }
    
    /*
        tell truck detail view
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == toTruckDetailViewSegue) {
            var destViewController: TruckDetailViewController = segue.destinationViewController as! TruckDetailViewController
            var truckId = Schedules.getTruckIdByScheduleId(currentScheduleId)
            destViewController.truckId(truckId!)
        }
    }
    
    // how to add custom annotation callout(awesome!)
    // http://stackoverflow.com/a/19404994/677596
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        // how to load from a nib file
        // http://stackoverflow.com/a/25513605
        var customView = UINib(nibName: "CustomAnnotationView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView

        // to make customView appear just above the pin
        customView.center = CGPointMake(view.bounds.size.width*0.5, -customView.bounds.size.height*0.5)
        view.addSubview(customView)
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        // how to remove subview
        // http://stackoverflow.com/a/24666052/677596
        for someView in view.subviews {
            if someView.isKindOfClass(CustomAnnotationView) {
                someView.removeFromSuperview()
            }
        }
    }
    
    /*
        customize annotation view
    
        By this point, all data should be available in memory so we can read directly
    */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var foodTruckAnnotation = annotation as! FoodTruckMapAnnotation
        var truckId: String  = foodTruckAnnotation.truckId
        var scheduleId: String  = foodTruckAnnotation.scheduleId
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        
        pinAnnotationView.pinColor = .Purple
        pinAnnotationView.draggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = false

        
        let deleteButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
        
        if let theImage: Image = Images.truckImages[truckId] {
            deleteButton.setBackgroundImage(theImage.image, forState: UIControlState.Normal)
        }
        
        pinAnnotationView.leftCalloutAccessoryView = deleteButton
        
        return pinAnnotationView
    }
    
    
    /*
        this function customizes what happens when button in left callout accessory view is clicked
    */
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var foodTruckAnnotation = view.annotation as! FoodTruckMapAnnotation
        self.currentScheduleId = foodTruckAnnotation.scheduleId
        performSegueWithIdentifier("MapFullToDetailSegue", sender: nil)
        // this is the last stop where we can still access annotation
    }
    
    func setRegion(latitude:CLLocationDegrees, longitude:CLLocationDegrees, delta:CLLocationDegrees = 1) {
        // how many degrees it would zoom out by default, 1 would be a lot
        var latDelta:CLLocationDegrees = delta
        var lonDelta:CLLocationDegrees = delta
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)

        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
        } else {
            mapView.setRegion(region, animated: false)
        }
    }

    func refreshByCategory(category:String) {
        
        
    }
    
    func refreshByDate(date:String) {
        for annotation in self.annotationsBySchedule.values {
            var viewForAnnotation = self.mapView.viewForAnnotation(annotation)
            
            //TODO: debugging here
            if viewForAnnotation == nil {
                println(annotation.scheduleId)
                continue
            }
            if annotation.date == date {
                viewForAnnotation.hidden = false
            } else {
                viewForAnnotation.hidden = true
            }
        }
    }
}
