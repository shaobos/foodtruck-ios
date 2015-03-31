//
//  TruckDetailsViewControllerWithScroll.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class TruckDetailsScrollViewController : TruckAwareViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var theTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var imageFetcher = ImageFetcher()

    var prevViewController: UIViewController?
    var previousViewControllerName:String = ""
    var scheduleToTableSegueID : String = "ScheduleToTableSegue"
    var scheduleToMapSegueID : String = "ScheduleToMapSegue"
    var inputLabel:String = ""
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    var collectionCellReusableId = "TruckDetailCollectionCell"
    
    @IBOutlet weak var anotherLabel: UILabel!
    @IBAction func backButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("ScheduleToMainSegue", sender: nil)
    }
    
    func setPrevViewController(prev: String) {
        self.previousViewControllerName = prev
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("who is my previous controller \(self.previousViewControllerName)")
        
        // Do any additional setup after loading the view.
        theTitle.text = inputLabel
        
        imageFetcher.fetchImageByTruckId(self.truckId, {
            
            println("Done fetching. Refreshing collection view")
            self.theCollectionView.reloadData()
            
        })
        renderView()
    }
    
    func renderView() {
        // TODO: nil checking
        if let truck = TheTrucks.trucks[self.truckId] {
            theTitle.text = truck["name"]
            if let theImage: Image = Images.truckImages[self.truckId] {
                image?.image =  theImage.image
            }
        }
        
//        startTime.text = schedule["start_time"] as? String
//        endTime.text = schedule["end_time"] as? String
//        address.text = schedule["address"] as? String
//        date.text = schedule["date"] as? String
//        

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("i'm here to get number of images")

        if let truckImages = TruckDetailImages.truckImages[self.truckId] {
            println("it's \(truckImages.count)")
            return truckImages.count
        } else {
            println("it's nil!!")

            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        println("i'm here to get cell")

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReusableId, forIndexPath: indexPath) as CollectionViewCell
        cell.imageView.image = photoForIndexPath(indexPath)
        return cell
    }
    
    func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
        let truckImages:[UIImage] = TruckDetailImages.truckImages[self.truckId]!
        
        return truckImages[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("An image was clicked!!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue is happening!!")
        var destViewController = segue.destinationViewController as TableViewController
        destViewController.truckId = self.truckId
        //destViewController.finalize()
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("farewell, my darling true")
    }
    
    
}