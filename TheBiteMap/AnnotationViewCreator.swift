//
//  AnnotationViewCreator.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 7/12/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


import MapKit

class AnnotationViewCreator {
    static func create(annotation: MKAnnotation) -> MKPinAnnotationView {
        var foodTruckAnnotation = annotation as! FoodTruckMapAnnotation
        var truckId: String  = foodTruckAnnotation.truckId
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "PerformSegue")
        pinAnnotationView.addGestureRecognizer(tap)
        pinAnnotationView.pinColor = .Purple
        pinAnnotationView.draggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = false
        
        
        let deleteButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
//        
//        // Add image to callout view
//        if let theImage: Image = Images.truckImages[truckId] {
//            deleteButton.setBackgroundImage(theImage.image, forState: UIControlState.Normal)
//        }
//        pinAnnotationView.rightCalloutAccessoryView = deleteButton
        return pinAnnotationView
    }
    
    func PerformSegue() {
        // performSegueWithIdentifier("MapFullToDetailSegue", sender: nil)
        
        println("pin annotation is wrong???")
    }
}