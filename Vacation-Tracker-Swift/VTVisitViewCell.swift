//
//  VTVisitViewCell.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTVisitViewCell: UITableViewCell {    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    var placeName = NSString()
    
    func setVisit(visit: VTVisit) {
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if visit.place.venue.name == nil {
            let address = visit.place.address
            
            // Creates an array from the street name components separated by a space
            let streetName = address.streetName.componentsSeparatedByString(" ")
            var name = address.streetNumber
            for var x = 0; x < streetName.count; x++ {
                let currentComponent: NSString = streetName[x]
                // If the component contains a number, ('19th' for example) it should be lowercase
                if currentComponent.intValue != 0 {
                    name = name.stringByAppendingString(" \(streetName[x].lowercaseString)")
                }
                else {
                    // If the component has length one, or is equal to NE, NW, SE, or SW it should be uppercase
                    if currentComponent.length == 1 || currentComponent == "NE" || currentComponent == "NW" || currentComponent == "SE" || currentComponent == "SW" {
                        name = name.stringByAppendingString(" \(currentComponent.uppercaseString)")
                    }
                        // Otherwise it should simply be capitalized
                    else {
                        name = name.stringByAppendingString(" \(streetName[x].capitalizedString)")
                    }
                }
            }
            self.placeNameLabel.text = name
        }
        else {
            self.placeNameLabel.text = visit.place.venue.name
        }
        
        // Time
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        var dateString = dateFormatter.stringFromDate(visit.arrivalDate)
        self.time.text = dateString
        
        // Date
        var difference = NSDate().timeIntervalSinceDate(visit.arrivalDate) // Difference between now and the arrival date
        difference -= fmod(difference, 86400.0) // Number of seconds to the day of the arrival date
        difference /= 86400.0 // Number of days
        if difference < 1.0 && difference >= 0.0 {
            self.date.text = "Today"
        }
        else if difference < 2.0 && difference >= 1.0 {
            self.date.text = "Yesterday"
        }
        else if difference < 8.0 && difference >= 2.0 {
            dateFormatter.dateFormat = "EEEE"
            self.date.text = "Last \(dateFormatter.stringFromDate(visit.arrivalDate))"
        }
        else {
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dateString = dateFormatter.stringFromDate(visit.arrivalDate)
            self.date.text = dateString
        }
    }
}