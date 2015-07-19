//
//  LargeImageViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 4/11/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


//import MWPhotoBrowser

class LargeImageViewController : MWPhotoBrowser, MWPhotoBrowserDelegate {
    
    var images = [UIImage]()
    var imageShown:UIImage?
    var shit:String?

    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return 1
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        var image = self.images[Int(index)]
        var mwPhoto:MWPhoto = MWPhoto(image: image)
        
        return mwPhoto
    }
    
//    func photoBrowser(photoBrowser: MWPhotoBrowser!, captionViewForPhotoAtIndex index: UInt) -> MWCaptionView! {
//        return nil
//    }
//    
//    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {
            println("trying to dismiss itself")
        })
       // performSegueWithIdentifier("LargeImageToTruckDetail", sender: nil)
    }

    // TODO: allow user to switch between multiple images in this view
    override func viewDidLoad() {
        
        enableGrid = false
        displayActionButton = true;
        displayNavArrows = true;
        displaySelectionButtons = false;
        alwaysShowControls = false;
        zoomPhotosToFill = true;
        startOnGrid = false;
        enableSwipeToDismiss = false;
        autoPlayOnAppear = false;
        
        if imageShown != nil {
            imageView.image = imageShown
        }
    }
    func setImage(image: UIImage) {
        imageShown = image
    }
    
    func setImageList(images: [UIImage]) {
        self.images = images
    }
    
    /*
    
    func showFullScreenImage(image:UIImage) {
    let photo:MWPhoto = MWPhoto(image:image)
    
    self.photos = [photo]
    
    let browser:MWPhotoBrowser = MWPhotoBrowser(delegate: self)
    
    browser.displayActionButton = true
    browser.displayNavArrows = false
    browser.displaySelectionButtons = false
    browser.zoomPhotosToFill = true
    browser.alwaysShowControls = false
    browser.enableGrid = false
    browser.startOnGrid = false
    browser.enableSwipeToDismiss = true
    
    browser.setCurrentPhotoIndex(0)
    
    self.navigationController?.pushViewController(browser, animated: true)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
    if Int(index) < self.photos.count {
    return photos.objectAtIndex(Int(index)) as! MWPhoto
    }
    return nil
    }
    
    func photoBrowserDidFinishModalPresentation(photoBrowser:MWPhotoBrowser) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }

*/
}