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



/**

A group contains:
    [
        schedule: [

        ],
        schedule : [

        ],
        ....

    ]


*/

class MapViewController: ScheduleAwareViewController, MKMapViewDelegate, UICollectionViewDelegate, FilterProtocol {
    
    var schedules = [String: [String: AnyObject]]()
    var scheduleFetcher = ScheduleFetcher()
    var trucks = TruckFetcher()
    var imageFetcher = ImageFetcher()
    // TODO: a dirty solution to pass around schedule id
    var currentScheduleId : String = ""
    var previousController : String = ""
    var toTruckDetailViewSegue = "MapFullToDetailSegue"
    
    // store all annotations created during map view initialization, for use case like date filtering
    var annotations = [FoodTruckMapAnnotation]()
    
    // selected annotation group
    var selectedGroupId : String = ""
    
    // selected truck id, which comes from two sources:
    // 1. a group annotation with single schedule, where truck id is set when users click on the image in callout window
    // 2. a group annotation with multiple schedules, where truck id is set when users click on image in galley at the bottom
    //
    // truck id will be used for performing segue, so that truck detail view controller will be aware of which truck to displays
    var selectedTruckId : String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
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
    //
    var groupByAddress = [String: [[String: AnyObject]]]()

    
    
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
                
                for scheduleId in self.schedules.keys {
                    var schedule:[String: AnyObject] = self.schedules[scheduleId]!
                    var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
                    var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
                    
                    
                    var address = schedule["address"] as! String
                    var date = schedule["date"] as! String
                    var state_time = schedule["start_time"] as! String
                    var end_time = schedule["end_time"] as! String
                    var key = date + address + state_time + end_time
                    if self.groupByAddress[key] == nil {
                        self.groupByAddress[key] = [[String: AnyObject]]()
                    }
                    
                    
                    schedule["id"] = scheduleId
                    self.groupByAddress[key]?.append(schedule)
                    latitudeSum += latitude
                    longitudeSum += longitude
                }
                
                // create annotation differently
                for groupId in self.groupByAddress.keys {
                    var groupModel:[[String: AnyObject]] = self.groupByAddress[groupId]!
                    var annotation:FoodTruckMapAnnotation
                    if (groupModel.count > 1) {
                        annotation = self.createAnnotationsByGroup(groupId, schedulesOnSameAddress: self.groupByAddress[groupId]!)
                    } else {
                        var onlySchedule = groupModel.first!
                        annotation = self.createAnnotation(onlySchedule["id"] as! String, singleScheduleObject: onlySchedule)
                    }
                    self.annotations.append(annotation)
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
    
    func createAnnotationsByGroup(groupId: String, schedulesOnSameAddress schedules: [[String: AnyObject]]) -> FoodTruckMapAnnotation {
        var temp:String = ""
        for singleSchedule in schedules {
            temp += singleSchedule["name"] as! String
        }
        
        var schedule = schedules.first!
        var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
        var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
        var newCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var annotation:FoodTruckMapAnnotation = FoodTruckMapAnnotation()
        var address:String = schedule["address"] as! String
        annotation.coordinate = newCoordinate
        annotation.title = "\(schedules.count) food trucks: \(address)"
        annotation.subtitle = schedule["date"] as! String + " " + (schedule["start_time"] as! String) + " - " + (schedule["end_time"] as! String)
        
        annotation.truckId = schedule["truck_id"] as! String
        annotation.groupId = groupId
        annotation.scheduleId = scheduleId
        annotation.date = schedule["date"] as! String
        
        if latitude > 180 || latitude < -180 || longitude > 180 || longitude < -180 {
            println("invalid longitude/latitude \(longitude)/\(latitude)")
        } else {
            self.mapView.addAnnotation(annotation)
        }
        
        return annotation
    }
    
func createAnnotation(scheduleId: String, singleScheduleObject schedule: [String: AnyObject]) -> FoodTruckMapAnnotation {
    
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
        
//        var annotation = annotations[self.scheduleId]
//        // this is how selected pin view is displayed programmatically
//        // http://stackoverflow.com/a/2339556/677596
//        mapView.selectAnnotation(annotation, animated: false)
    }
    
    /*
        tell truck detail view
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destViewController: TruckDetailViewController = segue.destinationViewController as! TruckDetailViewController

        if (selectedTruckId != "") {
            destViewController.truckId(selectedTruckId)

        } else {
        
            if (segue.identifier! == toTruckDetailViewSegue) {
                var truckId = Schedules.getTruckIdByScheduleId(currentScheduleId)
                destViewController.truckId(truckId!)
            }
        }
    }
    
    // how to add custom annotation callout(awesome!)
    // http://stackoverflow.com/a/19404994/677596
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        
        var foodTruckAnnotation = view.annotation as! FoodTruckMapAnnotation
        
        if (foodTruckAnnotation.groupId != "") {
            self.selectedGroupId = foodTruckAnnotation.groupId

            collectionView.reloadData()

            collectionView.hidden = false
        } else {
             self.selectedGroupId = ""
            collectionView.hidden = true
        }
        // how to load from a nib file
        // http://stackoverflow.com/a/25513605
//        var customView = UINib(nibName: "CustomAnnotationView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CustomAnnotationView
//
//        // to make customView appear just above the pin
//        //if customView.bounds.size.width > mapView.boun
//        customView.center = CGPointMake(view.bounds.size.width*0.5, -customView.bounds.size.height*0.5)
//        customView.time.text = "123"
//        view.addSubview(customView)
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        
        var foodTruckAnnotation = view.annotation as! FoodTruckMapAnnotation

        if (foodTruckAnnotation.groupId != "") {
            self.selectedGroupId = ""

            collectionView.hidden = true
        }
//        // how to remove subview
//        // http://stackoverflow.com/a/24666052/677596
//        for someView in view.subviews {
//            if someView.isKindOfClass(CustomAnnotationView) {
//                someView.removeFromSuperview()
//            }
//        }
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
        
        
        if (foodTruckAnnotation.groupId == "") {
            selectedGroupId = ""
            if let theImage: Image = Images.truckImages[truckId] {
                deleteButton.setBackgroundImage(theImage.image, forState: UIControlState.Normal)
            }
        
            pinAnnotationView.leftCalloutAccessoryView = deleteButton
        } else {
            selectedGroupId = foodTruckAnnotation.groupId
        }
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
        for annotation in self.annotations {
            var viewForAnnotation = self.mapView.viewForAnnotation(annotation)
            
            if viewForAnnotation == nil {
                continue
            }
            if annotation.date == date {
                viewForAnnotation.hidden = false
            } else {
                viewForAnnotation.hidden = true
            }
        }
    }
    
    
    /****** collection view ******/
    
    
    
    
    var collectionCellReusableId = "EventPictureCell"

    /*
    
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.selectedGroupId != "") {
            return groupByAddress[self.selectedGroupId]!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReusableId, forIndexPath: indexPath) as! MapCollectionViewCell
        
        // at the point, a group annotation must be selected(otherwise, users won't see this collection view)
        var selectedSchedule = groupByAddress[self.selectedGroupId]![indexPath.row]
        var truckId = selectedSchedule["truck_id"] as! String
        
        cell.truckId = truckId
        if let theImage: Image = Images.truckImages[truckId] {
            cell.imageView.image = theImage.image
        }
        return cell
    }
    
    /*
        When an image is clicked
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! MapCollectionViewCell
        self.selectedTruckId = cell.truckId
        performSegueWithIdentifier("MapFullToDetailSegue", sender: nil)
    }
}
