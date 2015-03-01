//
//  CollectionViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/19/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


class TrucksCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "TruckCell"
    
    func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
        var theImage : Image = Array(Images.truckImages.values)[indexPath.row]
        return theImage.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("DEBUG: return the number of cells!!")
        return Images.truckImages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CollectionViewCell

        cell.imageView.image = photoForIndexPath(indexPath)
        return cell
    }
    
}
