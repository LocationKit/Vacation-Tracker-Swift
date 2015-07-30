//
//  VTTripAnnotation.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation
import MapKit

class VTTripAnnotation: MKPointAnnotation {
    var trip: VTTrip = VTTrip()
    
    required init(trip: VTTrip) {
        super.init()
        self.trip = trip
    }
}