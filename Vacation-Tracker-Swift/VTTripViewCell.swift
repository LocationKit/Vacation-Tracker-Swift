//
//  VTTripViewCell.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTTripViewCell: UITableViewCell {
    func setTrip(trip: VTTrip) {
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let numVisits = trip.visitHandler.visits.count
        NSLog("Trip: %@", trip.tripName)
        if trip.tripName.isEqualToString("") {
            self.textLabel?.text = "Unknown Location"
        }
        else {
            NSLog("Nonnull")
            if numVisits == 1 {
                self.textLabel?.text = "\(trip.tripName) (\(numVisits) visit)"
            }
            else {
                self.textLabel?.text = "\(trip.tripName) (\(numVisits) visits)"
            }
        }
    }
}