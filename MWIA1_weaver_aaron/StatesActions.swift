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
    private var statesDict: Dictionary<String, [StateInformation]>!
    
    init(jsonFileName: String)
    {
        self.statesDict = readStatesFromJson(jsonFileName)
    }
    
    private func readStatesFromJson(jsonFileName: String) -> Dictionary<String, [StateInformation]>!
    {
        var statesDict: Dictionary<String, [StateInformation]>! = Dictionary<String, [StateInformation]>()
        
        print("Starting view")
        if let jsonFile = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: "json")
        {
            print("File Exists")
            if let jsonData = NSData(contentsOfFile: jsonFile)
            {
                //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding)!)
                
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                    print("made it")
                    print(json[0])
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
                                        statesList.append(StateInformation(stateTitle: String(element["name"]!), stateSubTitle: String(element["abbreviation"]!)))
                                    }
                                    
                                    print(String(Character(UnicodeScalar(val))))
                                    
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