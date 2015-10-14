    //
//  TruckDetailsViewControllerWithScroll.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 3/22/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

class TruckDetailViewController : UIViewController, UICollectionViewDelegate, MWPhotoBrowserDelegate {
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {})
    }
        
    //restore
    @IBOutlet weak var theTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var url: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var truckId: String?
    
    func truckId(truckId:String) {
        self.truckId = truckId
    }
    
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    var mapViewController:MapViewController? // hightlight pin from truck detail view
    var imageFetcher = ImageFetcher()
    var prevViewController: UIViewController?
    var previousViewControllerName:String = ""
    var inputLabel:String = ""
    var currentImage:UIImage?
    var photos = [UIImage]()
    var imageUrls = [String]()
    @IBOutlet weak var urlTextLabel: UILabel!

    @IBOutlet weak var showListButton: UIButton!
    @IBAction func showScheduleListButtonPressed(sender: AnyObject) {
        tableContainerView.hidden = false
        mapContainerView.hidden = true
        showListButton.hidden = true
    }
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    var collectionCellReusableId = "TruckDetailCollectionCell"
    
    @IBOutlet weak var anotherLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("who is my previous controller \(self.previousViewControllerName)")

        theTitle.text = inputLabel


        imageFetcher.fetchImageByTruckId(self.truckId, outerCallback: {
            self.theCollectionView.reloadData()
        })
        renderView()
    }
    
    override func viewDidLayoutSubviews() {
        // Do any additional setup after loading the view.
        contentView.frame.size = CGSizeMake(self.view.frame.width, self.contentView.frame.height)
        scrollView.contentSize = contentView.frame.size
        scrollView.scrollEnabled = true
        scrollView.addSubview(contentView)
        
    }
    func renderView() {
        if let truckId = self.truckId {
            if let truck = Trucks.trucks[truckId] {
                theTitle.text = truck["name"]
                url.text = truck["url"]
                category.text = truck["category"]
                if let theImage: Image = Images.truckImages[truckId] {
                    image?.image =  theImage.image
                }
            }
        } else {
            print("TruckDetailsScrollViewController - truckId is unset")
        }
    }
    
    /*
    
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let truckImages = TruckDetailImages.truckImages[self.truckId!] {
            return truckImages.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReusableId, forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView.image = photoForIndexPath(indexPath)
        return cell
    }
    
    func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
        let truckImages:[UIImage] = TruckDetailImages.truckImages[self.truckId!]!
        return truckImages[indexPath.row]
    }
    
    /*
        When an image is clicked
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("An image was clicked!! \(indexPath.length) \(indexPath.item) \(indexPath.section) and \(indexPath.row)")

        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        currentImage = cell.imageView.image
        self.photos = TruckDetailImages.truckImages[self.truckId!]!
        self.imageUrls = TruckDetailImages.reducedUrlList[self.truckId!]!

        
        let browser:MWPhotoBrowser = MWPhotoBrowser(delegate: self)
        
        browser.displayActionButton = true
        browser.displayNavArrows = false
        browser.displaySelectionButtons = false
        browser.zoomPhotosToFill = true
        browser.alwaysShowControls = false
        browser.enableGrid = false
        browser.startOnGrid = false
        browser.enableSwipeToDismiss = true
        
        browser.setCurrentPhotoIndex(CUnsignedLong(indexPath.row    ))
        var nav = UINavigationController(rootViewController: browser)
        nav.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        var imageUrl = self.imageUrls[Int(index)]
        var mwPhoto:MWPhoto = MWPhoto(URL: NSURL(string: imageUrl))
        
        return mwPhoto
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "TruckDetailToLargeImageSegue") {
            print("going to large image view")
            var destViewController = segue.destinationViewController as! LargeImageViewController
            if let theImage = currentImage {
                destViewController.setImage(theImage)
                destViewController.setImageList(TruckDetailImages.truckImages[self.truckId!]!)
                destViewController.imageUrls = TruckDetailImages.reducedUrlList[self.truckId!]!
            } else {
                print("currentImage is unset")
            }
        } else if (segue.identifier! == "TruckDetailContainerToTable") {
            print("  ** It works - TruckDetailContainerToTable!!")

            var destViewController = segue.destinationViewController as! TableViewController
            destViewController.truckId(truckId!)
        } else if (segue.identifier! == "TruckDetailContainerToMap") {
            print("  ** It works - TruckDetailContainerToMap!!")
            mapViewController = segue.destinationViewController as! MapViewController
            
        
        } else {
            print("Unknown segue in TruckDetialScrollViewController")
        }
    }
    

}