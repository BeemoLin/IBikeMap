//
//  ViewController.swift
//  IBikeMap
//
//  Created by BeemoLin on 2015/3/20.
//  Copyright (c) 2015年 BeemoLin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GMSMapViewDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var ibikeList = NSArray()
    var selectSna = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        drawMaker()
        
        self.bannerView.adUnitID = "ca-app-pub-9476662783947033/6247524104"
        
        self.bannerView.rootViewController = self
        
        self.bannerView.backgroundColor = UIColor.blackColor()
        
        var request: GADRequest = GADRequest()
        
        request.testDevices = ["5ED7C1CA-1E9B-4363-B4D6-D73BFB11948C"]
        
        self.bannerView.loadRequest(request)
        
        self.view.addSubview(self.bannerView)
    }
    
    @IBAction func updateMap(sender: UIButton) {
        drawMaker()
    }
    
    // 點擊地標
    func mapView(mapView: GMSMapView, didTapMarker market: GMSMarker) -> CBool{
        
        moveToMarker(market)
        
        return true
    }
    
    // 點擊地圖空白處
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D){
        removeSubviews(50)
    }
    
    private func moveToMarker(marker: GMSMarker) {
        var camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 16)
        self.mapView.camera = camera
        
        removeSubviews(50)
        
        var wBounds = self.view.bounds.width
        var hBounds = self.view.bounds.height
        var titleSize = CGRect(x: 0, y: 10, width: wBounds, height: 20)
        
        var navTitleLabel = UILabel()
        navTitleLabel.frame = titleSize
        navTitleLabel.autoresizesSubviews = true
        navTitleLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        navTitleLabel.text = marker.title
        navTitleLabel.textAlignment = NSTextAlignment.Center
        
        var textSize = CGRect(x: 0, y: 25, width: wBounds, height: 50)
        
        var mTextView: UITextView = UITextView()
        mTextView.frame = textSize
        mTextView.autoresizesSubviews = true
        mTextView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        mTextView.backgroundColor = UIColor(white: 1, alpha: 0)
        mTextView.text = marker.snippet
        mTextView.textAlignment = NSTextAlignment.Left
        
        var navbarHeight = self.navigationController?.navigationBar.frame.origin.y
        var statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        var windowHeight = navbarHeight! + statusbarHeight + 10
        
        var mWindow = UIView(frame:CGRectMake(0, 0, self.view.frame.width, 80))
        mWindow.autoresizesSubviews = true
        mWindow.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        mWindow.backgroundColor = UIColor(white: 1, alpha: 0.6)
        mWindow.tag = 50
        mWindow.addSubview(navTitleLabel)
        mWindow.addSubview(mTextView)
        
        self.mapView.addSubview(mWindow)
    }
    
    // 移除副表單
    private func removeSubviews(viewTag: NSInteger){
        var subviews = self.mapView.subviews
        for subview in subviews {
            subview.viewWithTag(viewTag)?.removeFromSuperview()
        }
    }
    
    // 繪製地標
    func drawMaker() {
        var ibikeData = BikeData()
        ibikeList = ibikeData.getBikeList()
        
        var camera = GMSCameraPosition.cameraWithTarget(CLLocationCoordinate2DMake(24.150381, 120.669015), zoom: 13)
        
        //self.mapView.frame = CGRectZero
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
        self.mapView.tag = 88
        
        var selectMarker: GMSMarker!
        
        for temp in ibikeList {
            
            var tempDetail = temp as BikeViewData
            var market = GMSMarker()
            
            market.position = CLLocationCoordinate2DMake(tempDetail.lat, tempDetail.lng)
            market.title = "站名:\(tempDetail.sna)"
            market.snippet = "可借數量:\(tempDetail.sbi) \n可停數量:\(tempDetail.bemp) \n更新時間:\(tempDetail.update)"
            
            // ubike 庫存率
            let iSbi = (tempDetail.sbi as NSNumber).doubleValue
            let iBemp = (tempDetail.bemp as NSNumber).doubleValue
            let total = iSbi + iBemp
            let balance: Double = iSbi / total
            
            if(balance == 0.0) { // 0% up 無車可借
                market.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
            } else if(balance == 1.0) { // 100% up 車位已滿
                market.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            } else { // 1~99% 正常運作
                market.icon = GMSMarker.markerImageWithColor(UIColor(red: 0.1, green: 128/255.0, blue: 0.1, alpha: 1.0))
            }
            
            market.map = self.mapView
            
            if selectSna == tempDetail.sna {
                selectMarker = market
            }
        }
        
        if (selectSna != "") {
            moveToMarker(selectMarker)
            selectSna = ""
        }
    }

}

