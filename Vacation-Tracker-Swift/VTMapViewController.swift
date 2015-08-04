//
//  VTMapViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation
import MapKit

class VTMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView! = MKMapView()
    @IBOutlet weak var visitsButton: UIButton! = UIButton()
    @IBOutlet weak var settingsButton: UIBarButtonItem! = UIBarButtonItem()
    @IBOutlet weak var searchButton: UIBarButtonItem! = UIBarButtonItem()
    @IBOutlet weak var displayPrefs: UISegmentedControl! = UISegmentedControl()
    @IBOutlet weak var toolbar: UIToolbar! = UIToolbar()
    var settingsPickerIndex: Int = -1
    
    var visits: NSMutableArray = NSMutableArray()
    var annotations: NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackingButton = MKUserTrackingBarButtonItem(mapView: self.mapView)
        var items = NSMutableArray(array: self.toolbar.items!)
        items.insertObject(trackingButton, atIndex: 0)
        self.toolbar.setItems(items as [AnyObject], animated: false)
        
        self.settingsButton.title = "\u{2699}"
        let font = UIFont(name: "Helvetica", size: 24.0) ?? UIFont.systemFontOfSize(24.0)
        let dict = [NSFontAttributeName: font]
        self.settingsButton.setTitleTextAttributes(dict as [NSObject: AnyObject], forState: UIControlState.Normal)
    }
    
    func showErrorAlertWithMessage(message: String) {
        var error = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let accept = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        error.addAction(accept)
        error.view.tintColor = UIColor(red: 0.97, green: 0.33, blue: 0.1, alpha: 1)
        self.presentViewController(error, animated: true, completion: nil)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if view.annotation.isKindOfClass(VTTripAnnotation) {
            self.performSegueWithIdentifier("MapToVisitsID", sender: view)
        }
        else if view.annotation.isKindOfClass(VTVisitAnnotation) {
            self.performSegueWithIdentifier("MapToVisitDetailID", sender: view)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        else {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("VisitAnnotationID")
            if annotationView != nil {
                annotationView.annotation = annotation
            }
            else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "VisitAnnotationID")
            }
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
            return annotationView
        }
    }
    
    // MARK: - Annotations
    
    func addAnnotations() {
        if self.displayPrefs.selectedSegmentIndex == 1 {
            self.annotations = NSMutableDictionary()
            if self.settingsPickerIndex == -1 {
                for var x = 0; x < VTTripHandler.trips.count; x++ {
                    self.showAllVisitsForTrip(VTTripHandler.trips[x] as! VTTrip)
                }
            }
            else {
                self.showAllVisitsForTrip(VTTripHandler.trips[self.settingsPickerIndex] as! VTTrip)
            }
        }
        else {
            self.showTripsOnMap()
        }
    }
    
    func showTripsOnMap() {
        if self.settingsPickerIndex == -1 {
            for var x = 0; x < VTTripHandler.trips.count; x++ {
                println(x)
                if (VTTripHandler.trips[x] as! VTTrip).visitHandler.visits.count != 0 {
                    var annotation = VTTripAnnotation(trip: VTTripHandler.trips[x] as! VTTrip)
                    annotation.title = VTTripHandler.tripNames[x] as! String
                    annotation.subtitle = "\((VTTripHandler.trips[x] as! VTTrip).visitHandler.visits.count) visits"
                    annotation.coordinate = ((VTTripHandler.trips[x] as! VTTrip).visitHandler.visits[0] as! VTVisit).place.address.coordinate
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        else {
            var annotation = VTTripAnnotation(trip: VTTripHandler.trips[self.settingsPickerIndex] as! VTTrip)
            annotation.title = VTTripHandler.tripNames[self.settingsPickerIndex] as! String
            annotation.subtitle = "\((VTTripHandler.trips[self.settingsPickerIndex] as! VTTrip).visitHandler.visits.count) visits"
            annotation.coordinate = ((VTTripHandler.trips[self.settingsPickerIndex] as! VTTrip).visitHandler.visits[0] as! VTVisit).place.address.coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func showAllVisitsForTrip(trip: VTTrip) {
        for var i = 0; i < trip.visitHandler.visits.count; i++ {
            var visit: VTVisit = trip.visitHandler.visits[i] as! VTVisit
            let placeName: NSString? = visit.place.venue.name
            let uID = visit.place.venue.venueId
            
            if (self.annotations.allKeys as NSArray).indexOfObject(uID) == NSNotFound {
                var annotation = VTVisitAnnotation(visit: visit)
                if placeName == nil {
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
                    annotation.title = name
                }
                else {
                    annotation.title = placeName as! String
                    self.annotations.setObject(annotation, forKey: uID)
                }
                annotation.increaseVisits(1)
                annotation.coordinate = visit.place.address.coordinate
                self.mapView.addAnnotation(annotation)
            }
            else {
                annotations.objectForKey(uID)?.increaseVisits(1)
            }
        }
    }
    
    func removeVisitsFromMap() {
        let userLocation = mapView.userLocation
        var pins = NSMutableArray(array: self.mapView.annotations)
        if userLocation != nil {
            pins.removeObject(userLocation)
        }
        self.mapView.removeAnnotations(pins as [AnyObject])
    }
    
    func reloadAnnotations() {
        if self.visitsButton.titleLabel?.text == "Hide Visits" {
            self.removeVisitsFromMap()
            self.addAnnotations()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapVisits(sender: AnyObject) {
        if self.visitsButton.titleLabel?.text == "Show Visits" {
            self.visitsButton.setTitle("Hide Visits", forState: UIControlState.Normal)
            self.addAnnotations()
        }
        else if self.visitsButton.titleLabel?.text == "Hide Visits" {
            self.visitsButton.setTitle("Show Visits", forState: UIControlState.Normal)
            self.removeVisitsFromMap()
        }
    }
    
    @IBAction func didTapSettings(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowMapSettingsID", sender: self)
    }
    
    @IBAction func didTapDisplayPrefs(sender: AnyObject) {
        if self.visitsButton.titleLabel!.text == "Hide Visits" {
            self.removeVisitsFromMap()
            self.addAnnotations()
        }
    }
    
    @IBAction func didTapSearch(sender: AnyObject) {
        self.performSegueWithIdentifier("NearbyPlacesSegueID", sender: self)
    }
    
    @IBAction func didTapMark(sender: AnyObject) {
        let locating = UIAlertController(title: "Locating...", message: "Finding your current location", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(locating, animated: true, completion: nil)
        LocationKit.sharedInstance().getCurrentPlaceWithHandler { (place, error) -> Void in
            if error == nil && place != nil {
                println("User is in \(place.venue.name) (manual)")
                var visit = VTVisit()
                NSLog("\(place)")
                visit.place = place
                visit.arrivalDate = NSDate()
                VTTripHandler.addVisit(visit, forTrip: VTTrip(name: place.address.locality))
                locating.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                locating.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self .showErrorAlertWithMessage("Could not determine your current place.")
                })
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMapSettingsID" {
            ((segue.destinationViewController as! UINavigationController).viewControllers[0] as! VTMapSettingsViewController).setSelectedRow(self.settingsPickerIndex, sender: self)
        }
        else if segue.identifier == "MapToVisitsID" {
            (segue.destinationViewController as! VTVisitListViewController).trip = (sender!.annotation as! VTTripAnnotation).trip
        }
        else if segue.identifier == "MapToVisitDetailID" {
            (segue.destinationViewController as! VTMapVisitDetailViewController).visit = (sender!.annotation as! VTVisitAnnotation).visit!
        }
    }
}