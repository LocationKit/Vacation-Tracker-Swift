//
//  VTMapVisitDetailViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTMapVisitDetailViewController: UIViewController {
    var visit = VTVisit()
    @IBOutlet weak var address_0: UILabel!
    @IBOutlet weak var address_1: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var localityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Creates an array from the street name components separated by a space
        
        var streetName = NSArray()
        println("\(visit) \(visit.place) \(visit.place.address)")
        if self.visit.place.address.streetName != nil {
            streetName = self.visit.place.address.streetName.componentsSeparatedByString(" ")
        }
        var name = self.visit.place.address.streetNumber
        for var x = 0; x < streetName.count; x++ {
            let currentComponent: NSString = streetName[x] as! NSString
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
        if self.visit.place.venue.name == nil {
            self.navigationItem.title = "Visit to \(name)"
        }
        else {
            self.navigationItem.title = "Visit to \(self.visit.place.venue.name)" // Sets navigation bar title to 'Visit to <place name>'
        }
        self.address_0.text = name
        self.address_1.text = "\(self.visit.place.address.locality.capitalizedString) \(self.visit.place.address.region) \(self.visit.place.address.postalCode)"
        self.categoryLabel.text = (self.visit.place.venue.category != nil ? self.visit.place.venue.category : "None")
        self.localityLabel.text = self.visit.place.address.locality
    }
}