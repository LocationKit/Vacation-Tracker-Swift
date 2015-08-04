//
//  VTVisitListViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import UIKit

class VTVisitListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var visits = NSMutableArray()
    var trip = VTTrip()
    let cellID = "VisitCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.visits = self.trip.visitHandler.visits
        self.navigationItem.title = "Visits in \(self.trip.tripName.capitalizedStringWithLocale(NSLocale.currentLocale()))"
        self.visits = NSMutableArray(array: self.trip.visitHandler.visits.copy() as! NSArray)
        self.tableView.reloadData()
        
        VTTripHandler.registerVisitObserver { (note) -> Void in
            if note.name != VTNotifications.VisitsChanged {
                return;
            }
            if (note.object as! [AnyObject])[0] as! NSString == self.trip.tripName {
                var oldCount = self.visits.count
                self.visits = ((note.object as! [AnyObject])[1] as! NSMutableArray).copy() as! NSMutableArray
                if !((note.object as! [AnyObject])[1].count < oldCount) {
                    self.tableView.reloadData()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func getVisitForIndex(index: Int) -> VTVisit {
        let lastIndex = self.visits.count - 1
        return self.visits[lastIndex - index] as! VTVisit
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visits.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("VisitDetailSegueID", sender: tableView)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: VTVisitViewCell? = self.tableView.dequeueReusableCellWithIdentifier(cellID) as! VTVisitViewCell?
        if cell == nil {
            self.tableView.registerNib(UINib(nibName: "VTVisitViewCell", bundle: nil), forCellReuseIdentifier: cellID)
            cell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as! VTVisitViewCell?
        }
        cell?.setVisit(self.getVisitForIndex(indexPath.row))
        let category = self.getVisitForIndex(indexPath.row).place.venue.category
        if category == nil {
            cell?.imageView?.image = UIImage(named: "map-button-item")
        }
        else {
            switch category {
            case "Automotive":
                cell?.imageView?.image = UIImage(named: "category-automotive")
            case "Bars and Nightlife":
                cell?.imageView?.image = UIImage(named: "category-bars")
            case "Community and Public Services":
                cell?.imageView?.image = UIImage(named: "category-community")
            case "Culture and Attractions":
                cell?.imageView?.image = UIImage(named: "category-attractions")
            case "Education":
                cell?.imageView?.image = UIImage(named: "category-education")
            case "Entertainment":
                cell?.imageView?.image = UIImage(named: "category-entertainment")
            case "Financial":
                cell?.imageView?.image = UIImage(named: "category-financial")
            case "Fitness Sports and Recreation":
                cell?.imageView?.image = UIImage(named: "category-fitness")
            case "Grocery":
                cell?.imageView?.image = UIImage(named: "category-grocery")
            case "Home and Garden":
                cell?.imageView?.image = UIImage(named: "category-home-garden")
            case "Legal":
                cell?.imageView?.image = UIImage(named: "category-legal")
            case "Medical":
                cell?.imageView?.image = UIImage(named: "category-medical")
            case "Organizations and Associations":
                cell?.imageView?.image = UIImage(named: "category-professional")
            case "Personal Care and Services":
                cell?.imageView?.image = UIImage(named: "category-personal-care")
            case "Professional":
                cell?.imageView?.image = UIImage(named: "category-professional")
            case "Residential":
                cell?.imageView?.image = UIImage(named: "category-residential")
            case "Restaurants":
                cell?.imageView?.image = UIImage(named: "category-restaurant")
            case "Retail":
                cell?.imageView?.image = UIImage(named: "category-retail")
            case "Travel":
                cell?.imageView?.image = UIImage(named: "category-travel")
            default:
                cell?.imageView?.image = UIImage(named: "map-button-item")
            }
        }
        return cell!
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VisitDetailSegueID" {
            let visit = self.getVisitForIndex(self.tableView.indexPathForSelectedRow()!.row)
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow()!, animated: true)
            (segue.destinationViewController as! VTVisitDetailViewController).visit = visit
        }
    }
}
