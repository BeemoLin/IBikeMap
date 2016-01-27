//
//  BikeData.swift
//  IBikeMap
//
//  Created by BeemoLin on 2015/3/18.
//  Copyright (c) 2015年 BeemoLin. All rights reserved.
//

import UIKit

class BikeData: NSObject {
    private var iBikes: NSArray = NSArray()
    private let iBikeUrl = NSURL(string: "http://61.223.249.207/ibike.json")!
    
    override init() {
        super.init()
        getJsonFromURL()
    }
    
    func getBikeList()->NSArray {
        var list: [BikeViewData] = Array()
        
        for result in iBikes {
            let ibikeViewData = BikeViewData()
            let ibikeDeatil = BikeDetail(ibikes: result as! NSDictionary)
            
            ibikeViewData.sarea = ibikeDeatil.sarea!
            ibikeViewData.sna = ibikeDeatil.sna!
            ibikeViewData.sbi = ibikeDeatil.sbi!
            ibikeViewData.bemp = ibikeDeatil.bemp!
            ibikeViewData.lat = ibikeDeatil.lat!
            ibikeViewData.lng = ibikeDeatil.lng!
            ibikeViewData.update = ibikeDeatil.update!
            
            list.append(ibikeViewData)
        }
        
        return list
    }
    
    func readData() -> NSMutableArray {
        // full path for local file data.plist
        let documentDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("Data.plist")
        let data = NSMutableDictionary(contentsOfFile: path.path!)!
        
        let favoriteList = data.objectForKey("FavoriteList")! as! NSMutableArray
        
        return favoriteList
    }
    
    func addData(favoriteString: NSString) {
        // full path for local file data.plist
        let documentDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("Data.plist")
        let data = NSMutableDictionary(contentsOfFile: path.path!)!
        
        let favoriteList: AnyObject? = data.objectForKey("FavoriteList")
        
        favoriteList?.addObject("\(favoriteString)")
        
        data.setObject(favoriteList!, forKey: "FavoriteList")
        
        data.writeToFile(path.path!, atomically: true)
    }
    
    func delData(newArr: NSArray) {
        // full path for local file data.plist
        let documentDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("Data.plist")
        let data = NSMutableDictionary(contentsOfFile: path.path!)!
        
        let favoriteList: AnyObject = data.objectForKey("FavoriteList")!
        
        data.setObject(newArr, forKey: "FavoriteList")
        
        data.writeToFile(path.path!, atomically: true)
    }
    
    private func getJsonFromURL() {
        var data: NSData = NSData.init()
        do {
            data = try NSData(contentsOfURL: iBikeUrl, options: NSDataReadingOptions.DataReadingUncached)
            print(data)
        } catch {
            print(error)
        }
        
        var json: AnyObject? = nil
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            print(json)
        } catch {
            print(error)
        }
        
        if json != nil {
            iBikes = NSArray(array: json as! NSArray)
        }
    }

}
