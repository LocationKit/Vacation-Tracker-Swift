//
//  VTTripHandler.swift
//  Vacation-Tracker
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

var center = NSNotificationCenter.defaultCenter()

class VTTripHandler: NSObject {
    struct VTNotifications {
        static let TripsChanged = "VTTripsChangedNotification"
        static let VisitsChanged = "VTVisitsChangedNotification"
    }
    
    static var trips: NSMutableArray = NSMutableArray()
    static var tripNames: NSMutableArray = NSMutableArray()
    
    static func registerTripObserver(block: (NSNotification!) -> Void) {
        center.addObserverForName(VTNotifications.TripsChanged, object: nil, queue: nil, usingBlock: block)
    }
    
    static func registerVisitObserver(block: (NSNotification!) -> Void) {
        center.addObserverForName(VTNotifications.VisitsChanged, object: nil, queue: nil, usingBlock: block)
    }
    
    static func notifyTripChange(trips: NSArray) {
        center.postNotificationName(VTNotifications.TripsChanged, object: trips)
        VTTripHandler.saveTripData()
    }
    
    static func notifyVisitChange(data: NSArray) {
        center.postNotificationName(VTNotifications.VisitsChanged, object: data)
        if data[1].count != 0 {
            if tripNames.indexOfObject(data.objectAtIndex(0)) != NSNotFound {
                (trips[tripNames.indexOfObject(data.objectAtIndex(0))] as! VTTrip).visitHandler.visits = data[1] as! NSMutableArray
            }
        }
        VTTripHandler.notifyTripChange(trips)
        VTTripHandler.saveTripData()
    }
    
    static func addVisit(visit: VTVisit, forTrip trip: VTTrip) {
        if tripNames.indexOfObject(trip.tripName) == NSNotFound {
            NSLog("Not found %@", visit.place.address)
            trips.addObject(trip)
            tripNames.addObject(trip.tripName)
            trip.addVisit(visit)
        }
        else {
            NSLog("Found %@", visit.place.address)
            let index = tripNames.indexOfObject(trip.tripName)
            var tripToUpdate = trips.objectAtIndex(index) as! VTTrip
            tripToUpdate.addVisit(visit)
            
            if index != (trips.count - 1) {
                trips.insertObject(tripToUpdate, atIndex: trips.count)
                trips.removeObjectAtIndex(index)
                tripNames.insertObject(tripNames.objectAtIndex(index), atIndex: tripNames.count)
                tripNames.removeObjectAtIndex(index)
            }
        }
        VTTripHandler.notifyTripChange(trips)
    }
    
    static func docsPath() -> NSString {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        return paths[0] as! NSString
    }
    
    static func saveTripData() {
        NSKeyedArchiver.archiveRootObject(trips, toFile: self.docsPath().stringByAppendingPathComponent("trips"))
        NSKeyedArchiver.archiveRootObject(tripNames, toFile: self.docsPath().stringByAppendingPathComponent("tripNames"))
    }
    
    static func loadTripData() {
        let fm = NSFileManager.defaultManager()
        let tripPath = self.docsPath().stringByAppendingPathComponent("trips")
        let namesPath = self.docsPath().stringByAppendingPathComponent("tripNames")
        if fm.fileExistsAtPath(tripPath) {
            trips = NSKeyedUnarchiver.unarchiveObjectWithFile(tripPath) as! NSMutableArray
        }
        if fm.fileExistsAtPath(namesPath) {
            tripNames = NSKeyedUnarchiver.unarchiveObjectWithFile(namesPath) as! NSMutableArray
        }
    }
}