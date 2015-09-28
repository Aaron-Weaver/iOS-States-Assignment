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
        
        print("lol")
        states = StatesActions(jsonFileName: "states")
        numberOfHeaders = states.getNumberOfStateGroups()
        stateSectionTitles = states.getSortedListOfIndexLetters()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfHeaders
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.getStatesBeginningWithLetter(self.stateSectionTitles[section]).count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = self.tableView.dequeueReusableCellWithIdentifier("SectionHeader") as? SectionHeaderCell
        
        if headerCell == nil
        {
            let nibs = NSBundle.mainBundle().loadNibNamed("SectionHeaderCell", owner: self, options: nil)
            headerCell = nibs[0] as? SectionHeaderCell
        }
        
        headerCell!.SectionHeaderLabel!.text = stateSectionTitles[section]
        return headerCell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var stateInfoCell = self.tableView.dequeueReusableCellWithIdentifier("StateInfoCell") as? StateInformationCell
        
        if stateInfoCell == nil
        {
            let nibs = NSBundle.mainBundle().loadNibNamed("StateInformationCell", owner: self, options: nil)
            stateInfoCell = nibs[0] as? StateInformationCell
        }
        
        let stateInCell: StateInformation! = states.getStatesBeginningWithLetter(self.stateSectionTitles[indexPath.section])![indexPath.row]
        
        let cellTitle: String! = stateInCell!.stateTitle!
        let cellSubTitle: String! = stateInCell!.stateSubTitle!
        
        stateInfoCell!.StateTitleLabel!.text = cellTitle!
        stateInfoCell!.StateSubtitleLabel!.text = cellSubTitle!
        
        return stateInfoCell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("stateDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailView: StateViewController  = segue.destinationViewController as! StateViewController
        let selectedRow: NSIndexPath = self.tableView.indexPathForSelectedRow!
        let stateInCell: StateInformation! = states.getStatesBeginningWithLetter(self.stateSectionTitles[selectedRow.section])![selectedRow.row]
        detailView.stateInfo = stateInCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
}