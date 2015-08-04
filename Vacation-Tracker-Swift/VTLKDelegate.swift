//
//  VTLKDelegate.swift
//  Vacation-Tracker
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTLKDelegate: NSObject, LocationKitDelegate {
    func locationKit(locationKit: LocationKit!, didUpdateLocation location: CLLocation!) {
        println("Location update at <\(location.coordinate.latitude), \(location.coordinate.longitude)>");
        
        LocationKit.sharedInstance().getCurrentPlaceWithHandler { (place, error) -> Void in
            if (error == nil) {
                println("The user is in \(place.venue.name) in \(place.address.locality)")
            }
            else {
                println("error fetching place: \(error)")
                
            }
        }
    }
    
    func locationKit(locationKit: LocationKit!, didStartVisit visit: LKVisit!) {
        println("Visit started.")
        VTTripHandler.addVisit(VTVisit(visit: visit), forTrip: VTTrip(name: visit.place.address.locality))
    }
    
    func locationKit(locationKit: LocationKit!, didEndVisit visit: LKVisit!) {
        println("Visit ended.")
    }
    
    func locationKit(locationKit: LocationKit!, didFailWithError error: NSError!) {
        println("LocationKit failed with error: \(error)")
    }
}