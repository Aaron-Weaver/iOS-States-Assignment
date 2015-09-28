//
//  StatesJsonParser.swift
//  MWIA1_weaver_aaron
//
//  Created by Aaron Weaver on 9/19/15.
//  Copyright © 2015 App Weava. All rights reserved.
//

import Foundation

class StatesActions
{
    var statesDict: Dictionary<String, [StateInformation]>!
    
    init(jsonFileName: String)
    {
        self.statesDict = readStatesFromJson(jsonFileName)
    }
    
    init()
    {
        
    }
    
    private func getBoundariesForState(jsonFileName: String, stateName: String) -> [BoundaryPoint]!
    {
        var stateBoundaries = [BoundaryPoint]()
        
        if let jsonFile = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: jsonFile)
            {
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                    
                    let statesJson = json["states"] as! [String:AnyObject!]
                    let stateArray = statesJson["state"]! as! [AnyObject!]
                    
                    for var i = 0; i < stateArray.count; i++
                    {
                        let state = stateArray[i] as! [String:AnyObject!]
                        
                        let stateJsonName = state["-name"] as! String!
                        
                        if stateJsonName == stateName
                        {
                            let stateBoundariesJson = state["point"] as! [[String:String!]]
                            
                            for element in stateBoundariesJson
                            {
                                let latitude = element["-lat"] as String!
                                let longitude = element["-lng"] as String!
                                
                                print(latitude)
                                print(longitude)
                                
                                stateBoundaries.append(BoundaryPoint(latitude: Double(latitude)!, longitude: Double(longitude)!))
                            }
                            
                            return stateBoundaries
                        }
                    }
                }
                catch
                {
                    
                }
            }
        }
        return stateBoundaries
    }
    
    private func readStatesFromJson(jsonFileName: String) -> Dictionary<String, [StateInformation]>!
    {
        var statesDict: Dictionary<String, [StateInformation]>! = Dictionary<String, [StateInformation]>()
        
        if let jsonFile = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: jsonFile)
            {
                //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding)!)
                
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                    //let stateArr = try NSJSONSerialization.JSONObjectWithData(json[0] as! NSData, options: NSJSONReadingOptions.MutableContainers)
                    
                    for var i = 0; i < json.count; i++
                    {
                        if let stateAlphabetGroup = json[i]! as? [String: AnyObject]
                        {
                            for val in UnicodeScalar("A").value...UnicodeScalar("Z").value
                            {
                                if let stateGroup = stateAlphabetGroup[String(Character(UnicodeScalar(val)))] as? [[String: String]]
                                {
                                    
                                    var statesList = [(StateInformation)]()
                                    
                                    
                                    for element in stateGroup
                                    {
                                        let stateInfo = StateInformation(stateTitle: String(element["name"]!), stateSubTitle: String(element["nickname"]!))
                                        stateInfo.stateBoundaries = self.getBoundariesForState("state_boundaries", stateName: stateInfo.stateTitle!)
                                        
                                        for element in stateInfo.stateBoundaries!
                                        {
                                            print(String(element.latitude) + "  " + String(element.longitude))
                                        }
        
                                        statesList.append(stateInfo)
                                    }
                                    
                                    statesDict[String(Character(UnicodeScalar(val)))] = statesList
                                    break
                                }
                            }
                        }
                    }
                    
                } catch
                {

                }
            }
        }

        return statesDict
    }
    
    func getStatesBeginningWithLetter(letter: String) -> [(StateInformation)]!
    {
        return self.statesDict[letter] as [(StateInformation)]!
    }
    
    func getSortedListOfIndexLetters() -> [(String)]
    {
        return self.statesDict.keys.sort({ $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending })
    }
    
    func getNumberOfStateGroups() -> Int
    {
        return self.statesDict!.count
    }
}