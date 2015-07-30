//
//  VTTabBarViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/29/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation
import UIKit

class VTTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.tabBar.tintColor = UIColor(red: 0.97, green: 0.33, blue: 0.1, alpha: 1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce") {
            VTTabBarViewController.showWelcome(self)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static func showWelcome(sender: UIViewController) {
        // Welcome page
        var welcomePage = OnboardingContentViewController(title: "Welcome!", body: "Thank you for downloading VacationTracker.", image: nil, buttonText: nil, action: nil)
        welcomePage.titleTextColor = UIColor(red: 0.97, green: 0.33, blue: 0.1, alpha: 1)
        welcomePage.underTitlePadding = 185
        
        // First info page
        var firstPage = OnboardingContentViewController(title: "Introduction", body: "VacationTracker automatically saves the places you visit during your vacations so they can easily be viewed later.", image: nil, buttonText: nil, action: nil)
        firstPage.underTitlePadding = 150
        
        // Second info page
        var secondPage = OnboardingContentViewController(title: "Features", body: "Visits can be shown on the map or viewed in the list view. When viewing a visit, you can add a rating and comments.", image: nil, buttonText: nil, action: nil)
        secondPage.underTitlePadding = 150
        
        // Third info page
        var thirdPage = OnboardingContentViewController(title: "Controls", body: "You can use the search button to discover places around you, and the pin button creates a visit at your current location.", image: nil, buttonText: "Get Started!") { () -> Void in
            sender.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().statusBarHidden = false
        }
        thirdPage.underTitlePadding = 150
        thirdPage.buttonTextColor = UIColor(red: 0.97, green: 0.33, blue: 0.1, alpha: 1)
        
        // Main onboarding vc
        var onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "info-background"), contents: [welcomePage, firstPage, secondPage, thirdPage])
        
        // Configures appearance
        onboardingVC.topPadding = 10
        onboardingVC.bottomPadding = 10
        onboardingVC.shouldFadeTransitions = true
        
        // Configures page control
        onboardingVC.pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        onboardingVC.pageControl.backgroundColor = UIColor.clearColor()
        onboardingVC.pageControl.opaque = false
        
        // Allows info to be skipped
        onboardingVC.allowSkipping = true
        onboardingVC.skipHandler = { () -> Void in
            sender.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().statusBarHidden = true
        }
        
        sender.presentViewController(onboardingVC, animated: true, completion: nil)
        UIApplication.sharedApplication().statusBarHidden = true
    }
}