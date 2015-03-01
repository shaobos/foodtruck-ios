//
//  ImageFetcher.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/21/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//



class ImageFetcher {
    
    // always check sum first, download if it doesn't match
    // check if image exists in file system, load if it's available
    func fetchImages(completeHandler: () -> Void) {
        // TODO: add update local feature herefeature here
        if (Images.truckImages.count > 0) {
            println("use local photos for now")
            completeHandler()
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            println("Okie dokie, time to fetch images")
        
            for truckInfo in TheTrucks.trucks {
                var imageUrl = WebService.baseUrl + truckInfo["img"]!
                if  let image : UIImage = self.loadImage(truckInfo["name"]!) {
                    Images.truckImages.insert(image, atIndex: 0)
                } else {
                    let image : UIImage = self.fetchImage(imageUrl)
                    self.storeImage(truckInfo["name"]!, image: image)
                    Images.truckImages.insert(image, atIndex: 0)

                }
            }
            completeHandler()
        }
    }
    

    func loadImage(id: String ) -> UIImage? {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var dirPath = paths.stringByAppendingPathComponent("images/\(id)" )
        var imagePath = paths.stringByAppendingPathComponent("images/\(id)/logo.jpg" )
        var checkImage = NSFileManager.defaultManager()
        
        
        if (checkImage.fileExistsAtPath(imagePath)) {
            let getImage = UIImage(contentsOfFile: imagePath)
            return getImage
        }
        return nil
    }
    
    func storeImage(id: String, image getImage : UIImage) {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var dirPath = paths.stringByAppendingPathComponent("images/\(id)" )
        var imagePath = paths.stringByAppendingPathComponent("images/\(id)/logo.jpg" )
        var checkImage = NSFileManager.defaultManager()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            checkImage.createDirectoryAtPath(dirPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            UIImageJPEGRepresentation(getImage, 100).writeToFile(imagePath, atomically: true)
        }
    }
    
    
    func fetchImage(imageUrl: String) -> UIImage {
        let url = NSURL(string: imageUrl);
        let imageData = NSData(contentsOfURL: url!)!
        
        let image = UIImage(data: imageData)
        if (image == nil) {
            println(imageUrl + " is nil!!")
        }
        
        return image!
    }
}