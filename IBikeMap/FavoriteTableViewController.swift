//
//  FavoriteTableViewController.swift
//  IBikeMap
//
//  Created by BeemoLin on 2015/3/24.
//  Copyright (c) 2015年 BeemoLin. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    var ibikeList = NSArray()
    var favoriteList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bikeData = BikeData()
        ibikeList = bikeData.getBikeList()
        favoriteList = bikeData.readData()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("sortArray"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func sortArray() {
        var bikeData = BikeData()
        ibikeList = bikeData.getBikeList()
        favoriteList = bikeData.readData()
        
        for (index, element) in enumerate(favoriteList) {
            favoriteList[index] = element
        }
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = "\(favoriteList[indexPath.row])"
        
        for temp in ibikeList {
            let tempDetail = temp as! BikeViewData
            
            if tempDetail.sna == (favoriteList[indexPath.row] as! NSString) {
                cell.detailTextLabel?.text = "可借車輛:\(tempDetail.sbi) / 可停車位:\(tempDetail.bemp)"
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var mapView = self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as! ViewController
        
        mapView.selectSna = favoriteList[indexPath.row] as! NSString as String
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var bikeData = BikeData()
            
            favoriteList.removeObjectAtIndex(indexPath.row)
            bikeData.delData(favoriteList)
            
            tableView.beginUpdates()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                
            tableView.endUpdates()
        }
    }
    
}
