//
//  VTTrip.swift
//  Vacation-Tracker
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTTrip: NSObject, NSCoding {
    var tripName: NSString = NSString()
    var visitHandler: VTVisitHandler = VTVisitHandler()
    
    init(name: NSString?) {
        if name == nil {
            self.tripName = "Unknown Location"
        }
        else {
            self.tripName = name!.capitalizedStringWithLocale(NSLocale.currentLocale())
        }
    }
    
    func addVisit(visit: VTVisit) -> Void {
        NSLog("Adding visit. address %@", visit.place.address)
        visitHandler.addVisit(visit)
    }
    
    override init() {
        super.init()
        self.tripName = NSString()
        self.visitHandler = VTVisitHandler()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.tripName = aDecoder.decodeObjectForKey("self.tripName") as! NSString
        self.visitHandler = aDecoder.decodeObjectForKey("self.visitHandler") as! VTVisitHandler
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.tripName, forKey: "self.tripName")
        aCoder.encodeObject(self.visitHandler, forKey: "self.visitHandler")
    }
}