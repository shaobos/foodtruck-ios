//
//  WebService.swift
//  foodtruck-ios
//
//  Created by Shaobo Sun on 2/18/15.
//  Copyright (c) 2015 Shaobo Sun. All rights reserved.
//


/*


original response from web service:
{
    category = Asian;
    category_detail = "Asian Fusion";
    id = 136;
    img = "trucks/3_Brothers_Kitchen/logo.jpg";
    name = "3 Brothers Kitchen";
    url = "http://www.3brotherskitchen.com";
}

after processing:
"136": {
    category = Asian;
    category_detail = "Asian Fusion";
    id = 136;
    img = "trucks/3_Brothers_Kitchen/logo.jpg";
    name = "3 Brothers Kitchen";
    url = "http://www.3brotherskitchen.com";
}

*/

// Model
struct Trucks {
    static var trucks = [String: [String: String]]()
}