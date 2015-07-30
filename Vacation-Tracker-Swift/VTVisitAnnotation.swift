//
//  VTVisitAnnotation.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation
import MapKit

class VTVisitAnnotation: MKPointAnnotation {
    var visit: VTVisit? = nil
    var numbVisits: Int = 0
    
    required init(visit: VTVisit) {
        super.init()
        self.visit = visit
        self.numbVisits = 0
    }
    
    func increaseVisits(numb: Int) {
        self.numbVisits += 1
        if self.numbVisits == 1 {
            self.subtitle = "1 visit"
        }
        else {
            self.subtitle = "\(self.numbVisits) visits"
        }
    }
}