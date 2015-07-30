//
//  VTVisit.swift
//  Vacation-Tracker
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTVisit: NSObject, NSCoding {
    var arrivalDate: NSDate
    var departureDate: NSDate?
    var place: LKPlace
    
    var rating: Double
    var comments: NSString
    
    override init() {
        self.arrivalDate = NSDate()
        self.departureDate = NSDate()
        self.place = LKPlace()
        
        self.rating = 5
        self.comments = NSString()
    }
    
    init(visit: LKVisit) {
        self.arrivalDate = visit.arrivalDate
        self.departureDate = visit.departureDate
        NSLog("%@", visit.place)
        self.place = visit.place
        
        self.rating = 5
        self.comments = NSString()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.arrivalDate = aDecoder.decodeObjectForKey("self.arrivalDate") as! NSDate
        self.departureDate = aDecoder.decodeObjectForKey("self.departureDate") as? NSDate
        self.place = aDecoder.decodeObjectForKey("self.place") as! LKPlace
        self.rating = aDecoder.decodeObjectForKey("self.rating") as! Double
        self.comments = aDecoder.decodeObjectForKey("self.comments") as! NSString
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.arrivalDate, forKey: "self.arrivalDate")
        aCoder.encodeObject(self.departureDate, forKey: "self.departureDate")
        aCoder.encodeObject(self.place, forKey: "self.place")
        aCoder.encodeObject(self.rating, forKey: "self.rating")
        aCoder.encodeObject(self.comments, forKey: "self.comments")
    }
}