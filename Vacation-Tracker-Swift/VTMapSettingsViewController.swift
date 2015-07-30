//
//  VTMapSettingsViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 7/30/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import Foundation

class VTMapSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var timePicker: UIPickerView!
    var indexToSet: Int = 0
    var parent = VTMapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timePicker.selectRow(indexToSet, inComponent: 0, animated: false)
    }
    
    // MARK: - UIPickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return VTTripHandler.trips.count + 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if row == 0 {
            return "All Trips"
        }
        else {
            return VTTripHandler.tripNames[row - 1] as! String
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func setSelectedRow(index: Int, sender: UIViewController) {
        self.indexToSet = index + 1
        self.parent = sender as! VTMapViewController
    }
    
    // MARK: - Actions
    
    @IBAction func didTapDone(sender: AnyObject) {
        self.parent.settingsPickerIndex = self.timePicker.selectedRowInComponent(0) - 1
        self.parent.reloadAnnotations()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func didTapPrivacySettings(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    
    @IBAction func didTapRewatch(sender: AnyObject) {
        VTTabBarViewController.showWelcome(self)
    }
    
}