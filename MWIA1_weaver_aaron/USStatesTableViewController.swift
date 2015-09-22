//
//  USStatesTableViewController.swift
//  MWIA1_weaver_aaron
//
//  Created by Aaron Weaver on 9/17/15.
//  Copyright © 2015 App Weava. All rights reserved.
//

import UIKit

class USStatesTableViewController: UITableViewController {
    
    var states: StatesActions!
    var stateSectionTitles: [(String)]!
    var numberOfHeaders: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        states = StatesActions(jsonFileName: "states")
        numberOfHeaders = states.getNumberOfStateGroups()
        stateSectionTitles = states.getSortedListOfIndexLetters()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}