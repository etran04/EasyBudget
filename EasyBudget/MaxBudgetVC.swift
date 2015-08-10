//
//  MaxBudgetVC.swift
//  EasyBudget
//
//  Created by Eric Tran on 8/9/15.
//  Copyright (c) 2015 Eric Tran. All rights reserved.
//

import UIKit
import Parse

class MaxBudgetVC: UIViewController {
    @IBOutlet weak var budgetField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetField.keyboardType = UIKeyboardType.NumberPad
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    /* Sets the budget in the cloud */ 
    @IBAction func confirmPressed(sender: UIButton) {
        if budgetField.text != "" {
            var budget = budgetField.text.toInt()
            
            var query = PFUser.query()
            query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
            query!.getFirstObjectInBackgroundWithBlock() {
                (object: AnyObject?, error: NSError?) -> Void in
                
                if error == nil {
                    var user = object as! PFObject
                    user["budget"] = budget
                    user.saveInBackground()
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
    }
    
    /* Calls this function when the tap is recognized */
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
