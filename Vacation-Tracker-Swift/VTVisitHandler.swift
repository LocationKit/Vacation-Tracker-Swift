//
//  VTVisitHandler.swift
//  Vacation-Tracker
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTVisitHandler: NSObject, NSCoding {
    var visits: NSMutableArray = NSMutableArray()
    var tripName: NSString = NSString()
    
    func addVisit(visit: VTVisit) {
        NSLog("adding in visithandler %@", visit.place.address)
        visits.addObject(visit)
        VTTripHandler.notifyVisitChange([self.tripName, self.visits])
    }
    
    func removeVisitAtIndex(index: Int) {
        self.visits.removeObjectAtIndex(index)
        VTTripHandler.notifyVisitChange([self.tripName, self.visits])
    }
    
    override init() {
        super.init()
        self.visits = NSMutableArray()
        self.tripName = NSString()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.visits = aDecoder.decodeObjectForKey("self.visits") as! NSMutableArray
        self.tripName = aDecoder.decodeObjectForKey("self.tripName") as! NSString
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.visits, forKey: "self.visits")
        aCoder.encodeObject(self.tripName, forKey: "self.tripName")
    }
}