//
//  VTTripListViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTTripListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let cellID = "TripCellID"
    var trips = NSMutableArray()
    var selected = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        VTTripHandler.registerTripObserver { (note) -> Void in
            if note.name != VTNotifications.TripsChanged {
                return;
            }
            self.tableView.reloadData()
        }
    }
    
    func getTripForTableIndex(index: Int) -> VTTrip {
        let maxIndex = VTTripHandler.trips.count - 1
        return VTTripHandler.trips[maxIndex - index] as! VTTrip
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VTTripHandler.trips.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell?
        if cell == nil {
            NSLog("Cell is nil")
            
            self.tableView.registerNib(UINib(nibName: "VTTripViewCell", bundle: nil), forCellReuseIdentifier: cellID)
            cell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell?
        }
        (cell as! VTTripViewCell).setTrip(VTTripHandler.trips[VTTripHandler.trips.count - 1 - indexPath.row] as! VTTrip)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selected = indexPath
        self.performSegueWithIdentifier("ShowTripVisitsID", sender: tableView)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTripVisitsID" {
            self.tableView.deselectRowAtIndexPath((sender?.indexPathForSelectedRow())!, animated: true)
            segue.destinationViewController.setTrip(self.getTripForTableIndex(self.selected.row))
        }
    }
}