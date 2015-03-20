//
//  BikeTableViewController.swift
//  ibike
//
//  Created by BeemoLin on 2015/3/19.
//  Copyright (c) 2015年 BeemoLin. All rights reserved.
//

import UIKit

class BikeTableViewController: UITableViewController {
    var ibikeList = NSArray()
    var areaTemp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bikeData = BikeData()
        ibikeList = bikeData.getBikeList()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return ibikeList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let update = (ibikeList[indexPath.section] as BikeViewData).update
        let sbi = (ibikeList[indexPath.section] as BikeViewData).sbi
        let bemp = (ibikeList[indexPath.section] as BikeViewData).bemp
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = (ibikeList[indexPath.section] as BikeViewData).sna
        cell.detailTextLabel?.text = "可借車輛:\(sbi) / 可停車位:\(bemp)"
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let area = (ibikeList[section] as BikeViewData).sarea
        
        if areaTemp != area {
            areaTemp = area
            return area
        }
        
        return ""
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var mapView = self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as ViewController
        
        mapView.selectSna = (ibikeList[indexPath.section] as BikeViewData).sna
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }


}
