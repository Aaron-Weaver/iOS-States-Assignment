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
    var statesDict: Dictionary<String, [StateInformation]>!
    var stateSectionTitles: [(String)]!
    var numberOfHeaders: Int!
    var statesVisitedCount: Int!
    @IBOutlet weak var statesVisitedCountLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lol")
        states = StatesActions(jsonFileName: "states")
        numberOfHeaders = states.getNumberOfStateGroups()
        stateSectionTitles = states.getSortedListOfIndexLetters()
        statesDict = states.statesDict
        self.statesVisitedCount = 0
        
        for (key, value) in statesDict
        {
            for element in value
            {
                if element.stateVisited == true
                {
                    self.statesVisitedCount = self.statesVisitedCount + 1
                }
            }
        }
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
        return statesDict[self.stateSectionTitles[section]]!.count
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
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("stateDetailSegue", sender: self.tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var stateInfoCell = self.tableView.dequeueReusableCellWithIdentifier("StateInfoCell") as? StateInformationCell
        
        if stateInfoCell == nil
        {
            let nibs = NSBundle.mainBundle().loadNibNamed("StateInformationCell", owner: self, options: nil)
            stateInfoCell = nibs[0] as? StateInformationCell
        }
        
        let stateInCell: StateInformation! = statesDict[self.stateSectionTitles[indexPath.section]]![indexPath.row]
        
        let cellTitle: String! = stateInCell!.stateTitle!
        let cellSubTitle: String! = stateInCell!.stateSubTitle!
        
        stateInfoCell!.StateTitleLabel!.text = cellTitle!
        stateInfoCell!.StateSubtitleLabel!.text = cellSubTitle!
        stateInfoCell!.backgroundColor = UIColor.whiteColor()
        
        if stateInCell.stateVisited == true
        {
            stateInfoCell!.backgroundColor = UIColor.greenColor()
        }
        else
        {
            stateInfoCell!.backgroundColor = UIColor.whiteColor()
        }
        
        return stateInfoCell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let stateInCell: StateInformation! = self.statesDict[self.stateSectionTitles[indexPath.section]]![indexPath.row]
//        
//        if stateInCell.stateVisited! == true
//        {
//            print(stateInCell.stateTitle)
//            cell.backgroundColor = UIColor.greenColor()
//        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let stateInCell: StateInformation! = self.statesDict[self.stateSectionTitles[indexPath.section]]![indexPath.row]
        
        if stateInCell.stateVisited == false
        {
            print("Visited")
            stateInCell.stateVisited = true
            self.statesVisitedCount = self.statesVisitedCount + 1
            self.updateVisitCount()
            self.tableView.reloadData()
        }
        else
        {
            let alert = UIAlertController(title: "Unvisit State", message: "Reset visitation status for \(stateInCell.stateTitle!)?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                
                stateInCell.stateVisited = false
                self.statesVisitedCount = self.statesVisitedCount - 1
                self.updateVisitCount()
                self.tableView.reloadData()
                
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let detailView: StateViewController  = segue.destinationViewController as! StateViewController
        let selectedRow: NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
        let stateInCell: StateInformation! = statesDict[self.stateSectionTitles[selectedRow.section]]![selectedRow.row]
        detailView.stateInfo = stateInCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    private func updateVisitCount()
    {
        self.statesVisitedCountLabel.title = "Visited:\(self.statesVisitedCount)"
    }
    
    @IBAction func resetButtonPressed(sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Clear States Visited", message: "Would you like to reset all states visited back to 0?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in
            
            self.statesVisitedCount = 0
            self.updateVisitCount()
            
            for (key, value) in self.statesDict
            {
                for element in value
                {
                    element.stateVisited = false
                }
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}