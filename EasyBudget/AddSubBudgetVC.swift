//
//  AddSubBudgetVC.swift
//  EasyBudget
//
//  Created by Eric Tran on 8/9/15.
//  Copyright (c) 2015 Eric Tran. All rights reserved.
//

import UIKit
import Parse
import Foundation

class AddSubBudgetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var budgetOffsetField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var subtractBtn: UIButton!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var tableRecords: UITableView!
    @IBOutlet weak var reasonField: UITextField!
    
    var transactions: [String] = ["Test", "Test", "Test"]

    
    override func viewDidLoad() {
        restartBtn.layer.cornerRadius = 10
        logoutBtn.layer.cornerRadius = 10
        budgetOffsetField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        tableRecords.delegate = self
        tableRecords.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refreshLabel(0)

        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    /* Updates and adds the offset in the cloud */
    @IBAction func addPressed(sender: UIButton) {
        if !budgetOffsetField.text.isEmpty {
            var offset = (budgetOffsetField.text as NSString).doubleValue
            refreshLabel(offset)
        }
    }
    
    /* Updates and subtracts the offset in the cloud */
    @IBAction func subtractPressed(sender: UIButton) {
        if !budgetOffsetField.text.isEmpty {
            var offset = (budgetOffsetField.text as NSString).doubleValue
            refreshLabel(-offset)
        }
    }
    
    /* Refreshes the cloud and label */
    func refreshLabel(offset: Double) {
        var query = PFUser.query()
        query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        query!.getFirstObjectInBackgroundWithBlock() {
            (object: AnyObject?, error: NSError?) -> Void in
            
            if error == nil {
                var user = object as! PFObject
                
                // Set the budget in the cloud
                var newBudget = offset + (user["budget"] as! Double)
                self.budgetLabel.text = "$" + (NSString(format: "%.2f", newBudget) as String)
                user["budget"] = newBudget
                
                // Set the reason in the cloud 
                //user["reason"]
                user.saveInBackground()
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }

    /* Clears the budget field in the cloud and takes user to MaxBudgetVC */
    @IBAction func restartBtn(sender: UIButton) {
        var query = PFUser.query()
        query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        query!.getFirstObjectInBackgroundWithBlock() {
            (object: AnyObject?, error: NSError?) -> Void in
            
            if error == nil {
                var user = object as! PFObject
                user.removeObjectForKey("budget")
                user.saveInBackground()
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    /* Logs the user out of the current session and brings up ParseLoginVC */
    @IBAction func logoutPressed(sender: UIButton) {
        PFUser.logOut()
    }
    
    /* Calls this function when the tap is recognized */
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /* Refreshes the content in the table */
    func loadTransactions() {
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableRecords.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.transactions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        
    }
}
