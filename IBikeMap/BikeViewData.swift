//
//  BikeViewData.swift
//  IBikeMap
//
//  Created by BeemoLin on 2015/3/19.
//  Copyright (c) 2015年 BeemoLin. All rights reserved.
//

import UIKit

class BikeViewData: NSObject {
    var sarea: String
    var sna: String
    var sbi: Int
    var bemp: Int
    var lat: Double
    var lng: Double
    var update: String
    
    override init() {
        sarea = ""
        sna = ""
        sbi = 0
        bemp = 0
        lat = 0.0
        lng = 0.0
        update = ""
    }
}
