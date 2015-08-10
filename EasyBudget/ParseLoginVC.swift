//
//  ViewController.swift
//  EasyBudget
//
//  Created by Eric Tran on 8/9/15.
//  Copyright (c) 2015 Eric Tran. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseLoginVC: UIViewController, PFLogInViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            var query = PFUser.query()
            query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
            query!.getFirstObjectInBackgroundWithBlock() {
                (object: AnyObject?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    var user = object as! PFObject
                    if user["budget"] != nil {
                        self.performSegueWithIdentifier("goToAddSubVC", sender: self)
                    }
                    else {
                        self.performSegueWithIdentifier("goToMainScreen", sender: self)
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
        else {
            var logInViewController = PFLogInViewController()
            logInViewController.fields = (PFLogInFields.UsernameAndPassword
                | PFLogInFields.LogInButton
                | PFLogInFields.SignUpButton
                | PFLogInFields.PasswordForgotten)
            logInViewController.delegate = self
            self.presentViewController(logInViewController, animated: false, completion: nil)
        }
    }

    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}

