//
//  VTVisitCommentsViewController.swift
//  Vacation-Tracker-Swift
//
//  Created by Spencer Atkin on 8/4/15.
//  Copyright (c) 2015 SocialRadar. All rights reserved.
//

import UIKit

class VTVisitCommentsViewController: UIViewController {
    var visit = VTVisit()
    @IBOutlet weak var commentsEntry: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsEntry.text = self.visit.comments as String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.commentsEntry.becomeFirstResponder()
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        self.commentsEntry.resignFirstResponder()
        var confirm = UIAlertController(title: "Discard changes?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.commentsEntry.becomeFirstResponder()
        }
        let discard = UIAlertAction(title: "Discard", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
        confirm.addAction(cancel)
        confirm.addAction(discard)
        confirm.view.tintColor = UIColor(red: 0.97, green: 0.33, blue: 0.1, alpha: 1)
        self.presentViewController(confirm, animated: true, completion: nil)
    }
    @IBAction func didTapDone(sender: AnyObject) {
        self.commentsEntry.resignFirstResponder()
        self.visit.comments = self.commentsEntry.text
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}