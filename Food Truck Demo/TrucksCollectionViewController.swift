//
//  CollectionViewController.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/19/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


class TrucksCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "TruckCell"
    private var images = [UIImage]()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
        return images[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var webService = WebService()
        webService.getTruckList {
            loadedImages in
            println("load image...")
            self.images = loadedImages
            // this is important, needs to reload it!
            self.collectionView?.reloadData()
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("DEBUG: return the number of cells!!")
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CollectionViewCell

        cell.imageView.image = photoForIndexPath(indexPath)
        return cell
    }
    
}
