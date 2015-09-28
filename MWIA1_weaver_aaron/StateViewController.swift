//
//  ViewController.swift
//  MWIA1_weaver_aaron
//
//  Created by Aaron Weaver on 9/17/15.
//  Copyright © 2015 App Weava. All rights reserved.
//

import UIKit
import GoogleMaps

class StateViewController: UIViewController {

    var stateInfo: StateInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let stateCenter = stateInfo.getStateCenterPoint()
        
        print(stateCenter.longitude!)
        print(stateCenter.latitude!)
        
        let camera = GMSCameraPosition.cameraWithLatitude(stateCenter.latitude!,
            longitude: stateCenter.longitude!, zoom: 4)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(stateCenter.latitude!, stateCenter.longitude!)
        marker.title = stateInfo.stateTitle
        marker.snippet = stateInfo.stateSubTitle
        marker.map = mapView
        
        let path = GMSMutablePath()
        for element in stateInfo.stateBoundaries
        {
            path.addCoordinate(CLLocationCoordinate2DMake(element.latitude, element.longitude))
        }
        let stateOutline = GMSPolyline(path: path)
        stateOutline.map = mapView
        
        print(stateInfo!.stateTitle!)
        self.title = stateInfo.stateTitle!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

