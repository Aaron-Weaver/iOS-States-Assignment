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
    private var statesDict: Dictionary<String, [String]>!
    
    init(jsonFileName: String)
    {
        self.statesDict = readStatesFromJson(jsonFileName)
        print(self.statesDict)
    }
    
    private func readStatesFromJson(jsonFileName: String) -> Dictionary<String, [String]>!
    {
        var statesDict: Dictionary<String, [String]>! = Dictionary<String, [String]>()
        
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
                        let stateAlphabetGroup = json[i]
                        for val in UnicodeScalar("A").value...UnicodeScalar("Z").value
                        {
                            if let stateGroup = stateAlphabetGroup[String(Character(UnicodeScalar(val)))] as? NSArray
                            {
                                var statesList = [(String)]()
                                
                                for element in stateGroup
                                {
                                    statesList.append(element["name"] as! String)
                                }
                                
                                statesDict[String(Character(UnicodeScalar(val)))] = statesList
                                break;
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
    
    func getStatesBeginningWithLetter(letter: String) -> NSArray
    {
        return self.statesDict[letter]! as NSArray
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