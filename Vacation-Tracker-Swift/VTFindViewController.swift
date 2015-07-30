//
//  VTFindViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation
import MapKit

class VTFindViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let searching: UIAlertController = UIAlertController(title: "Searching...", message: "Finding places around you. This may take a minute.", preferredStyle: UIAlertControllerStyle.Alert)
    static var lastFoundPlaces = NSArray()
    static var lastLocation: CLLocation? = CLLocation()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.removeAnnotations()
        self.markNearbyPlaces()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        else {
            var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("NearbyAnnotationID") as! MKPinAnnotationView?
            if annotationView != nil {
                annotationView?.annotation = annotation
            }
            else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "NearbyAnnotationID")
            }
            annotationView?.pinColor = MKPinAnnotationColor.Purple
            annotationView?.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        if !(views[0].annotation as AnyObject).isKindOfClass(MKUserLocation) {
            self.searching.dismissViewControllerAnimated(true, completion: nil)
            if VTFindViewController.lastLocation != nil {
                self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(VTFindViewController.lastLocation!.coordinate, 1000, 1000), animated: true)
            }
        }
    }
    
    func removeAnnotations() {
        let userLocation = self.mapView.userLocation
        var pins = NSMutableArray(array: self.mapView.annotations)
        if userLocation != nil {
            pins.removeObject(userLocation)
        }
        self.mapView.removeAnnotations(pins as [AnyObject])
    }
    
    func markNearbyPlaces() {
        self.presentViewController(searching, animated: false, completion: nil)
        // Gets the user's current location to use for the search requests
        LocationKit.sharedInstance().getCurrentLocationWithHandler { (location, error) -> Void in
            // If there is no error, continue
            if error == nil && location != nil {
                // If the user is close to the last search location, there is no need to re-search.  The old search is simply displayed
                if VTFindViewController.lastLocation != nil && location.distanceFromLocation(VTFindViewController.lastLocation) <= 30 {
                    self.mapView.addAnnotations(VTFindViewController.lastFoundPlaces as [AnyObject])
                }
                // Otherwise, a search is actually performed
                else {
                    VTFindViewController.lastLocation = location
                    
                    // Search request with current location is created and sent
                    let searchRequest = LKSearchRequest(location: location)
                    LocationKit.sharedInstance().searchForPlacesWithRequest(searchRequest, completionHandler: { (places, error) -> Void in
                        if places == nil || places.count == 0 {
                            self.showErrorWithMessage("No places found.")
                        }
                        else if error == nil {
                            self.markPlaces(places)
                        }
                        else {
                            NSLog("Place search error: %@", error)
                            self.showErrorWithMessage("Could not find place")
                        }
                    })
                }
            }
            else {
                NSLog("Location error: %@", error)
                self.showErrorWithMessage("Could not find places")
            }
        }
    }
    
    func showErrorWithMessage(message: String) {
        var error = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        error.view.tintColor = UIColor(red: 0.97, green: 0.33, blue: 0.1, alpha: 1)
        error.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        searching.dismissViewControllerAnimated(false, completion: nil)
        self.presentViewController(error, animated: true, completion: nil)
    }
    
    func markPlaces(places: [AnyObject]) {
        var annotations = NSMutableArray()
        for var x = 0; x < places.count; x++ {
            let currentPlace: LKPlace = places[x] as! LKPlace
            var annotation = MKPointAnnotation()
            annotation.coordinate = currentPlace.address.coordinate
            annotation.title = currentPlace.venue.name
            annotations.addObject(annotation)
        }
        VTFindViewController.lastFoundPlaces = annotations
        self.mapView.addAnnotations(annotations as [AnyObject])
    }
}