//
//  TableCellCustomView.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/28/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


import UIKit

class TableCellCustomView: UITableViewCell {

    @IBOutlet  var truckName: UILabel!
    @IBOutlet  var address: UILabel!
    @IBOutlet  var truckImage: UIImageView!
    @IBOutlet  var startTime: UILabel!
    @IBOutlet  var endTime: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var city: UILabel!
    
}
