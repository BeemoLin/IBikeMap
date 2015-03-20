//
//  BikeDeatil.swift
//  IBikeMap
//
//  Created by BeemoLin on 2015/3/19.
//  Copyright (c) 2015年 BeemoLin. All rights reserved.
//

import UIKit

class BikeDetail: NSObject {
    var sarea: String?
    var sna: String?
    var sbi: Int?
    var bemp: Int?
    var lat: Double?
    var lng: Double?
    var update: String?
    
    init(ibikes: NSDictionary) {
        sarea = ibikes["sarea"] as? String
        sna = ibikes["sna"] as? String
        sbi = (ibikes["sbi"] as? NSString)?.integerValue
        bemp = (ibikes["bemp"] as? NSString)?.integerValue
        lat = (ibikes["lat"] as? NSString)?.doubleValue
        lng = (ibikes["lng"] as? NSString)?.doubleValue
        update = ibikes["update"] as? String
    }
}
