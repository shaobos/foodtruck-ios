//
//  LargeImageViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 4/11/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


//import MWPhotoBrowser

class LargeImageViewController : MWPhotoBrowser, MWPhotoBrowserDelegate {
    
    var imageUrls = [String]()
    var images = [UIImage]()
    var imageShown:UIImage?
    var shit:String?

    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return 1
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        var image = self.images[Int(index)]
        var imageUrl = self.imageUrls[Int(index)]
       // var mwPhoto:MWPhoto = MWPhoto(image: image)
        var mwPhoto:MWPhoto = MWPhoto(URL: NSURL(string: imageUrl))
//        println(imageUrls)
        
        return mwPhoto
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {
            println("trying to dismiss itself")
        })
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
}