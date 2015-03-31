//
//  ImageFetcher.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/21/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//



class ImageFetcher {
    /*
        First get images of one specific truck:
        http://130.211.191.208/scripts/get_truck_img.php?truck=23
    
        this gives a list of image paths:
        ["\/trucks\/Taqueria_Angelicas\/logo.jpg","\/trucks\/Taqueria_Angelicas\/tagueria-angelicas-menu.jpg","\/trucks\/Taqueria_Angelicas\/taqueria-angelicas-churros.jpg","\/trucks\/Taqueria_Angelicas\/taqueria-angelicas-tacos.jpg","\/trucks\/Taqueria_Angelicas\/taqueria-angelicas.jpg"]
    
        then it fetches each image with this url:
        http://130.211.191.208/trucks/Taqueria_Angelicas/logo.jpg
    
        it's better to use picture with reduced size:
        http://130.211.191.208/trucks/Taqueria_Angelicas/reduced/logo.jpg
    */
    func fetchImageByTruckId(truckId : String?, callback: () -> Void) -> UIImage? {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var urlPath = WebService.baseUrl + "/scripts/get_truck_img.php?truck=" + truckId!
            WebService.request(urlPath, callback: {
                data -> Void in
                
                let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                
                // Parallelize it!
                for picPath in jsonResults {
                    var pictureUrl = WebService.baseUrl + (picPath as NSString)
                    println("DEBUG: \(pictureUrl)")
                    var image = self.fetchImage(pictureUrl)
                    
                    if TruckDetailImages.truckImages[truckId!] == nil {
                        TruckDetailImages.truckImages[truckId!] = [UIImage]()
                    }
                    TruckDetailImages.truckImages[truckId!]!.insert(image, atIndex: 0)
                    println(TruckDetailImages.truckImages[truckId!]!.count)
                }
                dispatch_sync(dispatch_get_main_queue(), {
                    callback()
                })
            })
        }
        // TODO: show a default picture if possible
        return nil
    }
    
    // always check sum first, download if it doesn't match
    // check if image exists in file system, load if it's available
    func fetchImages(completeHandler: () -> Void) {
        // TODO: add update local feature here
        // TODO: handle if fetching is in transition
        if (Images.truckImages.count > 0) {
            println("use local photos for now")
            completeHandler()
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            for truckInfo in TheTrucks.trucks.values {
                var imageUrl = WebService.baseUrl + truckInfo["img"]!
                var image:UIImage? = self.loadImage(truckInfo["name"]!)
                if (image == nil) {
                    image = self.fetchImage(imageUrl)
                    self.storeImage(truckInfo["name"]!, image: image!)
                }
                var newImage: Image = Image(image: image!)
                Images.truckImages[truckInfo["id"]!] = newImage
            }
            dispatch_sync(dispatch_get_main_queue(), {
                completeHandler()

            })
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