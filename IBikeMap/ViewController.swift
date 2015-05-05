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
    
    var selectSna = ""
    private var ibikeList = NSArray()
    private var selectMarker: GMSMarker?
    private var onFocusSna = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        drawMaker()
        
        self.bannerView.adUnitID = "ca-app-pub-9476662783947033/6247524104"
        
        self.bannerView.rootViewController = self
        
        self.bannerView.backgroundColor = UIColor.blackColor()
        
        var request: GADRequest = GADRequest()
        
        request.testDevices = ["d744895655b7a2536fe4da3cfb24721cec0b2cfb"]
        
        self.bannerView.loadRequest(request)
        
        self.view.addSubview(self.bannerView)
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
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            var diffLatitude = abs(self.mapView.myLocation.coordinate.latitude - position.target.latitude) as Double
            var diffLongitude = abs(self.mapView.myLocation.coordinate.longitude - position.target.longitude) as Double
        
            if self.mapView.myLocationEnabled {
                if (diffLatitude < 0.000001 && diffLongitude < 0.000001) {
                    removeSubviews(50)
                }
            }
        }
    }
    
    private func moveToMarker(marker: GMSMarker) {
        var ibikeData = BikeData()
        ibikeList = ibikeData.getBikeList()
        let favoriteList = ibikeData.readData()
        var camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 16)
        self.mapView.camera = camera
        
        var infoTitle = ""
        var infoSnippet = ""
        
        removeSubviews(50)
        
        for temp in ibikeList {
            var tempDetail = temp as! BikeViewData
            
            if marker.title == tempDetail.sna {
                onFocusSna = tempDetail.sna
                infoTitle = "站名:\(tempDetail.sna)"
                infoSnippet = "可借數量:\(tempDetail.sbi)  可停數量:\(tempDetail.bemp) \n更新時間:\(tempDetail.update)"
            }
        }
        
        var viewWidth = self.mapView.frame.width
        
        // 標題
        var titleSize = CGRect(x: 0, y: 10, width: viewWidth, height: 20)
        
        var navTitleLabel = UILabel()
        navTitleLabel.frame = titleSize
        navTitleLabel.font = UIFont.boldSystemFontOfSize(18.0)
        navTitleLabel.autoresizesSubviews = true
        navTitleLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        navTitleLabel.text = infoTitle
        navTitleLabel.textAlignment = NSTextAlignment.Center
        
        // 內文
        var textSize = CGRect(x: 0, y: 30, width: viewWidth, height: 50)
        
        var mTextView: UITextView = UITextView()
        mTextView.frame = textSize
        mTextView.font = UIFont.systemFontOfSize(15.0)
        mTextView.editable = false
        mTextView.autoresizesSubviews = true
        mTextView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        mTextView.backgroundColor = UIColor(white: 1, alpha: 0)
        mTextView.text = infoSnippet
        mTextView.textAlignment = NSTextAlignment.Left
        
        // 加到最愛按鈕
        var buttonSize = CGRect(x: (viewWidth - 60), y: 15, width: 45, height: 45)
        
        var imageName = "un_star.png"
        for temp in favoriteList  {
            if (temp as! NSString) == onFocusSna {
                imageName = "star.png"
            }
        }
        
        let buttonImage = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let mButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        
        mButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        mButton.frame = buttonSize
        mButton.backgroundColor = UIColor.clearColor()
        mButton.setImage(buttonImage, forState: .Normal)
        mButton.addTarget(self, action: Selector("starButton:"), forControlEvents: .TouchUpInside)
        
        var navbarHeight = self.navigationController?.navigationBar.frame.origin.y
        var statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        var windowHeight = navbarHeight! + statusbarHeight + 10
        
        var mWindow = UIView(frame:CGRectMake(0, 0, viewWidth, 80))
        mWindow.autoresizesSubviews = true
        mWindow.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        mWindow.backgroundColor = UIColor(white: 1, alpha: 0.6)
        mWindow.tag = 50
        mWindow.addSubview(navTitleLabel)
        mWindow.addSubview(mTextView)
        mWindow.addSubview(mButton)
        
        self.mapView.addSubview(mWindow)
        
        //Constraints
        let viewsDict = ["btn": mButton]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[btn]-15-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[btn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
            
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[btn(==45)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
            
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[btn(==45)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        
        selectMarker = marker
    }
    
    // 加入最愛
    func starButton(sender: UIButton!) {
        var ibikeData = BikeData()
        let favoriteList = ibikeData.readData()
        var haveStar = false
        
        for temp in favoriteList  {
            if temp as? NSString == onFocusSna {
                haveStar = true
            }
        }
        
        if haveStar {
            favoriteList.removeObject(onFocusSna)
            ibikeData.delData(favoriteList)
        } else {
            ibikeData.addData("\(onFocusSna)")
        }
        
        if selectMarker != nil {
            moveToMarker(selectMarker!)
        }
    }
    
    // 移除副表單
    private func removeSubviews(viewTag: NSInteger){
        var subviews = self.mapView.subviews
        
        for subview in subviews {
            subview.viewWithTag(viewTag)?.removeFromSuperview()
        }
        onFocusSna = ""
        selectMarker = nil
    }
    
    // 繪製地標
    func drawMaker() {
        var ibikeData = BikeData()
        ibikeList = ibikeData.getBikeList()
        
        removeSubviews(50)
        
        var defaultLocation = CLLocationCoordinate2DMake(24.150381, 120.669015)
        
        if self.mapView.myLocation != nil {
            defaultLocation = self.mapView.myLocation.coordinate
        }
        
        var camera = GMSCameraPosition.cameraWithTarget(defaultLocation, zoom: 14)
        
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
        self.mapView.tag = 88
        
        var selectMarker: GMSMarker?
        
        for temp in ibikeList {
            
            var tempDetail = temp as! BikeViewData
            var market = GMSMarker()
            
            market.position = CLLocationCoordinate2DMake(tempDetail.lat, tempDetail.lng)
            market.title = "\(tempDetail.sna)"
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
        
        if (selectSna != "" && selectMarker != nil) {
            moveToMarker(selectMarker!)
            selectSna = ""
        }
    }

}

