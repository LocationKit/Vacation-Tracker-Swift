//
//  AppDelegate.swift
//  Vacation-Tracker
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

    var window: UIWindow?
    let locationDelegate: VTLKDelegate = VTLKDelegate()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        VTTripHandler.loadTripData()
        let apiToken = "d735e0f01bef83d5"
        LocationKit.sharedInstance().startWithApiToken(apiToken, andDelegate: locationDelegate);
        //self.checkAlwaysAuthorization();
        // Override point for customization after application launch.
        return true
    }
    
    /*func checkAlwaysAuthorization() -> Void {
        let status = CLLocationManager.authorizationStatus()
        
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.Denied) {
            let title = (status == CLAuthorizationStatus.Denied) ? "Location services are off" : "Background location is not enabled"
            let message = "To use background location you must turn on 'Always' in the Location Services Settings"
            
            let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Settings", nil)
            alertView.show()
        }
        
        else if (status == CLAuthorizationStatus.NotDetermined) {
            let manager = CLLocationManager()
            if (manager.respondsToSelector(Selector("requestAlwaysAuthorization"))) {
                manager.requestAlwaysAuthorization()
            }
        }
    }*/
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        let backgroundID = application.beginBackgroundTaskWithName("LoadData", expirationHandler: { () -> Void in
            reply(nil)
        })
        VTTripHandler.loadTripData()
        let fm = NSFileManager.defaultManager()
        let tripPath = self.docsPath().stringByAppendingPathComponent("trips")
        
        if (fm.fileExistsAtPath(tripPath)) {
            let replyData = NSKeyedArchiver.archivedDataWithRootObject(NSKeyedUnarchiver.unarchiveObjectWithFile(tripPath)!)
            reply(["trips": replyData])
        }
        application.endBackgroundTask(backgroundID)
    }
    
    func docsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        VTTripHandler.saveTripData()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        VTTripHandler.saveTripData()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

