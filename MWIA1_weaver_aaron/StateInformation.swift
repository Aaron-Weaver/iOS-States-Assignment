//
//  StateInformation.swift
//  MWIA1_weaver_aaron
//
//  Created by Aaron Weaver on 9/22/15.
//  Copyright © 2015 App Weava. All rights reserved.
//

import Foundation

class StateInformation
{
    var stateTitle: String?
    var stateSubTitle: String?
    var stateVisited: Bool?
    var stateBoundaries: [BoundaryPoint]!
    
    init()
    {
        
    }
    
    init(stateTitle: String, stateSubTitle: String)
    {
        self.stateTitle = stateTitle
        self.stateSubTitle = stateSubTitle
    }
    
    func getStateCenterPoint() -> BoundaryPoint
    {
        
        let numPoints = Double((stateBoundaries?.count)!)
        var x: Double = 0
        var y: Double = 0
        
        for element in stateBoundaries!
        {
            print(String(element.longitude))
            x += element.latitude
            y += element.longitude
        }
        
        x = x / numPoints
        y = y / numPoints
        
        return BoundaryPoint(latitude: x, longitude: y)
    }
}

class BoundaryPoint {
    var latitude: Double!
    var longitude: Double!
    
    init(latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init()
    {
        
    }
}