//
//  FilterProtocol.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 7/12/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//

protocol FilterProtocol {
    func setDateFilter(date:String)
    func setCategoryFilter(category:String)
    func refreshByDate(date:String)
    func refreshByCategory(category:String)
    func clearDateFilter()
    func clearCategoryFilter()
}