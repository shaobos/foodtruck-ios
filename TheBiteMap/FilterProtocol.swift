//
//  FilterProtocol.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 7/12/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

protocol FilterProtocol {
    func refreshByDate(date:String)
    func refreshByCategory(category:String)
}