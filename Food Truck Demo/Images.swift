//
//  Images.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/28/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

import UIKit

struct Images {
    static var truckImages = [String:Image]()
}

struct TruckDetailImages {
    static var truckImages = [String:[UIImage]]()
}

struct Image {
    var image : UIImage
    init(image : UIImage) {
        //self.truckId = truckId
        self.image = image
    }
}