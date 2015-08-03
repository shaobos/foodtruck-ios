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
    
    var scheduleFetcher = ScheduleFetcher()
    var truckFetcher = TruckFetcher()
    var annotationCreator = AnnotationCreator()

    // TODO: a dirty solution to pass around schedule id
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
    
    var scheduleIdToAnnotation = [String: FoodTruckMapAnnotation]()
    var schedules = [String: [String: AnyObject]]()
    var schedulesGroupByEvent = [String: [[String: AnyObject]]]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
        Since we're going to only instantiate map view once, we need to tell when the view is loaded again in container view. luckily, we can use didMoveToParentViewController()
    */
    override func didMoveToParentViewController(parent: UIViewController?) {
        
        super.didMoveToParentViewController(parent)
        println("map moved to parent \(currentDateFilter) \(currentCategoryFilter)")
        
        highlightAnnotation(self.scheduleId)
        setRegionBySchedule(self.scheduleId)
    }
    
    override func viewDidAppear(animated: Bool) {
        println("*** Map view did appear!!! \(currentDateFilter) \(currentCategoryFilter)")
        refreshMap()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshMap()
        fetchSchedules()
    }
    
    func fetchSchedules() {
        truckFetcher.fetchTrucksInfoFromRemote {
            loadedImages in
            self.scheduleFetcher.fetchSchedules() {
                self.schedules = self.scheduleFetcher.getSchedules()
                self.initialize()
            }
        }
    }
    
    
    private func groupSchedulesByEvent() {
        for scheduleId in schedules.keys {
            var schedule:[String: AnyObject] = schedules[scheduleId]!
            var address = schedule["address"] as! String
            var date = schedule["date"] as! String
            var state_time = schedule["start_time"] as! String
            var end_time = schedule["end_time"] as! String
            var key = date + address + state_time + end_time
            if schedulesGroupByEvent[key] == nil {
                schedulesGroupByEvent[key] = [[String: AnyObject]]()
            }
            schedule["id"] = scheduleId
            schedulesGroupByEvent[key]?.append(schedule)
        }
    }
    
    private func processSchedules() {
        for groupId in schedulesGroupByEvent.keys {
            var scheduleGroup:[[String: AnyObject]] = schedulesGroupByEvent[groupId]!
            var annotation:FoodTruckMapAnnotation
            if (scheduleGroup.count > 1) {
                
                annotation = annotationCreator.createGroupAnnotation(groupId, schedulesOnSameAddress: schedulesGroupByEvent[groupId]!)
                for schedule in scheduleGroup {
                    scheduleIdToAnnotation[schedule["id"] as! String] = annotation
                }
            } else {
                var onlySchedule = scheduleGroup.first!
                annotation = annotationCreator.createSingleAnnotation(onlySchedule["id"] as! String, singleScheduleObject: onlySchedule)
                for schedule in scheduleGroup {
                    scheduleIdToAnnotation[schedule["id"] as! String] = annotation
                }
            }
            var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "PerformSegue")
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }
    
    func initialize() {
        groupSchedulesByEvent()
        processSchedules()

        
        // TODO: refactor this shit
        if (scheduleId == "") {
            setRegionToIncludeAllSchedules()
        } else {
            setRegionBySchedule(self.scheduleId)
            highlightAnnotation(self.scheduleId)
        }
    }
    
    
    private func setRegionToIncludeAllSchedules() {
        var count:Double = Double(schedules.count)
        var latitudeSum:Double = 0
        var longitudeSum:Double = 0
        
        for scheduleId in schedules.keys {
            var schedule:[String: AnyObject] = schedules[scheduleId]!
            var latitude:CLLocationDegrees = (schedule["lat"] as! NSString).doubleValue
            var longitude:CLLocationDegrees = (schedule["lng"] as! NSString).doubleValue
            latitudeSum += latitude
            longitudeSum += longitude
        }
        var centralLatitude:Double = latitudeSum / count
        var centralLongwitude:Double = longitudeSum / count
        setRegion(centralLatitude, longitude: centralLongwitude)
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
    
    /*
        show annotation view
    */
    func highlightAnnotation(scheduleId:String) {
        if (scheduleId == "") {
            return
        }
        
        var annotation = scheduleIdToAnnotation[self.scheduleId]
//        // this is how selected pin view is displayed programmatically
//        // http://stackoverflow.com/a/2339556/677596
        mapView.selectAnnotation(annotation, animated: false)
    }
    
    /*
        preparation before redirecting to truck detail view
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: TruckDetailViewController = segue.destinationViewController as! TruckDetailViewController
        if (selectedTruckId != "") {
            destViewController.truckId(selectedTruckId)
            // reset once it displays detail view of selected truck id
            // this state should not be retained
            selectedTruckId = ""
        }
    }
    
    // how to add custom annotation callout(awesome!)
    // http://stackoverflow.com/a/19404994/677596
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        var foodTruckAnnotation = view.annotation as! FoodTruckMapAnnotation
        self.selectedTruckId = foodTruckAnnotation.truckId

        println("Set selectedTruckId \(self.selectedTruckId)")
        if (foodTruckAnnotation.groupId != "") {
            self.selectedGroupId = foodTruckAnnotation.groupId
            collectionView.reloadData()
            collectionView.hidden = false
        } else {
             self.selectedGroupId = ""
            collectionView.hidden = true
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        
        var foodTruckAnnotation = view.annotation as! FoodTruckMapAnnotation

        if (foodTruckAnnotation.groupId != "") {
            self.selectedGroupId = ""
            collectionView.hidden = true
        }
    }
    
    /*
        create and customize annotation view
        By this point, all data should be available in memory so we can read directly
    */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "PerformSegue")
        
        var annotationView:MKAnnotationView =  AnnotationViewCreator.create(annotation)
        annotationView.addGestureRecognizer(tap)
        return annotationView
    }
    
    func PerformSegue() {
       // performSegueWithIdentifier("MapFullToDetailSegue", sender: nil)

        println("what's wrong???")
    }

    /*
        this function implements what happens when button in left callout accessory view is clicked
    */
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var foodTruckAnnotation = view.annotation as! FoodTruckMapAnnotation
        self.selectedTruckId = foodTruckAnnotation.truckId
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
    
    var currentDateFilter:String = ""
    var currentCategoryFilter:String = ""

    func setDateFilter(date:String) {
        currentDateFilter = date
    }
    func setCategoryFilter(category:String) {
        currentCategoryFilter = category
    }
    
    func refreshMap() {
        println(self)
        println("Map-refreshMap() current filter state \(currentDateFilter) \(currentCategoryFilter)")
        for annotation in self.annotations {
            var viewForAnnotation = self.mapView.viewForAnnotation(annotation)
            
            if viewForAnnotation == nil {
                continue
            }
            
            
            if currentDateFilter != "" && annotation.date != currentDateFilter {
                viewForAnnotation.hidden = true
                continue
            }
            
            if currentCategoryFilter != "" && !contains(annotation.categories, currentCategoryFilter) {
                viewForAnnotation.hidden = true
                continue
            }
            
            viewForAnnotation.hidden = false
            
        }
    }
    
    func refreshByCategory(category:String) {
        currentCategoryFilter = category
        refreshMap()
    }
    
    func refreshByDate(date:String) {
        currentDateFilter = date
        refreshMap()
    }
    
    func clearCategoryFilter() {
        currentCategoryFilter = ""
        refreshMap()
    }
    
    func clearDateFilter() {
        println("Map clearDateFilter is called")
        currentDateFilter = ""
        refreshMap()
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
            return schedulesGroupByEvent[self.selectedGroupId]!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReusableId, forIndexPath: indexPath) as! MapCollectionViewCell
        
        // at the point, a group annotation must be selected(otherwise, users won't see this collection view)
        var selectedSchedule = schedulesGroupByEvent[self.selectedGroupId]![indexPath.row]
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
