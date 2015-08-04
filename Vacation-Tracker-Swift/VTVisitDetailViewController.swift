//
//  VTVisitDetailViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import UIKit
import MapKit

class VTVisitDetailViewController: UIViewController {
    let MILE_TO_METER = 0.00062137
    @IBOutlet weak var mapView: MKMapView!
    var visit = VTVisit()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var address_0: UILabel!
    @IBOutlet weak var address_1: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStepper: UIStepper!
    var placeName: NSString? = NSString()
    var name = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingLabel.text = String(format: "Rating: %.f", self.visit.rating)
        self.ratingStepper.value = self.visit.rating
        
        if let place = visit.place.venue.name {
            self.placeName = visit.place.venue.name
        }
        else {
            self.placeName = nil
        }
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
        self.addAnnotation()
        if placeName == nil {
            self.navigationItem.title = "Visit to \(name)"
        }
        else {
            self.navigationItem.title = "Visit to \(self.placeName!)"
        }
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        self.dateLabel.text = dateFormatter.stringFromDate(visit.arrivalDate)
        dateFormatter.dateFormat = "h:mm a"
        self.timeLabel.text = dateFormatter.stringFromDate(visit.arrivalDate)
        
        self.address_0.text = name
        self.address_1.text = "\(address.locality.capitalizedString) \(address.region) \(address.postalCode)"
        
        if let category = self.visit.place.venue.category {
            self.categoryLabel.text = category
        }
        else {
            self.categoryLabel.text = "None"
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapStepper(sender: AnyObject) {
        self.visit.rating = self.ratingStepper.value
        self.ratingLabel.text = String(format: "Rating: %.f", self.visit.rating)
        VTTripHandler.notifyTripChange(VTTripHandler.trips)
    }
    
    func addAnnotation() {
        var annotation = MKPointAnnotation()
        if placeName == nil {
            annotation.title = "Visit to \(self.name)"
        }
        else {
            annotation.title = self.placeName as! String
        }
        annotation.coordinate = self.visit.place.address.coordinate
        self.mapView.centerCoordinate = annotation.coordinate
        self.mapView.mapType = MKMapType.Hybrid
        self.mapView.region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 0.1 / MILE_TO_METER, 0.1 / MILE_TO_METER)
        self.mapView.addAnnotation(annotation)
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsToCommentsSegueID" {
            ((segue.destinationViewController as! UINavigationController).viewControllers[0] as! VTVisitCommentsViewController).visit = self.visit
        }
    }

}
