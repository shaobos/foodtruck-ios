//
//  LargeImageViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 4/11/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


class LargeImageViewController : UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {
            println("trying to dismiss itself")
        })
       // performSegueWithIdentifier("LargeImageToTruckDetail", sender: nil)
    }
    var imageShown:UIImage?
    var shit:String?
    // TODO: allow user to switch between multiple images in this view
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageShown != nil {
            imageView.image = imageShown
        }
    }
    func setImage(image: UIImage) {
        imageShown = image
    }
}